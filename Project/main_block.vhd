library ieee;
use ieee.std_logic_1164.all;
use work.pack_my_types.all;

entity main_block is
	generic(
		CHARACTER_COUNT   : natural := 3; --max value is 180 (3 characters) and B4h (3 characters)
		BUFFER_DATA_WIDTH : natural := 8 --max value is 180 (1011 0100) - 8 bit
	);

	port(
		buffer_data     : in  std_logic_vector((BUFFER_DATA_WIDTH - 1) downto 0); --data from buffer
		numeral_system  : in  std_logic; --changing numeric system. data from button controller
		clk             : in  std_logic;
		out_information : out char_array((CHARACTER_COUNT - 1) downto 0)
	);
end main_block;

architecture rtl of main_block is
	signal old_ns : std_logic := '0';
	signal cur_ns : NUM_SYS   := DECIMAL;
begin
	change_num_system : process(clk)
	begin
		if (rising_edge(clk)) then
			if (old_ns = '0') and (numeral_system = '1') then
				case cur_ns is
					when DECIMAL => cur_ns <= HEX;
					when HEX     => cur_ns <= DECIMAL;
				end case;
			end if;
			old_ns <= numeral_system;
		end if;
	end process change_num_system;

	form_char : process(clk)
	begin
		if (rising_edge(clk)) then
			case cur_ns is
				when DECIMAL => out_information <= bin_to_dec_symb(buffer_data);
				when HEX     => out_information <= bin_to_hex_symb(buffer_data);
			end case;
		end if;
	end process form_char;
end rtl;
