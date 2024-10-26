library ieee;
use ieee.std_logic_1164.all;

entity InstDecoder_TB is
end InstDecoder_TB;

architecture arch of InstDecoder_TB is
	signal inst		:  std_logic_vector(31 downto 0);

	signal opcode	: std_logic_vector(6 downto 0);
	signal rd		: std_logic_vector(4 downto 0);
	signal rs1		: std_logic_vector(4 downto 0);
	signal rs2		: std_logic_vector(4 downto 0);
	signal funct3	: std_logic_vector(2 downto 0);
	signal funct7	: std_logic_vector(6 downto 0);
	signal imm		: std_logic_vector(31 downto 0);
begin

	UUT : entity work.InstDecoder
	port map(
		inst	=> inst,
		opcode	=> opcode,
		rd		=> rd,
		rs1		=> rs1,
		rs2		=> rs2,
		funct3	=> funct3,
		funct7	=> funct7,
		imm		=> imm
	);

	STIMULUS : process
	begin
		inst <= x"3e800093";
		wait for 10 ns;

		inst <= x"7d008113";
		wait for 10 ns;

		inst <= x"c1810193";
		wait for 10 ns;

		inst <= x"83018213";
		wait for 10 ns;

		inst <= x"3e820293";
		wait for 10 ns;

		inst <= x"00010317";
		wait for 10 ns;

		inst <= x"fec30313";
		wait for 10 ns;

		inst <= x"00430313";
		wait for 10 ns;

		wait;
	end process;
end architecture;
