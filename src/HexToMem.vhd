library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity hex_to_mem is
port (
	clk 	: in std_logic;
	reset 	: in std_logic;

	hex_value			: in std_logic_vector(3 downto 0);
	keypad_pressed		: in std_logic;
	mem_write_enable	: in std_logic;

	address		: out std_logic_vector(15 downto 0);
	data_out	: out std_logic_vector(31 downto 0);
	mem_write	: out std_logic
);
end hex_to_mem;

architecture arch of hex_to_mem is
    signal buffer : std_logic_vector(31 downto 0) := (others => '0');
    signal buffer_index : integer range 0 to 7 := 0;
    signal current_address : std_logic_vector(15 downto 0) := (others => '0');

begin
	process(clk, reset)
	begin
		if reset = '1' then
			buffer <= (others => '0');
			buffer_index <= 0;
			current_address <= (others => '0');
			mem_write <= '0';
			data_out <= (others => '0');
		elsif rising_edge(clk) then
			if keypad_valid = '1' then
				buffer(buffer_index*4+3 downto buffer_index*4) <= hex_value;
				buffer_index <= buffer_index + 1;
				
				if buffer_index = 7 then  -- A full 32-bit word is complete
					data_out <= buffer;
					mem_write <= '1';
					current_address <= current_address + 1;
					buffer_index <= 0;
				else
					mem_write <= '0';
				end if;
			elsif mem_write_enable = '1' then
				address <= current_address;
				mem_write <= '1';
			else
				mem_write <= '0';
			end if;
		end if;
	end process;
end architecture;

