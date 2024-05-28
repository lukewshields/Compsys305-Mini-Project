
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity levels is 
	port(
		vert_sync, game_on : in std_logic;
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
		
		if(((difficulty(2) = '1' and game_on = '0') or score > "010100") and mode = "10") then
		 level <= "11";
		elsif(((difficulty(1) = '1' and game_on = '0') or score > "001010") and mode = "10") then
			level <= "01";
		elsif (game_on = '0') then
			level <= "00";
		end if;
		
end process level_set;

end architecture arc;
