library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity Memory_TB is
end entity;

architecture arch of Memory_TB is
	signal clock	: std_logic := '1';
	signal reset	: std_logic;

	signal addr_a		: std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal data_in_a	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal wren_a		: std_logic;
	signal mode_a		: std_logic_vector(2 downto 0);
	signal data_out_a	: std_logic_vector(DATA_WIDTH-1 downto 0);

	signal addr_b		: std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal data_in_b	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal wren_b		: std_logic;
	signal mode_b		: std_logic_vector(2 downto 0);
	signal data_out_b	: std_logic_vector(DATA_WIDTH-1 downto 0);
begin
	UUT : entity work.Memory
	port map(
		clock		=> clock,

		addr_a		=> addr_a,
		data_in_a	=> data_in_a,
		wren_a		=> wren_a,
		mode_a		=> mode_a,
		data_out_a	=> data_out_a,

		addr_b		=> addr_b,
		data_in_b	=> data_in_b,
		wren_b		=> wren_b,
		mode_b		=> mode_b,
		data_out_b	=> data_out_b
	);

	CLOCK_PROC : process
	begin
		loop
			clock <= not clock;
			wait for TB_CLK_PD/2;
		end loop;
	end process;

	STIMULUS : process
	begin
	-- port a tests
		addr_a		<= (others => '0');
		data_in_a	<= (others => '0');
		mode_a		<= (others => '0');
		wren_a		<= '0';
		wait for TB_CLK_PD;

		-- test byte enabled writing
		data_in_a <= x"12345678";

		for i in 0 to 3 loop
			for j in 0 to 2 loop
				wren_a <= '1';
				mode_a <= std_logic_vector(to_unsigned(j, 3));
				wait for TB_CLK_PD;

				wren_a <= '0';
				wait for TB_CLK_PD;

				addr_a <= std_logic_vector(unsigned(addr_a) + 4);
			end loop;
			wait for TB_CLK_PD;
			addr_a <= std_logic_vector(unsigned(addr_a) + 1);
			wait for TB_CLK_PD;
		end loop;

		-- test memory read
		data_in_a <= x"DEADFEED";
		addr_a <= (others => '0');
		mode_a <= "010";
		wren_a <= '1';
		wait for TB_CLK_PD;
		wren_a <= '0';
		wait for TB_CLK_PD;

		for i in 0 to 3 loop
			for j in 0 to 7 loop
				mode_a <= std_logic_vector(to_unsigned(j, 3));
				wait for TB_CLK_PD;
			end loop;
			addr_a <= std_logic_vector(unsigned(addr_a) + 1);
			wait for TB_CLK_PD;
		end loop;

	end process;

end architecture;

