library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.std_logic_arith.all;
	use IEEE.std_logic_unsigned.all;
	use ieee.numeric_std.all; 

entity colorbar_simple is
	port (
		ADC_CLK_10      :	in	    std_logic;
		MAX10_CLK1_50   :	in     std_logic;
		MAX10_CLK2_50   :	in     std_logic;

		DRAM_ADDR       :	out    std_logic_vector(12 downto 0);
		DRAM_BA         :	out    std_logic_vector(1 downto 0);
		DRAM_CAS_N      :	out    std_logic;
		DRAM_CKE        :	out    std_logic;
		DRAM_CLK        :	out    std_logic;
		DRAM_CS_N       :	out    std_logic;
		DRAM_DQ         :	inout  std_logic_vector(15 downto 0);
		DRAM_LDQM       :	out    std_logic;
		DRAM_RAS_N      :	out	 std_logic;
		DRAM_UDQM       :	out    std_logic;
		DRAM_WE_N       :	out	 std_logic;

		HEX0				 :	out    std_logic_vector(7 downto 0);
		HEX1				 :	out    std_logic_vector(7 downto 0);
		HEX2				 :	out    std_logic_vector(7 downto 0);
		HEX3				 :	out    std_logic_vector(7 downto 0);
		HEX4				 :	out    std_logic_vector(7 downto 0);
		HEX5				 :	out    std_logic_vector(7 downto 0);

		KEY				 :	in		 std_logic_vector(1 downto 0);

		LEDR				 :	out	 std_logic_vector(9 downto 0);

		SW					 :	in		 std_logic_vector(9 downto 0);
		
		VGA_B				 :	out	 std_logic_vector(3 downto 0);
		VGA_G				 :	out    std_logic_vector(3 downto 0);
		VGA_HS			 :	out	 std_logic;
		VGA_R				 : out	 std_logic_vector(3 downto 0);
		VGA_VS			 :	out	 std_logic;
		
		GSENSOR_CS_N	 :	out	 std_logic;
		GSENSOR_INT		 :	in		 std_logic_vector(2 downto 1);
		GSENSOR_SCLK	 :  out    std_logic;
		GSENSOR_SDI		 :	inout  std_logic;
		GSENSOR_SDO	 	 :	inout  std_logic;

		ARDUINO_IO		 : inout  std_logic_vector(15 downto 0);
		ARDUINO_RESET_N : inout  std_logic;

		GPIO            :	inout  std_logic_vector(35 downto 0)
  );
end colorbar_simple;

architecture top of colorbar_simple is
	constant  maxrow   : integer := 525;
	constant  maxcol   : integer := 800;
	constant  maxpixel : integer := 8;
	
component pll is
	port (
		areset		: in  std_logic  := '0';
		inclk0		: in  std_logic  := '0';
		c0				: out std_logic
	);
end component;

component clock_divider IS
	generic (divider : integer := 4);
	port	(
		clk_in   : in  std_logic;
		clk_out  : out std_logic
	);
end component;

component hexdisplay IS
	port	(
		data     : in  std_logic_vector(23 downto 0);
		dig0		: out std_logic_vector(7 downto 0);
		dig1		: out std_logic_vector(7 downto 0);
		dig2		: out std_logic_vector(7 downto 0);
		dig3		: out std_logic_vector(7 downto 0);
		dig4		: out std_logic_vector(7 downto 0);
		dig5		: out std_logic_vector(7 downto 0)
	);
end component;

component vga_pll is
	port (
		areset		: in  std_logic  := '0';
		inclk0		: in  std_logic  := '0';
		c0				: out std_logic
	);
end component;


component vga_ctrl IS
	generic(
		htotal	:	integer   := maxcol;		
		hdisp		:	integer   := 640;		
		hpol		:	std_logic := '0';		
		hswidth 	:	integer   := 96;    	
		hfp	 	:	integer   := 16;		
		hbp	 	:	integer   := 48;		
		vtotal	:	integer   := maxrow;		
		vdisp		:	integer   := 480;		
		vpol		:	std_logic := '0';		
		vswidth 	:	integer   := 2;		
		vbp	 	:	integer   := 33;		
		vfp	 	:	integer   := 10		
	);
	port(
		reset_n		:	in	 std_logic;	
		clock_vga	:	in	 std_logic;	
		vsync			:	out std_logic;	
		hsync			:	out std_logic;	
		row         :  out integer range 0 to maxrow -1;
		col         :  out integer range 0 to maxcol -1;
		enable_n		:	out std_logic
	);
end component;

component vga_image is
	generic (maxrow   : integer := 525;
				maxcol   : integer := 800;
				maxpixel : integer := 8);
  port(
    enable_n      : in  std_logic; 
	 clock_vga     : in  std_logic;
	 row           : in  integer range 0 to maxrow   -1;
	 col			   : in  integer range 0 to maxcol   -1; 
	 pixel         : out integer range 0 to maxpixel -1
  ); 
end component;

component vga_rgb_palette is
		port(
		pixel			: in  integer range 0 to maxpixel -1;
		red         : out std_logic_vector(3 downto 0);
		green       : out std_logic_vector(3 downto 0);
		blue			: out std_logic_vector(3 downto 0)
	);
end component;


signal counter         : std_logic_vector (23 downto 0);
signal clock5hz        : std_logic;
signal clock_50m       : std_logic;
signal clock_vga       : std_logic;
signal reset_n         : std_logic;    

signal vga_enable_n    : std_logic;
signal vga_pixel       : integer range 0 to maxpixel -1;
signal vga_address     : std_logic_vector(16 downto 0);
signal vga_row         : integer range 0 to maxrow   -1;
signal vga_col         : integer range 0 to maxcol   -1;

begin
	u0: clock_divider  generic map (10000000 / 5) 
	                   port map (clk_in => ADC_CLK_10, 
										  clk_out => clock5hz);

   u2: hexdisplay     port map (data  => counter,
							  			  dig0  => hex0,
										  dig1  => hex1,
										  dig2  => hex2,
										  dig3  => hex3,
										  dig4  => hex4,
										  dig5  => hex5);

	pll1: vga_pll      port map (areset => not reset_n,
							    		  inclk0	=> MAX10_CLK1_50,
									     c0	   => clock_vga);
	
	vg: vga_ctrl		 generic map (htotal  => maxcol,
	                                hdisp   => 640,
											  hpol    => '0',
											  hswidth => 96,
											  hfp     => 16,
											  hbp     => 48,
											  vtotal  => maxrow,
											  vdisp   => 480,
											  vpol    => '0',
											  vswidth => 2,
											  vbp     => 33,
											  vfp     => 10)
		        			 port map (reset_n   => reset_n,
							 			  clock_vga => clock_vga,
										  vsync	   => VGA_VS,
										  hsync	   => VGA_HS,
										  row       => vga_row,
										  col       => vga_col,
		                          enable_n  => vga_enable_n);
										  
   vi: vga_image   	 generic map (maxrow => maxrow,
											  maxcol => maxcol,
											  maxpixel => maxpixel) 
							 port map (enable_n  => vga_enable_n,
			                       clock_vga => clock_vga,
			 							  row       => vga_row,
										  col       => vga_col,
										  pixel     => vga_pixel);

	vp: vga_rgb_palette port map (pixel    => vga_pixel,
											red      => VGA_R,
											green    => VGA_G,
											blue     => vga_B);
				
	process(reset_n, clock5hz)
	begin 
		if reset_n = '0' then
			counter <= x"000000";
		elsif rising_edge(clock5hz) then
			counter <= counter + 1;
		end if;
	end process;
	
	reset_n <= KEY(0);
	LEDR(9) <= clock5hz;
	LEDR(8) <= clock_vga;


end top;
