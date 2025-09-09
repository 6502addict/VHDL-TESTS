library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all; 

entity vga_rgb_palette is
  port(
 	 pixel  : in  integer range 0 to 7;
	 red    : out std_logic_vector(3 downto 0);
	 green  : out std_logic_vector(3 downto 0);
	 blue	  : out std_logic_vector(3 downto 0)
  ); 
END vga_rgb_palette;

architecture behavioral of vga_rgb_palette is
	type rom_array is array (0 to 7) of std_logic_vector (11 downto 0);
	
	constant rgb_rom: rom_array :=(
		"000000000000", "000000001111", "000011110000", "000011111111", "111100000000", "111100001111", "111111110000", "111111111111"
   ); 
	attribute romstyle : string;
	attribute romstyle of rgb_rom : constant	is "no_rw_check, logic";

begin
	red   <= rgb_rom(pixel)(11 downto 8);
   green <= rgb_rom(pixel)(7 downto 4);
   blue  <= rgb_rom(pixel)(3 downto 0);
end architecture;

--architecture behavioral of vga_rgb_palette is
--	type rom_array is array (0 to 7) of std_logic_vector (3 downto 0);
--	
--	constant red_rom: rom_array :=(
--	"0000", "0000", "0000", "0000", "1111", "1111", "1111", "1111"
--  ); 
--	constant green_rom: rom_array :=(
--	"0000", "0000", "1111", "1111", "0000", "0000", "1111", "1111"
 --  ); 
--	constant blue_rom: rom_array :=(
--	"0000", "1111", "0000", "1111", "0000", "1111", "0000", "1111"
 --  ); 
--begin
--	red   <= red_rom(pixel);
--  green <= green_rom(pixel);
 -- blue  <= blue_rom(pixel);
--end architecture;

--architecture behavior OF vga_rgb_palette IS
--begin
--	red    <= "1111" when (pixel = 4) or (pixel = 5) or (pixel = 6) or (pixel = 7)  else "0000";
--	green  <= "1111" when (pixel = 2) or (pixel = 3) or (pixel = 6) or (pixel = 7)  else "0000";
--	blue   <= "1111" when (pixel = 1) or (pixel = 3) or (pixel = 5) or (pixel = 7)  else "0000";
--end behavior;


--architecture behavior OF vga_rgb_palette IS
--begin
--	process (pixel)
--	begin
--		case pixel is
--			when 0 => -- black
--				red   <= "0000"; 
--				green <= "0000"; 
--				blue  <= "0000"; 
--			when 1 => -- blue
--				red   <= "0000"; 
--				green <= "0000"; 
--				blue  <= "1111"; 
--			when 2 => -- green
--				red   <= "0000"; 
--				green <= "1111"; 
--				blue  <= "0000"; 
--			when 3 => -- cyan
--				red   <= "0000";
--				green <= "1111";
--				blue  <= "1111";
--			when 4 => -- red
--				red   <= "1111";
--				green <= "0000";
--				blue  <= "0000";
--			when 5 => -- magenta
--				red   <= "1111"; 
--				green <= "0000"; 
--				blue  <= "1111";
--			when 6 =>  -- yellow
--				red   <= "1111"; 
--				green <= "1111";
--				blue  <= "0000"; 
--			when 7 => -- white
--				red   <= "1111";  
--				green <= "1111";  
--				blue  <= "1111";  
--			when others => NULL;
--		end case;
--	end process;	
--end behavior;
