LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


entity debouncer is 
	port (click : in std_logic;
	debounce : out std_logic
	);
end entity debouncer;

architecture arc of debouncer is 



begin

process (click)
variable onclick: std_logic;
variable counter: integer;
	begin

		--if (falling_edge(click)) then
			--debounce <= '1';
		--else 
			--debounce <= '0';
		--end if;
		if(click = '1') then
			   onclick := '1';
			else 
			 onclick := '0';
			counter := 1;
			end if;
			
			if (onclick = '1' and counter = 1) then
			debounce <= '1';
			counter := 0;
			else 
			debounce <= '0';
			end if;
end process;
end architecture arc;

	