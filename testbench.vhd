library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Adicionado para conversão


entity testbench is
end testbench;

architecture test_1 of testbench is

    -- Sinais do DUT
    signal w_CLK, w_RSTn : std_logic := '0';
    signal w_INST        : std_logic_vector(31 downto 0);
    signal w_OPCODE      : std_logic_vector(6 downto 0);
    signal w_RD_ADDR     : std_logic_vector(4 downto 0);
    signal w_RS1_ADDR    : std_logic_vector(4 downto 0);
    signal w_RS2_ADDR    : std_logic_vector(4 downto 0);
    signal w_RS1_DATA    : std_logic_vector(31 downto 0);
    signal w_RS2_DATA    : std_logic_vector(31 downto 0);
    signal w_IMM         : std_logic_vector(31 downto 0);
    signal w_ULA         : std_logic_vector(31 downto 0);

begin

    -- Instância do DUT
    u_DUT: entity work.RISCV32i
        port map (
            i_CLK       => w_CLK,
            i_RSTn      => w_RSTn,
            o_INST      => w_INST,
            o_OPCODE    => w_OPCODE,
            o_RD_ADDR   => w_RD_ADDR,
            o_RS1_ADDR  => w_RS1_ADDR,
            o_RS2_ADDR  => w_RS2_ADDR,
            o_RS1_DATA  => w_RS1_DATA,
            o_RS2_DATA  => w_RS2_DATA,
            o_IMM       => w_IMM,
            o_ULA       => w_ULA
        );

    -- Gerador de clock
    clock_process: process
    begin
        while true loop
            w_CLK <= '0';
            wait for 5ns;
            w_CLK <= '1';
            wait for 5ns;
        end loop;
    end process;

    -- Processo de teste
    process
    begin
        -- Reset
        w_RSTn <= '0';
        wait for 20ns;
        w_RSTn <= '1';

        -- Teste 1: JAL
        w_INST <= x"0040006F"; -- JAL
        wait for 20ns;
        assert to_integer(unsigned(w_ULA)) = 4
    		report "Erro no cálculo de JAL!" severity error;
            
        -- Teste 2: JALR
        w_INST <= x"00008067"; -- JALR
        wait for 20ns;
        assert to_integer(unsigned(w_ULA)) = 20
    		report "Erro no cálculo de JALR!" severity error;

        -- Teste 3: BEQ
        w_INST <= x"00002063"; -- BEQ
        wait for 20ns;
        assert to_integer(unsigned(w_ULA)) = 8
    		report "Erro no cálculo de BEQ!" severity error;

        -- Outros testes podem ser adicionados aqui
        wait;
    end process;

end test_1;