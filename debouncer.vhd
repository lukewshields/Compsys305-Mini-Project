LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


entity debouncer is 
	port (click : in std_logic;
			debounce : out std_logic;
	);
end entity debouncer;

architecture arc of debouncer is 
--signal debounce1 : std_logic;

begin

process (click)
	begin
		if(falling_edge(click)) then
			debounce <= '1';
		else 
			debounce <= '0';
		end if;
end process;
end architecture arc;