library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity RAM_TB is
end RAM_TB;

architecture arch of RAM_TB is
	signal address		: std_logic_vector(DATA_ADDR_WIDTH-1 downto 0);
	signal data_in,
			data_out	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mode			: std_logic_vector(2 downto 0);
	signal wren, clock	: std_logic;

	procedure wait_one_clock_cycle(signal clk : inout std_logic) is
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= not clk;
		wait for 50 ns;
	end procedure wait_one_clock_cycle;

	procedure load_mem(
		signal address		: inout std_logic_vector(15 downto 0);
		signal data			: inout std_logic_vector(31 downto 0); 
		signal wren, clock	: inout std_logic
	) is
	begin
		wren <= '1';
		for i in 0 to 15 loop
			address <= std_logic_vector(to_unsigned(i, 16));
			if i = 0 then
				data <= x"00000069";
			else
				data <= std_logic_vector(to_unsigned(i * 2, 32));
			end if;
			wait_one_clock_cycle(clock);
		end loop;
		wren <= '0';
	end procedure load_mem;
begin
	UUT : entity work.RAM
	port map(
		address		=> address,
		data_in		=> data_in,
		mode		=> mode,
		wren		=> wren,
		clock		=> clock,
		data_out	=> data_out
	);

	STIMULUS : process
	begin
		address		<= (others => '0');
		data_in		<= (others => '0');
		mode		<= (others => '0');
		wren		<= '0';
		clock		<= '0';
		wait_one_clock_cycle(clock);

		-- test byte enabled writing
		data_in <= x"12345678";

		for i in 0 to 3 loop
			for j in 0 to 2 loop
				wren <= '1';
				mode <= std_logic_vector(to_unsigned(j, 3));
				wait_one_clock_cycle(clock);

				wren <= '0';
				wait_one_clock_cycle(clock);
				address <= std_logic_vector(unsigned(address) + 4);
			end loop;
			wait_one_clock_cycle(clock);
			address <= std_logic_vector(unsigned(address) + 1);
			wait_one_clock_cycle(clock);
		end loop;

		-- test memory read
		data_in <= x"DEADFEED";
		address <= (others => '0');
		mode <= "010";
		wren <= '1';
		wait_one_clock_cycle(clock);
		wren <= '0';

		for i in 0 to 3 loop
			for j in 0 to 7 loop
				mode <= std_logic_vector(to_unsigned(j, 3));
				wait_one_clock_cycle(clock);
			end loop;
			address <= std_logic_vector(unsigned(address) + 1);
			wait_one_clock_cycle(clock);
		end loop;

		clock <= '0';
		data_in <= x"DEADBEEF";
	   	address <= x"1000";
		mode <= "010";
		wren <= '1';
		wait for 50 ns;

		clock <= '1';
		wren <= '0';
		wait for 50 ns;

		wait_one_clock_cycle(clock);
		wait;
	end process;
end architecture;
