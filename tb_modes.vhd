Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity tb_modes is 
end entity tb_modes;

architecture tb_modes_arc of tb_modes is 
    signal t_key1, t_key0, t_clk, t_reset : std_logic;
    signal t_mode: std_logic_vector (1 downto 0);

    component mode_controller is 
    port (
        key1, key0, clk, reset : in std_logic;
        mode : out std_logic_vector (1 downto 0)
    );
    end component mode_controller; 

    begin
        DUT: mode_controller port map (t_key1, t_key0, t_clk, t_reset, t_mode);

        key1_test : process
            begin   
                t_key1 <= '0', '1' after 30 ns, '0' after 40 ns, '1' after 100 ns, '0' after 110 ns;
                wait;
        end process key1_test;

        key0_test : process
            begin   
                t_key0 <= '0', '1' after 70 ns, '0' after 80 ns, '1' after 150 ns, '0' after 160 ns;
                wait;
        end process key0_test;

        reset_test : process 
            begin 
                t_reset <= '0', '1' after 50 ns, '0' after 59 ns, '1' after 80 ns, '0' after 89 ns, '1' after 120 ns, '0' after 130 ns;
                wait;
        end process reset_test;

        clk_gen: process
		begin
			wait for 5 ns;
         		t_clk <= '1'; 
         		wait for 5 ns;
         		t_clk <= '0';
     	end process clk_gen;  

end architecture tb_modes_arc;