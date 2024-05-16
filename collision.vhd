LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity collision is 
	port (bird_on, pipes_on, enable, vert_sync : in std_logic;
		mode : in std_logic_vector (1 downto 0);
		collide : out std_logic
	);
end entity collision;

architecture arc of collision is
begin


--previously only combinational logic
collide <= '1' when bird_on = '1' and pipes_on = '1' else '0';

end architecture arc;

--process(enable, mode, vert_sync)
--	begin
--		
--			if ((mode = "10" or mode = "01") and enable = '1') then
--				
--				
--				
--				
--				
----				if (bird_on = '1' and pipes_on = '1') then 
----					collide <= '1';
----				else 
----					collide <= '0';
----				end if;
--			end if;
--
--end process;