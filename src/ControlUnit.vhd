library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity ControlUnit is
port(
	clk		: in std_logic;
	clken	: in std_logic;
	reset	: in std_logic;
	opcode	: in std_logic_vector(6 downto 0);
	func3	: in std_logic_vector(2 downto 0);
	func7	: in std_logic_vector(6 downto 0);
	imm		: in std_logic_vector(31 downto 0);
	pc		: in std_logic_vector(31 downto 0);
	r1		: in std_logic_vector(31 downto 0);
	r2		: in std_logic_vector(31 downto 0);
	mem_in	: in std_logic_vector(31 downto 0);
	alu_z	: in std_logic_vector(31 downto 0);

	alu_x		: out std_logic_vector(31 downto 0);
	alu_y		: out std_logic_vector(31 downto 0);
	alu_func3	: out std_logic_vector(2 downto 0);
	alu_func7	: out std_logic_vector(6 downto 0);

	rd_val	: out std_logic_vector(31 downto 0);
	wr_rd	: out std_logic;
	wr_mem	: out std_logic;
	pc_next	: out std_logic_vector(31 downto 0);
	wr_pc	: out std_logic
);
end ControlUnit;

architecture arch of ControlUnit is
	signal alu_signals	: std_logic_vector(73 downto 0);

	signal pc_plus_4	: std_logic_vector(31 downto 0);
	signal pc_next_1	: std_logic_vector(31 downto 0);

	signal eq, lt, ltu	: std_logic;
	signal branch_taken	: boolean;

	signal wr_rd_1	: std_logic;
	signal wr_mem_1	: std_logic;

	type state_t is (init, normal, multiply0, divide0, end_wait, halt);
	signal current_state	: state_t;
	signal state_ctr	: integer range 0 to 10;

	constant mult_cycles	: integer := 6;
	constant div_cycles		: integer := 8;

	signal mult_start	: boolean;
	signal div_start	: boolean;
begin
	pc_plus_4 <= std_logic_vector(unsigned(pc) + 4);

	eq <= '1' when r1 = r2 else '0';
	lt <= '1' when signed(r1) < signed(r2) else '0';
	ltu <= '1' when unsigned(r1) < unsigned(r2) else '0';

	with opcode select
		alu_signals(73 downto 7) <=
	   		pc & imm & "000" when OPCODE_AUIPC | OPCODE_JAL | OPCODE_BRANCH,
			r1 & imm & "000" when OPCODE_JALR | OPCODE_LOAD | OPCODE_STORE,
			r1 & imm & func3 when OPCODE_IMM_COMP,
			r1 & r2 & func3 when OPCODE_REG_COMP,
			(others => 'X') when others;
	
	alu_signals(6 downto 0) <= func7 when (opcode = OPCODE_REG_COMP) else
								func7 when (opcode = OPCODE_IMM_COMP and func3 = "001") else
								func7 when (opcode = OPCODE_IMM_COMP and func3 = "101") else
								(others => '0');

	alu_x 		<= alu_signals(73 downto 42);
	alu_y		<= alu_signals(41 downto 10);
	alu_func3	<= alu_signals(9 downto 7);
	alu_func7	<= alu_signals(6 downto 0);

	with opcode select
		rd_val <= imm when OPCODE_LUI,
				  alu_z when OPCODE_AUIPC | OPCODE_IMM_COMP | OPCODE_REG_COMP,
				  pc_plus_4 when OPCODE_JAL | OPCODE_JALR,
				  mem_in when OPCODE_LOAD,
				  (others => 'X') when others;

	with opcode select
		wr_rd_1 <= '1' when OPCODE_LUI
							| OPCODE_AUIPC
							| OPCODE_IMM_COMP
							| OPCODE_REG_COMP 
							| OPCODE_JAL
							| OPCODE_JALR
							| OPCODE_LOAD,
				   '0' when others;

	with opcode select
		wr_mem_1 <= '1' when OPCODE_STORE,
					'0' when others;

	branch_taken <= (func3 = "000" and eq = '1')
					or (func3 = "001" and eq = '0')
					or (func3 = "100" and lt = '1')
					or (func3 = "101" and lt = '0')
					or (func3 = "110" and ltu = '1')
					or (func3 = "111" and ltu = '0');

	pc_next_1 <= alu_z when (OPCODE = OPCODE_JAL or OPCODE = OPCODE_JALR) else
				 alu_z when (OPCODE = OPCODE_BRANCH and branch_taken) else
				 pc_plus_4;

	-- state machine
	mult_start <= true when current_state = normal and (opcode = OPCODE_REG_COMP and func7 = "0000001" and unsigned(func3) <= "011") else false;
	div_start <= true when current_state = normal and (opcode = OPCODE_REG_COMP and func7 = "0000001" and unsigned(func3) > "011") else false;

	process (clk, reset)
	begin
		if reset = '0' then
			current_state <= init;
		elsif rising_edge(clk) then
			if clken = '1' then
				state_ctr <= state_ctr + 1;
				case current_state is
					when init =>
						current_state <= normal;
						state_ctr <= 0;
					when normal =>
						state_ctr <= 0;
						if mult_start then
							current_state <= multiply0;
							state_ctr <= 0;
						elsif div_start then
							current_state <= divide0;
							state_ctr <= 0;
						elsif (opcode = "0000000") then
							current_state <= halt;
							state_ctr <= 0;
						end if;
					when multiply0 =>
						if state_ctr = mult_cycles-2 then
							current_state <= end_wait;
							state_ctr <= 0;
						end if;
					when divide0 =>
						if state_ctr = div_cycles-2 then
							current_state <= end_wait;
							state_ctr <= 0;
						end if;
					when end_wait =>
						current_state <= normal;
						state_ctr <= 0;
					when halt =>
						state_ctr <= 0;
				end case;
			end if;
		end if;
	end process;

	with current_state select
		pc_next <= (others => '0') when init,
				   pc_next_1 when others;

	wr_pc <= '1' when (current_state = normal and not (mult_start or div_start) and opcode /= "0000000") or current_state = end_wait else '0';
	wr_rd <= wr_rd_1 when (current_state = normal and not (mult_start or div_start)) or current_state = end_wait else '0';
	wr_mem <= wr_mem_1 when current_state = normal else '0';

end architecture;
