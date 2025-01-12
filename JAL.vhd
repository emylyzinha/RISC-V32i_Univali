library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity JAL is
    Port (
        i_PC      : in  std_logic_vector(31 downto 0); -- Valor atual do PC
        i_IMM     : in  std_logic_vector(31 downto 0); -- Deslocamento imediato
        o_PC_NEXT : out std_logic_vector(31 downto 0)  -- Próximo valor do PC
    );
end JAL;

architecture arch of JAL is
begin
    o_PC_NEXT <= std_logic_vector(signed(i_PC) + signed(i_IMM)); -- Soma PC + deslocamento
end arch;
