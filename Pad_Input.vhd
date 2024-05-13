LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity Pad_Input is
Port ( input_value : in std_logic_vector(1 downto 0);
output_value : out std_logic_vector(3 downto 0));
end Pad_Input;

architecture Behavioral of Pad_Input is
begin
process(input_value)
begin
-- Assign input_value to lower bits of output_value
output_value(1 downto 0) <= input_value;

-- Pad higher bits of output_value with zeros
output_value(3 downto 2) <= "00";
end process;
end Behavioral;