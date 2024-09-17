library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_TB is
end ALU_TB;

architecture arch of ALU_TB is
	signal x, y	: std_logic_vector(31 downto 0);
	signal func3	: std_logic_vector(2 downto 0);
	signal func7	: std_logic_vector(6 downto 0);
	signal z		: std_logic_vector(31 downto 0);

	procedure test(
		signal funct3: inout std_logic_vector(2 downto 0);
		signal funct7: inout std_logic_vector(6 downto 0)
	) is
	begin
		funct7 <= "0000000";
		for i in 0 to 7 loop
			funct3	<= std_logic_vector(to_unsigned(i, 3));
			wait for 100 ns;

			if i = 0 or i = 5 then
				funct7(5) <= '1';
				wait for 100 ns;
				funct7(5) <= '0';
			end if;
		end loop;

		funct7 <= "0000001";

		for i in 0 to 7 loop
			funct3	<= std_logic_vector(to_unsigned(i, 3));
			wait for 100 ns;
		end loop;
	end procedure test;

begin
	UUT : entity work.ALU
	port map(
		x		=> x,
		y		=> y,
		func3	=> func3,
		func7	=> func7,
		z		=> z
	);

	STIMULUS : process
	begin
		x	<= std_logic_vector(to_signed(-4, 32));
		y	<= std_logic_vector(to_signed(-5, 32));
		test(func3, func7);

		x	<= std_logic_vector(to_signed(-5, 32));
		y	<= std_logic_vector(to_signed(-4, 32));
		test(func3, func7);

		x	<= std_logic_vector(to_signed(69, 32));
		y	<= std_logic_vector(to_signed(69, 32));
		test(func3, func7);

		x	<= x"69696969";
		y	<= x"42042042";
		test(func3, func7);

		wait;
	end process;
end architecture;
