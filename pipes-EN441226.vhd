LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity pipes is 
	port (clk, horiz_sync : in std_logic;
		pixel_row, pixel_col : in std_logic_vector(9 downto 0),
		red, green, blue : out std_loigc
	);

end entity pipes;

architecture arc of pipes is 
signal size_x: std_logic_vector (6 downto 0);
signal size_y: std_logic_vector ( 12 downto 0);


begin



	




end architecture arc;