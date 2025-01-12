library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity RISCV32i is
    Port ( 
        i_CLK      : in  std_logic;
        i_RSTn     : in  std_logic;

        -- Sinais para depuração
        o_INST      : out std_logic_vector(31 downto 0);
        o_OPCODE    : out std_logic_vector(6 downto 0);
        o_RD_ADDR   : out std_logic_vector(4 downto 0);
        o_RS1_ADDR  : out std_logic_vector(4 downto 0);
        o_RS2_ADDR  : out std_logic_vector(4 downto 0);
        o_RS1_DATA  : out std_logic_vector(31 downto 0);
        o_RS2_DATA  : out std_logic_vector(31 downto 0);
        o_IMM       : out std_logic_vector(31 downto 0);
        o_ULA       : out std_logic_vector(31 downto 0)
    );
end RISCV32i;

architecture arch_1 of RISCV32i is
    signal w_RS1, w_RS2 : std_logic_vector(31 downto 0); -- Liga a saída do banco
    signal w_ULA        : std_logic_vector(31 downto 0); -- Liga a saída da ULA
    signal w_ULAb       : std_logic_vector(31 downto 0); -- Liga entrada B da ULA
    signal w_ZERO       : std_logic; 
    
    -- Sinais adicionais para desvios
    signal w_BRANCH_CTRL : std_logic_vector(1 downto 0); -- Tipo correto;
    signal w_BRANCH      : std_logic;

    -- Sinais do gerador de imediato
    signal w_IMM : std_logic_vector(31 downto 0);
    
    -- Sinais do PC e memória de instrução
    signal w_PC, w_PC4 : std_logic_vector(31 downto 0); -- Endereço da instrução/ próxima instrução
    signal w_INST : std_logic_vector(31 downto 0); -- Instrução lida

    -- Sinais de controle
    signal w_ALU_SRC    : std_logic;
    signal w_MEM2REG    : std_logic;
    signal w_REG_WRITE  : std_logic;
    signal w_MEM_READ   : std_logic;
    signal w_MEM_WRITE  : std_logic;
    signal w_ALUOP      : std_logic_vector(1 downto 0);

    -- Sinais específicos para os próximos endereços do PC
    signal w_PC_NEXT_JAL    : std_logic_vector(31 downto 0); -- Próximo PC para JAL
    signal w_PC_NEXT_JALR   : std_logic_vector(31 downto 0); -- Próximo PC para JALR
    signal w_PC_NEXT_BRANCH : std_logic_vector(31 downto 0); -- Próximo PC para Branch

begin

    -- Componente de controle de desvios
    u_BRANCH_CTRL: entity work.branch_control
    port map (
        i_BRANCH_CTRL => w_BRANCH_CTRL, -- Seleciona o bit necessário
        i_ZERO        => w_ZERO,
        o_BRANCH      => w_BRANCH
    );

    -- Soma do PC com o imediato para desvio de branch
    u_BRANCH_ADDR: entity work.somador
    port map (
        i_A     => w_PC,
        i_B     => w_IMM,
        o_DATA  => w_PC_NEXT_BRANCH
    );

    -- Soma do PC com o imediato para instruções JAL
    u_JAL_ADDR: entity work.somador
    port map (
        i_A     => w_PC,
        i_B     => w_IMM,
        o_DATA  => w_PC_NEXT_JAL
    );

    -- Calcula próximo PC para instruções JALR
    u_JALR_ADDR: entity work.somador
    port map (
        i_A     => w_RS1,
        i_B     => w_IMM,
        o_DATA  => w_PC_NEXT_JALR
    );

    -- Multiplexador do próximo PC
    u_PC_MUX: entity work.mux41
    port map (
        i_A    => w_PC4,             -- Próxima instrução sem desvio
        i_B    => w_PC_NEXT_BRANCH,  -- Endereço de desvio (Branch)
        i_C    => w_PC_NEXT_JAL,     -- Endereço de JAL
        i_D    => w_PC_NEXT_JALR,    -- Endereço de JALR
        i_SEL  => w_BRANCH_CTRL,     -- Controle do tipo de desvio
        o_MUX  => w_PC_NEXT_JAL      -- Próximo PC
    );

    -- Controle principal
    u_CONTROLE: entity work.controle
    port map (    
        i_OPCODE    => w_INST(6 downto 0),
        o_ALU_SRC   => w_ALU_SRC, -- Escolhe entre w_RS2 e w_IMMED
        o_MEM2REG   => w_MEM2REG, -- Escolhe entre w_ALU e w_MEM
        o_REG_WRITE => w_REG_WRITE, -- Permite escrever no banco de registradores
        o_MEM_READ  => w_MEM_READ, -- Habilita memória para leitura
        o_MEM_WRITE => w_MEM_WRITE, -- Habilita memória para escrita
        o_ALUOP     => w_ALUOP, -- Gera sinais para a ULA
        o_BRANCH_CTRL => w_BRANCH_CTRL(0)
    );

    -- PC principal
    u_PC: entity work.ffd
    port map (
        i_DATA    => w_PC_NEXT_JAL, 
        i_CLK     => i_CLK,
        i_RSTn    => i_RSTn,
        o_DATA    => w_PC
    );

    -- Soma de 4 no PC
    u_SOMA4: entity work.somador
    port map (
        i_A     => w_PC, 
        i_B     => "00000000000000000000000000000100",  
        o_DATA  => w_PC4
    );

    -- Memória de instrução
    u_MEM_INST: entity work.memoria_instrucoes
    port map(
        i_ADDR  => w_PC,
        o_INST  => w_INST
    );

    -- Gerador de imediato
    u_GERADOR_IMM: entity work.gerador_imediato
    port map(
        i_INST  => w_INST,
        o_IMM   => w_IMM
    );

    -- Banco de registradores
    u_BANCO_REGISTRADORES: entity work.banco_registradores
    port map (
        i_CLK      => i_CLK,
        i_RSTn     => i_RSTn,
        i_WRena    => w_REG_WRITE,
        i_WRaddr   => w_INST(11 downto 7),
        i_RS1      => w_INST(19 downto 15),
        i_RS2      => w_INST(24 downto 20),
        i_DATA     => w_ULA,
        o_RS1      => w_RS1,
        o_RS2      => w_RS2
    );

    -- Unidade Lógica e Aritmética (ULA)
    u_ULA: entity work.ULA
    port map(
        i_A       => w_RS1,
        i_B       => w_ULAb,
        i_F3      => w_INST(14 downto 12),
        i_F7      => w_INST(31), -- Apenas o bit necessário
        i_ALUOP   => w_ALUOP,
        o_ZERO    => w_ZERO,
        o_ULA     => w_ULA
    );

    -- Multiplexador para a ULA
    u_MUX: entity work.mux21
    port map (
        i_A    => w_RS2,
        i_B    => w_IMM,
        i_SEL  => w_ALU_SRC,
        o_MUX  => w_ULAb
    );

    -- Sinais para depuração com o testbench
    o_INST      <= w_INST;
    o_OPCODE    <= w_INST(6 downto 0);
    o_RD_ADDR   <= w_INST(11 downto 7);
    o_RS1_ADDR  <= w_INST(19 downto 15);
    o_RS2_ADDR  <= w_INST(24 downto 20);
    o_RS1_DATA  <= w_RS1;
    o_RS2_DATA  <= w_RS2;
    o_IMM       <= w_IMM;
    o_ULA       <= w_ULA;

end arch_1;
