LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity collision is 
	port (bird, pipes, enable : in std_logic;
		pixel_row, pixel_col : in std_logic_vector(9 downto 0);
		collide : out std_logic
	);
end entity collision;

architecture arc of collision is
signal s_collide : std_logic := '0';


begin

process(pixel_row, pixel_col)
begin

	if (enable = '1') then
		if(bird = '1' and pipes = '1') then
			s_collide <= '1';
		else 
			s_collide <= '0';
		end if;
	end if;
end process;

collide <= s_collide;

end architecture arc;