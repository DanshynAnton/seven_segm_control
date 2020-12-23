library ieee;
use ieee.std_logic_1164.all;

entity my_buffer is
	generic(
		BUFFER_DATA_WIDTH : natural := 8 --max value is 180 (1011 0100) - 8 bit
	);

	port(
		data_in  : in  std_logic_vector((BUFFER_DATA_WIDTH - 1) downto 0); --input data
		data_en  : in  std_logic;       --Signal of available data
		clk      : in  std_logic;
		srst     : in  std_logic;       -- synchronous reset;
		data_out : out std_logic_vector((BUFFER_DATA_WIDTH - 1) downto 0) := (others => '0') --output data
	);

end my_buffer;

architecture rtl of my_buffer is
	signal buf_data : std_logic_vector((BUFFER_DATA_WIDTH - 1) downto 0) := (others => '0');
begin
	in_dat : process(clk)
	begin
		if (rising_edge(clk)) then
			if (srst = '1') then
				--Reset data
				buf_data <= (others => '0');
			elsif (data_en = '1') then
				--If data available - wright in buffer
				buf_data <= data_in;
			end if;
		end if;
	end process in_dat;

	out_dat : process(clk)
	begin
		if (rising_edge(clk)) then
			data_out <= buf_data;
		end if;
	end process out_dat;
end rtl;
