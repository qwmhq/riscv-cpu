library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Debouncer is
generic(clockfreq_hz : integer);
port(
	clk		: in std_logic;
	reset	: in std_logic;
	input	: in std_logic;
	output	: out std_logic
);
end Debouncer;

architecture arch of Debouncer is
--	constant clockfreq_hz: integer := 50;
	constant maxcount	: integer := clockfreq_hz * 1000 /1000;
	signal counter	: integer range 0 to maxcount;
	signal pressed	: std_logic;
begin
	process(clk, reset)
	begin
		if reset = '1' then
			counter <= 0;
			pressed <= '0';
		elsif rising_edge(clk) then
			counter <= counter + 1;
			if input = '1' then
				pressed <= '1';
			end if;

			if counter = maxcount - 1 then
				counter <= 0;
				pressed <= '0';
			end if;
		end if;
	end process;

	output <= input;
end architecture;
