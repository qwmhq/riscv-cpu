library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
port(
	reset	: in std_logic;
	clk		: in std_logic;
	clken	: in std_logic;

	rs1		: in std_logic_vector( 4 downto 0);
	rs2		: in std_logic_vector( 4 downto 0);
	rs3		: in std_logic_vector( 4 downto 0);

	rd		: in std_logic_vector( 4 downto 0);
	wr_en	: in std_logic;
	data_in	: in std_logic_vector(31 downto 0);

	r1		: out std_logic_vector(31 downto 0);
	r2		: out std_logic_vector(31 downto 0);
	r3		: out std_logic_vector(31 downto 0)
);
end RegisterFile;

architecture arch of RegisterFile is	
	type reg_array is array (natural range <>) of std_logic_vector(31 downto 0);
	signal registers			: reg_array(0 to 31);
	signal mutable_registers	: reg_array(1 to 31);
	signal rs1_idx				: integer range 0 to 31;
	signal rs2_idx				: integer range 0 to 31;
	signal rs3_idx				: integer range 0 to 31;
	signal rd_idx				: integer range 0 to 31;
begin
	rd_idx <= to_integer(unsigned(rd));
	rs1_idx <= to_integer(unsigned(rs1));
	rs2_idx <= to_integer(unsigned(rs2));
	rs3_idx <= to_integer(unsigned(rs3));
	
	process(clk, reset)
	begin
		if reset = '0' then
		-- reset all registers
			mutable_registers <= (others => (others => '0'));
		elsif rising_edge(clk) then
		-- update selected register (rd)
			if wr_en = '1' and clken = '1' and rd_idx > 0 then
				mutable_registers(rd_idx) <= data_in;
			end if;
		end if;
	end process;
	
	registers(1 to 31) <= mutable_registers;
	registers(0) <= x"00000000";		-- register x0 is hardwired to 0
	
	r1 <= registers(rs1_idx);
	r2 <= registers(rs2_idx);
	r3 <= registers(rs3_idx);
end architecture;
