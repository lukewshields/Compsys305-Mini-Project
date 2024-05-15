--takes in the collision and a number of lives and decrements a signal intialized to that input until it is 0 then outputs a death

entity lives is 
	port (
		collision : in std_logic;
		num_lives : in std_logic_vector(3 downto 0);-- up to 16 lives
		death : out std_logic;
	);

end entity lives;

architecture arc of lives is 
signal lives_count : std_logic_vector (3 downto 0) := num_lives;
begin

process (collision)
	begin
		if (rising_edge(collison)) then
			lives_count <= lives_count - "0001";
			if (lives_count = "0000") then
				death <= '1';
			end if;
		end if;
end process;

end architecture arc;