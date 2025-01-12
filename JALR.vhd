library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity JALR is
    Port (
        i_RS1     : in  std_logic_vector(31 downto 0); -- Valor do registrador RS1
        i_IMM     : in  std_logic_vector(31 downto 0); -- Deslocamento imediato
        o_PC_NEXT : out std_logic_vector(31 downto 0)  -- Próximo valor do PC
    );
end JALR;

architecture arch of JALR is
begin
    o_PC_NEXT <= std_logic_vector(signed(i_RS1) + signed(i_IMM)) and x"FFFFFFFE"; -- Soma e zera o LSB
end arch;
