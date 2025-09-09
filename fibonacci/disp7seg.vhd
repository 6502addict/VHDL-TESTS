library IEEE;
	use IEEE.std_logic_1164.all;
	use ieee.numeric_std.all; 
	use IEEE.std_logic_arith.all;
	use IEEE.std_logic_unsigned.all;

entity disp7seg is
	port (
		data:	in 	 std_logic_vector(3 downto 0);
		seg:	out    std_logic_vector(7 downto 0)
	);
end disp7seg;

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all; 

architecture behavioral of disp7seg is
	type rom_array is array (0 to 15) of std_logic_vector (7 downto 0);
	
	constant sevenseg: rom_array :=(
			"11000000",  -- '0'
			"11111001",  -- '1'
			"10100100",  -- '2'
			"10110000",  -- '3'
			"10011001",  -- '4'
			"10010010",  -- '5'
			"10000010",  -- '6'
			"11111000",  -- '7'
			"10000000",  -- '8'
			"10010000",  -- '9'
			"10001000",  -- 'A'
			"10000011",  -- 'B'
			"11000110",  -- 'C'
			"10100001",  -- 'D'
			"10000110",  -- 'E'
			"10001110"   -- 'F'
   ); 

begin
	seg   <= sevenseg(conv_integer(data));
end architecture;

--architecture disp7seg of disp7seg is
--begin

--	process (data)
--	begin
--		case data is
--			when "0000" => seg <= "11000000";  -- '0'
--			when "0001" => seg <= "11111001";  -- '1'
--			when "0010" => seg <= "10100100";  -- '2'
--			when "0011" => seg <= "10110000";  -- '3'
--			when "0100" => seg <= "10011001";  -- '4'
--			when "0101" => seg <= "10010010";  -- '5'
--			when "0110" => seg <= "10000010";  -- '6'
--			when "0111" => seg <= "11111000";  -- '7'
--			when "1000" => seg <= "10000000";  -- '8'
--			when "1001" => seg <= "10010000";  -- '9'
--			when "1010" => seg <= "10001000";  -- 'A'
--			when "1011" => seg <= "10000011";  -- 'B'
--			when "1100" => seg <= "11000110";  -- 'C'
--			when "1101" => seg <= "10100001";  -- 'D'
--			when "1110" => seg <= "10000110";  -- 'E'
--			when "1111" => seg <= "10001110";  -- 'F'
--			when others => NULL;
--		end case;
--	end process;

-- end disp7seg;
