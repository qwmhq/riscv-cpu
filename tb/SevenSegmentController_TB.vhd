library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity SevenSegmentController_TB is
end entity;

architecture arch of SevenSegmentController_TB is
	signal clk		: std_logic := '1';
	signal reset	: std_logic := '0';
	signal data_in	: std_logic_vector(31 downto 0);
	signal seg		: std_logic_vector(6 downto 0);
	signal anode	: std_logic_vector(7 downto 0);
begin

	UUT : entity work.SevenSegmentController
	port map(
		clk_50	=> clk,
		reset	=> reset,
		data_in	=> data_in,
		seg		=> seg,
		anode	=> anode
	);

	clock_proc: process
	begin
		loop
			clk <= not clk;
			wait for TB_CLK_PD/2;
		end loop;
	end process;

	stimulus: process
	begin
		wait until rising_edge(clk);

		reset <= '1';
		wait for TB_CLK_PD;

		data_in <= x"deadf00d";
		wait;
	end process;

end architecture;
