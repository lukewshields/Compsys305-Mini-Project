LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;


entity FlappyBird is 
	port (CLOCK_50: in std_logic;
			SW : in std_logic_vector (2 downto 0);
			KEY : in std_logic_vector (1 downto 0);
			VGA_HS, VGA_VS : out std_logic;
			VGA_R, VGA_G, VGA_B : out std_logic_vector (3 downto 0);
			PS2_DAT, PS2_CLK : inout std_logic
			
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
        clk, vert_sync, enable: in std_logic;
        red, green, blue: out std_logic
		);
	end component pipes;
		
	component bird is 
	    port (clk, vert_sync, click, enable	: IN std_logic;
       pixel_row, pixel_col	: IN std_logic_vector(9 DOWNTO 0);
		 red, green, blue 			: OUT std_logic);		
	end component bird;
	
	component mouse is
		PORT( clock_25Mhz, reset 		: IN std_logic;
			mouse_data					: INOUT std_logic;
         mouse_clk 					: INOUT std_logic;
         left_button, right_button	: OUT std_logic;
			mouse_cursor_row 			: OUT std_logic_vector(9 DOWNTO 0); 
			mouse_cursor_column 		: OUT std_logic_vector(9 DOWNTO 0)
		);     
	end component mouse;
	
	
	component collision is 
		port (bird, pipes, enable : in std_logic;
			pixel_row, pixel_col : in std_logic_vector(9 downto 0);
			collide : out std_logic
		);
	end component collision;
	
	component enable_handle is 
		port (enable: in std_logic;
			hold_enable : out std_logic
		);
	end component enable_handle;

	
	signal clk_25, red, green, blue, vert_s : std_logic;
	signal pixel_row_vga : std_logic_vector (9 downto 0);
	signal pixel_col_vga : std_logic_vector (9 downto 0);
	signal trash3 : std_logic;
	signal red_pipes, green_pipes, blue_pipes : std_logic;
	signal red_bird, green_bird, blue_bird : std_logic;
	signal red_final, green_final, blue_final : std_logic;
	signal leftclick : std_logic;
	signal moveup : std_logic;
	signal collide : std_logic;
	signal hold_enable : std_logic;
	
	signal trash : std_logic_vector (9 downto 0);
	signal trash2 : std_logic_vector (9 downto 0);
	signal trash4 : std_logic;
	
begin

	vga : vga_sync 
		port map(
			clock_25Mhz => clk_25,
			red => red_final,
			green => green_final,
			blue => blue_final,
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
			locked => trash3
		);
	
	pipe : pipes
		port map (
			pixel_row => pixel_row_vga,
			pixel_col => pixel_col_vga,
			clk => clk_25, 
			vert_sync => vert_s,
			enable => hold_enable,
			red => red_pipes,
			green => green_pipes,
			blue => blue_pipes
		);
	
	red_final <= red_bird;
	green_final <= green_pipes;
	blue_final <= blue_pipes and not red_bird;
		
	avatar : bird 
		port map (
			clk => clk_25,
		   vert_sync => vert_s,
			click => leftclick,
			enable => hold_enable,
		   pixel_row => pixel_row_vga, 
		   pixel_col => pixel_col_vga,
		   red => red_bird, -- this will have issues with writing to the same vga bit cant have multiple drivers, create different signals for each then assign to vga pins
		   green => green_bird,
		   blue => blue_bird
		);
	
	l : mouse 
		port map(
			clock_25Mhz => clk_25,
			reset => '0',
			mouse_data => PS2_DAT,
			mouse_clk => PS2_CLK,
         left_button => leftclick,
			right_button => trash4,
			mouse_cursor_row => trash,			 
			mouse_cursor_column => trash2
		);
	
	c: collision 
		port map (
			bird => red_bird,
			pipes => green_pipes,
			enable => hold_enable,
			pixel_row => pixel_row_vga, 
		   pixel_col => pixel_col_vga,
			collide => collide
		);
		
	e : enable_handle 
		port map (
			enable => not KEY(0),
			hold_enable => hold_enable
		);
		
	
	--for death detection use pixel clashes between red and green signals
		
end architecture arc;