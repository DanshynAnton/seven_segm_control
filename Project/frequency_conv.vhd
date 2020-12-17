library ieee;
use ieee.std_logic_1164.all;

entity frequency_conv is
	generic(
		FREQ_IN   : natural := 50_000_000; --50MHz
		FREQ_BUF  : natural := 1_000_000; --1MHz
		FREQ_BTN  : natural := 1_000_000; --1MHz
		FREQ_MAIN : natural := 1_000_000; --1MHz
		FREQ_IND  : natural := 1_000_000; --1MHz
		FREQ_SPI  : natural := 1_000_000 --1MHz
	);
	port(
		clk_in         : in  std_logic; --input clk from generator
		clk_buffer     : out std_logic; --clk signal for buffer block (my_buffer)
		clk_button     : out std_logic; --clk signal for button controller (button_controller)
		clk_main       : out std_logic; --clk signal for main block (main_block)
		clk_indication : out std_logic; --clk signal for indication controller (indication_controller)
		clk_spi        : out std_logic  --clk signal for SPI (spi_controller)
	);
end frequency_conv;

architecture rtl of frequency_conv is
	component freq_manager is
		generic(
			FREQ_IN  : natural := 50_000_000;
			FREQ_OUT : natural := 1_000_000
		);

		port(
			clk_in  : in  std_logic;
			clk_out : out std_logic
		);

	end component freq_manager;
begin
	buf_freq : freq_manager
		generic map(FREQ_IN => FREQ_IN, FREQ_OUT => FREQ_BUF)
		port map(
			clk_in  => clk_in,
			clk_out => clk_buffer
		);
	btn_freq : freq_manager
		generic map(FREQ_IN => FREQ_IN, FREQ_OUT => FREQ_BTN)
		port map(
			clk_in  => clk_in,
			clk_out => clk_button
		);
	main_freq : freq_manager
		generic map(FREQ_IN => FREQ_IN, FREQ_OUT => FREQ_MAIN)
		port map(
			clk_in  => clk_in,
			clk_out => clk_main
		);
	ind_freq : freq_manager
		generic map(FREQ_IN => FREQ_IN, FREQ_OUT => FREQ_IND)
		port map(
			clk_in  => clk_in,
			clk_out => clk_indication
		);
	spi_freq : freq_manager
		generic map(FREQ_IN => FREQ_IN, FREQ_OUT => FREQ_SPI)
		port map(
			clk_in  => clk_in,
			clk_out => clk_spi
		);
end rtl;
