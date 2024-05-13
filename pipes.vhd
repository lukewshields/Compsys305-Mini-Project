

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
--use ieee.numeric_std.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity pipes is 
    port (pixel_row, pixel_col: in std_logic_vector (9 downto 0);
		  --init_x_pos : in std_logic_vector(10 downto 0);
			rand : in std_logic_vector (9 downto 0);
			clk, vert_sync, enable: in std_logic;
			red, green, blue, pipes_on_out: out std_logic;
			pipes_x_pos1_out,pipes_x_pos2_out,pipes_x_pos3_out : out std_logic_vector (10 downto 0); -- for determining score
			pipe_width_out: OUT std_logic_vector (9 downto 0)
	 );
end entity pipes;

architecture arc of pipes is 
    --could get rid of all the pipe before the variable names maybe
	 signal pipe_gap : std_logic_vector (9 downto 0) := conv_std_logic_vector(160, 10); -- can later be shrunk based on the level/difficulty of the game
	 
    signal pipes_on : std_logic;
    signal pipe_height : std_logic_vector (9 downto 0) := conv_std_logic_vector(160, 10); --without any other _ , then pipe_height is equal to the top one
	 signal pipe_height_bot : std_logic_vector (9 downto 0) := conv_std_logic_vector(160, 10);
	 
	 signal pipe_height2 : std_logic_vector (9 downto 0) := conv_std_logic_vector(160, 10); --without any other _ , then pipe_height is equal to the top one
	 signal pipe_height_bot2 : std_logic_vector (9 downto 0) := conv_std_logic_vector(160, 10);
	 
	 signal pipe_height3 : std_logic_vector (9 downto 0) := conv_std_logic_vector(160, 10); --without any other _ , then pipe_height is equal to the top one
	 signal pipe_height_bot3 : std_logic_vector (9 downto 0) := conv_std_logic_vector(160, 10);
	 
    signal pipe_width : std_logic_vector (9 downto 0) := conv_std_logic_vector(40, 10);

    signal pipe_separation : std_logic_vector (9 downto 0);
    signal pipe_x_motion : std_logic_vector (9 downto 0) := conv_std_logic_vector(4, 10);
	 
    signal pipe_x_pos : std_logic_vector (10 downto 0) := conv_std_logic_vector(600, 11);
	 signal pipe_x_pos2 : std_logic_vector(10 downto 0) := conv_std_logic_vector(360, 11);
	 signal pipe_x_pos3 : std_logic_vector(10 downto 0) := conv_std_logic_vector(840, 11);
	 
	 signal bottom : std_logic_vector (9 downto 0) := conv_std_logic_vector(479,10);
	 signal ground : std_logic_vector (9 downto 0) := conv_std_logic_vector(460, 10);
	 
	-- signal random_10 : std_logic_vector (9 downto 0); 
	 
    begin

    red <= not pipes_on; --purple bg and green pipes lol
    green <= pipes_on;
    blue <= not pipes_on; 
	 pipes_x_pos1_out <= pipe_x_pos;
	 pipes_x_pos2_out <= pipe_x_pos2;
	 pipes_x_pos3_out <= pipe_x_pos3;
	 pipe_width_out <= pipe_width;
	 pipes_on_out <= pipes_on;
	 
	 --random_10 <=  rand & '0' & '0';
						
						

	pipes_on <= '1' when ((
	((pixel_row <= pipe_height or pixel_row + pipe_height_bot >= bottom) and (pipe_x_pos <= pixel_col or pipe_x_pos > conv_std_logic_vector(1048, 11)) and pixel_col <= pipe_x_pos + pipe_width) or 
	((pixel_row <= pipe_height2 or pixel_row + pipe_height_bot2 >= bottom) and (pipe_x_pos2 <= pixel_col or pipe_x_pos2 > conv_std_logic_vector(1048, 11)) and pixel_col <= pipe_x_pos2 + pipe_width) or 
	((pixel_row <= pipe_height3 or pixel_row + pipe_height_bot3 >= bottom) and (pipe_x_pos3 <= pixel_col or pipe_x_pos3 > conv_std_logic_vector(1048, 11)) and pixel_col <= pipe_x_pos3 + pipe_width)
	)

	 or (pixel_row >= conv_std_logic_vector(450, 10))
	) else '0';
	
	
	
--		pipes_on <= '1' when (( ( 
--	((pixel_row <= pipe_height or pixel_row + pipe_height_bot >= bottom) --and (pipe_x_pos <= pixel_col or pipe_x_pos > conv_std_logic_vector(1048, 11)) and pixel_col <= pipe_x_pos + pipe_width)) or 
--	(pixel_row <= pipe_height2 or pixel_row + pipe_height_bot2 >= bottom) or 
--	(pixel_row <= pipe_height3 or pixel_row + pipe_height_bot3 >= bottom)
--	)
--	 and 
--	
--	(
--	((pipe_x_pos <= pixel_col or pipe_x_pos > conv_std_logic_vector(1048, 11)) and pixel_col <= pipe_x_pos + pipe_width) or
--	((pipe_x_pos2 <= pixel_col or pipe_x_pos2 > conv_std_logic_vector(1048, 11)) and pixel_col <= pipe_x_pos2 + pipe_width) or
--	((pipe_x_pos3 <= pixel_col or pipe_x_pos3 > conv_std_logic_vector(1048, 11)) and pixel_col <= pipe_x_pos3 + pipe_width) 
--	))
--	 or (pixel_row >= conv_std_logic_vector(450, 10))
--	) else '0';
	 
	move_pipe : process(vert_sync)
    begin
		  --pipe_x_pos <= conv_std_logic_vector(400, 11);
        if rising_edge(vert_sync) then
				if (enable = '1') then
					if (pipe_x_pos + pipe_width <= conv_std_logic_vector(1, 11)) then --something about this is wrong maybe size of vectors idk adding the pipe_x_pos + ('0' & pipe_width) does nothing to where we reset but makes sure that we are always resetting??
						pipe_x_pos <= conv_std_logic_vector(700, 11);
						
						if (rand < conv_std_logic_vector(20, 10)) then
							pipe_height <= conv_std_logic_vector(20, 10);
							pipe_height_bot <= conv_std_logic_vector(300, 10);
						elsif (rand > conv_std_logic_vector(280, 10)) then
							pipe_height <= conv_std_logic_vector(280, 10);
							pipe_height_bot <= conv_std_logic_vector(40, 10);
						else 
							pipe_height <= rand;
							pipe_height_bot <= conv_std_logic_vector(480, 10) - rand - pipe_gap;
						end if;
						 
					else --add in elsif for the 2nd pipe less than zero and assign its center to the same spot
						pipe_x_pos <= pipe_x_pos - pipe_x_motion;
					end if;
				end if;
        end if;
    end process move_pipe;
	 
	 move_pipe2 : process(vert_sync)
		begin
			if (rising_edge(vert_sync)) then
				if (enable = '1') then
					if (pipe_x_pos2 + pipe_width <= conv_std_logic_vector(1,11)) then
						pipe_x_pos2 <= conv_std_logic_vector(700, 11);
						
						if (rand < conv_std_logic_vector(20, 10)) then
							pipe_height2 <= conv_std_logic_vector(20, 10);
							pipe_height_bot2 <= conv_std_logic_vector(300, 10);
						elsif (rand > conv_std_logic_vector(280, 10)) then
							pipe_height2 <= conv_std_logic_vector(280, 10);
							pipe_height_bot2 <= conv_std_logic_vector(40, 10);
						else 
							pipe_height2 <= rand;
							pipe_height_bot2 <=  conv_std_logic_vector(480, 10) - rand - pipe_gap;
						end if;
						
					else 
						pipe_x_pos2 <= pipe_x_pos2 - pipe_x_motion;
					end if;
				end if;
			end if;
	end process move_pipe2;
	
	
	move_pipe3 : process(vert_sync)
		begin
			if (rising_edge(vert_sync)) then
				if (enable = '1') then
					if (pipe_x_pos3 + pipe_width <= conv_std_logic_vector(1,11)) then
						pipe_x_pos3 <= conv_std_logic_vector(700, 11);
						
						if (rand < conv_std_logic_vector(20, 10)) then
							pipe_height3 <= conv_std_logic_vector(20, 10);
							pipe_height_bot3 <= conv_std_logic_vector(300, 10);
						elsif (rand > conv_std_logic_vector(280, 10)) then
							pipe_height3 <= conv_std_logic_vector(280, 10);
							pipe_height_bot3 <= conv_std_logic_vector(40, 10);
						else 
							pipe_height3 <= rand;
							pipe_height_bot3 <=  conv_std_logic_vector(480, 10) - rand - pipe_gap;
						end if;
					else 
						pipe_x_pos3 <= pipe_x_pos3 - pipe_x_motion;
					end if;
				end if;
			end if;
	end process move_pipe3;
	
end architecture arc;