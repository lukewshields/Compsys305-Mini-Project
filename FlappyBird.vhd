LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;


entity FlappyBird is 
	port (CLOCK_50: in std_logic;
			SW : in std_logic_vector (2 downto 0);
			VGA_HS, VGA_VS : out std_logic;
			VGA_R, VGA_G, VGA_B : out std_logic_vector (3 downto 0)
			);
end entity FlappyBird;

architecture arc of FlappyBird is
	component VGA_SYNC is 
			port(	clock_25Mhz, red, green, blue		: IN	STD_LOGIC;
				red_out, green_out, blue_out, horiz_sync_out, vert_sync_out	: OUT	STD_LOGIC;
				pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
	end component VGA_SYNC;


	component clock_divider is 
			port ( 
			Clk, reset: in std_logic;
			clock_25: out std_logic);
	end component clock_divider;
	
	signal clk_25 : std_logic;
	signal pixel_row_vga : std_logic_vector (9 downto 0);
	signal pixel_col_vga : std_logic_vector (9 downto 0);

begin

	vga : vga_sync 
		port map(
			clock_25Mhz => clk_25,
			red => SW(0),
			green => SW(1),
			blue => SW(2),
			red_out => VGA_R(3),
			green_out => VGA_G(3),
			blue_out => VGA_B(3),
			horiz_sync_out => VGA_HS,
			vert_sync_out => VGA_VS,
			pixel_row => pixel_row_vga,
			pixel_column => pixel_col_vga
		);
		
	divider: clock_divider 
		port map(
			Clk => CLOCK_50,
			reset => '0',
			clock_25 => clk_25
		);

end architecture arc;