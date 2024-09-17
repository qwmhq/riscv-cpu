library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity Memory is
port(
	clock		: in std_logic;

	addr_a		: in std_logic_vector(ADDR_WIDTH-1 downto 0);
	data_in_a	: in std_logic_vector(DATA_WIDTH-1 downto 0);
	wren_a		: in std_logic;
	mode_a		: in std_logic_vector(2 downto 0);
	data_out_a	: out std_logic_vector(DATA_WIDTH-1 downto 0);

	addr_b		: in std_logic_vector(ADDR_WIDTH-1 downto 0);
	data_in_b	: in std_logic_vector(DATA_WIDTH-1 downto 0);
	wren_b		: in std_logic;
	mode_b		: in std_logic_vector(2 downto 0);
	data_out_b	: out std_logic_vector(DATA_WIDTH-1 downto 0)
);
end Memory;

architecture arch of Memory is
	-- port a signals
	signal wr_mode_a		: std_logic_vector(1 downto 0);
	signal low_addr_a		: std_logic_vector(1 downto 0);
	signal byteena_a 		: std_logic_vector((DATA_WIDTH/8)-1 downto 0);
	signal int_addr_a		: std_logic_vector(ADDR_WIDTH-1 downto 2);
	signal int_data_in_a	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal int_data_out_a	: std_logic_vector(DATA_WIDTH-1 downto 0);

	signal byte_data_a	: std_logic_vector(7 downto 0);
	signal hword_data_a	: std_logic_vector((DATA_WIDTH/2)-1 downto 0);
	signal word_data_a	: std_logic_vector(DATA_WIDTH-1 downto 0);

	signal byte_out_a	: std_logic_vector(7 downto 0);
	signal hword_out_a	: std_logic_vector((DATA_WIDTH/2)-1 downto 0);
	signal word_out_a	: std_logic_vector(DATA_WIDTH-1 downto 0);

	signal zero_extd_byte_out_a		: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal sign_extd_byte_out_a		: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal extd_byte_out_a			: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal zero_extd_hword_out_a	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal sign_extd_hword_out_a	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal extd_hword_out_a			: std_logic_vector(DATA_WIDTH-1 downto 0);

	-- port b signals
	signal wr_mode_b		: std_logic_vector(1 downto 0);
	signal low_addr_b		: std_logic_vector(1 downto 0);
	signal byteena_b 		: std_logic_vector((DATA_WIDTH/8)-1 downto 0);
	signal int_addr_b		: std_logic_vector(ADDR_WIDTH-1 downto 2);
	signal int_data_in_b	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal int_data_out_b	: std_logic_vector(DATA_WIDTH-1 downto 0);

	signal byte_data_b	: std_logic_vector(7 downto 0);
	signal hword_data_b	: std_logic_vector((DATA_WIDTH/2)-1 downto 0);
	signal word_data_b	: std_logic_vector(DATA_WIDTH-1 downto 0);

	signal byte_out_b	: std_logic_vector(7 downto 0);
	signal hword_out_b	: std_logic_vector((DATA_WIDTH/2)-1 downto 0);
	signal word_out_b	: std_logic_vector(DATA_WIDTH-1 downto 0);

	signal zero_extd_byte_out_b		: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal sign_extd_byte_out_b		: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal extd_byte_out_b			: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal zero_extd_hword_out_b	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal sign_extd_hword_out_b	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal extd_hword_out_b			: std_logic_vector(DATA_WIDTH-1 downto 0);
begin
	-- port a inputs
	int_addr_a	<= addr_a(ADDR_WIDTH-1 downto 2);
	low_addr_a	<= addr_a(1 downto 0);
	wr_mode_a <= mode_a(1 downto 0);

	BE_ENCODER_A : entity work.ByteEnableEncoder
	port map(
		low_addr	=> low_addr_a,
		wr_mode		=> wr_mode_a,
		byteena		=> byteena_a
	);

	byte_data_a <= data_in_a(7 downto 0);
	hword_data_a <= data_in_a(7 downto 0) & data_in_a(15 downto 8);
	word_data_a <= hword_data_a & data_in_a(23 downto 16) & data_in_a(31 downto 24);
	with wr_mode_a select
		int_data_in_a <= byte_data_a & byte_data_a & byte_data_a & byte_data_a when "00",
						 hword_data_a & hword_data_a when "01",
						 word_data_a when "10",
						 (others => 'X') when others;

	-- port b inputs
	int_addr_b	<= addr_b(ADDR_WIDTH-1 downto 2);
	low_addr_b	<= addr_b(1 downto 0);
	wr_mode_b <= mode_b(1 downto 0);

	BE_ENCODER_B : entity work.ByteEnableEncoder
	port map(
		low_addr	=> low_addr_b,
		wr_mode		=> wr_mode_b,
		byteena		=> byteena_b
	);

	byte_data_b <= data_in_b(7 downto 0);
	hword_data_b <= data_in_b(7 downto 0) & data_in_b(15 downto 8);
	word_data_b <= hword_data_b & data_in_b(23 downto 16) & data_in_b(31 downto 24);
	with wr_mode_b select
		int_data_in_b <= byte_data_b & byte_data_b & byte_data_b & byte_data_b when "00",
						 hword_data_b & hword_data_b when "01",
						 word_data_b when "10",
						 (others => 'X') when others;


	-- memory IP component
	IP_MEM : entity work.IpMem
	port map(
		address_a 	=> int_addr_a,
		address_b	=> int_addr_b,
		byteena_a	=> byteena_a,
		byteena_b	=> byteena_b,
		clock_a		=> clock,
		clock_b		=> clock,
		data_a		=> int_data_in_a,
		data_b		=> int_data_in_b,
		wren_a		=> wren_a,
		wren_b		=> wren_b,
		q_a			=> int_data_out_a, 
		q_b			=> int_data_out_b
	);


	-- port a output
	word_out_a <= int_data_out_a(7 downto 0)
					& int_data_out_a(15 downto 8)
					& int_data_out_a(23 downto 16)
					& int_data_out_a(31 downto 24);

	hword_out_a <= int_data_out_a(23 downto 16)
				& int_data_out_a(31 downto 24) when addr_a(1) = '0' else
			   int_data_out_a(7 downto 0)
				& int_data_out_a(15 downto 8);

	with (addr_a(1 downto 0)) select
		byte_out_a <= int_data_out_a(31 downto 24) when "00",
					  int_data_out_a(23 downto 16) when "01",
					  int_data_out_a(15 downto 8) when "10",
					  int_data_out_a(7 downto 0) when "11",
					  (others => 'X') when others;

	zero_extd_hword_out_a <= std_logic_vector(resize(unsigned(hword_out_a), DATA_WIDTH));
	sign_extd_hword_out_a <= std_logic_vector(resize(signed(hword_out_a), DATA_WIDTH));
	extd_hword_out_a <= zero_extd_hword_out_a when mode_a(2) = '1' else sign_extd_hword_out_a;

	zero_extd_byte_out_a <= std_logic_vector(resize(unsigned(byte_out_a), DATA_WIDTH));
	sign_extd_byte_out_a <= std_logic_vector(resize(signed(byte_out_a), DATA_WIDTH));
	extd_byte_out_a <= zero_extd_byte_out_a when mode_a(2) = '1' else sign_extd_byte_out_a;

	data_out_a <= extd_byte_out_a when mode_a(1 downto 0) = "00" else
				  extd_hword_out_a when mode_a(1 downto 0) = "01" and addr_a(0) = '0' else
				  word_out_a when mode_a(1 downto 0) = "10" and addr_a(1 downto 0) = "00" else
				  (others => 'X');

	-- port b output
	word_out_b <= int_data_out_b(7 downto 0)
					& int_data_out_b(15 downto 8)
					& int_data_out_b(23 downto 16)
					& int_data_out_b(31 downto 24);

	hword_out_b <= int_data_out_b(23 downto 16)
				& int_data_out_b(31 downto 24) when addr_b(1) = '0' else
			   int_data_out_b(7 downto 0)
				& int_data_out_b(15 downto 8);

	with (addr_b(1 downto 0)) select
		byte_out_b <= int_data_out_b(31 downto 24) when "00",
					  int_data_out_b(23 downto 16) when "01",
					  int_data_out_b(15 downto 8) when "10",
					  int_data_out_b(7 downto 0) when "11",
					  (others => 'X') when others;

	zero_extd_hword_out_b <= std_logic_vector(resize(unsigned(hword_out_b), DATA_WIDTH));
	sign_extd_hword_out_b <= std_logic_vector(resize(signed(hword_out_b), DATA_WIDTH));
	extd_hword_out_b <= zero_extd_hword_out_b when mode_b(2) = '1' else sign_extd_hword_out_b;

	zero_extd_byte_out_b <= std_logic_vector(resize(unsigned(byte_out_b), DATA_WIDTH));
	sign_extd_byte_out_b <= std_logic_vector(resize(signed(byte_out_b), DATA_WIDTH));
	extd_byte_out_b <= zero_extd_byte_out_b when mode_b(2) = '1' else sign_extd_byte_out_b;

	data_out_b <= extd_byte_out_b when mode_b(1 downto 0) = "00" else
				  extd_hword_out_b when mode_b(1 downto 0) = "01" and addr_b(0) = '0' else
				  word_out_b when mode_b(1 downto 0) = "10" and addr_b(1 downto 0) = "00" else
				  (others => 'X');

end architecture;
