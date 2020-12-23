library ieee;
use ieee.std_logic_1164.all;
use work.pack_my_types.all;

entity seven_segm_ctrl is
	generic(
		TOP_LEVEL_CHARACTER_COUNT   : natural := 3; --max value is 180 (3 characters) and B4h (3 characters)
		TOP_LEVEL_BUFFER_DATA_WIDTH : natural := 8 --max value is 180 (1011 0100) - 8 bit
	);

	port(
		input_data : in  std_logic_vector((TOP_LEVEL_BUFFER_DATA_WIDTH - 1) downto 0);
		data_exist : in  std_logic;
		button     : in  std_logic;
		clk        : in  std_logic;
		sreset     : in  std_logic;
		spi_mosi   : out std_logic;
		spi_sck    : out std_logic;
		spi_ss     : out std_logic
	);
end seven_segm_ctrl;

architecture rtl of seven_segm_ctrl is

	component button_ctrl is
		port(
			button_in  : in  std_logic;
			button_clk : in  std_logic;
			button_out : out std_logic
		);
	end component button_ctrl;

	-----------------------------------------------------------------------------

	component frequency_conv is
		generic(
			FREQ_IN   : natural := 50_000_000; --50MHz
			FREQ_BUF  : natural := 10_000; --10KHz
			FREQ_BTN  : natural := 100_000; --100KHz
			FREQ_MAIN : natural := 10_000; --10KHz
			FREQ_IND  : natural := 10_000; --10KHz
			FREQ_SPI  : natural := 10_000_000 --10MHz
		);
		port(
			clk_in         : in  std_logic; --input clk from generator
			clk_buffer     : out std_logic; --clk signal for buffer block (my_buffer)
			clk_button     : out std_logic; --clk signal for button controller (button_controller)
			clk_main       : out std_logic; --clk signal for main block (main_block)
			clk_indication : out std_logic; --clk signal for indication controller (indication_controller)
			clk_spi        : out std_logic --clk signal for SPI (spi_controller)
		);
	end component frequency_conv;

	-----------------------------------------------------------------------------

	component my_buffer is
		generic(
			BUFFER_DATA_WIDTH : natural := TOP_LEVEL_BUFFER_DATA_WIDTH
		);

		port(
			data_in  : in  std_logic_vector((BUFFER_DATA_WIDTH - 1) downto 0); --input data
			data_en  : in  std_logic;   --Signal of available data
			clk      : in  std_logic;
			srst     : in  std_logic;   -- synchronous reset;
			data_out : out std_logic_vector((BUFFER_DATA_WIDTH - 1) downto 0) --output data
		);

	end component my_buffer;

	-----------------------------------------------------------------------------

	component main_block is
		generic(
			CHARACTER_COUNT   : natural := TOP_LEVEL_CHARACTER_COUNT;
			BUFFER_DATA_WIDTH : natural := TOP_LEVEL_BUFFER_DATA_WIDTH
		);

		port(
			buffer_data     : in  std_logic_vector((BUFFER_DATA_WIDTH - 1) downto 0); --data from buffer
			numeral_system  : in  std_logic; --changing numeric system. data from button controller
			clk             : in  std_logic;
			out_information : out char_array((CHARACTER_COUNT - 1) downto 0)
		);
	end component main_block;

	-----------------------------------------------------------------------------

	component indication_ctrl is
		generic(
			CHARACTER_COUNT : natural := TOP_LEVEL_CHARACTER_COUNT
		);

		port(
			characters   : in  char_array((CHARACTER_COUNT - 1) downto 0); --array of characters from main block (main_block)
			clk          : in  std_logic;
			ready        : in  std_logic := '1'; --signal from SPI that means, that SPI can take new data
			bite_for_spi : out std_logic_vector((CHARACTER_COUNT * 8 - 1) downto 0); --for every character there is an indicator. Each indicator have 8 segments (7 + dot)
			start        : out std_logic --signal to SPI that new data is ready
		);
	end component indication_ctrl;

	-----------------------------------------------------------------------------

	component spi_ctrl is
		generic(
			CHARACTER_COUNT : natural := TOP_LEVEL_CHARACTER_COUNT
		);

		port(
			start       : in  std_logic;
			spi_in_date : in  std_logic_vector((CHARACTER_COUNT * 8 - 1) downto 0); --array of characters from main block (main_block)
			clk         : in  std_logic;
			mosi        : out std_logic;
			sck         : out std_logic;
			ss          : out std_logic;
			ready       : out std_logic := '0'
		);
	end component spi_ctrl;

	-----------------------------------------------------------------------------

	signal buffer_main : std_logic_vector((TOP_LEVEL_BUFFER_DATA_WIDTH - 1) downto 0);
	signal btn_main    : std_logic;
	signal freq_buffer : std_logic;
	signal freq_btn    : std_logic;
	signal freq_main   : std_logic;
	signal freq_indc   : std_logic;
	signal freq_spi    : std_logic;
	signal main_indc   : char_array((TOP_LEVEL_CHARACTER_COUNT - 1) downto 0);
	signal indc_spi    : std_logic_vector((TOP_LEVEL_CHARACTER_COUNT * 8 - 1) downto 0);
	signal start_sign  : std_logic;
	signal ready_sign  : std_logic;

begin
	pm_btn_ctrl : button_ctrl port map(button_in => button, button_clk => freq_btn, button_out => btn_main);
	pm_freq_conv : frequency_conv port map(clk_in => clk, clk_buffer => freq_buffer, clk_button => freq_btn, clk_main => freq_main, clk_indication => freq_indc, clk_spi => freq_spi);
	pm_buffer : my_buffer port map(data_in => input_data, data_en => data_exist, clk => freq_buffer, srst => sreset, data_out => buffer_main);
	pm_main : main_block port map(buffer_data => buffer_main, numeral_system => btn_main, clk => freq_main, out_information => main_indc);
	pm_indc : indication_ctrl port map(characters => main_indc, clk => freq_indc, ready => ready_sign, bite_for_spi => indc_spi, start => start_sign);
	pm_spi : spi_ctrl port map(start => start_sign, spi_in_date => indc_spi, clk => freq_spi, mosi => spi_mosi, sck => spi_sck, ss => spi_ss, ready => ready_sign);
end rtl;
