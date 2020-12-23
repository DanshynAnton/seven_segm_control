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
		ready        : in  std_logic                                            := '1'; --signal from SPI that means, that SPI can take new data
		bite_for_spi : out std_logic_vector((CHARACTER_COUNT * 8 - 1) downto 0) := (others => '0'); --for every character there is an indicator. Each indicator have 8 segments (7 + dot)
		start        : out std_logic    --signal to SPI that new data is ready
	);
end indication_ctrl;

architecture rtl of indication_ctrl is
	--signal out_bits : std_logic_vector((CHARACTER_COUNT * 8 - 1) downto 0) := (others => '0');
	--variable sss : std_logic_vector((CHARACTER_COUNT * 8 - 1) downto 0) := (others => '0');
	signal st : std_logic := '0';
begin

	process(clk)
		variable out_bits : std_logic_vector((CHARACTER_COUNT * 8 - 1) downto 0) := (others => '0');
	begin
		if (rising_edge(clk)) then
			out_bits := ind_all_symb(characters);
			--ind_one_symb(variable smb : in SYMB; signal out_vector: out std_logic_vector((8 - 1) downto 0))
			if ready = '1' then
				bite_for_spi <= out_bits;
				st           <= '1';
			else
				st <= '0';
			end if;
		end if;
	end process;

	process(ready, clk)
	begin
		if (ready = '0') then
			start <= '0';
		elsif (rising_edge(clk)) then
			start <= st;
		end if;
	end process;
end rtl;
