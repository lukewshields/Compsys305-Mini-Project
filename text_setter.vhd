LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity text_setter is 
	port (
		pixel_row, pixel_col : in std_logic_vector (5 downto 0);
		pixel_row2, pixel_col2 : in std_logic_vector (9 downto 0);
		mode : in std_logic_vector (1 downto 0);
		score : in std_logic_vector(6 downto 0);
		lives : in std_logic_vector(5 downto 0);
		clk,enable, game_on, death : in std_logic;
		character_address, pause_address : out std_logic_vector (5 downto 0)
	);
	
end entity text_setter;




architecture arc of text_setter is 
signal s_character_address,  p_character_address : std_logic_vector (5 downto 0);

begin


process(clk)
variable ones_score,tens_score, ones_lives, tens_lives : std_logic_vector(5 downto 0);
variable current_score, current_lives : integer;

begin
	if (rising_edge(clk))  then -- later add an and we are in one of the states where we want the nomral text?
	
			if (mode = "10") then
			if (pixel_row = conv_std_logic_vector(2, 6)) then
				case pixel_col is
					when conv_std_logic_vector(15, 6)  => s_character_address <= conv_std_logic_vector(7, 6); --game
					when conv_std_logic_vector(16, 6)  => s_character_address <=  conv_std_logic_vector(1, 6);
					when conv_std_logic_vector(17, 6) => s_character_address <= conv_std_logic_vector(13, 6);
					when conv_std_logic_vector(18, 6) => s_character_address <= conv_std_logic_vector(5, 6);
						
					when conv_std_logic_vector(20, 6)  => s_character_address <=  conv_std_logic_vector(13, 6);--mode
					when conv_std_logic_vector(21, 6)  => s_character_address <=  conv_std_logic_vector(15, 6);
					when conv_std_logic_vector(22, 6)  => s_character_address <=  conv_std_logic_vector(4, 6);
					when conv_std_logic_vector(23, 6)  => s_character_address <=  conv_std_logic_vector(5, 6);
				
						when others => s_character_address <= "100000";
				end case;
			end if;
			if (game_on = '0') then
				if (pixel_row = conv_std_logic_vector(4, 6)) then
					case pixel_col is
						when conv_std_logic_vector(15, 6)  => s_character_address <= conv_std_logic_vector(19, 6); --sw
						when conv_std_logic_vector(16, 6)  => s_character_address <=  conv_std_logic_vector(23, 6);
						when conv_std_logic_vector(17, 6) => s_character_address <= conv_std_logic_vector(55, 6);--7
						
						when conv_std_logic_vector(19, 6)  => s_character_address <=  conv_std_logic_vector(5, 6);--easy
						when conv_std_logic_vector(20, 6)  => s_character_address <=  conv_std_logic_vector(1, 6);
						when conv_std_logic_vector(21, 6)  => s_character_address <=  conv_std_logic_vector(19, 6);
						when conv_std_logic_vector(22, 6)  => s_character_address <=  conv_std_logic_vector(25, 6);
				
						when others => s_character_address <= "100000";
					end case;
				end if;
				if (pixel_row = conv_std_logic_vector(5, 6)) then
					case pixel_col is
						when conv_std_logic_vector(15, 6)  => s_character_address <=  conv_std_logic_vector(19, 6); --sw
						when conv_std_logic_vector(16, 6)  => s_character_address <=  conv_std_logic_vector(23, 6);
						when conv_std_logic_vector(17, 6) => s_character_address <= conv_std_logic_vector(56, 6);--8
						
						when conv_std_logic_vector(19, 6)  => s_character_address <=  conv_std_logic_vector(13, 6);--medium
						when conv_std_logic_vector(20, 6)  => s_character_address <=  conv_std_logic_vector(5, 6);
						when conv_std_logic_vector(21, 6)  => s_character_address <=  conv_std_logic_vector(4, 6);
						when conv_std_logic_vector(22, 6)  => s_character_address <=  conv_std_logic_vector(9, 6);
						when conv_std_logic_vector(23, 6)  => s_character_address <=  conv_std_logic_vector(21, 6);
						when conv_std_logic_vector(24, 6)  => s_character_address <=  conv_std_logic_vector(13, 6);
				
						when others => s_character_address <= "100000";
					end case;
				end if;
				if (pixel_row = conv_std_logic_vector(6, 6)) then
					case pixel_col is
						when conv_std_logic_vector(15, 6)  => s_character_address <= conv_std_logic_vector(19, 6); --sw
						when conv_std_logic_vector(16, 6)  => s_character_address <=  conv_std_logic_vector(23, 6);
						when conv_std_logic_vector(17, 6) => s_character_address <= conv_std_logic_vector(57, 6);--9
						
						when conv_std_logic_vector(19, 6)  => s_character_address <=  conv_std_logic_vector(8, 6);--hard
						when conv_std_logic_vector(20, 6)  => s_character_address <=  conv_std_logic_vector(1, 6);
						when conv_std_logic_vector(21, 6)  => s_character_address <=  conv_std_logic_vector(18, 6);
						when conv_std_logic_vector(22, 6)  => s_character_address <=  conv_std_logic_vector(4, 6);
				
						when others => s_character_address <= "100000";
					end case;
				end if;
			end if;
		end if;
		
		
		if (mode = "01") then
			if (pixel_row = conv_std_logic_vector(2, 6)) then
				case pixel_col is
					when conv_std_logic_vector(13, 6)  => s_character_address <= conv_std_logic_vector(20, 6);
					when conv_std_logic_vector(14, 6)  => s_character_address <= conv_std_logic_vector(18, 6);
					when conv_std_logic_vector(15, 6)  => s_character_address <= conv_std_logic_vector(1, 6);
					when conv_std_logic_vector(16, 6)  => s_character_address <= conv_std_logic_vector(9, 6);
					when conv_std_logic_vector(17, 6)  => s_character_address <= conv_std_logic_vector(14, 6); --training
					when conv_std_logic_vector(18, 6)  => s_character_address <=  conv_std_logic_vector(9, 6);
					when conv_std_logic_vector(19, 6) => s_character_address <= conv_std_logic_vector(14, 6);
					when conv_std_logic_vector(20, 6) => s_character_address <= conv_std_logic_vector(7, 6);
						
					when conv_std_logic_vector(22, 6)  => s_character_address <=  conv_std_logic_vector(13, 6);--mode
					when conv_std_logic_vector(23, 6)  => s_character_address <=  conv_std_logic_vector(15, 6);
					when conv_std_logic_vector(24, 6)  => s_character_address <=  conv_std_logic_vector(4, 6);
					when conv_std_logic_vector(25, 6)  => s_character_address <=  conv_std_logic_vector(5, 6);
				
					when others => s_character_address <= "100000";
				end case;
			end if;
		end if;
		
			
		if (mode = "10" or mode = "01") then
			if(pixel_row = "000010") then
				current_lives := conv_integer(unsigned(lives));
				
				tens_lives := CONV_STD_LOGIC_VECTOR(current_lives/10, 6);  -- Right shift by 4 to get tens digit
				ones_lives := CONV_STD_LOGIC_VECTOR(current_lives mod 10,6); 
				
				case pixel_col is 
				when "000010" => s_character_address <= "010011"; --Score
				when "000011" => s_character_address <= "000011";
				when "000100" => s_character_address <= "001111";
				when "000101" => s_character_address <= "010010";
				when "000110" => s_character_address <= "000101";
				
				when conv_std_logic_vector(29, 6)  => s_character_address <=  conv_std_logic_vector(12, 6); --Lives
				when conv_std_logic_vector(30, 6)  => s_character_address <=  conv_std_logic_vector(9, 6);
				when conv_std_logic_vector(31, 6)  => s_character_address <=  conv_std_logic_vector(22, 6);
				when conv_std_logic_vector(32, 6)  => s_character_address <=  conv_std_logic_vector(5, 6);
				when conv_std_logic_vector(33, 6)  => s_character_address <=  conv_std_logic_vector(19, 6);
				
				when conv_std_logic_vector(35, 6)  => s_character_address <= "110000" + tens_lives; --tens digit
				when conv_std_logic_vector(36, 6)  => s_character_address <=  "110000" + ones_lives; --ones digit lives
				
				
				when others => s_character_address <= "100000";
				end case;
					current_score := conv_integer(unsigned(score));		
					if (current_score < 10) then
						if (pixel_col = "001000") then -- Single digit
							s_character_address <= CONV_STD_LOGIC_VECTOR(current_score + 48, 6);
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
						
			elsif ((pixel_row2(9 downto 4) = conv_std_logic_vector(15,6) or pixel_row2(9 downto 4) = conv_std_logic_vector(14,6)) and enable = '0') then
				case pixel_col2(9 downto 5) is
					when "00111" => p_character_address <= "010000"; -- Displays paused
					when "01000" => p_character_address <= "000001";
					when "01001" => p_character_address <= "010101";
					when "01010" => p_character_address <= "010011";
					when "01011" => p_character_address <= "000101";
					when "01100" => p_character_address <= "000100";
					when others => p_character_address <= "100000";
				end case;
--			else
--				s_character_address <= "100000";
--				p_character_address <= "100000";
			end if;
			
			if (game_on = '0' and death = '0') then
				if (pixel_row = conv_std_logic_vector(8, 6)) then
					case pixel_col is 
						when conv_std_logic_vector(13, 6)  => s_character_address <=  conv_std_logic_vector(3, 6); --Click
						when conv_std_logic_vector(14, 6)  => s_character_address <=  conv_std_logic_vector(12, 6);
						when conv_std_logic_vector(15, 6)  => s_character_address <=  conv_std_logic_vector(9, 6);
						when conv_std_logic_vector(16, 6)  => s_character_address <=  conv_std_logic_vector(3, 6);
						when conv_std_logic_vector(17, 6)  => s_character_address <=  conv_std_logic_vector(11, 6);
						
						when conv_std_logic_vector(19, 6)  => s_character_address <=  conv_std_logic_vector(20, 6); --to 
						when conv_std_logic_vector(20, 6)  => s_character_address <=  conv_std_logic_vector(15, 6); --start
						
						when conv_std_logic_vector(22, 6)  => s_character_address <=  conv_std_logic_vector(19, 6); --Click
						when conv_std_logic_vector(23, 6)  => s_character_address <=  conv_std_logic_vector(20, 6);
						when conv_std_logic_vector(24, 6)  => s_character_address <=  conv_std_logic_vector(1, 6);
						when conv_std_logic_vector(25, 6)  => s_character_address <=  conv_std_logic_vector(18, 6);
						when conv_std_logic_vector(26, 6)  => s_character_address <=  conv_std_logic_vector(20, 6);
				
						
						when others => s_character_address <= "100000";
					end case;
				end if;
			end if;
				
			if (death = '1') then
				if (pixel_row = conv_std_logic_vector(10, 6)) then
					case pixel_col is 
						when conv_std_logic_vector(15, 6)  => s_character_address <=  conv_std_logic_vector(7, 6); --game
						when conv_std_logic_vector(16, 6)  => s_character_address <=  conv_std_logic_vector(1, 6);
						when conv_std_logic_vector(17, 6)  => s_character_address <=  conv_std_logic_vector(13, 6);
						when conv_std_logic_vector(18, 6)  => s_character_address <=  conv_std_logic_vector(5, 6);
							
						when conv_std_logic_vector(20, 6)  => s_character_address <=  conv_std_logic_vector(15, 6); --over
						when conv_std_logic_vector(21, 6)  => s_character_address <=  conv_std_logic_vector(22, 6);
						when conv_std_logic_vector(22, 6)  => s_character_address <=  conv_std_logic_vector(5, 6);
						when conv_std_logic_vector(23, 6)  => s_character_address <=  conv_std_logic_vector(18, 6);
							
						when others => s_character_address <= "100000";
						
					end case;
				end if;
			end if;
			
		elsif (mode = "00" or mode = "11") then
			if (pixel_row = conv_std_logic_vector(8, 6)) then
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
			elsif (pixel_row = conv_std_logic_vector(10, 6)) then
				case pixel_col is 
						when conv_std_logic_vector(15, 6)  => s_character_address <=  conv_std_logic_vector(7, 6); --group
						when conv_std_logic_vector(16, 6)  => s_character_address <=  conv_std_logic_vector(18, 6);
						when conv_std_logic_vector(17, 6)  => s_character_address <=  conv_std_logic_vector(15, 6);
						when conv_std_logic_vector(18, 6)  => s_character_address <=  conv_std_logic_vector(21, 6);
						when conv_std_logic_vector(19, 6)  => s_character_address <=  conv_std_logic_vector(16, 6);
						
						when conv_std_logic_vector(21, 6)  => s_character_address <=  conv_std_logic_vector(51, 6);--30
						when conv_std_logic_vector(22, 6)  => s_character_address <=  conv_std_logic_vector(48, 6);
						
						when others => s_character_address <= "100000";
				end case;
			elsif (pixel_row = conv_std_logic_vector(13, 6)) then
				case pixel_col is 
						when conv_std_logic_vector(13, 6)  => s_character_address <=  "010011"; --sw
						when conv_std_logic_vector(14, 6)  => s_character_address <=  conv_std_logic_vector(23, 6);
						when conv_std_logic_vector(15, 6) => s_character_address <= conv_std_logic_vector(48, 6);
						--when conv_std_logic_vector(18, 6) => s_character_address <= conv_std_logic_vector(
						
						when conv_std_logic_vector(17, 6)  => s_character_address <=  conv_std_logic_vector(20, 6);--training
						when conv_std_logic_vector(18, 6)  => s_character_address <=  conv_std_logic_vector(18, 6);
						when conv_std_logic_vector(19, 6)  => s_character_address <=  conv_std_logic_vector(1, 6);
						when conv_std_logic_vector(20, 6)  => s_character_address <=  conv_std_logic_vector(9, 6);
						when conv_std_logic_vector(21, 6)  => s_character_address <=  conv_std_logic_vector(14, 6);
						when conv_std_logic_vector(22, 6)  => s_character_address <=  conv_std_logic_vector(9, 6);
						when conv_std_logic_vector(23, 6)  => s_character_address <=  conv_std_logic_vector(14, 6);
						when conv_std_logic_vector(24, 6)  => s_character_address <=  conv_std_logic_vector(7, 6);
					
						
						when others => s_character_address <= "100000";
				end case;
			elsif (pixel_row = conv_std_logic_vector(15, 6)) then
				case pixel_col is 
						when conv_std_logic_vector(15, 6)  => s_character_address <=  "010011"; --sw
						when conv_std_logic_vector(16, 6)  => s_character_address <=  conv_std_logic_vector(23, 6);
						when conv_std_logic_vector(17, 6) => s_character_address <= conv_std_logic_vector(49, 6);--1
						
						when conv_std_logic_vector(19, 6)  => s_character_address <=  conv_std_logic_vector(7, 6);--game
						when conv_std_logic_vector(20, 6)  => s_character_address <=  conv_std_logic_vector(1, 6);
						when conv_std_logic_vector(21, 6)  => s_character_address <=  conv_std_logic_vector(13, 6);
						when conv_std_logic_vector(22, 6)  => s_character_address <=  conv_std_logic_vector(5, 6);
				
						when others => s_character_address <= "100000";
				end case;
			else
				s_character_address <= "100000";
				p_character_address <= "100000";
			
			end if;
--		else 
--			s_character_address <= "100000";
--			p_character_address <= "100000";
		end if;
		
		
	
	end if;
end process;
character_address <= s_character_address;
pause_address <= p_character_address;
end architecture arc;