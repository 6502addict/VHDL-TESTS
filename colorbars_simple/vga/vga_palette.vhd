library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all; 

entity vga_rgb_palette is
  port(
 	 pixel  : in  integer;
	 red    : out std_logic_vector(3 downto 0);
	 green  : out std_logic_vector(3 downto 0);
	 blue	  : out std_logic_vector(3 downto 0)
  ); 
END vga_rgb_palette;

architecture behavior OF vga_rgb_palette IS
begin
	process (pixel)
	begin
		case data is
			when 0 => 
				red   <= "0000";  -- '0'
				green <= "0000";  -- '0'
				blue  <= "0000";  -- '0'
			when 1 => 
				red   <= "1111";  -- '1'
				green <= "0000";  -- '0'
				blue  <= "0000";  -- '0'
			when 2 => 
				red   <= "0000";  -- '2'
				green <= "1111";  -- '0'
				blue  <= "0000";  -- '0'
			when 3 => 
				red   <= "1111";  -- '3'
				green <= "1111";  -- '0'
				blue  <= "0000";  -- '0'
			when 4 => 
				red   <= "0000";  -- '4'
				green <= "0000";  -- '0'
				blue  <= "1111";  -- '0'
			when 5 => 
				red   <= "1111";  -- '5'
				green <= "0000";  -- '0'
				blue  <= "1111";  -- '0'
			when 6 => 
				red   <= "0000";  -- '6'
				green <= "1111";  -- '0'
				blue  <= "1111";  -- '0'
			when 7 => 
				red   <= "1111";  -- '7'
				green <= "1111";  -- '0'
				blue  <= "1111";  -- '0'
			when others => NULL;
		end case;
	end process;	
end behavior;
