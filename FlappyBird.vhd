LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;


entity FlappyBird is 
	port (CLOCK_50, SW0, SW1, SW2 : in std_logic;
			red_out, green_out, blue_out, horiz_sync_out, vert_sync_out : out std_logic
			);
end entity FlappyBird

architecture arc of FlappyBird is
	component vga_sync is 
			port(	clock_25Mhz, red, green, blue		: IN	STD_LOGIC;
				red_out, green_out, blue_out, horiz_sync_out, vert_sync_out	: OUT	STD_LOGIC;
				pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
	end component


	component clock_divider is 
			port ( 
			Clk, reset: in std_logic;
			clock_1HZ: out std_logic);
	end component 
	signal clk_25 : std_logic;
	signal pixel_row_vga : std_logic_vector (9 downto 0);
	signal pixel_col_vga : std_logic_vector (9 downto 0);

begin

	vga : vga_sync 
		port map(
			clock_25Mhz => clk_25,
			red => SW0,
			green => Sw1,
			blue => SW2,
			red_out => red_out,
			green_out => green_out,
			blue_out => blue_out,
			horiz_sync_out => horiz_sync_out,
			vert_sync_out => vert_sync_out,
			pixel_row => ,
			pixel_column => 
		);
		
	divider: clock_divider 
		port map(
			Clk => CLOCK_50,
			reset => '0',
			clock_25 => clk_25
		);

end architecture arc