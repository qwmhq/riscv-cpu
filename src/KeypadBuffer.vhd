library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeypadBuffer is
port (
	clk			: in std_logic;
	reset		: in std_logic;
	clear		: in std_logic;
	key_pressed	: in std_logic;
	key_value	: in std_logic_vector(3 downto 0);
	buf			: out std_logic_vector(31 downto 0);
	buf_full	: out std_logic
);
end KeypadBuffer;

architecture arch of KeypadBuffer is
	signal buf_reg	: std_logic_vector(31 downto 0);
	signal buf_ptr	: integer range 0 to 7 := 7;
begin
	process(key_pressed, reset, clear)
	begin
		if reset = '1' or clear = '1' then
			buf_reg <= (others => '0');
			buf_ptr <= 7;
			buf_full <= '0';
		elsif falling_edge(key_pressed) then
			if buf_full = '0' then
				buf_reg(buf_ptr * 4 + 3 downto buf_ptr * 4) <= key_value;

				if buf_ptr = 0 then
					buf_full <= '1';
				else
					buf_ptr <= buf_ptr - 1;
				end if;
			end if;
		end if;
	end process;
	buf <= buf_reg;
end architecture;
