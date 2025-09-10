library IEEE;
use IEEE.std_logic_1164.all;

-- we define the entity in entry 4 bit hexa decimal value mapped to 7 segments
entity disp7seg is
	port (
		data:	in 	 std_logic_vector(3 downto 0);
		seg:	out    std_logic_vector(7 downto 0)
	);
end disp7seg;

architecture disp7seg of disp7seg is
begin
   -- here we map the 7seg code needed according to the hexadecimal value we want to display
	-- not that there are not 7 but 8 wire connected to the 7seg 
	-- I've ignore the decimal point... that's why the high bit is always '1'
	-- note that a segment is on when the bit associated is '0'
	process (data)
	begin
		case data is
			when "0000" => seg <= "11000000";  -- '0'
			when "0001" => seg <= "11111001";  -- '1'
			when "0010" => seg <= "10100100";  -- '2'
			when "0011" => seg <= "10110000";  -- '3'
			when "0100" => seg <= "10011001";  -- '4'
			when "0101" => seg <= "10010010";  -- '5'
			when "0110" => seg <= "10000010";  -- '6'
			when "0111" => seg <= "11111000";  -- '7'
			when "1000" => seg <= "10000000";  -- '8'
			when "1001" => seg <= "10010000";  -- '9'
			when "1010" => seg <= "10001000";  -- 'A'
			when "1011" => seg <= "10000011";  -- 'B'
			when "1100" => seg <= "11000110";  -- 'C'
			when "1101" => seg <= "10100001";  -- 'D'
			when "1110" => seg <= "10000110";  -- 'E'
			when "1111" => seg <= "10001110";  -- 'F'
			when others => NULL;
		end case;
	end process;

end disp7seg;
