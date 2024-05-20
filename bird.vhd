
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bird IS
	PORT
		(clk, vert_sync, click, enable, reset	: IN std_logic;
		 mode : in std_logic_vector (1 downto 0);
		 collision : in std_logic;
       pixel_row, pixel_col	: IN std_logic_vector(9 DOWNTO 0);
		 --mode : in std_logic_vector(1 downto 0);
		 red, green, blue, bird_on_out : OUT std_logic;
		 bird_x_pos_out: out std_logic_vector(9 DOWNTO 0)
		 );		
END bird;

architecture behavior of bird is

SIGNAL bird_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0) := conv_std_logic_vector(8, 10);  
SIGNAL bird_y_pos				: std_logic_vector(9 DOWNTO 0) := conv_std_logic_vector(200, 10);
SiGNAL bird_x_pos				: std_logic_vector(9 DOWNTO 0) := conv_std_logic_vector(300, 10);
SIGNAL bird_y_motion			: std_logic_vector(9 DOWNTO 0) := conv_std_logic_vector(1, 10);
signal prev_clicked : std_logic;
signal counter : integer := 0; 
signal fall_early,has_collided : std_logic;




BEGIN           
bird_x_pos_out<=bird_x_pos;
--size <= CONV_STD_LOGIC_VECTOR(8,10);
-- bird_x_pos and bird_y_pos show the (x,y) for the centre of ball

--how to get a bird shape instead of a ball shape?
bird_on <= '1' when ((((pixel_col - bird_x_pos) * (pixel_col - bird_x_pos) + (pixel_row - bird_y_pos) * (pixel_row - bird_y_pos) <= size * size)) and (mode = "10" or mode = "01")) else	-- y_pos - size <= pixel_row <= y_pos + size
			'0'; -- later add an and mode is in one of the states where we want the ball


-- Colours for pixel data on video signal
--cyan bg and red ball

Red <=  bird_on;
Green <= not bird_on; 
Blue <=  not bird_on;
bird_on_out <= bird_on;

----this output signal tracks the front of the bird
--front_bird_y <= bird_y_pos;
--front_bird_x <= bird_x_pos + size;
--
----this output signal tracks the top of the bird
--top_bird_y <= bird_y_pos + size;
--top_bird_x <= bird_x_pos;


Move_Ball: process (vert_sync, click)  
begin
	--Move ball once every vertical sync
	if (rising_edge(vert_sync)) then		
		if (reset = '1') then
			bird_y_pos <= conv_std_logic_vector(200, 10);
			bird_y_motion <= conv_std_logic_vector(0, 10);
		end if;
		
		if (enable = '1' and (mode = "10" or mode = "01") ) then 
			prev_clicked <= click;
			if (click /= '0' and prev_clicked = '0' and has_collided = '0') then
				counter <= 0;
				fall_early <= '0';
			end if;
		
			if (counter < 8 and fall_early = '0' and bird_y_pos >= conv_std_logic_vector(10,10)) then --need to do the similar thing with the collide previous collision and collision
				bird_y_motion <= - conv_std_logic_vector(10,10);
				counter <= counter + 1;
			elsif ((counter >= 8 or (click /= '1' and prev_clicked = '1')) and has_collided = '0') then
				counter <= 0;
				fall_early <= '1';
--			elsif (collision = '1') then
--				bird_y_pos = CONV_STD_LOGIC_VECTOR(300,10);
--				bird_y_motion <= CONV_STD_LOGIC_VECTOR(0,10);
			elsif (has_collided = '0') then
				bird_y_motion <= CONV_STD_LOGIC_VECTOR(4,10);
			end if;
			bird_y_pos <= bird_y_pos + bird_y_motion;

			if(collision = '1' or reset = '1') then
				bird_y_pos <= conv_std_logic_vector(200, 10);
				bird_y_motion <= conv_std_logic_vector(0, 10);
				has_collided <= '1';
			end if;
			
			if (click = '1' and has_collided='1') then
				has_collided <= '0';
			end if;
			--Compute next ball Y position
		end if;
	end if;
end process Move_Ball;

--	collision_motion : process(vert_sync)
--		
--		begin
--			if (rising_edge(vert_sync)) then
--				if (collision = '1') then -- still unstable signal wolnt compile with rising edge
--					bird_y_pos <= conv_std_logic_vector(200, 10);
--				end if;
--			end if;
--	end process collision_motion;
			
END behavior;
