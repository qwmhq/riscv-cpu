library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IPRAM_TB is
end IPRAM_TB;

architecture arch of IPRAM_TB is
	signal address		: std_logic_vector(13 downto 0);
	signal byteena		: std_logic_vector(3 downto 0);
	signal data, q		: std_logic_vector(31 downto 0);
	signal clock, wren	: std_logic;

	procedure wait_one_clock_cycle(signal clk : inout std_logic) is
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= not clk;
		wait for 50 ns;
	end procedure wait_one_clock_cycle;

	procedure load_mem(
		signal address		: inout std_logic_vector(13 downto 0);
		signal byteena		: inout std_logic_vector(3 downto 0);
		signal data			: inout std_logic_vector(31 downto 0); 
		signal wren, clock	: inout std_logic
	) is
	begin
		wren <= '1';
		byteena <= "0001";
		for i in 0 to 15 loop
			address <= std_logic_vector(to_unsigned(i, 14));
			if i = 0 then
				data <= x"00000069";
			else
				data <= std_logic_vector(to_unsigned(i * 2, 32));
			end if;
			wait_one_clock_cycle(clock);
		end loop;
		wren <= '0';
	end procedure load_mem;

	procedure read_mem(
		signal address		: inout std_logic_vector(13 downto 0);
		signal wren, clock	: inout std_logic
	) is
	begin
		wren <= '0';
		for i in 0 to 15 loop
			address <= std_logic_vector(to_unsigned(i, 14));
			wait_one_clock_cycle(clock);
		end loop;
	end procedure read_mem;

begin
	UUT : entity work.IPRAM
	port map (
		address	=> address,
		byteena	=> byteena,
		data	=> data,
		clock	=> clock,
		wren	=> wren,
		q		=> q
	);

	STIMULUS: process
	begin
		-- initialize signals
		address	<= (others => '0');
		clock	<= '0';
		data	<= (others => '0');
		wren	<= '0';

		wait_one_clock_cycle(clock);

		load_mem(address, byteena, data, wren, clock);

		read_mem(address, wren, clock);

		wait;
	end process;
end architecture;
