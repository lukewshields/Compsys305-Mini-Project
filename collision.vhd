LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity collision is 
	port (bird_on, pipes_on : in std_logic;
		collide : out std_logic
	);
end entity collision;

architecture arc of collision is
begin

collide <= '1' when bird_on = '1' and pipes_on = '1' else '0';

end architecture arc;