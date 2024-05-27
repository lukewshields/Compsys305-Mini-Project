LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY bird_rom IS
	PORT
	(
		font_row, font_col : IN std_logic_vector(9 DOWNTO 0);
		clock				: 	IN STD_LOGIC ;
		bird_addy :   in STD_LOGIC_VECTOR(9 downto 0);
		rgb : OUT STD_LOGIC_VECTOR(11 downto 0)
	);
END bird_rom;


ARCHITECTURE SYN OF bird_rom IS

	SIGNAL rom_data		: STD_LOGIC_VECTOR (11 DOWNTO 0);
	signal rom_address : STD_LOGIC_VECTOR (9 DOWNTO 0);
	
	COMPONENT altsyncram
	GENERIC (
		address_aclr_a			: STRING;
		clock_enable_input_a	: STRING;
		clock_enable_output_a	: STRING;
		init_file				: STRING;
		intended_device_family	: STRING;
		lpm_hint				: STRING;
		lpm_type				: STRING;
		numwords_a				: NATURAL;
		operation_mode			: STRING;
		outdata_aclr_a			: STRING;
		outdata_reg_a			: STRING;
		widthad_a				: NATURAL;
		width_a					: NATURAL;
		width_byteena_a			: NATURAL
	);
	PORT (
		clock0		: IN STD_LOGIC ;
		address_a	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		q_a			: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
	END COMPONENT;

BEGIN

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "bird_sprite1.mif",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 1024,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		widthad_a => 10,
		width_a => 12,
		width_byteena_a => 1
	)
	PORT MAP (
		clock0 => clock,
		address_a => bird_addy,
		q_a => rom_data
	);
	--rom_address <
	--rom_address <= font_row(9 downto 4) & font_col(9 downto 4);

	rgb <= rom_data; 
	  
	--rom_output <= rom_data;

END SYN;