library ieee;
use ieee.std_logic_1164.all;

entity tb_my_buffer is
generic(
			DATA_WIDTH : natural := 8 --max value is 180 (1011 0100) - 8 bit
		);
end tb_my_buffer;
architecture rtl of tb_my_buffer is
	component my_buffer is
		generic(
			BUFFER_DATA_WIDTH : natural := 8 --max value is 180 (1011 0100) - 8 bit
		);
		port(
			data_in  : in  std_logic_vector((DATA_WIDTH - 1) downto 0); --input data
			data_en  : in  std_logic;   --Signal of available data
			clk      : in  std_logic;
			srst     : in  std_logic;   -- synchronous reset;
			data_out : out std_logic_vector((DATA_WIDTH - 1) downto 0) --output data
		);
	end component;

	signal data_in  : std_logic_vector((DATA_WIDTH - 1) downto 0); --input data
	signal data_en  : std_logic;        --Signal of available data
	signal clk      : std_logic;
	signal srst     : std_logic := '0'; -- synchronous reset;
	signal data_out : std_logic_vector((DATA_WIDTH - 1) downto 0); --output data

begin
	lalbe_lab : my_buffer
		port map(data_in  => data_in,
		         data_en  => data_en,
		         clk      => clk,
		         srst     => srst,
		         data_out => data_out
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
		data_in <= "01100101";
		data_en <= '1';
		wait for 55 ns;
		data_in <= "10001011";
		data_en <= '1';
		wait for 55 ns;
		data_en <= '0';
		data_in <= "11110001";
		wait for 25 ns;
		srst    <= '1';
		wait for 25 ns;
		srst    <= '0';
		wait for 55 ns;
		data_in <= "01010101";
		data_en <= '1';
		wait for 55 ns;
	end process gen_input_data;

end rtl;
