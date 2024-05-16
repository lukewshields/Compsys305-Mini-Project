-- Morteza (March 2023)
-- VHDL code for BCD to 7-Segment conversion
-- In this case, LED is on when it is '0'   
library IEEE;
use IEEE.std_logic_1164.all;   

entity test_collison is
     port (BCD_digit : in std_logic;
           SevenSeg_out : out std_logic_vector(6 downto 0));
end entity;

architecture arc1 of test_collison  is
begin
     SevenSeg_out   <=  "1111001"  when BCD_digit = '1'  else		-- 1
						"1000000"  when BCD_digit = '0'  else		-- 0
						"1111111";
end architecture arc1; 
