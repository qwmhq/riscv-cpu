library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity RegisterFile_TB is
end RegisterFile_TB;

architecture arch of RegisterFile_TB is
	signal clk		: std_logic := '1';
	signal reset	: std_logic := '0';

	signal rs1, rs2, rs3, rd	: std_logic_vector(4 downto 0);
	signal data_in, r1, r2, r3	: std_logic_vector(31 downto 0);
	signal wr_en	: std_logic;
begin
	UUT : entity work.RegisterFile
	port map(
		rs1 	=> rs1,
		rs2 	=> rs2,
		rs3 	=> rs3,
		rd 		=> rd,
		data_in	=> data_in,
		r1		=> r1,
		r2		=> r2,
		r3		=> r3,
		wr_en	=> wr_en,
		clk		=> clk,
		reset	=> reset
	);

	clk <= not clk after TB_CLK_PD/2;

	STIMULUS : process
	begin
		wait until rising_edge(clk);

		-- bring uut out of reset
		reset <= '1';

		wait for TB_CLK_PD;

		rs1 	<= "00001";
		rs2 	<= "00010";
		wr_en	<= '1';
		
		for i in 0 to 31 loop
			wait until rising_edge(clk);

			rd <= std_logic_vector(to_unsigned(i, 5));
			if i = 0 then
				data_in <= std_logic_vector(to_unsigned(69, 32));
			else
				data_in <= std_logic_vector(to_unsigned(i * 2, 32));
			end if;

			wait until falling_edge(clk);
		end loop;
			
		wr_en	<= '0';

		for i in 0 to 31 loop
			rs1 <= std_logic_vector(to_unsigned(i, 5));
			rs2 <= std_logic_vector(to_unsigned(31 - i, 5));
			wait for TB_CLK_PD;
		end loop;

		reset <= '0';
		wait for TB_CLK_PD;
		reset <= '1';

		for i in 0 to 7 loop
			rs1 <= std_logic_vector(to_unsigned(i * 4, 5));
			rs2 <= std_logic_vector(to_unsigned(31 - (i * 4), 5));
			wait for TB_CLK_PD;
		end loop;
		wait;
	end process;

end architecture;
