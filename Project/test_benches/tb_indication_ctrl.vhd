library ieee;
use ieee.std_logic_1164.all;
use work.pack_my_types.all;

entity tb_indication_ctrl is
end tb_indication_ctrl;
architecture rtl of tb_indication_ctrl is
	component indication_ctrl is
		generic(
			CHARACTER_COUNT : natural := 3 --max value is 180 (3 characters) and B4h (3 characters)
		);

		port(
			characters   : in  char_array((CHARACTER_COUNT - 1) downto 0); --array of characters from main block (main_block)
			clk          : in  std_logic;
			ready        : in  std_logic := '1'; --signal from SPI that means, that SPI can take new data
			bite_for_spi : out std_logic_vector((CHARACTER_COUNT * 8 - 1) downto 0); --for every character there is an indicator. Each indicator have 8 segments (7 + dot)
			start        : out std_logic --signal to SPI that new data is ready
		);
	end component;

	signal characters   : char_array((3 - 1) downto 0);
	signal clk          : std_logic;
	signal ready        : std_logic := '1';
	signal bite_for_spi : std_logic_vector((3 * 8 - 1) downto 0);
	signal start        : std_logic;
begin
	lalbe_lab : indication_ctrl
		port map(characters   => characters,
		         clk          => clk,
		         ready        => ready,
		         bite_for_spi => bite_for_spi,
		         start        => start
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
		characters <= (SSPACE, SSPACE, S0);
		wait for 20 ns;
		characters <= (S1, S3, S9);
		wait for 20 ns;
		characters <= (S1, S8, S0);
		wait for 20 ns;
		characters <= (SSPACE, S0, SH);
		wait for 20 ns;
		characters <= (S8, SB, SH);
		wait for 20 ns;
		characters <= (SB, S4, SH);
		wait for 20 ns;
	end process gen_input_data;

	gen_ready : process
	begin
		ready <= '1';
		wait for 22 ns;
		ready <= '0';
		wait for 28 ns;
	end process gen_ready;

end rtl;
