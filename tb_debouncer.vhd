entity tb_debouncer is 
end entity tb_debouncer;


architecture arc of tb_debouncer is 

component debouncer is 
	port (click : in std_logic;
			debounce : out std_logic
	);
end component debouncer;
signal t_click, t_debounce : std_logic;
begin
	DUT: debouncer port map (t_click, t_debounce);
	
	gen_click : process 
	begin 
		t_click <= '0', '1' after 40 ns, '0' after 80 ns, '1' after 100 ns, '0' after 103 ns;
	end process;

end architecture arc;