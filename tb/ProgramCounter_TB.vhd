library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity ProgramCounter_TB is
end entity;

architecture arch of ProgramCounter_TB is
	signal clk		: std_logic := '1';
	signal reset	: std_logic := '0';
	signal pc		: std_logic_vector(PC_WIDTH-1 downto 0);
	signal pc_next	: std_logic_vector(PC_WIDTH-1 downto 0);
	signal wren		: std_logic;
begin
	UUT: entity work.ProgramCounter
	port map(
		reset	=> reset,
		clk		=> clk,
		clken	=> '1',
		pc_next	=> pc_next,
		wren	=> wren,
		pc		=> pc
	);

	clk <= not clk after TB_CLK_PD/2;

	STIMULUS : process
	begin
		wait until rising_edge(clk);

		-- bring uut out of reset
		reset <= '1';
		wait for TB_CLK_PD;

		wren <= '1';

		pc_next <= x"69696969";
		wait for TB_CLK_PD;

		reset <= '0';
		wait for TB_CLK_PD;
		reset <= '1';

		pc_next <= x"00420420";
		wren <= '1';
		wait for TB_CLK_PD;

		pc_next <= x"FFFFFFFF";
		wren <= '1';
		wait for TB_CLK_PD;

		wait;
	end process;
end architecture;
