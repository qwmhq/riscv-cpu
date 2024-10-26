library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeypadScanner_TB is
end KeypadScanner_TB;

architecture arch of KeypadScanner_TB is
	constant clockfreqhz	: integer := 100;
	constant clockperiod	: time := 1000 ms / clockfreqhz;

	signal clock	: std_logic := '1';
	signal reset	: std_logic := '1';
	signal row		: std_logic_vector(3 downto 0) := "0000";
	signal col		: std_logic_vector(3 downto 0);
	signal keyval	: std_logic_vector(3 downto 0);
	signal keyup	: std_logic;

begin
	
	UUT : entity work.KeypadScanner
	generic map(clockfreqhz => clockfreqhz)
	port map(
		clock	=> clock,
		reset	=> reset,
		row		=> row,
		col		=> col,
		keyval	=> keyval,
		keyup	=> keyup
	);

	clock <= not clock after clockperiod / 2;

	STIM : process
	begin
		wait until rising_edge(clock);

		reset <= '0';

		wait until rising_edge(clock);

		-- simulate key presses

		for i in 0 to 3 loop
			for j in 0 to 3 loop
				for k in 1 to 200 ms / (clockperiod / 4) loop
					row(i) <= col(j);
					wait for clockperiod / 4;
				end loop;
				row(i) <= '0';
				wait for clockperiod * 2;
			end loop;
		end loop;

		wait;
	end process;
end architecture;
