library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity CPU_TB is
end CPU_TB;

architecture arch of CPU_TB is
	signal clk		: std_logic := '0';
	signal reset	: std_logic := '0';

	signal inst		: std_logic_vector(INST_WIDTH-1 downto 0);
	signal mem_in	: std_logic_vector(DATA_WIDTH-1 downto 0);

	signal pc		: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem_addr	: std_logic_vector(XLEN-1 downto 0);
	signal mem_out	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem_mode	: std_logic_vector(2 downto 0);
	signal wr_mem	: std_logic;

	signal addr_a		: std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal data_in_a	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal wren_a		: std_logic;

	type program_t is array (natural range <>) of std_logic_vector(INST_WIDTH-1 downto 0);

	signal factorial_program	: program_t(1 to 6) := (
		x"00600593",
		x"00100513",
		x"00100293",
		x"02550533",
		x"00128293",
		x"fe55dce3"
	);

	signal add1_program		: program_t(1 to 5) := (
		x"000642b7",
		x"14c28293",
		x"00064337",
		x"0df30313",
		x"006283b3"
	);

	signal program_idx	: integer;

begin

	UUT : entity work.CPU
	port map(
		clk			=> clk,
		clken		=> '1',
		reset		=> reset,
		inst		=> inst,
		mem_in		=> mem_in,
		pc			=> pc,
		mem_addr 	=> mem_addr,
		mem_out		=> mem_out,
		mem_mode	=> mem_mode,
		wr_mem		=> wr_mem,
		regsel		=> "00000",
		regsel_val	=> open
	);

	mem : entity work.Memory
	port map(
		clock	=> clk,

		-- instruction read
		addr_a		=> pc(ADDR_WIDTH-1 downto 0),
		data_in_a	=> x"00000000",
		wren_a		=> wren_a,
		mode_a		=> "010",
		data_out_a	=> inst,

		-- data read/write
		addr_b		=> mem_addr(ADDR_WIDTH-1 downto 0),
		data_in_b	=> mem_out,
		wren_b		=> wr_mem,
		mode_b		=> mem_mode,
		data_out_b	=> mem_in
	);

	clk <= not clk after tb_clk_pd/2;

	STIMULUS : process
	begin
		-- take uut out of reset
		wait until rising_edge(clk);

		reset <= '1';

		wait until rising_edge(clk);

		-- load program into memory
		/*
		wren_a <= '1';
		for i in range 1 to add1_program'length loop
			data_in_a <= add1_program(i);
		*/

	end process;

end architecture;
