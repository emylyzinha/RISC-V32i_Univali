library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity memoria_instrucoes is
    port (
        i_ADDR     :in std_logic_vector(31 downto 0);
        o_INST :out std_logic_vector(31 downto 0) 
    );
end entity memoria_instrucoes;

architecture arch_memoria_instrucoes of memoria_instrucoes is
    
    type t_ROM_ARRAY is array (0 to 65535) of std_logic_vector(7 downto 0);      
    constant ROM : t_ROM_ARRAY := (
    -- Instruções 
    "00000000","00010000","00000010","10010011", -- addi t0, zero, 1
    "00000000","00100000","00000011","00010011", -- addi t1, zero, 2
    -- Adição de instruções de desvio (branch)
    "00000001","00010000","00100011","01100011", -- beq t0, t1, 8  (não salta, t0 != t1)
    "00000001","00000000","00110000","01100011", -- beq t0, t0, 8  (salta, t0 == t0)
    -- Próximas instruções executadas após BEQ
    "00000001","11100011","11111001","00110011", -- and s2, t2, t5
    "00000001","11010011","01101001","10110011", -- or s3, t1, t4
    others => X"00"
);
    
begin
    o_INST <= ROM(conv_integer(i_ADDR)) & ROM(conv_integer(i_ADDR + 1)) &
                   ROM(conv_integer(i_ADDR + 2)) & ROM(conv_integer(i_ADDR + 3)); 
    
 

end architecture arch_memoria_instrucoes;


