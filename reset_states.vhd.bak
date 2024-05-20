 Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity reset_states is 
	port (mode : in std_logic_vector (1 downto 0);
			reseted : out std_logic
		);
end entity reset_states;

architecture arc of reset_states is 


begin

process(mode) 
	prev_mode <= mode;
	
	if (mode /= prev_mode) then
		reseted <= '1';
	else 
		reseted <= '0';
	end if;
end process;

end architecture arc;