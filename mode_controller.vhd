
 Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mode_controller is 
    port (
        clk, pb3, pb2, pb1 : in std_logic; --PB1 = 1 is samw as switches = 01, PB2 is same as switches = 10
		  reset_state : out std_logic; -- output to high whenever we switch states
        mode : out std_logic_vector (1 downto 0)
    );
end entity mode_controller;

architecture beh of mode_controller is 
    type state_type is (menu, train, game);
    signal state : state_type;
    signal next_state : state_type := menu;
    --signal mode1 : std_logic_vector (1 downto 0);

begin
    SYNC_PROCESS: process(clk)
        begin  
            if (rising_edge(clk)) then   
                if (pb3 = '1') then
                    state <= menu;
                else 
                    state <= next_state;
                end if;
            end if;
    end process;

    OUTPUT_DECODE : process(state)
        begin 
            case (state) is
                when menu => mode <= "00";
                when train => mode <= "01";
                when game => mode <= "10";
                when others => mode <= "00";
            end case; 
    end process;

    NEXT_STATE_DECODE : process(state, next_state, pb1, pb2, pb3)
        begin
        next_state <= menu;
        case (state) is 
            when (menu) => 
                if (pb1 = '1') then
                    next_state <= train;
                elsif (pb2 = '1') then
                    next_state <= game;
                else    
                    next_state <= menu;
                end if;
            when (train) => 
               if (pb2 = '1') then
                    next_state <= game;
                elsif (pb3 = '1') then 
                    next_state <= menu;
                else 
                    next_state <= train;
                end if;
            when (game) => 
                if (pb1 = '1') then
                    next_state <= train;
                elsif (pb3 = '1') then
                    next_state <= menu;
                else 
                    next_state <= game;
                end if;
            when others => next_state <= menu;
        end case;
    end process;
	 
	 output_pb3state : process(state, next_state) 
		begin
			if (state /= next_state) then
				reset_state <= '1';
			else 
				reset_state <= '0';
			end if;
	 end process;
        
    --mode <= mode1;

end architecture beh;
