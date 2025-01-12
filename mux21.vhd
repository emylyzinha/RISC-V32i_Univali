library IEEE;
use IEEE.std_logic_1164.all;

entity mux21 is

	Port (	i_A, i_B : in std_logic_vector(31 downto 0); 
    		i_SEL    : in std_logic;
            o_MUX    : out std_logic_vector(31 downto 0) 
         );

end mux21;

architecture arch_1 of mux21 is

begin
	process (i_A, i_B, i_SEL)
    begin
    	if (i_SEL = '0') then
        	o_MUX <= i_A;
        else
        	o_MUX <= i_B;
        end if;
    end process;
end arch_1;