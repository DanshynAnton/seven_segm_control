library ieee;
use ieee.std_logic_1164.all;

entity spi_ctrl is
	generic(
		CHARACTER_COUNT : natural := 3  --max value is 180 (3 characters) and B4h (3 characters)
	);
	port(
		start       : in  std_logic;    --Signal to start indicate new value
		spi_in_date : in  std_logic_vector((CHARACTER_COUNT * 8 - 1) downto 0); --array of characters from main block (main_block)
		clk         : in  std_logic;
		mosi        : out std_logic;    --master out slave in
		sck         : out std_logic;    --slave clk
		ss          : out std_logic;    --slave select
		ready       : out std_logic := '0' --signal from SPI thet all data is indicated
	);
end spi_ctrl;

architecture rtl of spi_ctrl is
	type STATE is (
		STATE_WAITING,
		STATE_DATA,
		STATE_CLK_H,
		STATE_CLK_L
	);
	signal cur_state : STATE := STATE_WAITING;
	signal cur_data  : std_logic_vector((CHARACTER_COUNT * 8 - 1) downto 0);
begin
	form_mosi : process(clk) is
		variable i : integer := 0;
	begin
		if (rising_edge(clk)) then
			case cur_state is
				when STATE_WAITING =>
					mosi <= '0';
					sck  <= '0';
					if (start = '1') then
						cur_state <= STATE_DATA;
						ready     <= '0';
						i         := 0;
						ss        <= '1';
						cur_data  <= spi_in_date;
					end if;
				when STATE_DATA =>
					if (i < CHARACTER_COUNT * 8) then
						mosi      <= cur_data(i);
						i         := i + 1;
						cur_state <= STATE_CLK_H;
					else
						ready     <= '1';
						ss        <= '0';
						cur_state <= STATE_WAITING;
						i         := 0;
					end if;
				when STATE_CLK_H =>
					sck       <= '1';
					cur_state <= STATE_CLK_L;
				when STATE_CLK_L =>
					sck       <= '0';
					cur_state <= STATE_DATA;
			end case;
		end if;
	end process form_mosi;
end rtl;
