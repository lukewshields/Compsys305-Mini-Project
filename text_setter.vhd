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
	if (rising_edge(clk))  then -- later add an and we are in one of the states where we want the nomral text?
		if (mode = "10" or mode = "01") then
			if(pixel_row = "000010") then
				case pixel_col is 
				when "000010" => s_character_address <= "010011";
				when "000011" => s_character_address <= "000011";
				when "000100" => s_character_address <= "001111";
				when "000101" => s_character_address <= "010010";
				when "000110" => s_character_address <= "000101";
				
				when conv_std_logic_vector(29, 6)  => s_character_address <=  conv_std_logic_vector(12, 6);
				when conv_std_logic_vector(30, 6)  => s_character_address <=  conv_std_logic_vector(9, 6);
				when conv_std_logic_vector(31, 6)  => s_character_address <=  conv_std_logic_vector(22, 6);
				when conv_std_logic_vector(32, 6)  => s_character_address <=  conv_std_logic_vector(5, 6);
				when conv_std_logic_vector(33, 6)  => s_character_address <=  conv_std_logic_vector(19, 6);
				
				when conv_std_logic_vector(35, 6)  => s_character_address <=  conv_std_logic_vector(48, 6);
				
				
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
		elsif (mode = "00" or mode = "11") then
			if (pixel_row = "001100") then
				case pixel_col is
--					when "010000" => s_character_address <= "000110";
--					when "010001" => s_character_address <= "001100";
--					when "010010" => s_character_address <= "000001";
--					when "010011" => s_character_address <= "010000";
--					when "010100" => s_character_address <= "010000";
--					when "010101" => s_character_address <= "011001";

					when conv_std_logic_vector(14, 6) => s_character_address <= "000110"; --flappy 
					when conv_std_logic_vector(15, 6) => s_character_address <= "001100";
					when conv_std_logic_vector(16, 6)  => s_character_address <= "000001";
					when conv_std_logic_vector(17, 6)  => s_character_address <= "010000";
					when conv_std_logic_vector(18, 6)  => s_character_address <= "010000";
					when conv_std_logic_vector(19, 6)  => s_character_address <= "011001";
					
					when conv_std_logic_vector(21, 6)  => s_character_address <=  conv_std_logic_vector(2, 6); --bird
					when conv_std_logic_vector(22, 6)  => s_character_address <=  conv_std_logic_vector(9, 6);
					when conv_std_logic_vector(23, 6)  => s_character_address <=  conv_std_logic_vector(18, 6);
					when conv_std_logic_vector(24, 6)  => s_character_address <=  conv_std_logic_vector(4, 6);
					

			
					when others => s_character_address <= "100000";
				end case;
			elsif (pixel_row = "001110") then
				case pixel_col is 
						when conv_std_logic_vector(15, 6)  => s_character_address <=  conv_std_logic_vector(7, 6); --group
						when conv_std_logic_vector(16, 6)  => s_character_address <=  conv_std_logic_vector(18, 6);
						when conv_std_logic_vector(17, 6)  => s_character_address <=  conv_std_logic_vector(15, 6);
						when conv_std_logic_vector(18, 6)  => s_character_address <=  conv_std_logic_vector(21, 6);
						when conv_std_logic_vector(19, 6)  => s_character_address <=  conv_std_logic_vector(16, 6);
						
						when conv_std_logic_vector(21, 6)  => s_character_address <=  conv_std_logic_vector(51, 6);
						when conv_std_logic_vector(22, 6)  => s_character_address <=  conv_std_logic_vector(48, 6);
						
						when others => s_character_address <= "100000";
				end case;
				
			end if;
		end if;
	end if;
end process;
character_address <= s_character_address;
end architecture arc;