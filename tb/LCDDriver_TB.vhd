library ieee;
use ieee.std_logic_1164.all;
use work.common_pkg.all;

entity LCDDriver_TB is
end entity;

architecture arch of LCDDriver_TB is
	signal clock	: std_logic := '1';
	signal reset	: std_logic := '0';

	signal lcd_chars	: character_string(0 to 31);
	signal lcd_e	: std_logic;
	signal lcd_rs	: std_logic;
	signal lcd_dbus	: std_logic_vector(3 downto 0);
begin
	clock <= not clock after TB_CLK_PD/2;

	UUT : entity work.LCDDriver
	port map
	(
		clock	=> clock,
		reset	=> reset,

		chars	=> lcd_chars,
		e		=> lcd_e,
		rs		=> lcd_rs,
		dbus	=> lcd_dbus
	);

	lcd_chars <= (
		x"42", x"6c", x"75", x"65", x"74", x"6f", x"6f", x"74",
		x"68", x"20", x"6c", x"69", x"6e", x"6b", x"20", x"20",
		x"64", x"69", x"73", x"63", x"6f", x"6e", x"6e", x"65",
		x"63", x"74", x"65", x"64", x"20", x"20", x"20", x"20"
	);

	STIMULUS : process
	begin
		wait for TB_CLK_PD;

		-- take uut out of reset
		reset <= '1';
		wait for TB_CLK_PD;
	end process;

end architecture;
