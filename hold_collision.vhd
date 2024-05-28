LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity hold_collision is 
	port (
		collide, vert_sync : in std_logic; 
		collide_stable : out std_logic
	);
end entity hold_collision;

architecture arc of hold_collision is 
signal prev_collide : std_logic;
signal collide2 : std_logic;
signal count : integer;

begin

process (vert_sync, collide)
	begin
		if (rising_edge(vert_sync)) then	
			prev_collide <= collide;
			
			if ((collide = '1' or collide2 = '1') and count < 500000) then
				count <= count + 1;
				collide2 <= '1';
			else
				count <= 0;
				prev_collide <= '0';
				collide2 <= '0';
			end if;
			
		end if;
end process;

collide_stable <= collide2;

end architecture arc;
