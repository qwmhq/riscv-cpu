library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package common_pkg is
	constant XLEN		: integer := 32;
	constant PC_WIDTH	: integer := 32;
	constant DATA_WIDTH : integer := 32;
	constant INST_WIDTH : integer := 32;
	constant ADDR_WIDTH : integer := 11;
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

	type character_string is array (natural range <>) of STD_LOGIC_VECTOR(7 downto 0);
	function hex_to_ascii(hex : std_logic_vector(3 downto 0)) return std_logic_vector;
	function hex_to_dec_char(hex : std_logic_vector(4 downto 0)) return character_string;
	function generate_character_string(
		val5_dec	: std_logic_vector(4 downto 0);
		val16		: std_logic_vector(15 downto 0);
		val32_1		: std_logic_vector(31 downto 0);
		val32_2		: std_logic_vector(31 downto 0)
	) return character_string;
end package;

package body common_pkg is
	function hex_to_ascii(hex : std_logic_vector(3 downto 0)) return std_logic_vector is
	begin
		if hex < x"a" then
			return std_logic_vector(unsigned('0' & hex) + x"30");
		else
			return std_logic_vector(unsigned('0' & hex) + x"37");
		end if;
	end function;
	
	function hex_to_dec_char(hex : std_logic_vector(4 downto 0)) return character_string is
		variable x	: unsigned(4 downto 0) := unsigned(hex);
		variable d1 : std_logic_vector(4 downto 0) := std_logic_vector(x / 10);
		variable d2	: std_logic_vector(4 downto 0) := std_logic_vector(x mod 10);
	begin
		return (
			hex_to_ascii(d1(3 downto 0)),
			hex_to_ascii(d2(3 downto 0))
		);
	end function;

	function generate_character_string(
		val5_dec	: std_logic_vector(4 downto 0);
		val16		: std_logic_vector(15 downto 0);
		val32_1		: std_logic_vector(31 downto 0);
		val32_2		: std_logic_vector(31 downto 0)
	) return character_string is
		variable chars	: character_string(0 to 31);
	begin
		chars(0 to 2) := (x"20", x"41", x"3A"); --" A:"

		chars(3) := hex_to_ascii(val16(15 downto 12));
		chars(4) := hex_to_ascii(val16(11 downto 8));
		chars(5) := hex_to_ascii(val16(7 downto 4));
		chars(6) := hex_to_ascii(val16(3 downto 0));

		chars(7) := (x"7E"); -- "->"

		chars(8) := hex_to_ascii(val32_1(31 downto 28));
		chars(9) := hex_to_ascii(val32_1(27 downto 24));
		chars(10) := hex_to_ascii(val32_1(23 downto 20));
		chars(11) := hex_to_ascii(val32_1(19 downto 16));
		chars(12) := hex_to_ascii(val32_1(15 downto 12));
		chars(13) := hex_to_ascii(val32_1(11 downto 8));
		chars(14) := hex_to_ascii(val32_1(7 downto 4));
		chars(15) := hex_to_ascii(val32_1(3 downto 0));

		chars(16 to 20) := (x"20", x"20", x"52", x"3A", x"78"); -- "  R:x"
		chars(21 to 22) := hex_to_dec_char(val5_dec);
		chars(23) := (x"7E"); -- REG  8 ->

		chars(24) := hex_to_ascii(val32_2(31 downto 28));
		chars(25) := hex_to_ascii(val32_2(27 downto 24));
		chars(26) := hex_to_ascii(val32_2(23 downto 20));
		chars(27) := hex_to_ascii(val32_2(19 downto 16));
		chars(28) := hex_to_ascii(val32_2(15 downto 12));
		chars(29) := hex_to_ascii(val32_2(11 downto 8));
		chars(30) := hex_to_ascii(val32_2(7 downto 4));
		chars(31) := hex_to_ascii(val32_2(3 downto 0));

		return chars;
	end function;
end package body common_pkg;
