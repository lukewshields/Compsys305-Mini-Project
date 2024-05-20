


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
--use ieee.numeric_std.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity pipes is 
    port (pixel_row, pixel_col, rand: in std_logic_vector (9 downto 0);
			mode : in std_logic_vector (1 downto 0);
		  --init_x_pos : in std_logic_vector(10 downto 0);
			clk, vert_sync, enable, click, collision, reset: in std_logic;
			diff : in std_logic_vector(2 downto 0);
			red, green, blue, pipes_on_out, game_on: out std_logic;
			difficulty : out std_logic_vector (1 downto 0); --00 CORRESPONDS TO EASY 01 corresponds to MEDIUM, 11 corresponds to HARD
			pipes_x_pos1_out,pipes_x_pos2_out,pipes_x_pos3_out : out std_logic_vector (10 downto 0); -- for determining score
			pipe_width_out: OUT std_logic_vector (9 downto 0)
	 );
end entity pipes;

architecture arc of pipes is 
    --could get rid of all the pipe before the variable names maybe
	 signal pipe_gap : std_logic_vector (9 downto 0); --:= conv_std_logic_vector(120, 10); -- can later be shrunk based on the level/difficulty of the game 
	 --note 120 will be used for hard mode, 160 for medium and 200 for easy
	 
    signal pipes_on : std_logic;
    signal pipe_height : std_logic_vector (9 downto 0) := conv_std_logic_vector(160, 10); --without any other _ , then pipe_height is equal to the top one
	 signal pipe_height_bot : std_logic_vector (9 downto 0) := conv_std_logic_vector(160, 10);
	 
	 signal pipe_height2 : std_logic_vector (9 downto 0) := conv_std_logic_vector(160, 10); --without any other _ , then pipe_height is equal to the top one
	 signal pipe_height_bot2 : std_logic_vector (9 downto 0) := conv_std_logic_vector(160, 10);
	 
	 signal pipe_height3 : std_logic_vector (9 downto 0) := conv_std_logic_vector(160, 10); --without any other _ , then pipe_height is equal to the top one
	 signal pipe_height_bot3 : std_logic_vector (9 downto 0) := conv_std_logic_vector(160, 10);
	 
    signal pipe_width : std_logic_vector (9 downto 0) := conv_std_logic_vector(40, 10);

    signal pipe_x_motion : std_logic_vector (9 downto 0) := conv_std_logic_vector(4, 10);
	 
	 signal pipe_x_motion_prev : std_logic_vector (9 downto 0);
	 signal has_collided : std_logic;
	 
    signal pipe_x_pos : std_logic_vector (10 downto 0) := conv_std_logic_vector(960, 11);
	 signal pipe_x_pos2 : std_logic_vector(10 downto 0) := conv_std_logic_vector(720, 11);
	 signal pipe_x_pos3 : std_logic_vector(10 downto 0) := conv_std_logic_vector(1200, 11);
	 
	 signal bottom : std_logic_vector (9 downto 0) := conv_std_logic_vector(479,10);
	 signal ground : std_logic_vector (9 downto 0) := conv_std_logic_vector(460, 10);
	 
	 signal game_on_s : std_logic;
	 
	-- signal random_10 : std_logic_vector (9 downto 0); 
	 
    begin

    red <= not pipes_on; 
    green <= pipes_on;
    blue <= not pipes_on; 
	 pipes_x_pos1_out <= pipe_x_pos;
	 pipes_x_pos2_out <= pipe_x_pos2;
	 pipes_x_pos3_out <= pipe_x_pos3;
	 pipe_width_out <= pipe_width;
	 pipes_on_out <= pipes_on;
	 
	 --random_10 <=  rand & '0' & '0';
	game_on <= game_on_s;			
						

	pipes_on <= '1' when (((
	((pixel_row <= pipe_height or pixel_row + pipe_height_bot >= bottom) and (pipe_x_pos <= pixel_col or pipe_x_pos > conv_std_logic_vector(1500, 11)) and pixel_col <= pipe_x_pos + pipe_width) or 
	((pixel_row <= pipe_height2 or pixel_row + pipe_height_bot2 >= bottom) and (pipe_x_pos2 <= pixel_col or pipe_x_pos2 > conv_std_logic_vector(1500, 11)) and pixel_col <= pipe_x_pos2 + pipe_width) or 
	((pixel_row <= pipe_height3 or pixel_row + pipe_height_bot3 >= bottom) and (pipe_x_pos3 <= pixel_col or pipe_x_pos3 > conv_std_logic_vector(1500, 11)) and pixel_col <= pipe_x_pos3 + pipe_width)
	) and (mode = "10" or mode = "01"))

	 or (pixel_row >= conv_std_logic_vector(450, 10)) -- and (mode = "10" or mode = "01")
	) else '0'; --later add an and mode is in one of the states where we need pipes
	
	
	
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
--				if (reset = '1') then
--					pipe_x_pos <= conv_std_logic_vector(960, 11); --CANT ASSIGN MULTIPLE DRIVERS
--					
--				--end if;
				if (enable = '1' and (mode = "10" or mode = "01")) then
					if ((pipe_x_pos + pipe_width <= conv_std_logic_vector(1, 11)) and has_collided = '0') then --something about this is wrong maybe size of vectors idk adding the pipe_x_pos + ('0' & pipe_width) does nothing to where we reset but makes sure that we are always resetting??
						game_on_s <= '1';
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
					elsif (has_collided = '1') then
						game_on_s <= '0';
						pipe_x_pos <= conv_std_logic_vector(960, 11);
					else 
						game_on_s <= '1';
						pipe_x_pos <= pipe_x_pos - pipe_x_motion;
					end if;
				end if;
        end if;
    end process move_pipe;
	 
	 move_pipe2 : process(vert_sync)
		begin
			if (rising_edge(vert_sync)) then
--				if (reset = '1') then
--					pipe_x_pos <= conv_std_logic_vector(720, 11);
--				--end if;
				if (enable = '1' and (mode = "10" or mode = "01")) then
					if ((pipe_x_pos2 + pipe_width <= conv_std_logic_vector(1,11)) and has_collided = '0') then
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
						
					elsif (has_collided = '1') then
						pipe_x_pos2 <= conv_std_logic_vector(720, 11);
					else 
						pipe_x_pos2 <= pipe_x_pos2 - pipe_x_motion;
					end if;
				end if;
			end if;
	end process move_pipe2;
	
	
	move_pipe3 : process(vert_sync)
		begin
			if (rising_edge(vert_sync)) then
--				if (reset = '1') then
--					pipe_x_pos <= conv_std_logic_vector(1200, 11);
--				--end if;
				if (enable = '1' and (mode = "10" or mode = "01")) then
					if ((pipe_x_pos3 + pipe_width <= conv_std_logic_vector(1,11)) and has_collided = '0') then
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
					elsif (has_collided = '1') then
						pipe_x_pos3 <= conv_std_logic_vector(1200, 11);
					else 
						pipe_x_pos3 <= pipe_x_pos3 - pipe_x_motion;
					end if;
				end if;
			end if;
	end process move_pipe3;
	
	pipe_motion : process(vert_sync)
		begin
			if (rising_edge(vert_sync)) then
				if (collision = '1' or reset = '1') then -- still unstable signal wolnt compile with rising edge
					has_collided <= '1';
--					pipe_x_pos <= conv_std_logic_vector(600, 11);
--					pipe_x_pos2 <= conv_std_logic_vector(360, 11);
--					pipe_x_pos3 <= conv_std_logic_vector(840, 11);
				elsif (click = '1' and has_collided = '1') then -- from here to the reset of the pipes takes time 
					has_collided <= '0';
				end if;
			end if;
	end process pipe_motion;
	
	gap_width : process(vert_sync)
	
		begin
			if (rising_edge(vert_sync)) then --maybe later move this logic out of the pipes module, and move it to its own difficulty module, so many diff things can be set by it?
				if (diff(0) = '1' and mode = "10") then
					pipe_gap <= conv_std_logic_vector(200, 10);
					difficulty <= "00";
				elsif(diff(1) = '1' and mode = "10") then
					pipe_gap <= conv_std_logic_vector(160, 10);
					difficulty <= "01";
				elsif(diff(2) = '1' and mode = "10") then
					pipe_gap <= conv_std_logic_vector(120, 10);
					difficulty <= "11";
				else 
					pipe_gap <= conv_std_logic_vector(200, 10);
					difficulty <= "00";
				end if;
			end if;		
	end process gap_width;
	
	
end architecture arc;