LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity text_setter is 
	port (
		pixel_row, pixel_col : in std_logic_vector (5 downto 0);
		score : in std_logic_vector(5 downto 0);
		clk,enable : in std_logic;
		character_address : out std_logic_vector (5 downto 0)
	);
	
end entity text_setter;




architecture arc of text_setter is 
begin


process(clk)
begin
	if rising_edge(clk) then
	if(pixel_row = "000010") then
		case pixel_col is 
			when "000010" => character_address <= "010011";
			when "000011" => character_address <= "000011";
			when "000100" => character_address <= "001111";
			when "000101" => character_address <= "010010";
			when "000110" => character_address <= "000101";
			when others => character_address <= "100000";
		end case;
		if (enable='1') then
--		if ((score /= "0000") and (score<"1010"))then
--			if (pixel_col = "000111") then
--				character_address<= score + "011000";
--				else
--				character_address <= "100000";
--			end if;
--			
--			else
--			character_address<=score + "011000";
--		end if;
			if (pixel_col = "001000") then
				character_address<= score + "110000";
			end if;
		end if;
	elsif (pixel_row = conv_std_logic_vector(15,6) and enable = '0')then
		case pixel_col is
			when "010010" => character_address <= "010000";
			when "010011" => character_address <= "000001";
			when "010100" => character_address <= "010101";
			when "010101" => character_address <= "010011";
			when "010110" => character_address <= "000101";
			when "010111" => character_address <= "000100";
			when others => character_address <= "100000";
		end case;
	else
		character_address <= "100000";
	end if;
	end if;
end process;

end architecture arc;