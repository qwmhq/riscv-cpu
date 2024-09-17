library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity ProgramCounter_TB is
end entity;

architecture arch of ProgramCounter_TB is
	signal pc, pc_next		: std_logic_vector(PC_WIDTH-1 downto 0);
	signal wren, clk, reset	: std_logic;
begin
	UUT: entity work.ProgramCounter
	port map(
		pc_next	=> pc_next,
		wren	=> wren,
		clk		=> clk,
		reset	=> reset,
		pc		=> pc
	);

	STIMULUS : process
	begin
		reset <= '1';
		wait_one_clock_cycle_0_1(clk, 10 ns);
		
		reset  <= '0';
		wren <= '1';

		pc_next <= x"69696969";
		wait_one_clock_cycle_0_1(clk, 10 ns);

		reset <= '1';
		wait_one_clock_cycle_0_1(clk, 10 ns);
		reset <= '0';

		pc_next <= x"00420420";
		wren <= '1';
		wait_one_clock_cycle_0_1(clk, 10 ns);

		pc_next <= x"FFFFFFFF";
		wren <= '1';
		wait_one_clock_cycle_0_1(clk, 10 ns);

		wait;
	end process;
end architecture;
