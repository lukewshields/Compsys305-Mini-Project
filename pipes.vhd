LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity pipes is 
	port (clk : in std_logic;
		pixel_row, pixel_col, vert_sync : in std_logic_vector (9 downto 0);
		red_out, green_out, blue_out : out std_logic; --write to vga2 just above the background
		
	);

end entity pipes;

architecture arc of pipes is 
signal size : std_logic_vector (9 downto 0); --holds current size
signal x_pos: std_logic_vector (9 downto 0); --current middle x of pipe
signal y_pos: std_logic_vector (9 downto 0); --current middle y of pipe
signal gap_x : std_logic_vector (9 downto 0);
signal gap_y : std_logic_vector (9 downto 0);
signal gapsize : std_logic_vector (9 downto 0);
signal pipe_x_motion: std_logic (9 downto 0); --motion for pipe to move left
signal pipe_on : std_logic;
signal pipe_width: std_logic_vector(9 downto 0); --need to initialize this?




begin

size <= CONV_STD_LOGIC_VECTOR(15, 10);


move_pipe: process (vert_sync)
	begin
		pipe_on => '1' when ((pixel_column > gap_x - pipe_width) and (pixel_column < gap_x) and ((gap_y + gapsize <= pixel_row) or (pixel_row <= gap_y - gapsize)))
						else '0';
		if(rising_edge(vert_sync) then
		
		
		end if;
			




end architecture arc;