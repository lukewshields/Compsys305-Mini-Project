
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
--use ieee.numeric_std.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity pipes is 
    port (pixel_row, pixel_col : in std_logic_vector (9 downto 0);
        clk, vert_sync, enable: in std_logic;
        red, green, blue: out std_logic
    );

end entity pipes;

architecture arc of pipes is 
    --could get rid of all the pipe before the variable names maybe
    signal  pipes_on : std_logic;
    signal pipe_height : std_logic_vector (9 downto 0);
    signal pipe_width : std_logic_vector (9 downto 0);
    --signal pip_gap : std_logic_vector (9 downto 0);
    signal pipe_separation : std_logic_vector (9 downto 0);
    signal pipe_x_motion : std_logic_vector (9 downto 0);
	 
    signal pipe_x_pos : std_logic_vector (10 downto 0) := conv_std_logic_vector(600, 11);
	 signal pipe_x_pos2 : std_logic_vector (10 downto 0) := conv_std_logic_vector(300, 11);
	 --signal pipe_x_pos2 : std_logic_vector (10 downto 0);
	 --signal pipe_x_pos : signed (10 downto 0);
	 
	 signal bottom : std_logic_vector (9 downto 0);
	 signal edge_right : std_logic_vector (10 downto 0);
	 signal zero : std_logic_vector(10 downto 0);
	 
    begin

    red <= not pipes_on; --purple bg and green pipes lol
    green <= pipes_on;
    blue <= not pipes_on;
	 
	 pipe_height <= conv_std_logic_vector(150, 10);
	 bottom <= conv_std_logic_vector(479,10);
	 edge_right <= conv_std_logic_vector(599, 11);
	 zero <= conv_std_logic_vector(0, 11);
	 pipe_x_motion <= conv_std_logic_vector(3, 10);
	 pipe_width <= conv_std_logic_vector(50, 10);
	 
	 
	 
	 --pipe_separation <= conv_std_logic_vector(80, 10);
	 
	-- pipe_width <= conv_std_logic_vector(50, 10);
	-- pipe_x_pos <= conv_std_logic_vector(600, 11);
	 
	 --pipe_x_pos <= to_signed(240, 11);
	
	 
    

	 pipes_on <= '1' when ((pixel_row <= pipe_height or pixel_row + pipe_height >= bottom) and ((pipe_x_pos <= pixel_col + pipe_width and pixel_col <= pipe_x_pos + pipe_width)

	 or (pipe_x_pos2 <= pixel_col + pipe_width and pixel_col <= pipe_x_pos2 + pipe_width))) else '0'; --need the extra statements??
    -- or same expressions but replace pipe_x_pos with pipe_x_pos2							
	 
	 
	move_pipe : process(vert_sync)
    begin
		  --pipe_x_pos <= conv_std_logic_vector(400, 11);
        if rising_edge(vert_sync) then
            if (pipe_x_pos + pipe_width <= zero) then --something about this is wrong maybe size of vectors idk adding the pipe_x_pos + ('0' & pipe_width) does nothing to where we reset but makes sure that we are always resetting??
                pipe_x_pos <= conv_std_logic_vector(700, 11);
				elsif(pipe_x_pos2 + pipe_width <= zero) then --being weird ab updating
					pipe_x_pos2 <= conv_std_logic_vector(700, 11);
            else --add in elsif for the 2nd pipe less than zero and assign its center to the same spot
                pipe_x_pos <= pipe_x_pos - pipe_x_motion;
					 pipe_x_pos2 <= pipe_x_pos2 - pipe_x_motion;
            end if;
        end if;
    end process move_pipe;




end architecture arc;
