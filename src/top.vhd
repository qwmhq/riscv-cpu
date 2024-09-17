library ieee;
use ieee.std_logic_1164.all;
use work.common_pkg.all;

entity top is
port(
	clk		: in std_logic;
	reset	: in std_logic;

	-- keypad ports
	keypad1_row	: in std_logic_vector(3 downto 0);
	keypad1_col	: out std_logic_vector(3 downto 0);

	keypad2_row	: in std_logic_vector(3 downto 0);
	keypad2_col	: out std_logic_vector(3 downto 0);
	
	-- lcd display ports
	lcd_rs		: out std_logic;
	lcd_e		: out std_logic;
	lcd_rw		: out std_logic;
	lcd_data	: inout std_logic_vector(7 downto 0);
	
	output_1	: out std_logic_vector(31 downto 0);
	output_2	: out std_logic_vector(31 downto 0);
	output_3	: out std_logic_vector(31 downto 0)
);
end entity;

architecture arch of top is
	constant clockfreq_hz	: integer := 50000000;
	signal inst	: std_logic_vector(INST_WIDTH-1 downto 0);
	signal instmem_rd_addr
			: std_logic_vector(INST_ADDR_WIDTH-1 downto 0);

	-- keypad signals
	signal keypad1_hexval	: std_logic_vector(3 downto 0);
	signal keypad1_pressed	: std_logic;

	signal keypad2_hexval	: std_logic_vector(3 downto 0);
	signal keypad2_pressed	: std_logic;
	
	-- keypad buffer
	signal kpd_buf_clear	: std_logic;
	signal kpd_buffer		: std_logic_vector(31 downto 0);
	signal kpd_buf_full		: std_logic;

	-- lcd signals
	signal lcd_on	: std_logic;
	signal lcd_blon	: std_logic;
	signal lcd_addr_in	: std_logic_vector (14 downto 0);
	signal lcd_buf_in	: std_logic_vector(31 downto 0);
	signal lcd_regdata_in	: std_logic_vector(31 downto 0);

	-- memory signals
	signal mem_addr_a		: std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal mem_indata_a		: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem_outdata_a	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem_wren_a		: std_logic;
	signal mem_mode_a		: std_logic_vector(2 downto 0);

	signal mem_addr_b		: std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal mem_indata_b		: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem_outdata_b	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem_wren_b		: std_logic;
	signal mem_mode_b		: std_logic_vector(2 downto 0);

	signal inst_addr1		: std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal inst_addr2		: std_logic_vector(ADDR_WIDTH-1 downto 0);

	-- cpu signals
	signal cpu_clk		: std_logic;
	signal cpu_clk_en	: std_logic;
	signal cpu_pc		: std_logic_vector(PC_WIDTH-1 downto 0);
	signal cpu_memaddr	: std_logic_vector(XLEN-1 downto 0);
	signal cpu_rs3		: std_logic_vector(4 downto 0);
	signal cpu_r3		: std_logic_vector(DATA_WIDTH-1 downto 0);

	-- state machine
	type state_t is (inst_entry, exec);
	signal state	: state_t;
	signal exec_counter	: integer range 0 to clockfreq_hz * 5;

begin
	process(clk, reset)
	begin
		if reset = '1' then
			state <= inst_entry;
			exec_counter <= 0;
			inst_addr1 <= (others => '0');
		elsif rising_edge(clk) then
			case state is
				when inst_entry =>
					cpu_clk_en <= '0';
					mem_addr_a <= inst_addr1;
				when exec =>
					cpu_clk_en <= '1';
					mem_addr_a <= inst_addr2;
			end case;
		end if;
	end process;

	inst <= mem_outdata_a;
	cpu_clk <= clk and cpu_clk_en;	-- cpu clk enable
	CPU : entity work.CPU
	port map(
		clk			=> cpu_clk,
		reset		=> reset,
		inst		=> inst,
		mem_in		=> mem_outdata_b,
		pc			=> cpu_pc,
		mem_addr	=> cpu_memaddr,
		mem_out		=> mem_indata_b,
		mem_mode	=> mem_mode_b,
		wr_mem		=> mem_wren_b
--		rs3			=> cpu_rs3,
--		r3			=> cpu_r3
	);

	inst_addr2	<= cpu_pc(ADDR_WIDTH-1 downto 0);
	mem_addr_b	<= cpu_memaddr(ADDR_WIDTH-1 downto 0);

	MEM : entity work.Memory
	port map(
		clock		=> clk,

		addr_a		=> mem_addr_a,
		data_in_a	=> mem_indata_a,
		wren_a		=> mem_wren_a,
		mode_a		=> mem_mode_a,
		data_out_a	=> mem_outdata_a,

		addr_b		=> mem_addr_b,
		data_in_b	=> mem_indata_b,
		wren_b		=> mem_wren_b,
		mode_b		=> mem_mode_b,
		data_out_b	=> mem_outdata_b
	);

	KPD1 : entity work.KeypadDecoder
	generic map(clockfreq_hz => clockfreq_hz)
	port map(
		clk			=> clk,
		reset		=> reset,
		row			=> keypad1_row,
		col			=> keypad1_col,
		hex_value		=> keypad1_hexval,
		keypad_pressed	=> keypad1_pressed
	);

	KPD2 : entity work.KeypadDecoder
	generic map(clockfreq_hz => clockfreq_hz)
	port map(
		clk		=> clk,
		reset	=> reset,
		row		=> keypad2_row,
		col		=> keypad2_col,
		hex_value		=> keypad2_hexval,
		keypad_pressed	=> keypad2_pressed
	);

	kpd_buf_clear <= '1' when keypad2_pressed ='1' and keypad2_hexval = "0000";
	KPD_BUF : entity work.KeypadBuffer
	port map(
		clk		=> clk,
		reset	=> reset,
		clear	=> kpd_buf_clear,
		key_pressed	=> keypad1_pressed,
		key_value	=> keypad1_hexval,
		buf			=> kpd_buffer,
		buf_full	=> kpd_buf_full
	);
	mem_indata_a <= kpd_buffer;

	lcd_regdata_in <=  cpu_r3;
	lcd_buf_in <= kpd_buffer;
	lcd_addr_in <= inst_addr1;
	LCD : entity work.LCDController
	port map(
		reset		=> reset,
		clock_50	=> clk,

		addr_in		=> lcd_addr_in,
		buf_in		=> lcd_buf_in,
		regdata_in	=> lcd_regdata_in,

		lcd_rs		=> lcd_rs,
		lcd_e		=> lcd_e,
		lcd_rw		=> lcd_rw,
		lcd_on		=> lcd_on,
		lcd_blon	=> lcd_blon,
		data_bus	=> lcd_data
	);

	output_1 <= cpu_memaddr;
	output_2 <= mem_outdata_a;
	output_3 <= mem_indata_b;
end architecture;
