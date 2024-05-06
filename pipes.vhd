LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
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
    --signal pipe_separation : std_logic_vector (9 downto 0);
    signal pipe_x_motion : std_logic_vector (9 downto 0);
    signal pipe_x_pos : std_logic_vector (10 downto 0);
	 --signal pipe_x_pos : signed (10 downto 0);
	 signal bottom : std_logic_vector (9 downto 0);

    begin

    red <= not pipes_on; --purple bg and green pipes lol
    green <= pipes_on;
    blue <= not pipes_on;
	 
	 pipe_width <= conv_std_logic_vector(50, 10);
	 pipe_height <= conv_std_logic_vector(150, 10);
	 --pipe_x_pos <= to_signed(240, 11);
	 pipe_x_pos <= conv_std_logic_vector(240, 11);
	 bottom <= conv_std_logic_vector(479,10);
	 pipe_x_motion <= conv_std_logic_vector(4, 10);

	 pipes_on <= '1' when ((pixel_row <= pipe_height or (pixel_row + pipe_height >= bottom)) and pipe_x_pos <= pixel_col + pipe_width 
							and pixel_col<= pipe_x_pos + pipe_width) else '0';
							
	 
	--move_pipe : process(vert_sync)
	--begin
	--if (rising_edge(vert_sync)) then
	--	if (pipe_x_pos + signed(pipe_width) <= 0) then
	--		pipe_x_pos <= to_signed(600, 11);
	--	else 
	--		pipe_x_pos <= pipe_x_pos - signed(pipe_x_motion);
	--	end if;
	--end if;
		
	--end process move_pipe;




end architecture arc;