Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mode_controller is 
    port (
        key1, key0, clk, reset : in std_logic;
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

    NEXT_STATE_DECODE : process(state, next_state, key1, key0)
        begin
        next_state <= menu;
        case (state) is 
            when (menu) => 
                if (key1 = '0' and key0 = '1') then
                    next_state <= train;
                elsif (key1 = '1' and key0 = '0') then
                    next_state <= game;
                else    
                    next_state <= menu;
                end if;
            when (train) => 
               if (key1 = '1' and key0 = '0') then
                    next_state <= game;
                elsif (reset = '1') then
                    next_state <= menu;
                else 
                    next_state <= train;
                end if;
            when (game) => 
                if (key1 = '0' and key0 = '1') then
                    next_state <= train;
                elsif (reset = '1') then
                    next_state <= menu;
                else 
                    next_state <= game;
                end if;
            when others => next_state <= menu;
        end case;
    end process;
        
    --mode <= mode1;

end architecture beh;