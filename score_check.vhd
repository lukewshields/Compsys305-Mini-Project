LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity score_check is 
	port(
		vert_sync, Enable, collision, game_on, reset, death : in std_logic;
		mode : in std_logic_vector (1 downto 0);
		pipe_x_pos1,pipe_x_pos2,pipe_x_pos3 : in std_logic_vector (10 downto 0);
		pipe_width,bird_x_pos : in std_logic_vector (9 downto 0);
		score: out std_logic_vector (6 downto 0); 
		tens,ones: out std_logic_vector (3 downto 0)
	);
end entity score_check;


architecture beh of score_check is 
signal score_s : std_logic_vector(6 downto 0);
signal pipe_count1,pipe_count2,pipe_count3 : integer:= 1; 
signal current_score : integer;
	begin
		process (vert_sync, Enable)
		begin 
			if (rising_edge(vert_sync)) then
				if (enable = '1') then
					if (reset = '1' or death = '1') then
						score_s <= "0000000";
					elsif (reset = '1' or collision = '1') then
						pipe_count1 <= 1;
						pipe_count2 <= 1;
						pipe_count3 <= 1;
					elsif (game_on = '1') then 
						if ((pipe_x_pos1 + pipe_width) <= bird_x_pos and pipe_count1 = 0) then
							score_s <= score_s + "0000001";
							pipe_count1 <= 1;
						elsif ((pipe_x_pos1 + pipe_width)>bird_x_pos and pipe_count1 = 1) then
							pipe_count1 <= 0;
						end if;
						if ((pipe_x_pos2 + pipe_width) <= bird_x_pos and pipe_count2 = 0) then
							score_s <= score_s + "0000001";
							pipe_count2 <= 1;
						elsif ((pipe_x_pos2 + pipe_width)>bird_x_pos and pipe_count2 = 1) then
							pipe_count2 <= 0;
						end if;
						if ((pipe_x_pos3 + pipe_width) <= bird_x_pos and pipe_count3 = 0) then
							score_s <= score_s + "0000001";
							pipe_count3 <= 1;
						elsif ((pipe_x_pos3 + pipe_width)>bird_x_pos and pipe_count3 = 1) then
							pipe_count3 <= 0;
						end if;
					end if;
				end if;
			end if;
	end process;
	score <= score_s;
	
	current_score <= conv_integer(unsigned(score_s));
	
	tens <= CONV_STD_LOGIC_VECTOR(current_score/10, 4);  -- Right shift by 4 to get tens digit
	ones <= CONV_STD_LOGIC_VECTOR(current_score mod 10, 4); 
end architecture beh; 