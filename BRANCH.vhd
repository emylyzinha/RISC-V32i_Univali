library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BRANCH is
    Port (
        i_PC      : in  std_logic_vector(31 downto 0); -- Valor atual do PC
        i_IMM     : in  std_logic_vector(31 downto 0); -- Deslocamento imediato
        i_BRANCH  : in  std_logic;                     -- Sinal de controle de desvio
        o_PC_NEXT : out std_logic_vector(31 downto 0)  -- Próximo valor do PC
    );
end BRANCH;

architecture arch of BRANCH is
begin
    o_PC_NEXT <= std_logic_vector(signed(i_PC) + signed(i_IMM)) when i_BRANCH = '1' else i_PC;
end arch;
