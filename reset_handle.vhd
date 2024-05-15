LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


entity reset_handle is 
	port (
			reset: in std_logic;
			hold_reset : out std_logic
		);

end entity reset_handle;

architecture arc of reset_handle is 
signal count : std_logic := '0';


begin
	process (reset)
	begin
		if(rising_edge(reset) and count = '0') then
			hold_reset <= '1';
			count <= '1';
		elsif (count='1' and rising_edge(reset)) then
			hold_reset <= '0';
			count <= '0';
		end if;
--		if (collision = '1' and count = '1') then
--			hold_enable <= '0';
--			count <= '0';
--		end if;
	end process;
end architecture arc;