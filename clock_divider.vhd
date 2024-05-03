--Newest clock divider naming
--PASTE into clock divider in project
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity clock_divider is
	port ( 
		Clk, reset: in std_logic;
		clock_1HZ: out std_logic
		);

end entity clock_divider;

architecture beh of clock_divider is 
	signal count : integer := 1;
	signal tmp : std_logic := '0';
	
	begin 
		process(Clk, reset)
			begin
			if(reset = '1') then 
				count <= 1;
				tmp <= '0';
			elsif(Clk'event and Clk = '1') then
				if(count = 2) then
					tmp <= not tmp;
					count <= 1;
			end if;
		end if;
	 clock_1HZ <= tmp;
	 end process;
end architecture beh;