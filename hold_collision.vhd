LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity hold_collision is 
	port (
		collide, clk, vert_sync : in std_logic; -- need vert_sync?
		collide_stable : out std_logic
	);
end entity hold_collision;

architecture arc of hold_collision is 
signal prev_collide : std_logic;
signal assign_to_out : std_logic;
--signal collide2 : std_logic;
signal count : integer;

begin

process (clk, vert_sync, collide)
	begin
		if (rising_edge(vert_sync)) then	
			prev_collide <= collide;
			if((collide = '1' and prev_collide = '0') or (prev_collide = '1' and collide = '1')) then
				assign_to_out <= '1';
			else 
				assign_to_out <= '0';
			end if;
			
		end if;
end process;

collide_stable <= assign_to_out;

end architecture arc;

--			if(collide = '1') then
--				prev_collide <= '1';
--			end if;
----			prev_collide <= collide;
--			
--			if ((prev_collide = '1' or collide2 = '1') and count < 1000) then
--				count <= count + 1;
--				collide2 <= '1';
--			else
--				count <= 0;
--				prev_collide <= '0';
--				collide2 <= '0';
--			end if;




--
--prev_collide <= collide; --take value out of clk 
--			if (prev_collide /= collide and rising_edge(vert_sync)) then
--				prev_collide <= collide;
--			end if;
--		end if;