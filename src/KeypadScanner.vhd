library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeypadScanner is
generic(clockenfreqhz	: integer);
port(
	clock		: in std_logic;
	clock_en	: in std_logic;
	reset		: in std_logic;
	row		: in std_logic_vector(3 downto 0);
	col		: out std_logic_vector(3 downto 0);
	keyval	: out std_logic_vector(3 downto 0);
	keyup		: out std_logic
);
end KeypadScanner;

architecture arch of KeypadScanner is
	constant dbnce_ctr_max	: integer := clockenfreqhz * 20 / 1000;
	signal dbnce_ctr	: integer range 0 to dbnce_ctr_max;
	signal row_idx		: integer range 0 to 3;
	signal col_idx		: integer range 0 to 3;

	type state_t is (idle, debounce, scan_rows, scan_cols_0, scan_cols_1, wait_keyup, output);
	signal current_state	: state_t;
begin
	process(clock, reset)
	begin
		if reset = '0' then
			current_state <= idle;
			dbnce_ctr <= 0;
			row_idx <= 0;
			col_idx <= 0;
			keyup <= '0';
		elsif rising_edge(clock) then
			if clock_en = '1' then
				case current_state is
					when idle =>
						dbnce_ctr <= 0;
						row_idx <= 0;
						col_idx <= 0;

						col <= "0000";
						keyup <= '0';

						if row /= "1111" then
							current_state <= debounce;
						else
							current_state <= idle;
						end if;
					when debounce =>
						if row /= "1111" then
							if dbnce_ctr < dbnce_ctr_max then
								dbnce_ctr <= dbnce_ctr + 1;
								current_state <= debounce;
							else
								current_state <= scan_rows;
							end if;
						else
							current_state <= idle;
						end if;
					when scan_rows =>
						if row /= "1111" then
							for i in 0 to 3 loop
								if row(i) = '0' then
									row_idx <= i;
								end if;
							end loop;
							current_state <= scan_cols_0;
							col_idx <= 0;
						else
							current_state <= idle;
						end if;
					when scan_cols_0 =>
						col <= (others => '1');
						col(col_idx) <= '0';
						current_state <= scan_cols_1;
					when scan_cols_1 =>
						if row(row_idx) = '0' then
							current_state <= wait_keyup;
							keyval <= std_logic_vector(to_unsigned(row_idx * 4 + col_idx, keyval'length));
						else
							if col_idx < 3 then
								col_idx <= col_idx + 1;
								current_state <= scan_cols_0;
							else
								current_state <= idle;
							end if;
						end if;
					when wait_keyup =>
						if row /= "1111" then
							current_state <= wait_keyup;
						else
							current_state <= output;
						end if;
					when output =>
						keyup <= '1';
						current_state <= idle;
				end case;	
			end if;	
		end if;
	end process;
	
end architecture;
