library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity top is
port(
	reset	: in std_logic;
	clock	: in std_logic;

	-- hd44780 lcd
	lcd_e		: out std_logic;
	lcd_rs	: out std_logic;
	lcd_dbus	: out std_logic_vector(3 downto 0);

	led_on	: out std_logic;
	
	-- keypad
	kpd1_col	: out std_logic_vector(3 downto 0);
	kpd1_row	: in std_logic_vector(3 downto 0);
	
	kpd2_col	: out std_logic_vector(3 downto 0);
	kpd2_row	: in std_logic_vector(3 downto 0);

	-- seven segment display
	disp_seg	: out std_logic_vector(6 downto 0);
	disp_anode	: out std_logic_vector(7 downto 0);

	-- signaltap sampling clock
	pll_c1	: out std_logic;
	
	-- switch input
	port0	: in std_logic_vector((DATA_WIDTH/2)-1 downto 0)
);
end top;

architecture arch of top is
	constant clockfreqhz 	: integer := 50_000_000;
	constant clockenfreqhz	: integer := 100;
	constant maxclockcount	: integer := clockfreqhz / clockenfreqhz;
	
	signal resetn	: std_logic;
		
	-- internal signals
	signal clock_count	: integer range 0 to maxclockcount;
	signal clock_en		: std_logic;
	signal clock_25		: std_logic;

	-- lcd
	signal lcd_val16		: std_logic_vector(15 downto 0);
	signal lcd_val32_1	: std_logic_vector(31 downto 0);
	signal lcd_val32_2	: std_logic_vector(31 downto 0);
	signal lcd_chars	: character_string(0 to 31);
	
	-- keypad
	signal kpd1_keyval	: std_logic_vector(3 downto 0);
	signal kpd1_keyup		: std_logic;

	signal kpd2_keyval	: std_logic_vector(3 downto 0);
	signal kpd2_keyup		: std_logic;
	
	-- keypad buffer
	signal buf_input	: std_logic_vector(3 downto 0);
	signal buf_reg		: std_logic_vector(31 downto 0);

	-- 
	signal mem_addr_io	: std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal regsel			: std_logic_vector(4 downto 0);
	signal regsel_val		: std_logic_vector(31 downto 0);

	type state_t is (idle, pre_mem_load, mem_load, mem_load_write, mem_view, execute_0, execute_1);
	signal current_state	: state_t;

	-- keypad2 constants
	constant CLEAR_KEYVAL		: std_logic_vector(3 downto 0) := x"E";
	constant RS_DEC_KEYVAL		: std_logic_vector(3 downto 0) := x"A";
	constant RS_INC_KEYVAL		: std_logic_vector(3 downto 0) := x"B";
	constant EXEC_KEYVAL		: std_logic_vector(3 downto 0) := x"F";
	constant ADDR_DEC_KEYVAL	: std_logic_vector(3 downto 0) := x"6";
	constant ADDR_INC_KEYVAL	: std_logic_vector(3 downto 0) := x"7";
	constant MEMLD_KEYVAL		: std_logic_vector(3 downto 0) := x"2";
	constant MEMVIEW_KEYVAL		: std_logic_vector(3 downto 0) := x"3";
	constant ENTER_KEYVAL		: std_logic_vector(3 downto 0) := x"D";
	constant BACK_KEYVAL		: std_logic_vector(3 downto 0) := x"9";
	constant HALT_KEYVAL		: std_logic_vector(3 downto 0) := x"C";
	
	-- memory
	signal mem_mode_a		: std_logic_vector(2 downto 0);
	signal mem_wren_a		: std_logic;
	signal mem_addr_a		: std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal mem_data_in_a	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem_data_out_a	: std_logic_vector(DATA_WIDTH-1 downto 0);

	signal mem_mode_b		: std_logic_vector(2 downto 0);
	signal mem_wren_b		: std_logic;
	signal mem_addr_b		: std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal mem_data_in_b	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem_data_out_b	: std_logic_vector(DATA_WIDTH-1 downto 0);
	
	signal in_port_data	: std_logic_vector(DATA_WIDTH-1 downto 0);

	-- cpu
	signal cpu_clock_en		: std_logic;
	signal cpu_mem_addr_out	: std_logic_vector(31 downto 0);
	signal cpu_pc			: std_logic_vector(31 downto 0);
	signal cpu_reset		: std_logic;

	-- seven segment display
	signal disp_data	: std_logic_vector(DATA_WIDTH-1 downto 0);
begin

	resetn <= not reset;

-- ----------------------------------------------------
-- LCD CONTROLLER COMPONENT
-- ----------------------------------------------------
	lcd_chars <= generate_character_string(regsel, lcd_val16, lcd_val32_1, lcd_val32_2);
	U1 : entity work.LCDDriver
	port map
	(
		reset	=> reset,
		clock	=> clock,

		chars	=> lcd_chars,
		
		e		=> lcd_e,
		rs		=> lcd_rs,
		dbus	=> lcd_dbus
	);
	
-- ----------------------------------------------------
-- KEYPAD SCANNERS
-- ----------------------------------------------------
	U2 : entity work.KeypadScanner
	generic map(clockenfreqhz => clockenfreqhz)
	port map(
		clock		=> clock,
		clock_en	=> clock_en,
		reset		=> reset,
		row			=> kpd1_row,
		col			=> kpd1_col,
		keyval		=> kpd1_keyval,
		keyup		=> kpd1_keyup
	);
	
	U3 : entity work.KeypadScanner
	generic map(clockenfreqhz => clockenfreqhz)
	port map(
		clock		=> clock,
		clock_en	=> clock_en,
		reset		=> reset,
		row			=> kpd2_row,
		col			=> kpd2_col,
		keyval		=> kpd2_keyval,
		keyup		=>	kpd2_keyup
	);
	
	with kpd1_keyval select
		buf_input <= x"1" when x"0",
						x"2" when x"1",
						x"3" when x"2",
						x"A" when x"3",
						x"4" when x"4",
						x"5" when x"5",
						x"6" when x"6",
						x"B" when x"7",
						x"7" when x"8",
						x"8" when x"9",
						x"9" when x"A",
						x"C" when x"B",
						x"E" when x"C",
						x"0" when x"D",
						x"F" when x"E",
						x"D" when x"F",
						(others => 'X') when others;

-- -------------------------------------------------------
-- memory
-- -------------------------------------------------------
	in_port_data(31 downto 16) <= port0;
	in_port_data(15 downto 0) <= (others => '0');
	U4 : entity work.Memory
	port map(
		clock	=> clock_25,

		addr_a		=> mem_addr_a,
		data_in_a	=> mem_data_in_a,
		wren_a		=> mem_wren_a,
		mode_a		=> mem_mode_a,
		data_out_a	=> mem_data_out_a,

		addr_b		=> mem_addr_b,
		data_in_b	=> mem_data_in_b,
		wren_b		=> mem_wren_b,
		mode_b		=> mem_mode_b,
		data_out_b	=> mem_data_out_b,

		in_port_data => in_port_data,
		out_port_data => disp_data
	);

-- -------------------------------------------------------
-- CPU
-- -------------------------------------------------------
	U5 : entity work.CPU
	port map(
		clk		=> clock_25,
		clken	=> cpu_clock_en,
		reset	=> cpu_reset,

		inst	=> mem_data_out_a,
		mem_in	=> mem_data_out_b,
		regsel	=> regsel,

		pc			=> cpu_pc,
		mem_addr	=> cpu_mem_addr_out,
		mem_out		=> mem_data_in_b,
		mem_mode	=> mem_mode_b,
		wr_mem		=> mem_wren_b,
		regsel_val	=> regsel_val
	);
	mem_addr_b <= cpu_mem_addr_out(ADDR_WIDTH-1 downto 0);

-- ----------------------------------------------------
-- PLL
-- ----------------------------------------------------
	U6 : entity work.PLL
	port map
	(
		areset	=> resetn,
		inclk0	=> clock,
		c1		=> pll_c1,
		c0		=> clock_25
	);

-- ----------------------------------------------------
-- Seven Segment Controller
-- ----------------------------------------------------
	U7 : entity work.SevenSegmentController
	port map
	(
		clk_50	=> clock,
		reset	=> reset,
		data_in => disp_data,
		seg		=> disp_seg,
		anode	=> disp_anode
	);

-- ----------------------------------------------------
-- slow clock process
-- ----------------------------------------------------
	P1: process(clock, reset)
	begin
		if (reset = '0') then
			clock_count <= 0;
			clock_en <= '0';
		elsif rising_edge(clock) then
			if clock_count <= maxclockcount - 1 then
				clock_count <= clock_count + 1;
				clock_en <= '0';
			else
				clock_count <= 0;
				clock_en <= '1';
			end if;
		end if;
	end process;
	
-- --------------------------------------------------------
-- 
-- --------------------------------------------------------	
	
	with current_state select
		lcd_val16 <= (others => '0') when execute_0 | execute_1,
							"00000" & mem_addr_io when others;
	
	lcd_val32_1 <= buf_reg;
	lcd_val32_2 <= regsel_val;
	
	cpu_clock_en <= '1' when current_state = execute_1 else '0';

	mem_mode_a <= "010";
	mem_data_in_a <= buf_reg;
	with current_state select
		mem_addr_a <= cpu_pc(ADDR_WIDTH-1 downto 0) when execute_0 | execute_1,
							mem_addr_io when others;						
	
-- --------------------------------------------------------	
-- state machine processs
-- --------------------------------------------------------
	P2 : process(clock, reset)
	begin
		if (reset = '0') then
			current_state <= idle;
			mem_addr_io <= (others => '0');
			regsel <= (others => '0');
			buf_reg <= (others => '0');
			cpu_reset <= '1';
		elsif rising_edge(clock) then
			if clock_en = '1' then
				-- defaults
				mem_wren_a <= '0';

				-- keypad2 presses that don't depend on current state
				if kpd2_keyup = '1' then
					-- register select increment and decrement
					if kpd2_keyval = RS_INC_KEYVAL then
						regsel <= std_logic_vector(unsigned(regsel) + 1);
					elsif kpd2_keyval = RS_DEC_KEYVAL then
						regsel <= std_logic_vector(unsigned(regsel) - 1);
					elsif kpd2_keyval = BACK_KEYVAL then
						current_state <= idle;
					end if;
				end if;

				case current_state is
					when idle =>
						mem_addr_io <= (others => '0');
						buf_reg <= (others => '0');
						if kpd2_keyup = '1' then
							if kpd2_keyval = MEMLD_KEYVAL then
								current_state <= pre_mem_load;
							elsif kpd2_keyval = MEMVIEW_KEYVAL then
								current_state <= mem_view;
							end if;
						end if;
					when pre_mem_load =>
						buf_reg <= mem_data_out_a;
						current_state <= mem_load;
					when mem_load =>
						if kpd1_keyup = '1' then
							buf_reg <= buf_reg(buf_reg'high - 4 downto buf_reg'low) & buf_input;
						elsif kpd2_keyup = '1' then
							if kpd2_keyval = CLEAR_KEYVAL then 
								buf_reg <= (others => '0');
							elsif kpd2_keyval = ADDR_DEC_KEYVAL then
								mem_addr_io <= std_logic_vector(unsigned(mem_addr_io) - 4);
								current_state <= pre_mem_load;
							elsif kpd2_keyval = ADDR_INC_KEYVAL then
								mem_addr_io <= std_logic_vector(unsigned(mem_addr_io) + 4);
								current_state <= pre_mem_load;
							elsif kpd2_keyval = ENTER_KEYVAL then
								current_state <= mem_load_write;
								mem_wren_a <= '1';
							elsif kpd2_keyval = EXEC_KEYVAL then
								current_state <= execute_0;
								cpu_reset <= '0';
							end if;
						end if;
					when mem_load_write =>
						mem_addr_io <= std_logic_vector(unsigned(mem_addr_io) + 4);
						current_state <= pre_mem_load;
					when mem_view =>
						buf_reg <= mem_data_out_a;
						if kpd2_keyup = '1' then
							if kpd2_keyval = ADDR_DEC_KEYVAL then
								mem_addr_io <= std_logic_vector(unsigned(mem_addr_io) - 4);
							elsif kpd2_keyval = ADDR_INC_KEYVAL then
								mem_addr_io <= std_logic_vector(unsigned(mem_addr_io) + 4);
							end if;
						end if;
					when execute_0 =>
						cpu_reset <= '1';
						current_state <= execute_1;
					when execute_1 =>
						if kpd2_keyup = '1' then
							if kpd2_keyval = HALT_KEYVAL then
								current_state <= idle;
							end if;
						end if;
				end case;
			end if;
		end if;
	end process;
			
	led_on <= not clock_en;
end architecture;
