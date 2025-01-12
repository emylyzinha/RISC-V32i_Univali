library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ULA is

	Port (	i_A, i_B : in  std_logic_vector(31 downto 0); -- normalmente entra rs1 e rs2
    		i_F3     : in  std_logic_vector(2 downto 0);
            i_F7     : in  std_logic;
            i_ALUOP	 : in  std_logic_vector(1 downto 0); -- identifica a presença de BRANCH e formatoR
            o_ZERO   : out std_logic;					 -- informa se o desvio deve ou não ser tomado.
            o_ULA    : out std_logic_vector(31 downto 0) 
         );

end ULA;

architecture arch_ULA of ULA is
	signal w_SUB : std_logic_vector(31 downto 0);

begin
	-- Cálcula o resultado da saída da ULA
	process (i_A, i_B, i_F3, i_F7, i_ALUOP, w_SUB)
    begin
    	case i_F3 is
      		when "000" =>	-- ADD/SUB, só é SUB se formatoR e i_F7=1
        		if (i_F7 = '1' and i_ALUOP(1) = '1') then
        			o_ULA <= i_A - i_B;
        		else
        			o_ULA <= i_A + i_B;
        		end if;    	
            when "100" =>	-- XOR
            	o_ULA <= i_A xor i_B;
            when "101" =>	-- SLT ou ADD do SW 
            	if (i_ALUOP(1) = '1') then
                	if (w_SUB(31) = '1') then
                    	o_ULA <= X"00000001";
                    else 
                    	o_ULA <= X"00000000";
                    end if;
        		else
        			o_ULA <= i_A + i_B;
        		end if;   
            when "110" =>	-- OR
            	o_ULA <= i_A or i_B;
            when "111" =>	-- AND
            	o_ULA <= i_A and i_B;
            when OTHERS =>	-- Outros
                o_ULA <= X"00000000";
    	end case;
    end process;
    
    --Cálcula se o BRANCH será ou não tomado
    w_SUB 	<= i_A - i_B;
    process (i_F3, i_ALUOP, w_SUB)
    begin
    	if (i_ALUOP(0) = '1') then
          case i_F3 is
              when "000" =>	-- BEQ
                  if (w_SUB = X"00000000") then
                  	o_ZERO <= '1';
                  else
                  	o_ZERO <= '0';
                  end if;
              when "001" =>	-- BNE
                  if (w_SUB = X"00000000") then
                  	o_ZERO <= '0';
                  else
                  	o_ZERO <= '1';
                  end if;
              when "100" =>	-- BLT
                  if (w_SUB(31) = '1') then
                  	o_ZERO <= '1';
                  else
                  	o_ZERO <= '0';
                  end if;
              when "101" =>	-- BGE
              	if (w_SUB(31) = '0') then
                  	o_ZERO <= '1';
                  else
                  	o_ZERO <= '0';
                  end if;
              when OTHERS =>	-- Outros
                  o_ZERO <= '0';
          end case;
        else
        	o_ZERO <= '0';
        end if;
    end process;
    
    
    
end arch_ULA;