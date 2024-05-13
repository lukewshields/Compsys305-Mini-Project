
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

--USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

--USE IEEE.STD_LOGIC_SIGNED.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity pipes is 
    port (pixel_row, pixel_col : in std_logic_vector (9 downto 0);
        clk, vert_sync, enable: in std_logic;
        red, green, blue: out std_logic
    );

end entity pipes;

architecture arc of pipes is 
    --could get rid of all the pipe before the variable names maybe
    signal  pipes_on : std_logic;
    signal pipe_height : std_logic_vector (9 downto 0) := std_logic_vector(to_unsigned(150, 10));
    signal pipe_width : std_logic_vector (9 downto 0) := std_logic_vector(to_unsigned(60, 10));
	 
    --signal pipe_gap : std_logic_vector (9 downto 0);
    signal pipe_separation : std_logic_vector (9 downto 0);
    signal pipe_x_motion : std_logic_vector (9 downto 0) := std_logic_vector(to_unsigned(4, 10));
	 
    signal pipe_x_pos : std_logic_vector (10 downto 0) := std_logic_vector(to_signed(600, 11));
	 signal pipe_x_pos2 : std_logic_vector (10 downto 0) := std_logic_vector(to_signed(300, 11));
	 
	 signal bottom : std_logic_vector (9 downto 0) := std_logic_vector(to_unsigned(479,10));
	 signal zero : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(0, 11));
	 
    begin

    red <= not pipes_on; --purple bg and green pipes lol
    green <= pipes_on;
    blue <= not pipes_on;
	 
	 --pipe_separation <= conv_std_logic_vector(80, 10);
	 
	-- pipe_width <= std_logic_vector(to_unsigned(50, 10);
	-- pipe_x_pos <= std_logic_vector(to_unsigned(600, 11);
	 

	 
	pipes_on <= '1' when (
    ((pixel_row <= pipe_height or std_logic_vector(to_unsigned(pixel_row + pipe_height, 10)) >= bottom) and 
        ((pipe_x_pos <= std_logic_vector(to_unsigned(pixel_col + pipe_width, 10)) and pixel_col <= pipe_x_pos + pipe_width) or 
        (pipe_x_pos2 <= std_logic_vector(to_unsigned(pixel_col + pipe_width, 10)) and pixel_col <= pipe_x_pos2 + pipe_width))
    ) or (pixel_row >= std_logic_vector(to_unsigned(458, 10)))
	) else '0';
	
    -- or same expressions but replace pipe_x_pos with pipe_x_pos2							
	 
	 
	move_pipe : process(vert_sync)
    begin
		  --pipe_x_pos <= conv_std_logic_vector(400, 11);
        if rising_edge(vert_sync) then
				if (enable = '1') then
					if (std_logic_vector(to_signed(pipe_x_pos + pipe_width, 11)) <= std_logic_vector(to_unsigned(1,11))) then --something about this is wrong maybe size of vectors idk adding the pipe_x_pos + ('0' & pipe_width) does nothing to where we reset but makes sure that we are always resetting??
						pipe_x_pos <= std_logic_vector(to_signed(240, 11)); --this never executes ghost reset??? something is wrong w math/type detecting this...
					end if;
					pipe_x_pos <= std_logic_vector(to_signed(pipe_x_pos - pipe_x_motion, 11));
				end if;
        end if;
    end process move_pipe;
	 
	 move_pipe2 : process(vert_sync)
    begin
		  --pipe_x_pos <= std_logic_vector(to_unsigned(400, 11);
        if rising_edge(vert_sync) then
				if (enable = '1') then
					if (std_logic_vector(to_signed(pipe_x_pos2 + pipe_width, 11)) <= std_logic_vector(to_unsigned(1,11))) then --something about this is wrong maybe size of vectors idk adding the pipe_x_pos + ('0' & pipe_width) does nothing to where we reset but makes sure that we are always resetting??
						pipe_x_pos2 <= std_logic_vector(to_signed(240, 11));
					end if;
					pipe_x_pos2 <= std_logic_vector(to_signed(pipe_x_pos2 - pipe_x_motion, 11));
				end if;
        end if;
    end process move_pipe2;


end architecture arc;