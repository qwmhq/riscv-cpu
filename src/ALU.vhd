library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
port(
	x, y	: in std_logic_vector(31 downto 0);
	func3	: in std_logic_vector(2 downto 0);
	func7	: in std_logic_vector(6 downto 0);
	z		: out std_logic_vector(31 downto 0)
);
end ALU;

architecture arch of ALU is
	signal x_signed, y_signed		: signed(31 downto 0);
	signal x_unsigned, y_unsigned	: unsigned(31 downto 0);

	signal shift_amount	: integer range 0 to 31;

	signal lt, ltu	: boolean;

	signal add_result,
			sub_result,
			sll_result,
			slt_result,
			sltu_result,
			xor_result,
			srl_result,
			sra_result,
			or_result,
			and_result,
			res1_000,
			res1_101,
			mul_result,
			mulh_result,
			mulhsu_result,
			mulhu_result,
			div_result,
			divu_result,
			rem_result,
			remu_result		: std_logic_vector(31 downto 0);

	signal mul_ss, mul_uu	: std_logic_vector(63 downto 0);
	signal mul_su			: std_logic_vector(64 downto 0);

	signal res1, res2	: std_logic_vector(31 downto 0);

begin
	x_signed		<= signed(x);
	y_signed		<= signed(y);
	x_unsigned		<= unsigned(x);
	y_unsigned		<= unsigned(y);
	shift_amount	<= to_integer(unsigned(y(4 downto 0)));
	lt				<= x_signed < y_signed;
	ltu				<= x_unsigned < y_unsigned;
	
	add_result	<= std_logic_vector(x_signed + y_signed);
	sub_result	<= std_logic_vector(x_signed - y_signed);
	sll_result	<= std_logic_vector(shift_left(x_unsigned, shift_amount));
	slt_result 	<= x"00000001" when lt = true else x"00000000";
	sltu_result	<= x"00000001" when ltu = true else x"00000000";
	xor_result	<= x xor y;
	srl_result	<= std_logic_vector(shift_right(x_unsigned, shift_amount));
	sra_result	<= std_logic_vector(shift_right(x_signed, shift_amount));
	or_result	<= x or y;
	and_result	<= x and y;

	with(func7(5)) select
		res1_000 <= add_result when '0',
					sub_result when '1',
					(others => 'X') when others;

	with(func7(5)) select
		res1_101 <= srl_result when '0',
					sra_result when '1',
					(others => 'X') when others;

	with (func3) select
		res1 <= res1_000 when "000",
				sll_result when "001",
				slt_result when "010",
				sltu_result when "011",
				xor_result when "100",
				res1_101 when "101",
				or_result when "110",
				and_result when "111",
				(others => 'X') when others;
	
	-- "M"
	mul_ss	<= std_logic_vector(x_signed * y_signed);
	mul_uu	<= std_logic_vector(x_unsigned * y_unsigned);
	mul_su	<= std_logic_vector(x_signed * signed('0' & y));

	mul_result		<= mul_ss(31 downto 0);
	mulh_result		<= mul_ss(63 downto 32);
	mulhsu_result	<= mul_su(63 downto 32);
	mulhu_result	<= mul_uu(63 downto 32);

	div_result		<= std_logic_vector(x_signed / y_signed);
	divu_result		<= std_logic_vector(x_unsigned / y_unsigned);
	rem_result		<= std_logic_vector(x_signed mod y_signed);
	remu_result		<= std_logic_vector(x_unsigned mod y_unsigned);

	with (func3) select
		res2 <= mul_result when "000",
				mulh_result when "001",
				mulhsu_result when "010",
				mulhu_result when "011",
				div_result when "100",
				divu_result when "101",
				rem_result when "110",
				remu_result when "111",
				(others => 'X') when others;

	with (func7(0)) select
		z <= res1 when '0',
			 res2 when '1',
			(others => 'X') when others;
end architecture;
