library ieee;
use ieee.std_logic_1164.all;

entity ByteEnableEncoder is
port(
	low_addr		: in std_logic_vector(1 downto 0);	-- lowest 2 bits of the address
	wr_mode		: in std_logic_vector(1 downto 0);	-- "00" for byte, "01" for half-word, "10" for word
	byteena	: out std_logic_vector(3 downto 0)
);
end ByteEnableEncoder;

architecture arch of ByteEnableEncoder is
begin
	byteena <= "1111" when low_addr = "00" and wr_mode = "10" else
				"1100" when low_addr = "00" and wr_mode = "01" else
				"1000" when low_addr = "00" and wr_mode = "00" else
				"0100" when low_addr = "01" and wr_mode = "00" else
				"0011" when low_addr = "10" and wr_mode = "01" else
				"0010" when low_addr = "10" and wr_mode = "00" else
				"0001" when low_addr = "11" and wr_mode = "00" else
				"0000";
end architecture;
