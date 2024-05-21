
--takes in the collision and a number of lives and decrements a signal intialized to that input until it is 0 then outputs a death

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;



entity lives is 
	port (
		collision, reset, death : in std_logic;
		mode : in std_logic_vector (1 downto 0);
		lives_out : out std_logic_vector(5 downto 0)
		--death : out std_logic
	);

end entity lives;

architecture arc of lives is 
signal lives_count : std_logic_vector (5 downto 0) := conv_std_logic_vector(20, 6);
--signal prev_collision : std_logic;
begin

process (collision, reset)
	begin
		--prev_collision <= collision;
		
		--if(rising_edge(vert_s)) then
		--keep track of modes and if the prev mode is diff from the curr mode then we need to reset the lives
			if (reset = '1' or death = '1') then 
				lives_count <= conv_std_logic_vector(4, 6);
			else 
				if (rising_edge(collision) and mode = "10") then
					lives_count <= lives_count - "000001";
----					if (lives_count <= "000001") then
----						death <= '1';
----					else 
----						death <= '0';
----					end if;
				end if;
			end if;
		--end if;
end process;
lives_out <= lives_count;

end architecture arc;