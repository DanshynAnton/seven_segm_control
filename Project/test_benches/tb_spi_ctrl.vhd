library ieee;
use ieee.std_logic_1164.all;

entity tb_spi_ctrl is
	generic(
		CH_COUNT : natural := 3  --max value is 180 (3 characters) and B4h (3 characters)
	);
end tb_spi_ctrl;
architecture rtl of tb_spi_ctrl is
	component spi_ctrl
		generic(
			CHARACTER_COUNT : natural := CH_COUNT --max value is 180 (3 characters) and B4h (3 characters)
		);
		port(
			start       : in  std_logic; --Signal to start indicate new value
			spi_in_date : in  std_logic_vector((CHARACTER_COUNT * 8 - 1) downto 0); --array of characters from main block (main_block)
			clk         : in  std_logic;
			mosi        : out std_logic; --master out slave in
			sck         : out std_logic; --slave clk
			ss          : out std_logic; --slave select
			ready       : out std_logic := '0' --signal from SPI thet all data is indicated
		);
	end component;

	signal start       : std_logic := '1';     --Signal to start indicate new value
	signal spi_in_date : std_logic_vector((CH_COUNT * 8 - 1) downto 0); --array of characters from main block (main_block)
	signal clk         : std_logic;
	signal mosi        : std_logic;     --master out slave in
	signal sck         : std_logic;     --slave clk
	signal ss          : std_logic;     --slave select
	signal ready       : std_logic := '0'; --signal from SPI thet all data is indicated

begin
	lalbe_lab : spi_ctrl
		port map(start       => start,
		         spi_in_date => spi_in_date,
		         clk         => clk,
		         mosi        => mosi,
		         sck         => sck,
		         ss          => ss,
		         ready       => ready
		        );
	gen_clk : process
	begin
		clk <= '1';
		wait for 5 ns;
		clk <= '0';
		wait for 5 ns;
	end process gen_clk;

	gen_input_data : process
	begin
		spi_in_date <= "000001100100111101101111";
		wait for 750 ns;
		spi_in_date <= "011111000110011001110100";
		wait for 750 ns;
	end process gen_input_data;

	gen_start : process
	begin
		start <= '1';
		wait for 1500 ns;
		start <= '0';
		wait for 1500 ns;
	end process gen_start;

end rtl;
