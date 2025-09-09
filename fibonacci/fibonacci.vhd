library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.std_logic_arith.all;
	use IEEE.std_logic_unsigned.all;
	use ieee.numeric_std.all; 

entity fibonacci is
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
end fibonacci;

architecture top of fibonacci is
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

component bcd_display IS
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

component debouncer is
	port (
		clk   	: in  std_logic;
		key	   : in  std_logic;
		q		   : out std_logic
	);
end component;

component fibo is
	generic (N        : INTEGER := 32);
	port    (clk      : in  std_logic;
				reset_n  : in  std_logic;	
				fib      : out std_logic_vector(N - 1 DOWNTO 0)  
	);
end component;
	
signal reset_n         : std_logic;    
signal clock_1hz       : std_logic;
signal clock_5hz       : std_logic;
signal clock_debounce  : std_logic;
signal clock_fib       : std_logic;
signal clock_manual    : std_logic;
signal fib             : std_logic_vector(23 downto 0);


begin
	-- produce 5Hz clock for fast fib computation
	u0: clock_divider generic map (divider => 50_000_000 / 5) 
	                     port map (clk_in => MAX10_CLK1_50, 
										    clk_out => clock_5hz);

	-- produce 5Hz clock for slow fib computation
	u1: clock_divider generic map (divider => 5 / 1) 
	                     port map (clk_in => clock_5hz, 
										    clk_out => clock_1hz);

	-- produce 1KHz clock for key debounce
	u2: clock_divider generic map (divider => 50_000_000 / 1000) 
	                     port map (clk_in => MAX10_CLK1_50, 
										    clk_out => clock_debounce);
 
   u3: debouncer        port map (clk => clock_debounce,
                                  key => KEY(1),
											 q   => clock_manual);
											 
-- u4: hexdisplay       port map (data  => fib,
-- 							     		 dig0  => hex0,
--										    dig1  => hex1,
--										    dig2  => hex2,
--										    dig3  => hex3,
--										    dig4  => hex4,
--										    dig5  => hex5);

   u5: bcd_display      port map (data  => fib,
							     	 	    dig0  => hex0,
										    dig1  => hex1,
										    dig2  => hex2,
										    dig3  => hex3,
										    dig4  => hex4,
										    dig5  => hex5);

	
	reset_n <= KEY(0);
	LEDR(9) <= clock_fib;
	LEDR(0) <= SW(0);
	LEDR(1) <= SW(1);

	f1 : fibo generic map (n => 24) 
				 port    map (clock_fib, reset_n, fib);

				 
	clock_fib <= clock_1hz    when SW(1 downto 0) = "01" else
					 clock_5hz    when SW(1 downto 0) = "10" else
					 clock_manual;
				 
END top;