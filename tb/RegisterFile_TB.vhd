library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

entity RegisterFile_TB is
end RegisterFile_TB;

architecture arch of RegisterFile_TB is
	signal rs1, rs2, rs3, rd	: std_logic_vector(4 downto 0);
	signal data_in, r1, r2, r3	: std_logic_vector(31 downto 0);
	signal wr_en, clk, reset	: std_logic;
begin
	UUT : entity work.RegisterFile
	port map(
		rs1 	=> rs1,
		rs2 	=> rs2,
--		rs3 	=> rs3,
		rd 		=> rd,
		data_in	=> data_in,
		r1		=> r1,
		r2		=> r2,
--		r3		=> r3,
		wr_en	=> wr_en,
		clk		=> clk,
		reset	=> reset
	);

	STIMULUS : process
	begin
		rs1 	<= "00001";
		rs2 	<= "00010";
		wr_en	<= '1';
		
		for i in 0 to 31 loop
			rd <= std_logic_vector(to_unsigned(i, 5));
			if i = 0 then
				data_in <= std_logic_vector(to_unsigned(69, 32));
			else
				data_in <= std_logic_vector(to_unsigned(i * 2, 32));
			end if;
			wait_one_clock_cycle_1_0(clk, 10 ns);
		end loop;
			
		wr_en	<= '0';

		for i in 0 to 31 loop
			rs1 <= std_logic_vector(to_unsigned(i, 5));
			rs2 <= std_logic_vector(to_unsigned(31 - i, 5));
			wait_one_clock_cycle_1_0(clk, 10 ns);
		end loop;

		reset <= '1';
		wait_one_clock_cycle_1_0(clk, 10 ns);
		reset <= '0';

		for i in 0 to 7 loop
			rs1 <= std_logic_vector(to_unsigned(i * 4, 5));
			rs2 <= std_logic_vector(to_unsigned(31 - (i * 4), 5));
			wait_one_clock_cycle_1_0(clk, 10 ns);
		end loop;
		wait;
	end process;

end architecture;