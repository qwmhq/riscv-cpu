library ieee;
use ieee.std_logic_1164.all;
use work.common_pkg.all;

entity CPU is
port(
	clk		: in std_logic;
	clken	: in std_logic;
	reset	: in std_logic;

	inst		: in std_logic_vector(INST_WIDTH-1 downto 0);
	mem_in		: in std_logic_vector(DATA_WIDTH-1 downto 0);
	regsel		: in std_logic_vector(4 downto 0);

	pc			: out std_logic_vector(PC_WIDTH-1 downto 0);
	mem_addr	: out std_logic_vector(XLEN-1 downto 0);
	mem_out		: out std_logic_vector(DATA_WIDTH-1 downto 0);
	mem_mode	: out std_logic_vector(2 downto 0);
	wr_mem		: out std_logic;
	regsel_val	: out std_logic_vector(DATA_WIDTH-1 downto 0)
);
end CPU;

architecture arch of CPU is
	signal pc_val,
			pc_next_val	: std_logic_vector(PC_WIDTH-1 downto 0);

	signal opcode	: std_logic_vector(6 downto 0);

	signal rd, rs1, rs2	: std_logic_vector(4 downto 0);

	signal func3, alu_func3	: std_logic_vector(2 downto 0);
	signal func7, alu_func7	: std_logic_vector(6 downto 0);

	signal imm, r1, r2,
			alu_x, alu_y,
			alu_z, rd_val	: std_logic_vector(DATA_WIDTH-1 downto 0);
	
	signal wr_rd, wr_pc	: std_logic;
begin
	INST_DCD : entity work.InstDecoder
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

	ALU : entity work.ALU
	port map(
		clock	=> clk,
		x		=> alu_x,
		y		=> alu_y,
		func3	=> alu_func3,
		func7	=> alu_func7,
		z		=> alu_z
	);

	REGFILE : entity work.RegisterFile
	port map(
		rs1		=> rs1,
		rs2		=> rs2,
		rs3		=> regsel,
		rd		=> rd,
		data_in	=> rd_val,
		wr_en	=> wr_rd,
		clk		=> clk,
		reset	=> reset,
		r1		=> r1,
		r2		=> r2,
		r3		=> regsel_val
	);

	CU : entity work.ControlUnit
	port map(
		clk		=> clk,
		clken	=> clken,
		reset	=> reset,
		opcode	=> opcode,
		func3	=> func3,
		func7	=> func7,
		imm		=> imm,
		pc		=> pc_val,
		r1		=> r1,
		r2		=> r2,
		mem_in	=> mem_in,
		alu_z	=> alu_z,
		alu_x	=> alu_x,
		alu_y	=> alu_y,
		alu_func3	=> alu_func3,
		alu_func7	=> alu_func7,
		rd_val	=> rd_val,
		wr_rd	=> wr_rd,
		wr_mem	=> wr_mem,
		pc_next	=> pc_next_val,
		wr_pc	=> wr_pc
	);

	PROGCOUNTR : entity work.ProgramCounter
	port map(
		pc_next	=> pc_next_val,
		wren	=> wr_pc,
		clk		=> clk,
		reset	=> reset,
		pc		=> pc_val
	);

	pc <= pc_val;
	mem_out <= r2;
	mem_addr <= alu_z;
	mem_mode <= func3;

end architecture;
