library IEEE;
use IEEE.std_logic_1164.all;

entity controle is

	Port (	i_OPCODE 	: in std_logic_vector(6 downto 0); 
    		o_ALU_SRC	: out std_logic;
            o_MEM2REG	: out std_logic;
            o_REG_WRITE	: out std_logic;
            o_MEM_READ	: out std_logic;
            o_MEM_WRITE	: out std_logic;
            o_ALUOP    	: out std_logic_vector(1 downto 0) ;
            o_BRANCH_CTRL : out std_logic
         );
end controle;

architecture arq_controle of controle is
	signal w_TYPE_U, w_TYPE_J, w_TYPE_Ijalr, w_TYPE_B, w_TYPE_L, w_TYPE_S, w_TYPE_I, w_TYPE_R, w_TYPE_Ifence, w_TYPE_Icall : std_logic;
begin
	-- detecção do formado e tipo de operação operação
	w_TYPE_U 		<= '1' when i_OPCODE="0110111" or i_OPCODE="0010111"  else '0';
    w_TYPE_J 		<= '1' when i_OPCODE="1101111" else '0';
    w_TYPE_Ijalr 	<= '1' when i_OPCODE="1100111" else '0';
    w_TYPE_B 		<= '1' when i_OPCODE="1100011" else '0';
    w_TYPE_L 		<= '1' when i_OPCODE="0000011" else '0';
    w_TYPE_S 		<= '1' when i_OPCODE="0100011" else '0';
    w_TYPE_I 		<= '1' when i_OPCODE="0010011" else '0';
    w_TYPE_R 		<= '1' when i_OPCODE="0110011" else '0';
    w_TYPE_Ifence 	<= '1' when i_OPCODE="0001111" else '0';
    w_TYPE_Icall 	<= '1' when i_OPCODE="1110011" else '0';
    
    --geração dos sinais de controle de acordo com o TYPE de operação
    -- sinal do seletor do multiplexador que vai para ULA
    o_ALU_SRC 	<= 	'1'  when w_TYPE_U='1' or w_TYPE_Ijalr='1' or w_TYPE_L='1' or w_TYPE_S='1' or w_TYPE_I='1' else '0';
    
    -- Seletor que escolhe entre a saída da memória e da ULA
    o_MEM2REG 	<= 	'1'  when w_TYPE_L='1' else '0';
    
    -- Permite a escrita no banco de registradores (como quase sempre está em 1, colocamos em zero só nesses poucos casos)
    o_REG_WRITE <= 	'0'  when w_TYPE_B='1' or w_TYPE_S='1' else '1';
    
    -- permite leitura da memória
    o_MEM_READ 	<= 	'1'  when w_TYPE_L='1' else '0';
    
    -- permite escrita na memória
    o_MEM_WRITE <= 	'1'  when w_TYPE_S='1' else '0';
    
    -- operações como BEQ e Tipo_R requerem operações específicas da ULA
    o_ALUOP 	<= 	"10" when w_TYPE_R='1' else 
    				"01" when w_TYPE_B='1' else "00";
    
	
end arq_controle;