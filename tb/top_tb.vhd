library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity top_tb is
end entity;

 architecture arch of top_tb is

	signal clk		: std_logic := '0';
   	signal reset	: std_logic := '0';

	type inst_array is array (natural range <>) of std_logic_vector(INST_WIDTH-1 downto 0);

	signal prog1	: inst_array(0 to 4) := ( -- compute 4 + 5 - 19
		x"00400293",
		x"00500313",
		x"006283b3",
		x"fed38393",
		x"00702423"
	);

	signal prog2	: inst_array(0 to 5) := ( -- sum numbers from 1 to 10
		x"00100293",
		x"00000413",
		x"00a00313",
		x"00540433",
		x"00128293",
		x"fe535ce3"
	);

	signal cpu_clk			: std_logic;
	signal inst				: std_logic_vector(31 downto 0);
	signal cpu_rs3			: std_logic_vector(4 downto 0);

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

	signal cpu_memaddr		: std_logic_vector(31 downto 0);
	signal cpu_pc			: std_logic_vector(31 downto 0);
	signal inst_addr		: std_logic_vector(ADDR_WIDTH-1 downto 0);

 begin
--	cpu_rs3 <= (others => '0');
	inst <= mem_outdata_a;
	mem_mode_a <= "010";
	inst_addr <= cpu_pc(ADDR_WIDTH-1 downto 0);

	CPU : entity work.CPU
	port map(
		clk			=> clk,
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

	CLOCK_PROC : process
	begin
		loop
			clk <= not clk;
			wait for TB_CLK_PD/2;
		end loop;
	end process;

	STIMULUS : process
	begin
		-- reset
		reset <= '1';
		wait for TB_CLK_PD;
		reset <= '0';
		wait for TB_CLK_PD;
		cpu_clk <= 'Z';

		-- load instructions into memory
		mem_wren_a <= '1';
		for i in prog1'range loop
			mem_addr_a <= std_logic_vector(to_unsigned(i*4, ADDR_WIDTH));
			mem_indata_a <= prog1(i);
			wait for TB_CLK_PD;
		end loop;
		wait for TB_CLK_PD;

		mem_wren_a <= '0';
		mem_indata_a <= (others => 'Z');
		mem_addr_a <= (others => 'Z');
		wait for TB_CLK_PD;

		-- reset cpu pc, so instructions can be executed
		reset <= '1';
		wait for TB_CLK_PD;
		reset <= '0';
		cpu_clk <= clk;

		for i in 0 to 39 loop
			mem_addr_a <= inst_addr;
			wait for TB_CLK_PD/8;
		end loop;

		-- reset and load new program into memory
		reset <= '1';
		wait for TB_CLK_PD;
		reset <= '0';

		mem_wren_a <= '1';
		for i in prog2'range loop
			mem_addr_a <= std_logic_vector(to_unsigned(i*4, ADDR_WIDTH));
			mem_indata_a <= prog2(i);
			wait for TB_CLK_PD;
		end loop;
		wait for TB_CLK_PD;

		mem_wren_a <= '0';
		mem_indata_a <= (others => 'Z');
		mem_addr_a <= (others => 'Z');
		wait for TB_CLK_PD;

		-- reset pc and execute instructions
		cpu_clk <= clk;
		reset <= '1';
		wait for TB_CLK_PD;
		reset <= '0';
		mem_addr_a <= cpu_pc(ADDR_WIDTH-1 downto 0);

		for i in 0 to 127 loop
			mem_addr_a <= inst_addr;
			wait for TB_CLK_PD/8;
		end loop;

		wait;

	end process;
end architecture;
