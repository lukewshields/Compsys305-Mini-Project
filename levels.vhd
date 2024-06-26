

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
--use ieee.numeric_std.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity levels is 
	port(
		vert_sync : in std_logic;
		difficulty : in std_logic_vector(2 downto 0); --manual in put from switches sw7 easy sw8 medium sw9 hard
		score : in std_logic_vector(6 downto 0);
		mode : in std_logic_vector(1 downto 0);
		level : out std_logic_vector(1 downto 0) -- output of level depending on switches and score
	);
end entity levels;


architecture arc of levels is 


begin


level_set : process(vert_sync, difficulty, score, mode) 
	begin
		if((difficulty(2) = '1' or score > "010100") and mode = "10") then
		 level <= "11";
		elsif((difficulty(1) = '1' or score > "001010") and mode = "10") then
			level <= "01";
		else
			level <= "00";
		end if;
		
end process level_set;

end architecture arc;


--
--variable medium_on, hard_on : std_logic;
--		begin
--			if (rising_edge(vert_sync)) then --maybe later move this logic out of the pipes module, and move it to its own difficulty module, so many diff things can be set by it?
--				if (diff(0) = '1' and mode = "10" ) then
--					
--					difficulty <= "00";
--					if (score > "000110") then
--						medium_on := '1';
--					end if;
--				elsif(diff(1) = '1' and mode = "10") then
--					
--					difficulty <= "01";
--					if (score > "010100") then
--						hard_on := '1';
--					end if;
--				elsif(diff(2) = '1' and mode = "10") then
--					
--					difficulty <= "11";
--				else 
--					
--					difficulty <= "00";
--				end if;
--				
--				
--				if(medium_on = '1' and hard_on = '0') then
--					
--					difficulty <= "01";
--					if (score > "010100") then
--						hard_on := '1';
--					end if;
--				elsif(hard_on = '1') then
--					
--					difficulty <= "11";
--				end if;
--				
--			end if;		