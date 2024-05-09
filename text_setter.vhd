LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity text_display is 
	port (
		pixel_row, pixel_col : in std_logic_vector (5 downto 0);
		clk : in std_logic;
		character_address : out std_logic_vector (5 downto 0)
	);
	
end entity text_display;




architecture arc of text_display is 
begin


process(clk)
begin
	if(pixel_row = "001010") then
		case pixel_col is 
			when "001010" => character_address <= "10111";
			when "010100" => character_address <= "11000";
			when "011110" => character_address <= "00010";
			when "101000" => character_address <= "10000";
			when "110010" => character_address <= "10011";
			when "111100" => character_address <= "00110";
		end case;	
	end if;
end process;

end architecture arc;



