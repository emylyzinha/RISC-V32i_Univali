library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux41 is
    Port (
        i_A   : in  std_logic_vector(31 downto 0); -- Entrada A
        i_B   : in  std_logic_vector(31 downto 0); -- Entrada B
        i_C   : in  std_logic_vector(31 downto 0); -- Entrada C
        i_D   : in  std_logic_vector(31 downto 0); -- Entrada D
        i_SEL : in  std_logic_vector(1 downto 0);  -- Sinal de seleção (2 bits)
        o_MUX : out std_logic_vector(31 downto 0)  -- Saída selecionada
    );
end mux41;

architecture arch of mux41 is
begin
    process(i_A, i_B, i_C, i_D, i_SEL)
    begin
        case i_SEL is
            when "00" => o_MUX <= i_A; -- Seleciona A
            when "01" => o_MUX <= i_B; -- Seleciona B
            when "10" => o_MUX <= i_C; -- Seleciona C
            when "11" => o_MUX <= i_D; -- Seleciona D
            when others => o_MUX <= (others => '0'); -- Caso inválido
        end case;
    end process;
end arch;
