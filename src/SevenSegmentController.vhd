library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SevenSegmentController is
port (
	clk_50	: in std_logic;
	reset	: in std_logic;
	data_in	: in std_logic_vector(31 downto 0);
	seg		: out std_logic_vector(6 downto 0);
	anode	: out std_logic_vector(7 downto 0)
);
end SevenSegmentController ;

architecture arch of SevenSegmentController is

	signal clken		: std_logic := '0';
	signal digit_select	: unsigned(2 downto 0);

	constant clk_div_factor	: integer := 50000;
	signal counter		: integer range 0 to clk_div_factor-1:= 0;

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
    -- clock enable signal generation
    process(clk_50, reset)
    begin
	if reset = '0' then
	    counter <= 0;
	    clken <= '0';
        elsif rising_edge(clk_50) then
            if counter = clk_div_factor-1 then
                counter <= 0;
                clken <= '1';
            else
                counter <= counter + 1;
		clken <= '0';
            end if;
        end if;
    end process;

    -- digit multiplexing control
    process(clk_50, reset)
    begin
        if reset = '0' then
            digit_select <= "000";
        elsif rising_edge(clk_50) then
	    if clken = '1' then
		digit_select <= digit_select + 1;
	    end if;
        end if;
    end process;

    -- Select the appropriate digit and segment encoding
    process(digit_select, data_in)
    begin
        case digit_select is
            when "000" =>
                anode <= "11111110";
                seg <= hex_to_7seg(data_in(3 downto 0));
            when "001" =>
                anode <= "11111101";
                seg <= hex_to_7seg(data_in(7 downto 4));
            when "010" =>
                anode <= "11111011";
                seg <= hex_to_7seg(data_in(11 downto 8));
            when "011" =>
                anode <= "11110111";
                seg <= hex_to_7seg(data_in(15 downto 12));
            when "100" =>
                anode <= "11101111";
                seg <= hex_to_7seg(data_in(19 downto 16));
            when "101" =>
                anode <= "11011111";
                seg <= hex_to_7seg(data_in(23 downto 20));
            when "110" =>
                anode <= "10111111";
                seg <= hex_to_7seg(data_in(27 downto 24));
            when "111" =>
                anode <= "01111111";
                seg <= hex_to_7seg(data_in(31 downto 28));
            when others =>
                anode <= "11111111";
                seg <= "0000000";
        end case;
    end process;

end architecture;
