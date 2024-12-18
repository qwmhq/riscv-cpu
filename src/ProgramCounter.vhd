library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity ProgramCounter is
port(
	reset	: in std_logic;
	clk		: in std_logic;
	clken	: in std_logic;
	pc_next	: in std_logic_vector(PC_WIDTH-1 downto 0);
	wren	: in std_logic;
	pc		: out std_logic_vector(PC_WIDTH-1 downto 0)
);
end ProgramCounter;

architecture arch of ProgramCounter is
begin
	process(clk, reset)
	begin
		if reset = '0' then
			pc <= (others => '0');
		elsif rising_edge(clk) then
			if clken = '1' and wren = '1' then
				pc <= pc_next;
			end if;
		end if;
	end process;
end architecture;
