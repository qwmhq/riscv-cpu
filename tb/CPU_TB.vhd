library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity CPU_TB is
end CPU_TB;

architecture arch of CPU_TB is
	signal clk		: std_logic := '1';
	signal clk_inv	: std_logic;
	signal reset	: std_logic := '0';

	signal inst		: std_logic_vector(INST_WIDTH-1 downto 0);
	signal mem_in	: std_logic_vector(DATA_WIDTH-1 downto 0);

	signal pc		: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal pc_next	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem_addr	: std_logic_vector(XLEN-1 downto 0);
	signal mem_out	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem_mode	: std_logic_vector(2 downto 0);
	signal wr_mem	: std_logic;
	signal mem_out_a	: std_logic_vector(DATA_WIDTH-1 downto 0);

	signal out_port_data	: std_logic_vector(DATA_WIDTH-1 downto 0);

	signal wren_a		: std_logic;

	type program_t is array (natural range <>) of std_logic_vector(INST_WIDTH-1 downto 0);

	/*
	-- sum 1 to 10
	signal program        : program_t(0 to 7) := (
		   x"00100293",
		   x"00000413",
		   x"00a00313",
		   x"00540433",
		   x"00128293",
		   x"fe535ce3",
		   x"7e802c23",
		   x"00000000"
	);
	-- load_store
	signal program        : program_t(0 to 7) := (
		   x"06900293",
		   x"42000313",
		   x"02502423",
		   x"02602623",
		   x"02802383",
		   x"02c02403",
		   x"00000000",
		   x"00000000"
	);
	*/
	-- multiplication
	signal program        : program_t(0 to 7) := (
		   x"00300313",
		   x"fef00393",
		   x"02730e33",
		   x"00000000",
		   x"00000000",
		   x"00000000",
		   x"00000000",
		   x"00000000"
	);
	/*
	-- division
	signal program        : program_t(0 to 7) := (
		   x"fce00293",
		   x"00300313",
		   x"0262c3b3",
		   x"0262ee33",
		   x"00000000",
		   x"00000000",
		   x"00000000",
		   x"00000000"
	);
	*/

	signal program_idx	: integer range program'low to program'high;

begin

	UUT : entity work.CPU
	port map(
		clk			=> clk,
		clken		=> '1',
		reset		=> reset,
		inst		=> inst,
		mem_in		=> mem_in,
		pc			=> pc,
		pc_next		=> pc_next,
		mem_addr	=> mem_addr,
		mem_out		=> mem_out,
		mem_mode	=> mem_mode,
		wr_mem		=> wr_mem,
		regsel		=> (others => '0'),
		regsel_val	=> open
	);

	wren_a <= '0';
	mem : entity work.Memory
	port map(
		clock_a		=> clk,
		clocken_a	=> '1',

		clock_b		=> clk_inv,
		clocken_b	=> '1',

		-- instruction read
		addr_a		=> pc_next(ADDR_WIDTH-1 downto 0),
		data_in_a	=> (others => '0'),
		wren_a		=> '0',
		mode_a		=> "010",
		data_out_a	=> mem_out_a,

		-- data read/write
		addr_b		=> mem_addr(ADDR_WIDTH-1 downto 0),
		data_in_b	=> mem_out,
		wren_b		=> wr_mem,
		mode_b		=> mem_mode,
		data_out_b	=> mem_in,

		in_port_data	=> x"deadf00d",
		out_port_data	=> out_port_data
	);

	clk <= not clk after tb_clk_pd/2;
	clk_inv <= not clk;


	program_idx <= to_integer(unsigned(pc(4 downto 2)));
	-- inst <= program(program_idx) when to_integer(unsigned(pc(31 downto 2))) <= program'high else (others => '0');
	inst <= mem_out_a;

	STIMULUS : process
	begin
		-- take uut out of reset

		wait for TB_CLK_PD;

		reset <= '1';

		wait;

	end process;

end architecture;
