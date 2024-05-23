LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


entity enable_handle is 
	port (mode : in std_logic_vector (1 downto 0);
			enable, collision: in std_logic;
			hold_enable : out std_logic
		);

end entity enable_handle;

architecture arc of enable_handle is 
signal count : std_logic := '0';


begin
	process (enable, collision, mode, count)
	begin
		if (mode = "10" or mode = "01") then
			if(rising_edge(enable) and count = '0') then
				hold_enable <= '0';
				count <= '1';
			elsif (count='1' and rising_edge(enable)) then
				hold_enable <= '1';
				count <= '0';
			end if;
		end if;
--		
--		if (collision = '1' and count = '1') then
--			hold_enable <= '0';
--			count <= '0';
--		end if;
	end process;
end architecture arc;