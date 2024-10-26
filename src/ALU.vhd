library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
port(
	clock	: in std_logic;
	x, y	: in std_logic_vector(31 downto 0);
	func3	: in std_logic_vector(2 downto 0);
	func7	: in std_logic_vector(6 downto 0);
	z		: out std_logic_vector(31 downto 0)
);
end ALU;

architecture arch of ALU is
	signal x_signed, y_signed		: signed(31 downto 0);
	signal x_unsigned, y_unsigned	: unsigned(31 downto 0);

	signal x_ext, y_ext				: std_logic_vector(32 downto 0);

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
			div_result,
			rem_result		: std_logic_vector(31 downto 0);

	signal mul_res_full		: std_logic_vector(65 downto 0);

	signal div_res_full,
			rem_res_full	: std_logic_vector(32 downto 0);

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
	x_ext(31 downto 0) <= x;
	y_ext(31 downto 0) <= y;

	with func3 select
		x_ext(32) <= x(31) when "001" | "010" | "100" | "110",
					 '0' when others;
	with func3 select
		y_ext(32) <= y(31) when "001" | "100" | "110",
					 '0' when others;

	MUL1 : entity work.Multiplier
	port map(
		clock	=> clock,
		dataa	=> x_ext,
		datab	=> y_ext,
		result	=> mul_res_full
	);
	mul_result <= mul_res_full(31 downto 0);
	mulh_result <= mul_res_full(63 downto 32);

	DIV1 : entity work.Divider
	port map(
		clock		=> clock,
		numer		=> x_ext,
		denom		=> y_ext,
		quotient	=> div_res_full,
		remain		=> rem_res_full
	);
	div_result <= div_res_full(31 downto 0);
	rem_result <= rem_res_full(31 downto 0);

	/*
	mul_result	<= (others => '0');
	mulh_result	<= (others => '0');

	div_result	<= (others => '0');
	rem_result	<= (others => '0');
	*/

	with (func3) select
		res2 <= mul_result when "000",
				mulh_result when "001" | "010" | "011",
				div_result when "100" | "101",
				rem_result when "110" | "111",
				(others => 'X') when others;

	with (func7(0)) select
		z <= res1 when '0',
			 res2 when '1',
			(others => 'X') when others;

end architecture;
