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
	component vga_sync is 
			port(	clock_25Mhz, red, green, blue		: IN	STD_LOGIC;
				red_out, green_out, blue_out, horiz_sync_out, vert_sync_out	: OUT	STD_LOGIC;
				pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
	end component;


	--component clock_divider is 
	--		port ( 
	--		Clk, reset: in std_logic;
	--		clock_25: out std_logic);
--	end component; 
	component pll is 
		port (
			refclk   : in  std_logic := '0'; --  refclk.clk
			rst      : in  std_logic := '0'; --   reset.reset
			outclk_0 : out std_logic;        -- outclk0.clk
			locked   : out std_logic         --  locked.export
		);
	end component pll;
	
	component pipes is 
		 port (pixel_row, pixel_col : in std_logic_vector (9 downto 0);
		  start_pos : in std_logic_vector (10 downto 0);
        clk, vert_sync, enable: in std_logic;
        red, green, blue: out std_logic
		);
	end component pipes;
	
	signal clk_25, red, green, blue, vert_s : std_logic;
	signal pixel_row_vga : std_logic_vector (9 downto 0);
	signal pixel_col_vga : std_logic_vector (9 downto 0);
	signal trash : std_logic;
	

begin

	vga : vga_sync 
		port map(
			clock_25Mhz => clk_25,
			red => red,
			green => green,
			blue => blue,
			red_out => VGA_R(3),
			green_out => VGA_G(3),
			blue_out => VGA_B(3),
			horiz_sync_out => VGA_HS,
			--vert_sync_out => VGA_VS,
			vert_sync_out => vert_s, -- how to split the vert_sync pin signal and still apply to input of components
			pixel_row => pixel_row_vga,
			pixel_column => pixel_col_vga
		);
		
	--vert_s <= VGA_VS;
	VGA_VS <= vert_s;
	
	divider : pll 
		port map (
			refclk => CLOCK_50,
			rst => '0',
			outclk_0 => clk_25,
			locked => trash
		);
	
	pipe : pipes
		port map (
			pixel_row => pixel_row_vga,
			pixel_col => pixel_col_vga,
			start_pos => conv_std_logic_vector(200, 11),
			clk => clk_25, 
			vert_sync => vert_s,
			enable => '1',
			red => red,
			green => green,
			blue => blue
		);
		
	--pipe2 : pipes -- red green and blue cannot be assigned to more than 1 value need to use more bits of the vga_r values?
		--port map (
			--pixel_row => pixel_row_vga,
			--pixel_col => pixel_col_vga,
			--start_pos => conv_std_logic_vector(450, 11),
			--clk => clk_25, 
			--vert_sync => vert_s,
			--enable => '1',
			--red => red,
			--green => green,
			--blue => blue
		--);
		
end architecture arc;