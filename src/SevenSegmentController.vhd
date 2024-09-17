library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SevenSegmentController is
port (
	clk		: in std_logic;
	reset	: in std_logic;
	data_in	: in std_logic_vector(15 downto 0);
	seg		: out std_logic_vector(6 downto 0);
	anode	: out std_logic_vector(3 downto 0)
);
end SevenSegmentController ;

architecture arch of SevenSegmentController is

	signal clk_div		: std_logic := '0'; -- clock divider signal
	signal digit_select	: unsigned(1 downto 0);
	signal counter		: integer := 0; -- counter for clock division

	-- 7-segment encoding lookup table (abcdefg)
	function hex_to_7seg(hex : std_logic_vector(3 downto 0)) return std_logic_vector is
	begin
		case hex is
			when "0000" => return "0111111"; -- 0
			when "0001" => return "0000110"; -- 1
			when "0010" => return "1011011"; -- 2
			when "0011" => return "1001111"; -- 3
			when "0100" => return "1100110"; -- 4
			when "0101" => return "1101101"; -- 5
			when "0110" => return "1111101"; -- 6
			when "0111" => return "0000111"; -- 7
			when "1000" => return "1111111"; -- 8
			when "1001" => return "1101111"; -- 9
			when "1010" => return "1110111"; -- A
			when "1011" => return "1111100"; -- b
			when "1100" => return "0111001"; -- C
			when "1101" => return "1011110"; -- d
			when "1110" => return "1111001"; -- E
			when "1111" => return "1110001"; -- F
			when others => return "0000000"; -- Blank
		end case;
	end function;

begin

	/*
    -- clock divider (for multiplexing speed control)
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = 50000 then -- adjust for desired multiplexing speed
                counter <= 0;
                clk_div <= not clk_div;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
	*/

	clk_div <= clk;

    -- digit multiplexing control
    process(clk_div, reset)
    begin
        if reset = '1' then
            digit_select <= "00";
        elsif rising_edge(clk_div) then
            digit_select <= digit_select + 1;
        end if;
    end process;

    -- Select the appropriate digit and segment encoding
    process(digit_select, data_in)
    begin
        case digit_select is
            when "00" =>
                anode <= "1110";
                seg <= hex_to_7seg(data_in(3 downto 0));
            when "01" =>
                anode <= "1101";
                seg <= hex_to_7seg(data_in(7 downto 4));
            when "10" =>
                anode <= "1011";
                seg <= hex_to_7seg(data_in(11 downto 8));
            when "11" =>
                anode <= "0111";
                seg <= hex_to_7seg(data_in(15 downto 12));
            when others =>
                anode <= "1111";
                seg <= "0000000";
        end case;
    end process;

end architecture;
