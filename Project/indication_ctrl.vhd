library ieee;
use ieee.std_logic_1164.all;
use work.pack_my_types.all;

entity indication_ctrl is
	generic(
		CHARACTER_COUNT : natural := 3  --max value is 180 (3 characters) and B4h (3 characters)
	);

	port(
		characters   : in  char_array((CHARACTER_COUNT - 1) downto 0); --array of characters from main block (main_block)
		clk          : in  std_logic;
		ready        : in  std_logic := '1'; --signal from SPI that means, that SPI can take new data
		bite_for_spi : out std_logic_vector((CHARACTER_COUNT * 8 - 1) downto 0); --for every character there is an indicator. Each indicator have 8 segments (7 + dot)
		start        : out std_logic    --signal to SPI that new data is ready
	);
end indication_ctrl;

architecture rtl of indication_ctrl is
	signal out_bits : std_logic_vector((CHARACTER_COUNT * 8 - 1) downto 0) := (others => '0');
begin
	process(clk)
	begin
		for i in characters'range loop
			out_bits((i * 8 + 7) downto i * 8) <= ind_one_symb(characters(i));
		end loop;
	end process;

	process(clk)
	begin
		if ready = '1' then
			bite_for_spi <= out_bits;
			start        <= '1';
		else
			start <= '0';
		end if;
	end process;
end rtl;
