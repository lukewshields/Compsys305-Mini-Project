LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity collision is 
	port (bird_on, pipes_on, enable, vert_sync : in std_logic;
		collide : out std_logic
	);
end entity collision;

architecture arc of collision is

begin

process(bird_on, pipes_on)
begin
	if (enable = '1') then
		if(bird_on = '1' and pipes_on = '1') then
			collide <= '1';
		else
			collide <= '0';
		end if;
	end if;
end process;
--
--process(collision) 
--begin
--	if (collision = '1') then
--		collide <= '1';
--	else 
--		collide <= '0';
--	end if;
--end process;

end architecture arc;