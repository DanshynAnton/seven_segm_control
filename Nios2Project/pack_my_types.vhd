library ieee;
use ieee.std_logic_1164.all;

package pack_my_types is
	type SYMB is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, SA, SB, SC, SD, SE, SF, SH, SSPACE);
	type char_array is array (natural range <>) of SYMB;
	type NUM_SYS is (HEX, DECIMAL);

	pure function hex_one_symb(signal bin_vector : std_logic_vector(3 downto 0)) return SYMB;
	procedure dec_one_symb(variable dec : in natural; variable res : out SYMB);
	pure function ind_one_symb(signal smb : SYMB) return std_logic_vector;
	pure function bin_to_hex_symb(signal bin_vector : std_logic_vector) return char_array;
	pure function bin_to_dec_symb(signal bin_vector : std_logic_vector) return char_array;
end package;

package body pack_my_types is
	--Function thet define SYMB for 4-bit string (HEX character)
	pure function hex_one_symb(signal bin_vector : std_logic_vector(3 downto 0)) return SYMB is
		variable out_char : SYMB;
	begin
		case bin_vector is
			when "0000" => out_char := S0;
			when "0001" => out_char := S1;
			when "0010" => out_char := S2;
			when "0011" => out_char := S3;
			when "0100" => out_char := S4;
			when "0101" => out_char := S5;
			when "0110" => out_char := S6;
			when "0111" => out_char := S7;
			when "1000" => out_char := S8;
			when "1001" => out_char := S9;
			when "1010" => out_char := SA;
			when "1011" => out_char := SB;
			when "1100" => out_char := SC;
			when "1101" => out_char := SD;
			when "1110" => out_char := SE;
			when "1111" => out_char := SF;
		end case;
		return out_char;
	end hex_one_symb;

	--Function thet define SYMB for decimal number
	procedure dec_one_symb(variable dec : in natural; variable res : out SYMB) is
		variable out_char : SYMB;
	begin
		case dec is
			when 0      => out_char := S0;
			when 1      => out_char := S1;
			when 2      => out_char := S2;
			when 3      => out_char := S3;
			when 4      => out_char := S4;
			when 5      => out_char := S5;
			when 6      => out_char := S6;
			when 7      => out_char := S7;
			when 8      => out_char := S8;
			when 9      => out_char := S9;
			when others => out_char := SSPACE;
		end case;
		res := out_char;
	end dec_one_symb;

	--Function for converting std_logic_vector to HEX character
	pure function bin_to_hex_symb(signal bin_vector : std_logic_vector) return char_array is
		variable out_char : char_array(2 downto 0);
	begin
		out_char(0) := SH;
		out_char(1) := hex_one_symb(bin_vector(3 downto 0));
		out_char(2) := hex_one_symb(bin_vector(7 downto 4));
		--If first symbol is zero (eq. angle is from 0 to 15) - replace first symbol by empty space
		if out_char(2) = S0 then
			out_char(2) := SSPACE;
		end if;
		return out_char;
	end bin_to_hex_symb;

	--Function for converting std_logic_vector to DECIMAL character
	pure function bin_to_dec_symb(signal bin_vector : std_logic_vector) return char_array is
		variable data     : natural                := 0;
		variable d        : natural;
		variable n        : natural                := 1;
		variable out_char : char_array(2 downto 0) := (others => SSPACE);
	begin
		--convert std_logic_vector to integer
		for i in bin_vector'reverse_range loop
			if bin_vector(i) = '1' then
				data := data + n;
			end if;
			n := n * 2;
		end loop;
		d := data mod 10;
		dec_one_symb(d, out_char(0));

		data := data / 10;
		d    := data mod 10;
		dec_one_symb(d, out_char(1));

		data := data / 10;
		d    := data mod 10;
		dec_one_symb(d, out_char(2));
		--If first symbol is zero (eq. angle is from 0 to 99) - replace first symbol by empty space
		--If second symbol is zero too (eq. angle is from 0 to 9) - replace second symbol by empty space
		if out_char(2) = S0 then
			out_char(2) := SSPACE;
			if (out_char(1) = S0) then
				out_char(1) := SSPACE;
			end if;
		end if;
		return out_char;
	end bin_to_dec_symb;

	pure function ind_one_symb(signal smb : SYMB) return std_logic_vector is
		variable out_vector : std_logic_vector(7 downto 0);
	begin
		case smb is
			when S0     => out_vector := "00111111";
			when S1     => out_vector := "00000110";
			when S2     => out_vector := "01011011";
			when S3     => out_vector := "01001111";
			when S4     => out_vector := "01100110";
			when S5     => out_vector := "11101101";
			when S6     => out_vector := "01111101";
			when S7     => out_vector := "00000111";
			when S8     => out_vector := "01111111";
			when S9     => out_vector := "01101111";
			when SA     => out_vector := "01110111";
			when SB     => out_vector := "01111100";
			when SC     => out_vector := "00111001";
			when SD     => out_vector := "01011110";
			when SE     => out_vector := "01111001";
			when SF     => out_vector := "01110001";
			when SH     => out_vector := "01110100";
			when SSPACE => out_vector := "00000000";
			when others => out_vector := "01000000";
		end case;
		return out_vector;
	end ind_one_symb;
end package body;
