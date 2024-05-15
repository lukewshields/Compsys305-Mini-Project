entity menu_text is 
	port (
		pixel_row, pixel_col : in std_logic_vector (5 downto 0);
		mode : in std_logic_vector (1 downto 0);
		clk,enable : in std_logic;
		character_address : out std_logic_vector (5 downto 0)
	);
end entity menu_text;




architecture arc of menu_text is 


signal s_character_address : std_logic_vector (5 downto 0);
begin


process(clk)


begin
	if (rising_edge(clk) and (mode = "00" or mode = "11")) then -- mode wolnt ever be 11 but can still leave it like this
		if(pixel_row = "001000") then
			case pixel_col is 
			when "000010" => s_character_address <= "010011";
			when "000011" => s_character_address <= "000011";
			when "000100" => s_character_address <= "001111";
			when "000101" => s_character_address <= "010010";
			when "000110" => s_character_address <= "000101";
			when others => s_character_address <= "100000";
			end case;
		end if;
	end if;
end process;
character_address <= s_character_address;

end architecture arc;