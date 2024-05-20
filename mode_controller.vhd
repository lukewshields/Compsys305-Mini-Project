 Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mode_controller is 
    port (
        clk, reset : in std_logic;
		  switches : in std_logic_vector (1 downto 0);
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
                if (reset = '1') then
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

    NEXT_STATE_DECODE : process(state, next_state, switches)
        begin
        next_state <= menu;
        case (state) is 
            when (menu) => 
                if (switches = "01") then
                    next_state <= train;
						  --reset_state <= '1';
                elsif (switches = "10") then
                    next_state <= game;
						  --reset_state <= '1';
                else    
                    next_state <= menu;
						  --reset_state <= '0';
                end if;
            when (train) => 
               if (switches = "10") then
                    next_state <= game;
						  --reset_state <= '1';
                elsif (reset ='1' or switches = "11" or switches ="00") then --ONE BUG HERE IS reset_state only works for however long the key is held:  FIXED I BELIEVE
                    next_state <= menu;
						  --reset_state <= '1';
                else 
                    next_state <= train;
						  --reset_state <= '0';
                end if;
            when (game) => 
                if (switches = "01") then
                    next_state <= train;
						  --reset_state <= '1';
                elsif (reset = '1' or switches = "11" or switches = "00") then
                    next_state <= menu;
						  --reset_state <= '1';
                else 
                    next_state <= game;
						  --reset_state <= '0';
                end if;
            when others => next_state <= menu;
        end case;
    end process;
	 
	 output_resetstate : process(state, next_state) 
		begin
			if (state /= next_state) then
				reset_state <= '1';
			else 
				reset_state <= '0';
			end if;
	 end process;
        
    --mode <= mode1;

end architecture beh;