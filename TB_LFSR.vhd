
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity tb_LFSR is
end entity tb_LFSR;

architecture test_lfsr of tb_LFSR is 
	signal t_clk, t_reset : std_logic;
	signal t_rand : std_logic_vector (9 downto 0);
	
	component LFSR is 
		port (
			clk, reset : in std_logic;
			rand : out std_logic_vector (9 downto 0)
		);
	end component LFSR;
	begin

	DUT: LFSR port map(t_clk, t_reset, t_rand);
	
	start: process 
		begin
			t_reset <= '1', '0' after 10 ns;
			wait;
	end process start;

	 -- clock generation
     	clk_gen: process
		begin
			wait for 5 ns;
         		t_Clk <= '1'; 
         		wait for 5 ns;
         		t_Clk <= '0';
     	end process clk_gen;  

end architecture test_lfsr;