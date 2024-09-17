library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity RAM is
	port(
		address		: in std_logic_vector(DATA_ADDR_WIDTH-1 downto 0);
		data_in		: in std_logic_vector(DATA_WIDTH-1 downto 0);
		mode		: in std_logic_vector(2 downto 0);
		wren		: in std_logic;
		clock		: in std_logic;
		data_out	: out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end RAM;

architecture arch of RAM is
	signal wr_mode			: std_logic_vector(1 downto 0);
	signal low_addr			: std_logic_vector(1 downto 0);
	signal byteena			: std_logic_vector((DATA_WIDTH/8)-1 downto 0);
	signal ipram_addr		: std_logic_vector(DATA_ADDR_WIDTH-1 downto 2);
	signal byte_data		: std_logic_vector(7 downto 0);
	signal halfword_data	: std_logic_vector(15 downto 0);
	signal word_data		: std_logic_vector(31 downto 0);
	signal write_data		: std_logic_vector(31 downto 0);
	signal q_word, q_word1	: std_logic_vector(31 downto 0);
	signal q_halfword		: std_logic_vector(15 downto 0);
	signal q_byte			: std_logic_vector(7 downto 0);
	signal zero_extd_q_halfword,
			zero_extd_q_byte,
			sign_extd_q_halfword,
			sign_extd_q_byte,
			extd_q_halfword,
			extd_q_byte		: std_logic_vector(31 downto 0);
begin
	wr_mode <= mode(1 downto 0);
	low_addr <= address(1 downto 0);
	BE_ENCODER : entity work.ByteEnableEncoder
	port map (
		low_addr	=> low_addr,
		wr_mode		=> wr_mode,
		byteena		=> byteena
	);

	byte_data <= data_in(7 downto 0);
	halfword_data <= data_in(7 downto 0) & data_in(15 downto 8);
	word_data <= halfword_data & data_in(23 downto 16) & data_in(31 downto 24);
	with wr_mode select
		write_data <= byte_data & byte_data & byte_data & byte_data when "00",
					  halfword_data & halfword_data when "01",
					  word_data when "10",
					  (others => 'X') when others;


	ipram_addr <= address(DATA_ADDR_WIDTH-1 downto 2);
	RAM_1 : entity work.IPRAM 
	port map (
		address	=> ipram_addr,
		byteena	=> byteena,
		data	=> write_data,
		clock	=> clock,
		wren	=> wren,
		q		=> q_word1
	);

	q_halfword <=
   		q_word1(23 downto 16) & q_word1(31 downto 24) when address(1) = '0' else
		q_word1(7 downto 0) & q_word1(15 downto 8);

	with (address(1 downto 0)) select
		q_byte <= q_word1(31 downto 24) when "00",
			   q_word1(23 downto 16) when "01",
			   q_word1(15 downto 8) when "10",
			   q_word1(7 downto 0) when "11",
			   (others => 'X') when others;

	q_word <= q_word1(7 downto 0) & q_word1(15 downto 8) & q_word1(23 downto 16) & q_word1(31 downto 24);

	zero_extd_q_halfword	<= std_logic_vector(resize(unsigned(q_halfword), 32));
	zero_extd_q_byte 		<= std_logic_vector(resize(unsigned(q_byte), 32));

	sign_extd_q_halfword	<= std_logic_vector(resize(signed(q_halfword), 32));
	sign_extd_q_byte		<= std_logic_vector(resize(signed(q_byte), 32));

	extd_q_halfword	<= zero_extd_q_halfword when mode(2) = '1' else sign_extd_q_halfword;
	extd_q_byte 	<= zero_extd_q_byte when mode(2) = '1' else sign_extd_q_byte;

	data_out <= extd_q_byte when mode(1 downto 0) = "00" else
				extd_q_halfword when mode(1 downto 0) = "01" and address(0) = '0' else
				q_word when mode(1 downto 0) = "10" and address(1 downto 0) = "00" else
				(others => 'X');

end architecture;
