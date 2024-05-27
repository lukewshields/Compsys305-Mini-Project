
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.NUMERIC_STD.all;
USE  IEEE.STD_LOGIC_SIGNED.all;



ENTITY bird IS
	PORT
		(clk, vert_sync, horiz_sync, click, enable, reset, game_on	: IN std_logic;
		 mode : in std_logic_vector (1 downto 0);
		 collision : in std_logic;
       pixel_row, pixel_col	: IN std_logic_vector(9 DOWNTO 0);
		 lives : in std_logic_vector(5 downto 0);
		 --mode : in std_logic_vector(1 downto 0);
		 red, green, blue, bird_on_out, death : OUT std_logic;
		 rgb : out std_logic_vector(11 downto 0);
		 bird_x_pos_out: out std_logic_vector(9 DOWNTO 0)
		 );		
END bird;

architecture behavior of bird is

SIGNAL bird_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0) := std_logic_vector(to_unsigned(8, 10));  
SIGNAL bird_y_pos				: std_logic_vector(9 DOWNTO 0) := std_logic_vector(to_unsigned(200, 10));
SiGNAL bird_x_pos				: std_logic_vector(9 DOWNTO 0) := std_logic_vector(to_unsigned(300, 10));
SIGNAL bird_y_motion			: std_logic_vector(9 DOWNTO 0) := std_logic_vector(to_unsigned(1, 10));
signal prev_clicked : std_logic;
signal counter : integer := 0; 
signal fall_early,has_collided : std_logic;
signal death_s : std_logic;

constant BIRD_SCALE : std_logic_vector:= std_logic_vector(to_unsigned(1, 10));
signal character_address : std_logic_vector(12 downto 0) :=  std_logic_vector(to_unsigned(0, 13));
signal t_bird_rgb : std_logic_vector(11 downto 0);
signal temp_bird_on : std_logic;

signal bird_addy_bird :  STD_LOGIC_VECTOR(9 downto 0);

--component sprite32
--	generic (
--					scale:std_logic_vector
--					);
--	port(
--			clk, reset, horiz_sync : IN STD_LOGIC;
--			character_address : IN STD_LOGIC_VECTOR(12 downto 0);
--			sprite_row, sprite_column, 
--			pixel_row, pixel_column : IN STD_LOGIC_VECTOR(9 downto 0);
--			rgb : OUT STD_LOGIC_VECTOR(11 downto 0);
--			sprite_on: OUT STD_LOGIC
--			);
--end component;

component bird_rom 
	port(
		font_row, font_col : IN std_logic_vector(9 DOWNTO 0);
		clock				: 	IN STD_LOGIC ;
		bird_addy :   in STD_LOGIC_VECTOR(9 downto 0);
		rgb : OUT STD_LOGIC_VECTOR(11 downto 0)
	);
end component bird_rom;


BEGIN

--display : Process(clk,bird_on)
--begin 
--	if rising_edge(clk) then
--		if (bird_on = '1') then
--			bird_addy_bird <= std_logic_vector(to_unsigned(
--								(to_integer(unsigned(pixel_row)) - to_integer(unsigned(bird_y_pos))) * 32 +
--								(to_integer(unsigned(pixel_col)) - to_integer(unsigned(bird_x_pos))), 10));
--		end if;
--	end if;
--end process;
		
		
Coin_Display : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (to_integer(unsigned(pixel_col)) >= to_integer(unsigned(bird_x_pos)) AND
                to_integer(unsigned(pixel_col)) < to_integer(unsigned(bird_x_pos)) + to_integer(unsigned(size)) AND
                to_integer(unsigned(pixel_row)) >= to_integer(unsigned(bird_y_pos)) AND
                to_integer(unsigned(pixel_row)) < to_integer(unsigned(bird_y_pos)) + to_integer(unsigned(size))) THEN
                bird_on <= '1';
                bird_addy_bird <= std_logic_vector(to_unsigned(
                    (to_integer(unsigned(pixel_row)) - to_integer(unsigned(bird_y_pos))) * 1 +
                    (to_integer(unsigned(pixel_col)) - to_integer(unsigned(bird_x_pos))), 10));
            ELSE
                bird_on <= '0';
            END IF;
        END IF;
    END PROCESS Coin_Display;
		
--bird_x_pos<= std_logic_vector(to_unsigned();(300,10);

sprites : bird_rom
	port map(
		bird_x_pos,bird_y_pos,clk, bird_addy_bird, t_bird_rgb
	);
	
rgb <= t_bird_rgb;

--sprite_component : sprite32
--	generic map(
--					BIRD_SCALE
--					)
--	port map(
--			clk, '0', horiz_sync, character_address, bird_y_pos, bird_x_pos, pixel_row, pixel_col, t_bird_rgb, temp_bird_on
--			);
           
--bird_x_pos_out<=bird_x_pos;
--size <= std_logic_vector(to_unsigned();(8,10);
-- bird_x_pos and bird_y_pos show the (x,y) for the centre of ball

----how to get a bird shape instead of a ball shape?
--bird_on <= '1' when ((((pixel_col - bird_x_pos) * (pixel_col - bird_x_pos) + (pixel_row - bird_y_pos) * (pixel_row - bird_y_pos) <= size * size)) and (mode = "10" or mode = "01")) else	-- y_pos - size <= pixel_row <= y_pos + size
--			'0'; -- later add an and mode is in one of the states where we want the ball
--bird_on <= temp_bird_on;

-- Colours for pixel data on video signal
--cyan bg and red ball

Red <= bird_on;
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
		if (death_s = '0') then
		if (reset = '1') then
			bird_y_pos <= std_logic_vector(to_unsigned(200, 10));
			bird_y_motion <= std_logic_vector(to_unsigned(0, 10));
		end if;
		
		if (enable = '1' and (mode = "10" or mode = "01") ) then 
			prev_clicked <= click;
			if (click /= '0' and prev_clicked = '0' and has_collided = '0') then
				counter <= 0;
				fall_early <= '0';
			end if;
		
			if (counter < 8 and fall_early = '0' and bird_y_pos >= std_logic_vector(to_unsigned(10,10))) then --need to do the similar thing with the collide previous collision and collision
				bird_y_motion <= - std_logic_vector(to_unsigned(10,10));
				counter <= counter + 1;
			elsif ((counter >= 8 or (click /= '1' and prev_clicked = '1')) and has_collided = '0') then
				counter <= 0;
				fall_early <= '1';
			elsif (has_collided = '0') then
				bird_y_motion <= std_logic_vector(to_unsigned(4,10));
			end if;
			
			if (game_on = '1') then --used this to make sure we do not fall when initially starting the game
				bird_y_pos <= bird_y_pos + bird_y_motion;
			end if;

			if(collision = '1' or reset = '1') then --collide or change of modes
				bird_y_pos <= std_logic_vector(to_unsigned(200, 10));
				bird_y_motion <= std_logic_vector(to_unsigned(0, 10));
				has_collided <= '1';
				if (lives <= "000000") then
					death_s <= '1';
				else 
					death_s <= '0';
				end if;
			end if;
			
			if (click = '1' and has_collided='1') then
				has_collided <= '0';
				--death_s <= '0';--begin falling again
			end if;
			
		end if;
		end if;
		
		if (click = '1') then 
			death_s <= '0';
		end if;
	end if;
end process Move_Ball;
death <= death_s;

--	collision_motion : process(vert_sync)
--		
--		begin
--			if (rising_edge(vert_sync)) then
--				if (collision = '1') then -- still unstable signal wolnt compile with rising edge
--					bird_y_pos <= std_logic_vector(to_unsigned();(200, 10);
--				end if;
--			end if;
--	end process collision_motion;
			
END behavior;