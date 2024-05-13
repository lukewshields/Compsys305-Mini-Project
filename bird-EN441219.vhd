LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bird IS
	PORT
		(clk, vert_sync, click, enable	: IN std_logic;
       pixel_row, pixel_col	: IN std_logic_vector(9 DOWNTO 0);
		 red, green, blue 			: OUT std_logic);		
END bird;

architecture behavior of bird is

SIGNAL bird_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL bird_y_pos				: std_logic_vector(9 DOWNTO 0) := conv_std_logic_vector(200, 10);
SiGNAL bird_x_pos				: std_logic_vector(9 DOWNTO 0) := conv_std_logic_vector(300, 10);
SIGNAL bird_y_motion			: std_logic_vector(9 DOWNTO 0) := conv_std_logic_vector(1, 10);
signal prev_clicked : std_logic;
signal counter : integer := 0; 
signal fall_early : std_logic;



BEGIN           

size <= CONV_STD_LOGIC_VECTOR(8,10);
-- bird_x_pos and bird_y_pos show the (x,y) for the centre of ball

--how to get a bird shape instead of a ball shape?
bird_on <= '1' when (((pixel_col - bird_x_pos) * (pixel_col - bird_x_pos) + (pixel_row - bird_y_pos) * (pixel_row - bird_y_pos) <= size * size)) else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';


-- Colours for pixel data on video signal
--cyan bg and red ball

Red <=  bird_on;
Green <= not bird_on; 
Blue <=  not bird_on;




Move_Ball: process (vert_sync, click)  
begin
	--Move ball once every vertical sync
	if (rising_edge(vert_sync)) then		
		if (enable = '1') then
		--Bounce off top or bottom of the screen
			prev_clicked <= click;
			if (click /= '0' and prev_clicked = '0') then
				counter <= 0;
				fall_early <= '0';
			end if;
		
			if (counter < 8 and fall_early = '0') then
				bird_y_motion <= - conv_std_logic_vector(10,10);
				counter <= counter + 1;
			elsif (counter >= 8 or (click /= '1' and prev_clicked = '1')) then
				counter <= 0;
				fall_early <= '1';
			else  
				bird_y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			end if;
			--Compute next ball Y position
			bird_y_pos <= bird_y_pos + bird_y_motion;
		end if;
	end if;
end process Move_Ball;
			
END behavior;
