library ieee;
use ieee.std_logic_1164.all;
use work.common_pkg.all;

entity InstDecoder is
port(
	inst	: in std_logic_vector(31 downto 0);

	opcode	: out std_logic_vector(6 downto 0);
	rd		: out std_logic_vector(4 downto 0);
	rs1		: out std_logic_vector(4 downto 0);
	rs2		: out std_logic_vector(4 downto 0);
	funct3	: out std_logic_vector(2 downto 0);
	funct7	: out std_logic_vector(6 downto 0);
	imm		: out std_logic_vector(31 downto 0)
);
end InstDecoder;

architecture arch of InstDecoder is
	signal imm_sign_ext : std_logic_vector(31 downto 11);
	signal i_imm, s_imm,
	b_imm, u_imm, j_imm	: std_logic_vector(31 downto 0);
begin
	opcode	<= inst(6 downto 0);
	rd		<= inst(11 downto 7);
	funct3	<= inst(14 downto 12);
	rs1		<= inst(19 downto 15);
	rs2		<= inst(24 downto 20);
	funct7	<= inst(31 downto 25);

	imm_sign_ext <= (others => inst(31));

	i_imm	<= imm_sign_ext & inst(30 downto 20);
	s_imm	<= imm_sign_ext & inst(30 downto 25) & inst(11 downto 7);
	b_imm	<= imm_sign_ext(31 downto 12) & inst(7) & inst(30 downto 25) & inst(11 downto 8) & '0';
	u_imm	<= inst(31) & inst(30 downto 12) & "000000000000";
	j_imm	<= imm_sign_ext(31 downto 20) & inst(19 downto 12) & inst(20) & inst(30 downto 21) & '0';

	with opcode select
		imm <= u_imm when OPCODE_LUI | OPCODE_AUIPC,
			   i_imm when OPCODE_JALR,
			   i_imm when OPCODE_LOAD,
			   i_imm when OPCODE_IMM_COMP,
			   s_imm when OPCODE_STORE,
			   j_imm when OPCODE_JAL,
			   b_imm when OPCODE_BRANCH,
			   (others => 'X') when others;

end architecture;
