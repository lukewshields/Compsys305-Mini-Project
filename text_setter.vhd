LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity text_setter is 
	port (
		pixel_row, pixel_col : in std_logic_vector (9 downto 0);
		score : in std_logic_vector(5 downto 0);
		clk,enable : in std_logic;
		character_address,pause_address : out std_logic_vector (5 downto 0)
		
	);
	
end entity text_setter;




architecture arc of text_setter is 
signal s_character_address,p_character_address : std_logic_vector (5 downto 0);
begin


process(clk)
variable ones_score,tens_score : std_logic_vector(5 downto 0);
variable current_score : integer;
variable mask : std_logic_vector(9 downto 0) :="0000001111";
variable current_row,current_col : std_logic_vector(9 downto 0);
begin
	if rising_edge(clk) then
		current_row := pixel_row or mask;
		if(pixel_row(9 downto 4) = ("000010")) then
			case pixel_col(9 downto 4) is 
			when "000010" => s_character_address <= "010011";
			when "000011" => s_character_address <= "000011";
			when "000100" => s_character_address <= "001111";
			when "000101" => s_character_address <= "010010";
			when "000110" => s_character_address <= "000101";
			when others => s_character_address <= "100000";
			end case;
				current_score := conv_integer(unsigned(score));		
				if (current_score<10) then
					if (pixel_col(9 downto 4) = "001000") then -- Single digit
					s_character_address<= CONV_STD_LOGIC_VECTOR(current_score + 48, 6);
					end if;
				else
					tens_score := CONV_STD_LOGIC_VECTOR(current_score/10, 6);  -- Right shift by 4 to get tens digit
					ones_score := CONV_STD_LOGIC_VECTOR(current_score mod 10,6); 
					if (pixel_col(9 downto 4) = "001000") then
						s_character_address <= tens_score + "110000"; -- Displays single digit
					elsif (pixel_col(9 downto 4) = "001001") then
						s_character_address <= ones_score + "110000"; -- Displays tens digit
					end if;
				end if;
				
	elsif ((pixel_row(9 downto 4) = conv_std_logic_vector(15,6) or pixel_row(9 downto 4) = conv_std_logic_vector(14,6)) and enable = '0') then
		case pixel_col(9 downto 5) is
			when "00111" => p_character_address <= "010000"; -- Displays pause
			when "01000" => p_character_address <= "000001";
			when "01001" => p_character_address <= "010101";
			when "01010" => p_character_address <= "010011";
			when "01011" => p_character_address <= "000101";
			when "01100" => p_character_address <= "000100";
			when others => p_character_address <= "100000";
		end case;
	else
		s_character_address <= "100000";
		p_character_address <= "100000";
	end if;
	end if;
end process;
character_address <= s_character_address;
pause_address <= p_character_address;
end architecture arc;