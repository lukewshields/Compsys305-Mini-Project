
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity LFSR is 
	port (
		clk, reset : in std_logic;
		rand : out std_logic_vector (9 downto 0)
	);
end entity LFSR;

architecture arc of LFSR is
	signal rand_temp : std_logic_vector (7 downto 0);
	begin
	
	process (clk, reset, rand_temp)
		begin
		if (reset = '1') then
			rand_temp <= "01101010";
		elsif (rising_edge(clk)) then
			rand_temp(1) <= rand_temp(0);
			rand_temp(2) <= rand_temp(1) xor rand_temp(7);
			rand_temp(3) <= rand_temp(2) xor rand_temp(7);
			rand_temp(4) <= rand_temp(3) xor rand_temp(7);
			rand_temp(5) <= rand_temp(4);
			rand_temp(6) <= rand_temp(5);
			rand_temp(7) <= rand_temp(6);
			rand_temp(0) <= rand_temp(7);
			--rand_temp(8) <= rand_temp(7);
			--rand_temp(9) <= rand_temp(8);
			--rand_temp(0) <= rand_temp(9);	
		end if;
		rand <= '0' & '0' & rand_temp;
	end process;
end architecture arc;