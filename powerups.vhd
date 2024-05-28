LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

--Component for life powerups
entity powerups is 

	port (
		pixel_row, pixel_col, rand, pipe_speed : in std_logic_vector(9 downto 0);
		vert_sync, death, enable, collision, collision_pipe, reset, game_on : in std_logic;
		mode : in std_logic_vector(1 downto 0);
		red, green, blue, powerup_on_out : out std_logic
	);

end entity powerups;

architecture arc of powerups is 

signal powerup_on : std_logic;
signal size : std_logic_vector(9 downto 0) := conv_std_logic_vector(7, 10);
signal x_pos : std_logic_vector(10 downto 0);
signal y_pos : std_logic_vector(9 downto 0) := conv_std_logic_vector(240, 10);


begin

powerup_on <= '1' when ((((pixel_col - x_pos) * (pixel_col - x_pos) + (pixel_row - y_pos) * (pixel_row - y_pos) <= size * size)) and (mode = "10")) else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';

--draws a sideways heart kinda?
--powerup_on <= '1' when ( --GPT failed at drawing a heart ;(
--    --(((pixel_col - x_pos) * (pixel_col - x_pos) + (pixel_row - y_pos) * (pixel_row - y_pos)) <= (size * size)) and 
--    (mode = "10") and
--    (
--        -- Heart Shape Equation
--        (
--				(((pixel_row - y_pos) <= size) and ((pixel_col - x_pos) * (pixel_col - x_pos) + (pixel_row - y_pos) * (pixel_row - y_pos) <= size * size))
--
--            and
--            (
--                -- Lower left part of the heart
--                (
--                    ((pixel_col - x_pos) + abs(pixel_row - y_pos)) <= size
--                )
--            )
--            and
--            (
--                -- Lower right part of the heart
--                (
--                    (abs(pixel_col - x_pos) - abs(pixel_row - y_pos)) <= size
--                )
--            )
--        )
--    )
--) else '0';

--Gpt garbage
--powerup_on <= '1' when (
--    ((((pixel_col - x_pos) * (pixel_col - x_pos) + (pixel_row - y_pos - conv_std_logic_vector(6, 10)) * (pixel_row - y_pos - conv_std_logic_vector(6, 10)) <= conv_std_logic_vector(6, 10) * conv_std_logic_vector(6, 10))) and (pixel_row <= y_pos - conv_std_logic_vector(6, 10))) or  -- top-left curve
--    ((((pixel_col - x_pos - conv_std_logic_vector(6, 10)) * (pixel_col - x_pos - conv_std_logic_vector(6, 10)) + (pixel_row - y_pos) * (pixel_row - y_pos) <= conv_std_logic_vector(6, 10) * conv_std_logic_vector(6, 10)) and (pixel_col <= x_pos))) or  -- top-right curve
--    ((((pixel_col - x_pos + conv_std_logic_vector(6, 10)) * (pixel_col - x_pos + conv_std_logic_vector(6, 10)) + (pixel_row - y_pos) * (pixel_row - y_pos) <= conv_std_logic_vector(6, 10) * conv_std_logic_vector(6, 10)) and (pixel_col >= x_pos))) or  -- top-left curve
--    (pixel_col >= (x_pos - conv_std_logic_vector(6, 10)) and pixel_col <= (x_pos + conv_std_logic_vector(6, 10)) and pixel_row >= y_pos - conv_std_logic_vector(6, 10) and pixel_row <= y_pos + conv_std_logic_vector(6, 10))  -- bottom rectangle
--) and (mode = "10") else
--'0';


--Tried implementing by self
--powerup_on <= '1' when ( (pixel_col - x_pos <= size) and (
--	--left half of top semicircel
--	--within size of the Y_pos on the top and circel equation starting at over - half size from normal x_pos and only less than size
--	(((pixel_col - (x_pos)) * (pixel_col - (x_pos)) + (pixel_row - y_pos) * (pixel_row - y_pos) <= size * size))
----	and ((pixel_row - y_pos <= size) and ((pixel_col - (x_pos + half_size)) * (pixel_col - (x_pos + half_size)) + (pixel_row - y_pos) * (pixel_row - y_pos) <= size))
----	and 
----	
----		(((pixel_col - x_pos) + abs(pixel_row - y_pos)) <= size)
----      and
----            (
----                -- Lower right part of the heart
----                (
----                    (abs(pixel_col - x_pos) - abs(pixel_row - y_pos)) <= size
----                )
----            )
--) and (mode = "10")) else '0';
--powerup_on_out <= powerup_on;


powerup_on_out <= powerup_on;

Red <=  powerup_on;
Green <= not powerup_on; 
Blue <=  not powerup_on;

move_powerup : process(vert_sync, game_on, death, enable) --update x motion according to the pipe_speed

begin
	if (game_on = '1' and death = '0') then
		if(rising_edge(vert_sync)) then
			if (mode = "10" and enable = '1') then
				if(x_pos + size <= conv_std_logic_vector(1, 11) or collision = '1') then
					x_pos <= conv_std_logic_vector(800, 11);
					if (rand > conv_std_logic_vector(450, 10)) then
						y_pos <= conv_std_logic_vector(440, 10);
					elsif (rand < conv_std_logic_vector(10, 10)) then
						y_pos <= conv_std_logic_vector(20, 10);
					else 
						y_pos <= rand;
					end if;
				else 
					if (collision_pipe = '1') then
						y_pos <= conv_std_logic_vector(900, 10);
					end if;
					x_pos <= x_pos - pipe_speed;
				end if;
			end if;
		end if;
	else 
		
		x_pos <= conv_std_logic_vector(800, 11);
	end if;

end process move_powerup;


end architecture arc;