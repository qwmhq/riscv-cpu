library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity multiplier_tb is
end entity;

architecture arch of multiplier_tb is
	signal clock	: std_logic := '1';
	signal x			: std_logic_vector(32 downto 0);
	signal y			: std_logic_vector(32 downto 0);
	signal result	: std_logic_vector(65 downto 0);
begin
	UUT : entity work.multiplier
	port map(
		clock		=> clock,
		dataa		=> x,
		datab		=> y,
		result	=> result
	);
	
	STIMULUS : process
	begin
		wait until rising_edge(clock);
	
		x	<= std_logic_vector(to_signed(-4, 33));
		y	<= std_logic_vector(to_signed(-5, 33));
		wait for tb_clk_pd *3;

		x	<= std_logic_vector(to_signed(10, 33));
		y	<= std_logic_vector(to_signed(-5, 33));
		wait for tb_clk_pd *3;
		
		wait for tb_clk_pd * 4;
	end process;
	
	clock <= not clock after tb_clk_pd/2;
end architecture;