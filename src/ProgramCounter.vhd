library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity ProgramCounter is
port(
	pc_next	: in std_logic_vector(PC_WIDTH-1 downto 0);
	wren	: in std_logic;
	clk		: in std_logic;
	reset	: in std_logic;
	pc		: out std_logic_vector(PC_WIDTH-1 downto 0)
);
end ProgramCounter;

architecture arch of ProgramCounter is
begin
	process(clk, reset, wren)
	begin
		if reset = '1' then
			pc <= (others => '0');
		elsif falling_edge(clk) and wren = '1' then
			pc <= pc_next;
		end if;
	end process;
end architecture;