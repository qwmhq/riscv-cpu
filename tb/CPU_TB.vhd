library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity CPU_TB is
end CPU_TB;

architecture arch of CPU_TB is
	signal clk		: std_logic := '0';
	signal reset	: std_logic;

	signal inst		: std_logic_vector(INST_WIDTH-1 downto 0);
	signal mem_in	: std_logic_vector(DATA_WIDTH-1 downto 0);

	signal pc		: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal pc_next	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem_addr	: std_logic_vector(XLEN-1 downto 0);
	signal mem_out	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem_mode	: std_logic_vector(2 downto 0);
	signal wr_mem	: std_logic;

	type program_t is array (natural range <>) of std_logic_vector(INST_WIDTH-1 downto 0);

	signal factorial_program	: program_t(1 to 6) := (
		x"00600593",
		x"00100513",
		x"00100293",
		x"02550533",
		x"00128293",
		x"fe55dce3"
	);
	signal program_idx	: integer;

begin

	UUT : entity work.CPU
	port map(
		clk			=> clk,
		reset		=> reset,
		inst		=> inst,
		mem_in		=> mem_in,
		pc			=> pc,
		pc_next		=> pc_next,
		mem_addr 	=> mem_addr,
		mem_out		=> mem_out,
		mem_mode	=> mem_mode,
		wr_mem		=> wr_mem
	);

	CLOCK_PROC : process
	begin
		loop
			clk <= not clk;
			wait for TB_CLK_PD/2;
		end loop;
	end process;

	STIMULUS : process
	begin
		reset <= '1';
		wait for TB_CLK_PD;
		reset <= '0';
		wait for TB_CLK_PD;

		loop
			program_idx <= to_integer(unsigned(pc(3 downto 0)));
			-- inst <= factorial_program(to_integer(unsigned(pc)));
			wait for TB_CLK_PD/2;
		end loop;
	end process;

end architecture;
