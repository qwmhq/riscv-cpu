library ieee;
use ieee.std_logic_1164.all;

package common_pkg is
	constant XLEN		: integer := 32;
	constant PC_WIDTH	: integer := 32;
	constant DATA_WIDTH : integer := 32;
	constant INST_WIDTH : integer := 32;
	constant ADDR_WIDTH : integer := 15;
	constant DATA_ADDR_WIDTH : integer := 15;
	constant INST_ADDR_WIDTH : integer := 14;

	-- opcodes
	constant OPCODE_LUI			: std_logic_vector(6 downto 0) := "0110111";
	constant OPCODE_AUIPC		: std_logic_vector(6 downto 0) := "0010111";
	constant OPCODE_JAL			: std_logic_vector(6 downto 0) := "1101111";
	constant OPCODE_JALR		: std_logic_vector(6 downto 0) := "1100111";
	constant OPCODE_BRANCH		: std_logic_vector(6 downto 0) := "1100011";
	constant OPCODE_LOAD		: std_logic_vector(6 downto 0) := "0000011";
	constant OPCODE_STORE		: std_logic_vector(6 downto 0) := "0100011";
	constant OPCODE_IMM_COMP	: std_logic_vector(6 downto 0) := "0010011";
	constant OPCODE_REG_COMP	: std_logic_vector(6 downto 0) := "0110011";
	constant OPCODE_FENCE		: std_logic_vector(6 downto 0) := "0001111";
	constant OPCODE_CALL		: std_logic_vector(6 downto 0) := "1110011";

	constant TB_CLK_PD	: time := 20 ns;
	
	procedure wait_one_clock_cycle_0_1(signal clk : inout std_logic; half_time : in time);

	procedure wait_one_clock_cycle_1_0(signal clk : inout std_logic; half_time : in time);

end package;

package body common_pkg is

	procedure wait_one_clock_cycle_0_1(signal clk : inout std_logic; half_time : in time) is
	begin
		clk <= '0';
		wait for half_time;
		clk <= not clk;
		wait for half_time;
	end procedure wait_one_clock_cycle_0_1;

	procedure wait_one_clock_cycle_1_0(signal clk : inout std_logic; half_time : in time) is
	begin
		clk <= '1';
		wait for half_time;
		clk <= not clk;
		wait for half_time;
	end procedure wait_one_clock_cycle_1_0;

end package body common_pkg;
