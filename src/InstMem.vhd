library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity InstMem is
port(
	wr_address,
	rd_address	: in std_logic_vector(INST_ADDR_WIDTH-1 downto 0);
	data_in		: in std_logic_vector(INST_WIDTH-1 downto 0);
	clock		: in std_logic;
	wren		: in std_logic;
	data_out	: out std_logic_vector(INST_WIDTH-1 downto 0)
);
end InstMem;

architecture arch of InstMem is
	signal ipram2_wr_addr,
			ipram2_rd_addr	: std_logic_vector(INST_ADDR_WIDTH-1 downto 2);
begin
	ipram2_wr_addr <= wr_address(INST_ADDR_WIDTH-1 downto 2);
	ipram2_rd_addr <= rd_address(INST_ADDR_WIDTH-1 downto 2);
	RAM_1 : entity work.IPRAM2
	port map(
		wraddress 	=> ipram2_wr_addr,
		rdaddress 	=> ipram2_rd_addr,
		data		=> data_in,
		clock		=> clock,
		wren		=> wren,
		q			=> data_out
	);
end architecture;
