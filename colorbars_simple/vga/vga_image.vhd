library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all; 

entity vga_image is
	generic (maxrow   : integer := 525;
				maxcol   : integer := 800;
				maxpixel : integer := 8);
  port(
    enable_n  : in  std_logic; 
	 clock_vga : in  std_logic;
	 row       : in  integer range 0 to maxrow   - 1;
	 col       : in  integer range 0 to maxcol   - 1;
	 pixel	  : out integer range 0 to maxpixel - 1
  ); 
END vga_image;

architecture behavior OF vga_image IS
begin
  process (enable_n, clock_vga, row, col)
  begin
  if rising_edge(clock_vga) then
	 if enable_n = '0' then
		pixel <= col / 80;
  	 else
		pixel <= 0;
	 end if;
  end if;
  end process;
end behavior;
