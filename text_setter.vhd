LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity text_setter is 
	port (
		pixel_row, pixel_col : in std_logic_vector (5 downto 0);
		clk : in std_logic;
		character_address : out std_logic_vector (5 downto 0)
	);
	
end entity text_setter;




architecture arc of text_setter is 
begin


process(clk)
begin
	if(pixel_row = "001010") then
		case pixel_col is 
			when "001010" => character_address <= "010111";
			when "010100" => character_address <= "011000";
			when "011110" => character_address <= "000010";
			when "101000" => character_address <= "010000";
			when "110010" => character_address <= "010011";
			when "111100" => character_address <= "000110";
			when others => character_address <= "XXXXXX";
		end case;	
	end if;
end process;

end architecture arc;



