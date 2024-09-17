library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity ControlUnit_TB is
end ControlUnit_TB;

architecture arch of ControlUnit_TB is
	signal clk,
			reset		: std_logic;
	signal inst			: std_logic_vector(31 downto 0);
	signal opcode		: std_logic_vector(6 downto 0);
	signal rd, rs1, rs2	: std_logic_vector(4 downto 0);
	signal pc, r1, r2,
			imm, mem_in,
			alu_z		: std_logic_vector(31 downto 0);
	signal func3		: std_logic_vector(2 downto 0);
	signal func7		: std_logic_vector(6 downto 0);

	signal alu_x,
			alu_y,
			rd_val,
			pc_next		: std_logic_vector(31 downto 0);
	signal alu_func3	: std_logic_vector(2 downto 0);
	signal alu_func7	: std_logic_vector(6 downto 0);
	signal wr_rd,
			wr_mem,
			wr_pc		: std_logic;
	signal pc_val		: integer;
begin
	INST_DCDR: entity work.InstDecoder
	port map(
		inst	=> inst,
		opcode	=> opcode,
		rd		=> rd,
		rs1		=> rs1,
		rs2		=> rs2,
		funct3	=> func3,
		funct7	=> func7,
		imm		=> imm
	);

	UUT: entity work.ControlUnit
	port map(
		clk		=> clk,
		reset	=> reset,
		opcode	=> opcode,
		func3	=> func3,
		func7	=> func7,
		imm		=> imm,
		pc		=> pc,
		r1		=> r1,
		r2		=> r2,
		mem_in	=> mem_in,
		alu_z	=> alu_z,
		alu_x	=> alu_x,
		alu_y	=> alu_y,
		alu_func3	=> alu_func3,
		alu_func7	=> alu_func7,
		rd_val		=> rd_val,
		wr_rd		=> wr_rd,
		wr_mem		=> wr_mem,
		pc_next		=> pc_next,
		wr_pc		=> wr_pc
	);

	STIMULUS: process
	begin
		pc 		<= x"00000004";
		r1		<= x"00000069";
		r2		<= x"00000420";
		alu_z	<= x"0000AAAA";
		mem_in	<= x"0000BBBB";

		inst	<= x"003100b3";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"403100b3";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"3e800093";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"7d008113";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"c1810193";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"83018213";
		wait_one_clock_cycle_1_0(clk, 10 ns);
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"3e820293";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"00010317";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"fec30313";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"00430313";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"00129463";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"00128463";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"0012c463";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"0012d463";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"0012e463";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"0012f463";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"0d40006f";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"fff12183";
		wait_one_clock_cycle_1_0(clk, 10 ns);
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"fe312fa3";
		wait_one_clock_cycle_1_0(clk, 10 ns);
		wait_one_clock_cycle_1_0(clk, 10 ns);

		inst	<= x"00000013";
		wait_one_clock_cycle_1_0(clk, 10 ns);

		wait;
	end process;
end architecture;
