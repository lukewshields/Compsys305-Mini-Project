LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity text_setter is 
	port (
		pixel_row, pixel_col : in std_logic_vector (5 downto 0);
		mode : in std_logic_vector (1 downto 0);
		score : in std_logic_vector(6 downto 0);
		clk,enable : in std_logic;
		character_address : out std_logic_vector (5 downto 0)
	);
	
end entity text_setter;




architecture arc of text_setter is 
signal s_character_address : std_logic_vector (5 downto 0);
begin


process(clk)
variable ones_score,tens_score : std_logic_vector(5 downto 0);
variable current_score : integer;
begin
	if (rising_edge(clk) and (mode = "10" or mode = "01"))  then -- later add an and we are in one of the states where we want the nomral text?
		if(pixel_row = "000010") then
			case pixel_col is 
			when "000010" => s_character_address <= "010011";
			when "000011" => s_character_address <= "000011";
			when "000100" => s_character_address <= "001111";
			when "000101" => s_character_address <= "010010";
			when "000110" => s_character_address <= "000101";
			when others => s_character_address <= "100000";
			end case;
				current_score := conv_integer(unsigned(score));		
				if (current_score < 10) then
					if (pixel_col = "001000") then -- Single digit
						s_character_address<= CONV_STD_LOGIC_VECTOR(current_score + 48, 6);
					end if;
				else
					tens_score := CONV_STD_LOGIC_VECTOR(current_score/10, 6);  -- Right shift by 4 to get tens digit
					ones_score := CONV_STD_LOGIC_VECTOR(current_score mod 10,6); 
					if (pixel_col = "001000") then
						s_character_address <= tens_score + "110000"; -- Displays single digit
					elsif (pixel_col = "001001") then
						s_character_address <= ones_score + "110000"; -- Displays tens digit
					end if;
				end if;
					
		elsif (pixel_row = conv_std_logic_vector(15,6) and enable = '0')then
			case pixel_col is
				when "010010" => s_character_address <= "010000";
				when "010011" => s_character_address <= "000001";
				when "010100" => s_character_address <= "010101";
				when "010101" => s_character_address <= "010011";
				when "010110" => s_character_address <= "000101";
				when "010111" => s_character_address <= "000100";
				when others => s_character_address <= "100000";
			end case;
		else
			s_character_address <= "100000";
		end if;
	end if;
end process;
character_address <= s_character_address;
end architecture arc;