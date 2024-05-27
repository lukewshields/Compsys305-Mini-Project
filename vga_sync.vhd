
library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY VGA_SYNC IS
	PORT(	clock_25Mhz, red, green, blue		: IN	STD_LOGIC;
			rgb : in std_logic_vector(11 downto 0);
			bird_on : IN std_logic;
			red_out, green_out, blue_out : out std_logic_vector(3 downto 0);
			horiz_sync_out, vert_sync_out	: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END VGA_SYNC;

ARCHITECTURE a OF VGA_SYNC IS
	SIGNAL horiz_sync, vert_sync : STD_LOGIC;
	SIGNAL video_on, video_on_v, video_on_h : STD_LOGIC;
	SIGNAL h_count, v_count :STD_LOGIC_VECTOR(9 DOWNTO 0);
	signal t_rgb : std_logic_vector(11 downto 0);

BEGIN

-- video_on is high only when RGB data is displayed
video_on <= video_on_H AND video_on_V;

t_rgb <= rgb;


PROCESS
BEGIN
	WAIT UNTIL(clock_25Mhz'EVENT) AND (clock_25Mhz='1');

--Generate Horizontal and Vertical Timing Signals for Video Signal
-- H_count counts pixels (640 + extra time for sync signals)
-- 
--  Horiz_sync  ------------------------------------__________--------
--  H_count       0                640             659       755    799
--
	IF (h_count = 799) THEN
   		h_count <= "0000000000";
	ELSE
   		h_count <= h_count + 1;
	END IF;

--Generate Horizontal Sync Signal using H_count
	IF (h_count <= 755) AND (h_count >= 659) THEN
 	  	horiz_sync <= '0';
	ELSE
 	  	horiz_sync <= '1';
	END IF;

--V_count counts rows of pixels (480 + extra time for sync signals)
--  
--  Vert_sync      -----------------------------------------------_______------------
--  V_count         0                                      480    493-494          524
--
	IF (v_count >= 524) AND (h_count >= 699) THEN
   		v_count <= "0000000000";
	ELSIF (h_count = 699) THEN
   		v_count <= v_count + 1;
	END IF;

-- Generate Vertical Sync Signal using V_count
	IF (v_count <= 494) AND (v_count >= 493) THEN
   		vert_sync <= '0';
	ELSE
  		vert_sync <= '1';
	END IF;

-- Generate Video on Screen Signals for Pixel Data
	IF (h_count <= 639) THEN
   		video_on_h <= '1';
   		pixel_column <= h_count;
	ELSE
	   	video_on_h <= '0';
	END IF;

	IF (v_count <= 479) THEN
   		video_on_v <= '1';
   		pixel_row <= v_count;
	ELSE
   		video_on_v <= '0';
	END IF;

-- Put all video signals through DFFs to elminate any delays that cause a blurry image
	if(video_on = '1') then
		if(bird_on = '1') then 
			red_out <= t_rgb(11 downto 8);
			green_out <= t_rgb(7 downto 4);
			blue_out <= t_rgb(3 downto 0);
		else
			red_out <= red & red & red & red;
			green_out <= green & green & green & green;
			blue_out <= blue & blue & blue & blue;
		end if;
	else
--			red_out <= "0000";
--			green_out <= "0000";
--			blue_out <= "0000";

--			red_out <= red & red & red & red;
--			green_out <= green & green & green & green;
--			blue_out <= blue & blue & blue & blue;
		
	end if;
--		red_out <= "1111" when video_on = '1' else "0000";
--		green_out <= "1111"when video_on = '1' else "0000";
--		blue_out <= "1111"when video_on = '1' else "0000";
--	
----		red_out <= red AND video_on;
----		green_out <= green AND video_on;
----		blue_out <= blue AND video_on;
	
		horiz_sync_out <= horiz_sync;
		vert_sync_out <= vert_sync;

END PROCESS;
END a;
