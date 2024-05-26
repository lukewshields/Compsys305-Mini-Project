
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;


entity FlappyBird is 
	port (CLOCK_50: in std_logic;
			SW : in std_logic_vector (9 downto 0);
			KEY : in std_logic_vector (3 downto 0);
			LEDR : out std_logic_vector (9 downto 0);
			VGA_HS, VGA_VS : out std_logic;
			VGA_R, VGA_G, VGA_B : out std_logic_vector (3 downto 0);
			PS2_DAT, PS2_CLK : inout std_logic;
			HEX0, HEX1 : out std_logic_vector (6 downto 0)			
			);
end entity FlappyBird;

architecture arc of FlappyBird is
	component vga_sync is 
			port(	clock_25Mhz, red, green, blue		: IN	STD_LOGIC;
				rgb : in std_logic_vector(11 downto 0);
				red_out, green_out, blue_out : out std_logic_vector (3 downto 0);
				horiz_sync_out, vert_sync_out	: OUT	STD_LOGIC;
				pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
	end component;

	component pll is 
		port (
			refclk   : in  std_logic := '0'; --  refclk.clk
			rst      : in  std_logic := '0'; --   reset.reset
			outclk_0 : out std_logic;        -- outclk0.clk
			locked   : out std_logic         --  locked.export
		);
	end component pll;
	
	component pipes is 
    port (pixel_row, pixel_col, rand: in std_logic_vector (9 downto 0);
			mode, level : in std_logic_vector (1 downto 0);
			score : in std_logic_vector (6 downto 0);
			clk, vert_sync, enable, click, collision, reset, death: in std_logic;
			red, green, blue, pipes_on_out, game_on : out std_logic;
			pipes_x_pos1_out,pipes_x_pos2_out,pipes_x_pos3_out : out std_logic_vector (10 downto 0);
			pipe_width_out, pipe_speed: out std_logic_vector (9 downto 0)
	 );
	end component pipes;
		
	component bird is 
    port (clk, vert_sync, click, enable, reset, game_on	: IN std_logic;
		 mode : in std_logic_vector (1 downto 0);
		 collision : in std_logic;
       pixel_row, pixel_col	: IN std_logic_vector(9 DOWNTO 0);
		 lives : in std_logic_vector(5 downto 0);
		 red, green, blue, bird_on_out, death : OUT std_logic;
		 rgb : out std_logic_vector(11 downto 0);
		 bird_x_pos_out: out std_logic_vector(9 DOWNTO 0)
		 );			
	end component bird;
	
	component mouse is
		PORT( clock_25Mhz, reset 		: IN std_logic;
			mouse_data					: INOUT std_logic;
         mouse_clk 					: INOUT std_logic;
         left_button	: OUT std_logic
		);     
	end component mouse;
	
	
	component collision is 
		port (bird_on, pipes_on, enable, vert_sync : in std_logic;
			mode : in std_logic_vector (1 downto 0);
			collide : out std_logic
		);
	end component collision;
	
	component enable_handle is 
		port (mode : in std_logic_vector (1 downto 0);
			enable, collision: in std_logic;
			hold_enable : out std_logic
		);
	end component enable_handle;
	
	component char_rom is 
		PORT
	(
		character_address	:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock				: 	IN STD_LOGIC ;
		rom_mux_output		:	OUT STD_LOGIC
	);
	end component char_rom;
	
	component text_setter is 
		port (
			pixel_row, pixel_col : in std_logic_vector (5 downto 0);
			pixel_row2, pixel_col2 : in std_logic_vector (9 downto 0);
			mode, difficulty : in std_logic_vector (1 downto 0);
			score : in std_logic_vector(6 downto 0);
			lives : in std_logic_vector (5 downto 0);
			clk,enable, game_on, death : in std_logic;
			character_address, pause_address : out std_logic_vector (5 downto 0)
		);
	end component text_setter;
	
	component score_check is 
		port(
			vert_sync, Enable, collision, game_on, reset, death: in std_logic;
			mode : in std_logic_vector (1 downto 0);
			pipe_x_pos1, pipe_x_pos2, pipe_x_pos3 : in std_logic_vector (10 downto 0);
			pipe_width, bird_x_pos : in std_logic_vector (9 downto 0);
			score: out std_logic_vector (6 downto 0); 
			tens,ones: out std_logic_vector (3 downto 0)
		);
	end component score_check;
	
	component LFSR is 
		port (
			clk, reset : in std_logic;
			rand : out std_logic_vector (9 downto 0)
		);
	end component LFSR;
	
	component BCD_to_SevenSeg is
		port (
			BCD_digit : in std_logic_vector(3 downto 0);
			SevenSeg_out : out std_logic_vector(6 downto 0)
		);
	end component BCD_to_SevenSeg;
	

	component mode_controller is 
		port (
			clk, pb3, pb2, pb1 : in std_logic;
			reset_state : out std_logic;
			mode : out std_logic_vector (1 downto 0)
		);
	end component mode_controller;
	
	component hold_collision is 
		port (
			collide, clk, vert_sync : in std_logic;
			collide_stable : out std_logic
		);
	end component hold_collision;
	
	
	component lives is 
		port (
			collision, collision_power, reset, death: in std_logic;
			mode : in std_logic_vector (1 downto 0);
			lives_out : out std_logic_vector(5 downto 0)
			--death : out std_logic
		);
	end component lives;
	
	
	component levels is 
		port(
			vert_sync : in std_logic;
			difficulty : in std_logic_vector(2 downto 0); --switches user input on level
			score : in std_logic_vector(6 downto 0);
			mode : in std_logic_vector(1 downto 0);
			level : out std_logic_vector(1 downto 0) -- output of level depending on manual switches and score
		);
	end component levels;
	
	
	component powerups is 
		port (
			pixel_row, pixel_col, rand, pipe_speed : in std_logic_vector(9 downto 0);
			vert_sync, death, enable, collision, collision_pipe, reset, game_on : in std_logic;
			mode : in std_logic_vector(1 downto 0);
			red, green, blue, powerup_on_out : out std_logic
		);
	end component powerups;
	
	signal clk_25, red, green, blue, vert_s : std_logic;
	signal pixel_row_vga : std_logic_vector (9 downto 0);
	signal pixel_col_vga : std_logic_vector (9 downto 0);
	signal trash3 : std_logic;
	signal red_pipes, green_pipes, blue_pipes : std_logic;
	signal red_powerup, green_powerup, blue_powerup : std_logic;
	signal green_pipes2, blue_pipes2 : std_logic;
	signal red_bird, green_bird, blue_bird : std_logic;
	signal red_final, green_final, blue_final : std_logic;
	signal leftclick : std_logic;
	
	signal collide, collide_stable, collide_power, collide_pipe, collide_stable_power, collide_stable_pipe : std_logic;
	
	signal hold_enable : std_logic;
	signal pipes_on, bird_on, powerup_on : std_logic;
	signal pipes_x_pos,pipes_x_pos2,pipes_x_pos3 : std_logic_vector (10 downto 0);
	signal bird_x_pos, pipe_width: std_logic_vector (9 downto 0);
	signal score : std_logic_vector (6 downto 0);
	signal rand_bits : std_logic_vector (9 downto 0);
	signal tens_score : std_logic_vector (3 downto 0);
	signal ones_score : std_logic_vector (3 downto 0);

	signal char_addy,pause_addy : std_logic_vector (5 downto 0);
	signal rom_mux_addy,rom_mux_addy2 : std_logic;
	
	signal mode : std_logic_vector (1 downto 0);
	signal death : std_logic;
	
	signal level : std_logic_vector(1 downto 0);
	
	signal lives_out : std_logic_vector (5 downto 0);
	
	signal game_on : std_logic; --from pipes sent to score check to fix initial score of 1 whenever having a collision
	signal reset_state : std_logic; -- from the mode controller and it resets the score and lives when switching modes
	
	signal pipe_speed : std_logic_vector (9 downto 0);

	signal reseted : std_logic;
	
	signal temp_rgb : std_logic_vector(11 downto 0);
	
begin

	vga : vga_sync 
		port map(
			clock_25Mhz => clk_25,
			red => red_final,
			green => green_final,
			blue => blue_final,
			rgb => temp_rgb,
			red_out => VGA_R,
			green_out => VGA_G,
			blue_out => VGA_B,
			horiz_sync_out => VGA_HS,
			vert_sync_out => vert_s, 
			pixel_row => pixel_row_vga,
			pixel_column => pixel_col_vga
		);

	VGA_VS <= vert_s;
	
			
	LEDR(1) <= collide_stable;
	LEDR(0) <= death;
	LEDR(9) <= collide_stable_pipe;

	LEDR(6) <= reset_state;
	LEDR(2) <= collide_stable_power;
	LEDR(3) <= game_on;
	
	divider : pll 
		port map (
			refclk => CLOCK_50,
			rst => '0',
			outclk_0 => clk_25,
			locked => trash3
		);
	
	pipe1 : pipes
		port map (
			pixel_row => pixel_row_vga,
			pixel_col => pixel_col_vga,
			rand => rand_bits,
			mode => mode,
			level => level,
			score => score,
			clk => clk_25, 
			vert_sync => vert_s,
			enable => hold_enable,
			click => leftclick,
			collision => collide_stable,
			reset => reset_state,
			death => death,
			red => red_pipes,
			green => green_pipes,
			blue => blue_pipes,
			pipes_on_out => pipes_on,
			game_on => game_on,
			pipes_x_pos1_out => pipes_x_pos,
			pipes_x_pos2_out => pipes_x_pos2,
			pipes_x_pos3_out => pipes_x_pos3,
			pipe_width_out => pipe_width,
			pipe_speed => pipe_speed
		);
		
	
	red_final <= (red_bird or red_powerup or rom_mux_addy or rom_mux_addy2);

	green_final <= (green_pipes or rom_mux_addy or rom_mux_addy2);

	blue_final <= ((blue_pipes and not red_bird and not red_powerup) or rom_mux_addy or rom_mux_addy2);

		
	avatar : bird 
		port map (
			clk => clk_25,
		   vert_sync => vert_s,
			click => leftclick,
			enable => hold_enable,
			reset => reset_state,
			game_on => game_on,
			mode => mode,
			collision => collide_stable,
		   pixel_row => pixel_row_vga, 
		   pixel_col => pixel_col_vga,
			lives => lives_out,
		   red => red_bird, 
		   green => green_bird,
		   blue => blue_bird,
			rgb => temp_rgb,
			bird_on_out => bird_on,
			death => death,
			bird_x_pos_out => bird_x_pos
		);
	
	l : mouse 
		port map(
			clock_25Mhz => clk_25,
			reset => '0',
			mouse_data => PS2_DAT,
			mouse_clk => PS2_CLK,
         left_button => leftclick
		);
	
	c: collision 
		port map (
			bird_on => bird_on,
			pipes_on => pipes_on,
			enable => hold_enable,
			vert_sync => vert_s,
			mode => mode,
			collide => collide
		);
		
	c2: collision 
		port map (
			bird_on => bird_on,
			pipes_on => powerup_on,
			enable => hold_enable,
			vert_sync => vert_s,
			mode => mode,
			collide => collide_power --collide between the bird and a power up
		);
		
	c3: collision 
		port map (
			bird_on => powerup_on,
			pipes_on => pipes_on,
			enable => hold_enable,
			vert_sync => vert_s,
			mode => mode,
			collide => collide_pipe --collide between the power up and pipe
		);
		
	e : enable_handle 
		port map (
			mode => mode,
			enable => not KEY(0),
			collision => collide,
			hold_enable => hold_enable
		);
		
		
	ch: char_rom
		port map(
			character_address => char_addy,
			font_row => pixel_row_vga (3 downto 1), 
			font_col	=> pixel_col_vga (3 downto 1),
			clock => clk_25,
			rom_mux_output => rom_mux_addy
		);
		
	
	ch2: char_rom
		port map(
			character_address => pause_addy,
			font_row => pixel_row_vga (4 downto 2), 
			font_col	=> pixel_col_vga (4 downto 2),
			clock => clk_25,
			rom_mux_output => rom_mux_addy2
	);
	
	t: text_setter
		 port map(
			 pixel_row => pixel_row_vga(9 downto 4),
			 pixel_col => pixel_col_vga (9 downto 4),
			 pixel_row2 => pixel_row_vga,
			 pixel_col2 => pixel_col_vga,
			 mode => mode,
			 difficulty => level,
			 score => score,
			 lives => lives_out,
			 clk=>clk_25,
			 enable=>hold_enable,
			 game_on => game_on,
			 death => death,
			 character_address=> char_addy,
			 pause_address => pause_addy
	 );
	 
	 sc : score_check
		port map (
			vert_sync=> vert_s,
			Enable => hold_enable,
			collision => collide_stable,
			game_on => game_on,
			reset => reset_state,
			death => death,
			mode => mode,
			pipe_x_pos1 => pipes_x_pos,
			pipe_x_pos2 => pipes_x_pos2,
			pipe_x_pos3 => pipes_x_pos3,
			pipe_width => pipe_width,
			bird_x_pos => bird_x_pos,
			score => score, 
			tens => tens_score,
			ones => ones_score
	);
	
	rand_bit_gen : lfsr
		port map (
			clk => vert_s,
			reset => not hold_enable,
			rand => rand_bits
		);
				
		
	tens_conv: BCD_to_SevenSeg
		port map (
			BCD_digit => tens_score,
			SevenSeg_out => HEX1
		);
		
	ones_display: BCD_to_SevenSeg
		port map (
			BCD_digit => ones_score,
			SevenSeg_out => HEX0
		);
	
	controller : mode_controller 
		port map (
			clk => vert_s,
			pb3 => not KEy(3),
			pb2 => not KEY(2),
			pb1 => not KEY(1),
			reset_state => reset_state,
			mode => mode 
		);
--		
	collision_handle : hold_collision
		port map (
			collide => collide,
			clk => clk_25,
			vert_sync => clk_25,
			collide_stable => collide_stable
		);
		
	collision_handle2 : hold_collision
		port map (
			collide => collide_power,
			clk => clk_25,
			vert_sync => clk_25,
			collide_stable => collide_stable_power
		);
	
	collision_handle3 : hold_collision
		port map (
			collide => collide_pipe,
			clk => clk_25,
			vert_sync => clk_25,
			collide_stable => collide_stable_pipe
		);
	
	lives_count : lives 
		port map (
			collision => collide_stable,
			collision_power => collide_stable_power,
			reset => reset_state,
			death => death,
			mode => mode,
			lives_out => lives_out
		);
	
	level_set : levels 
		port map (
			vert_sync => vert_s,
			difficulty => SW(9 downto 7),
			score => score,
			mode => mode,
			level => level
		);
		
	--for death detection use pixel clashes between red and green signals
	
	special : powerups 
		port map (
			pixel_row => pixel_row_vga,
			pixel_col => pixel_col_vga,
			rand => rand_bits,
			pipe_speed => pipe_speed,
			vert_sync => vert_s,
			death => death,
			enable => hold_enable,
			collision => collide_stable_power,
			collision_pipe => collide_stable_pipe,
			reset => reset_state,
			game_on => game_on,
			mode => mode,
			red => red_powerup,
			green => green_powerup,
			blue => blue_powerup,
			powerup_on_out => powerup_on
		);
		
		
end architecture arc;