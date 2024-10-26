library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity InstMem_TB is
end InstMem_TB;

architecture arch of InstMem_TB is
	signal wr_address,
			rd_address	: std_logic_vector(INST_ADDR_WIDTH-1 downto 0);
	signal data_in,
			data_out	: std_logic_vector(INST_WIDTH-1 downto 0);
	signal clock, wren	: std_logic;

	type inst_array is array (natural range <>) of std_logic_vector(INST_WIDTH-1 downto 0);
	signal instructions : inst_array(0 to 7) := (
		x"3e800093",
		x"7d008113",
		x"c1810193",
		x"83018213",
		x"3e820293",
		x"00010317",
		x"fec30313",
		x"00430313"
	);
begin
	UUT : entity work.InstMem
	port map(
		wr_address	=> wr_address,
		rd_address	=> rd_address,
		data_in		=> data_in,
		clock		=> clock,
		wren		=> wren,
		data_out	=> data_out
	);

	STIMULUS : process
	begin
		-- write to memory
		wren <= '1';
		wait_one_clock_cycle_0_1(clock, 10 ns);

		for i in instructions'range loop
			wr_address <= std_logic_vector(to_unsigned(i, INST_ADDR_WIDTH));
			data_in <= instructions(i);
			wait_one_clock_cycle_0_1(clock, 10 ns);
		end loop;
		wren <= '0';

		-- read from memory
		for i in 0 to instructions'length loop
			rd_address <= std_logic_vector(to_unsigned(i, INST_ADDR_WIDTH));
			wait_one_clock_cycle_0_1(clock, 10 ns);
		end loop;

		wait;
	end process;

end architecture;
