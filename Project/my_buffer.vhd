library ieee;
use ieee.std_logic_1164.all;

entity my_buffer is
	generic(
		BUFFER_DATA_WIDTH : natural := 8 --max value is 180 (1011 0100) - 8 bit
	);

	port(
		data_in  : in  std_logic_vector((BUFFER_DATA_WIDTH - 1) downto 0);
		clk      : in  std_logic;
		data_out : out std_logic_vector((BUFFER_DATA_WIDTH - 1) downto 0)
	);

end my_buffer;

architecture rtl of my_buffer is
	signal buf_data : std_logic_vector((BUFFER_DATA_WIDTH - 1) downto 0) := (others => '0');
begin
	in_dat : process(data_in)
	begin
		buf_data <= data_in;
	end process in_dat;

	out_dat : process(clk)
	begin
		data_out <= buf_data;
	end process out_dat;
end rtl;
