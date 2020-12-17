library ieee;
use ieee.std_logic_1164.all;

entity button_ctrl is
	port(
		button_in  : in  std_logic;
		button_clk : in  std_logic;
		button_out : out std_logic
	);
end button_ctrl;

architecture rtl of button_ctrl is
	signal old      : std_logic := '0';
	signal btn_wait : integer   := 0;
begin
	process(button_clk)
	begin
		if rising_edge(button_clk) then
			if button_in = '1' then
				if btn_wait >= 10 then
					button_out <= '1';
				else
					btn_wait   <= btn_wait + 1;
					button_out <= '0';
				end if;
			else
				btn_wait   <= 0;
				button_out <= '0';
			end if;
		end if;
	end process;
end rtl;
