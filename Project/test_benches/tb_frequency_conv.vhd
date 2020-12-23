library ieee;
use ieee.std_logic_1164.all;

entity tb_frequency_conv is
end entity;

architecture rtl of tb_frequency_conv is
	component frequency_conv is
		generic(
			FREQ_IN   : natural := 50_000_000; --50MHz
			FREQ_BUF  : natural := 100_000; --1MHz
			FREQ_BTN  : natural := 100_000; --1MHz
			FREQ_MAIN : natural := 100_000; --1MHz
			FREQ_IND  : natural := 100_000; --1MHz
			FREQ_SPI  : natural := 100_000 * (3 * 24 + 2) --1MHz
		);
		port(
			clk_in         : in  std_logic; --input clk from generator
			clk_buffer     : out std_logic; --clk signal for buffer block (my_buffer)
			clk_button     : out std_logic; --clk signal for button controller (button_controller)
			clk_main       : out std_logic; --clk signal for main block (main_block)
			clk_indication : out std_logic; --clk signal for indication controller (indication_controller)
			clk_spi        : out std_logic --clk signal for SPI (spi_controller)
		);
	end component;

	signal clk_in         : std_logic := '0';
	signal clk_buffer     : std_logic;
	signal clk_button     : std_logic;
	signal clk_main       : std_logic;
	signal clk_indication : std_logic;
	signal clk_spi        : std_logic;
begin
	lable_lab : frequency_conv
		port map(clk_in         => clk_in,
		         clk_buffer     => clk_buffer,
		         clk_button     => clk_button,
		         clk_main       => clk_main,
		         clk_indication => clk_indication,
		         clk_spi        => clk_spi);

	gen_clk : process
	begin
		clk_in <= '1';
		wait for 10 ns;
		clk_in <= '0';
		wait for 10 ns;
	end process;

end rtl;
