library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeypadDecoder is
generic(clockfreq_hz : integer);
port (
	clk		: in std_logic;
	reset	: in std_logic;
	row		: in std_logic_vector(3 downto 0);

	col				: out std_logic_vector(3 downto 0);
	hex_value		: out std_logic_vector(3 downto 0);
	keypad_pressed	: out std_logic
);
end KeypadDecoder;

architecture arch of KeypadDecoder is
	type state_type is (IDLE, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17);
	signal state : state_type;
	signal keypad_pressed_int : std_logic;
begin
	process(clk, reset)
	begin
		if reset = '1' then
			state <= s1;
			col <= "1111";
			-- hex_value <= "0000";
			keypad_pressed_int <= '0';
		elsif rising_edge(clk) then
			case state is
				when IDLE =>
					keypad_pressed_int <= '0';
					col <= "1111";
					state <= s1;
				when s1 =>
					if row /= "0000" then
						col <= "1000";
					else 
						col <= "1111";
					end if;

					if row(0) = '1' then
						state <= s2;
					elsif row(1) = '1' then
						state <= s6;
					elsif row(2) = '1' then
						state <= s10;
					elsif row(3) = '1' then
						state <= s14;
					else
						state <= s1;
					end if;
				when s2 =>
					if row(0) = '1' then
						hex_value <= x"0";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "0100";
						state <= s3;
					end if;
				when s3 =>
					if row(0) = '1' then
						hex_value <= x"1";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "0010";
						state <= s4;
					end if;
				when s4 =>
					if row(0) = '1' then
						hex_value <= x"2";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "0001";
						state <= s5;
					end if;
				when s5 =>
					if row(0) = '1' then
						hex_value <= x"3";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "1000";
						state <= s6;
					end if;
				when s6 =>
					if row(1) = '1' then
						hex_value <= x"4";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "0100";
						state <= s7;
					end if;
				when s7 =>
					if row(1) = '1' then
						hex_value <= x"5";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "0010";
						state <= s8;
					end if;
				when s8 =>
					if row(1) = '1' then
						hex_value <= x"6";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "0001";
						state <= s9;
					end if;
				when s9 =>
					if row(1) = '1' then
						hex_value <= x"7";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "1000";
						state <= s10;
					end if;
				when s10 =>
					if row(2) = '1' then
						hex_value <= x"8";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "0100";
						state <= s11;
					end if;
				when s11 =>
					if row(2) = '1' then
						hex_value <= x"9";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "0010";
						state <= s12;
					end if;
				when s12 =>
					if row(2) = '1' then
						hex_value <= x"a";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "0001";
						state <= s13;
					end if;
				when s13 =>
					if row(2) = '1' then
						hex_value <= x"b";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "1000";
						state <= s14;
					end if;
				when s14 =>
					if row(3) = '1' then
						hex_value <= x"c";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "0100";
						state <= s15;
					end if;
				when s15 =>
					if row(3) = '1' then
						hex_value <= x"d";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "0010";
						state <= s16;
					end if;
				when s16 =>
					if row(3) = '1' then
						hex_value <= x"e";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						col <= "0001";
						state <= s17;
					end if;
				when s17 =>
					if row(3) = '1' then
						hex_value <= x"f";
						keypad_pressed_int <= '1';
						state <= IDLE;
					else
						state <= IDLE;
					end if;
				when others => null;
			end case;
		end if;
	end process;

	DBOUNCE : entity work.Debouncer
	generic map(clockfreq_hz => clockfreq_hz)
	port map(
		clk		=> clk,
		reset	=> reset,
		input	=> keypad_pressed_int,
		output	=> keypad_pressed
	);

end architecture;
