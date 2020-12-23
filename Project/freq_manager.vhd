library ieee;
use ieee.std_logic_1164.all;

--Component that devide frequency
entity freq_manager is
	generic(
		FREQ_IN  : natural := 50_000_000; --50MG
		FREQ_OUT : natural := 1_000_000 --1MG
	);
	port(
		clk_in  : in  std_logic;
		clk_out : out std_logic
	);
end freq_manager;

architecture rtl_freq of freq_manager is
	signal clk_reg : std_logic := '0';
begin
	process(clk_in) is
		variable count : natural := 0;
	begin
		if (rising_edge(clk_in)) then
			if (count = ((FREQ_IN / 2) / FREQ_OUT) - 1) then
				clk_reg <= not clk_reg;
				count   := 0;
			else
				count := count + 1;
			end if;
		end if;
	end process;
	clk_out  <= clk_reg;
end rtl_freq;