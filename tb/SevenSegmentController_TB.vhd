library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity SevenSegmentController_TB is
end entity;

architecture arch of SevenSegmentController_TB is
	signal clk		: std_logic := '1';
	signal reset	: std_logic;
	signal data_in	: std_logic_vector(15 downto 0);
	signal seg		: std_logic_vector(6 downto 0);
	signal anode	: std_logic_vector(3 downto 0);
begin

	UUT : entity work.SevenSegmentController
	port map(
		clk		=> clk,
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
		reset <= '1';
		wait for TB_CLK_PD;
		reset <= '0';

		data_in <= x"dead";
		wait;
	end process;

end architecture;
