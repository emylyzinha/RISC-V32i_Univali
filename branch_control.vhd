library IEEE;
use IEEE.std_logic_1164.all;

entity branch_control is
    port (
        i_BRANCH_CTRL : in  std_logic_vector(1 downto 0); -- Tipo de desvio
        i_ZERO        : in  std_logic;                   -- Resultado da comparação da ULA
        o_BRANCH      : out std_logic                   -- Controle de desvio
    );
end branch_control;

architecture behav of branch_control is
begin
    process (i_BRANCH_CTRL, i_ZERO)
    begin
        case i_BRANCH_CTRL is
            when "00" => -- Sem desvio
                o_BRANCH <= '0';
            when "01" => -- Desvio se igual
                o_BRANCH <= i_ZERO;
            when "10" => -- Desvio se diferente
                o_BRANCH <= not i_ZERO;
            when "11" => -- Desvio incondicional
                o_BRANCH <= '1';
            when others =>
                o_BRANCH <= '0'; -- Comportamento padrão
        end case;
    end process;
end behav;
