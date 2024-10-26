library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity LCDDriver is
port(
	clock	: in std_logic;
	reset	: in std_logic;

	chars	: in character_string(0 to 31);

	e		: out std_logic;
	rs		: out std_logic;
	dbus	: out std_logic_vector(3 downto 0)
);
end entity;

architecture arch of LCDDriver is
	type state_t is (
		reset0, reset1, reset2,
		func_set0, func_set1,
		display_on, display_off, display_clear,
		entrymode_set, char_write,
		goto_line2, return_home
	);
	signal current_state	: state_t;

	-- clock division and enables
	constant clockdiv_factor	: integer := 50_000_000 / 400;
	-- constant clockdiv_factor	: integer := 4;
	signal counter		: integer range 0 to clockdiv_factor-1;
	signal clken	: std_logic;
	signal slow_clk	: std_logic;

	signal lcd_data8	: std_logic_vector(7 downto 0);
	signal lcd_data4	: std_logic_vector(3 downto 0);
	signal state_ctr	: integer range 0 to 63;

	signal current_line	: integer range 1 to 2;
	signal current_char	: integer range 0 to 31;
begin
	
	-- clock enable generation
	process(clock, reset)
	begin
		if (reset = '0') then
			counter <= 0;
			clken <= '0';
			slow_clk <= '0';
		elsif rising_edge(clock) then
			if counter = clockdiv_factor-1 then
				counter <= 0;
				clken <= '1';
			else
				counter	<= counter + 1;
				clken <= '0';
			end if;

			if counter = 0 then
				slow_clk <= '1';
			elsif counter = (clockdiv_factor/2) then
				slow_clk <= '0';
			end if;
		end if;
	end process;

	-- state machine
	process(clock, reset)
	begin
		if reset = '0' then
			current_state <= reset0;
			state_ctr <= 0;
			current_line <= 1;
		elsif rising_edge(clock) then
			if clken = '1' then
				state_ctr <= state_ctr + 1;
				case current_state is
					when reset0 =>
						current_state <= reset1;
						state_ctr <= 0;
					when reset1 =>
						current_state <= reset2;
						state_ctr <= 0;
					when reset2 =>
						current_state <= func_set0;
						state_ctr <= 0;
					when func_set0 =>
						current_state <= func_set1;
						state_ctr <= 0;
					when func_set1 =>
						if state_ctr = 1 then
							current_state <= display_off;
							state_ctr <= 0;
						end if;
					when display_off =>
						if state_ctr = 1 then
							current_state <= display_clear;
							state_ctr <= 0;
						end if;					
					when display_clear =>
						if state_ctr = 1 then
							current_state <= display_on;
							state_ctr <= 0;
						end if;
					when display_on =>
						if state_ctr = 1 then
							current_state <= entrymode_set;
							state_ctr <= 0;
						end if;
					when entrymode_set =>
						if state_ctr = 1 then
							current_state <= char_write;
							state_ctr <= 0;
						end if;
					when char_write =>
						if state_ctr = 31 and current_line = 1 then
							current_state <= goto_line2;
							state_ctr <= 0;
						elsif state_ctr = 31 and current_line = 2 then
							current_state <= return_home;
							state_ctr <= 0;
						end if;
					when goto_line2 =>
						if state_ctr = 1 then
							current_state <= char_write;
							state_ctr <= 0;
						end if;
					when return_home =>
						if state_ctr = 1 then
							current_state <= char_write;
							state_ctr <= 0;
						end if;
				end case;
				
				if current_state = goto_line2 then
					current_line <= 2;
				elsif current_state = return_home then
					current_line <= 1;
				end if;
			end if;
		end if;
	end process;

	with current_state select
		rs <= '1' when char_write,
			  '0' when others;

	current_char <= (state_ctr/2) + (current_line-1) * 16;
	with current_state select
		lcd_data8 <= "0011XXXX" when reset0 | reset1 | reset2,
					 "0010XXXX" when func_set0,
					 "001010XX" when func_set1,
					 "00001000" when display_off,
					 "00000001" when display_clear,
					 "00001100" when display_on,
					 "00000110" when entrymode_set,
					 "11000000" when goto_line2,
					 "0000001X" when return_home,
					 chars(current_char) when char_write,
					 (others => 'X') when others;
	
	lcd_data4 <= lcd_data8(7 downto 4) when (state_ctr mod 2) = 0 else
				 lcd_data8(3 downto 0);

	e <= slow_clk;
	dbus <= lcd_data4;
end architecture;
