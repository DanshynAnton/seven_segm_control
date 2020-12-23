library ieee;
use ieee.std_logic_1164.all;
use work.pack_my_types.all;

entity tb_main_block is
generic
(
			DATA_WIDTH : natural := 8; --max value is 180 (1011 0100) - 8 bit
			CHARACTER_COUNT : natural := 3
);
end tb_main_block;
architecture rtl of tb_main_block is
	component main_block is
		generic(
			CHARACTER_COUNT   : natural := 3; --max value is 180 (3 characters) and B4h (3 characters)
			BUFFER_DATA_WIDTH : natural := 8 --max value is 180 (1011 0100) - 8 bit
		);

		port(
			buffer_data     : in  std_logic_vector((DATA_WIDTH - 1) downto 0); --data from buffer
			numeral_system  : in  std_logic; --changing numeric system. data from button controller
			clk             : in  std_logic;
			out_information : out char_array((CHARACTER_COUNT - 1) downto 0)
		);
	end component;

	signal buffer_data     : std_logic_vector((DATA_WIDTH - 1) downto 0); --data from buffer
	signal numeral_system  : std_logic := '0'; --changing numeric system. data from button controller
	signal clk             : std_logic;
	signal out_information : char_array((CHARACTER_COUNT - 1) downto 0);
begin
	lalbe_lab : main_block
		port map(buffer_data     => buffer_data,
		         numeral_system  => numeral_system,
		         clk             => clk,
		         out_information => out_information
		        );
	gen_clk : process
	begin
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
	end process gen_clk;

	gen_input_data : process
	begin
		buffer_data    <= "00000000";
		wait for 20 ns;
		buffer_data    <= "10001011";
		wait for 20 ns;
		buffer_data    <= "10110100";
		wait for 20 ns;
		numeral_system <= '1';
		wait for 20 ns;
		numeral_system <= '0';
		wait for 20 ns;
	end process gen_input_data;

end rtl;
