-- libraries needed mostly for conversion between VHDL type
-- in the past I was using too many libraries leading to confusion
-- finally I stick with these ones and it works fine most of the time

library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.std_logic_arith.all;  
	use IEEE.std_logic_unsigned.all;
	use ieee.numeric_std.all; 
	
	
-- first we describe	 the top level entities connected to the devices present on the board

entity de10lite is
	port (
-- the clocks provided by the DE10 Lite	
		ADC_CLK_10      :	in	    std_logic;
		MAX10_CLK1_50   :	in     std_logic;
		MAX10_CLK2_50   :	in     std_logic;

-- the sdram connectedt to the DE10 Lite (I've not yet mastered the control of the sdram
-- and are using mostly the embedded block ram  (EBR)		
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
-- the seven segment hexa display
-- on Terasic board they are not multiplexed and use a lot of pin on the FPGA
-- generally they are multiplexed and requires far less pin
-- generally 7 or 8 pin  + 1 pin by display chip
-- some 7seg display are charliplexed
		HEX0				 :	out    std_logic_vector(7 downto 0);
		HEX1				 :	out    std_logic_vector(7 downto 0);
		HEX2				 :	out    std_logic_vector(7 downto 0);
		HEX3				 :	out    std_logic_vector(7 downto 0);
		HEX4				 :	out    std_logic_vector(7 downto 0);
		HEX5				 :	out    std_logic_vector(7 downto 0);
-- the 2 buttons on Terasic Boards they are debounced by as shmitt trigger
		KEY				 :	in		 std_logic_vector(1 downto 0);
-- the ten leds
		LEDR				 :	out	 std_logic_vector(9 downto 0);
-- the switches
		SW					 :	in		 std_logic_vector(9 downto 0);
-- the VGA signals  4 bit red 4 bit green 4 bit blue + horizontal and vertical synchro		
		VGA_B				 :	out	 std_logic_vector(3 downto 0);
		VGA_G				 :	out    std_logic_vector(3 downto 0);
		VGA_HS			 :	out	 std_logic;
		VGA_R				 : out	 std_logic_vector(3 downto 0);
		VGA_VS			 :	out	 std_logic;
-- gsensor I never found an application needing the use of the gsensor		
		GSENSOR_CS_N	 :	out	 std_logic;
		GSENSOR_INT		 :	in		 std_logic_vector(2 downto 1);
		GSENSOR_SCLK	 : out    std_logic;
		GSENSOR_SDI		 :	inout  std_logic;
		GSENSOR_SDO	 	 :	inout  std_logic;
-- the arduino connector (Arduino UNO Style)
-- but beware that many arduino uno are 5V and could destroy the DE10 Lite
-- I found a steelstudio arduino shield working only 3.3v but the performances are not so good
-- it's limiting the speed to around 5Mhz
		ARDUINO_IO		 : inout  std_logic_vector(15 downto 0);
		ARDUINO_RESET_N : inout  std_logic;
-- the GPIO connector... also 3.3v
		GPIO            :	inout  std_logic_vector(35 downto 0)
  );
end de10lite;
-- now we have finished describing the chips and ports available on the DE10
-- there is also a pin mapping you can access it via Assignments/Assignment Editor

-- now we start do describe what the design is doing with the board
architecture top of de10lite is


-- first we have to describe the external entities / component used in the design
-- I placed the clock_divider almost used in al designs
-- even though it is not specific to a board
-- to write a component it's not so complicated you cut and paste the entity
-- and past it here changing "entity" by component and "end xxx" by "end component"
component clock_divider IS
	generic (divider : integer := 4);
	port	(
		clk_in   : in  std_logic;
		clk_out  : out std_logic
	);
end component;

-- I added the hexadisplay it permit to display something on the mapping
-- in this case it's a kind of wrapper that instantiate the 6 7segment display
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


-- we have finished declaring the component used...
-- now we have to declare the wire used in the application
-- the wire with the clock used for a counter  
signal clock_2hz       : std_logic;

-- the wire use to reset the counter
signal reset_n         : std_logic; 
-- note the _n after the reset is not there to have something pretty ;)
-- but to indicates that the signal is active low

-- now a group of 24 wire (in fact 24 flipflop to hold the counter value)   
signal counter         : std_logic_vector (23 downto 0);


-- as we have declared the wire / registers used
-- we start to connect the element together
begin
-- first we connect a clock divider to lower the DE10 Lite clock
-- to have something visible on the 7 seg display
-- here I choose 2 Hz	
	u0: clock_divider  generic map (50_000_000 / 2)            -- note _ is used just to make the group of digit more readable
	                   port map (clk_in => MAX10_CLK1_50,      -- on entry we feed the DE10 Lite 50Mhz clock
										  clk_out => clock_2hz);        -- we connect the output to the clock_2hz "wire"  

-- now we connect the counter to the hexa display								
   u1: hexdisplay     port map (data  => counter,               
							  			  dig0  => hex0,
										  dig1  => hex1,
										  dig2  => hex2,
										  dig3  => hex3,
										  dig4  => hex4,
										  dig5  => hex5);

-- not that it's not like C or C#  program
-- the orderer of the line is not important I could invert some blocks without any effect
										  

-- now I create a process to increment the counter at each clock tick										 
	process(reset_n, clock_2hz)
	begin 
	   -- if reset goes low we reset the counter. not that this is an asynchronous reset
		if reset_n = '0' then
			counter <= x"000000";
		-- now each time the clock goes from low to high the counter is increased
	   -- if we wanted to increase while the clock goes from high to low we would have used   falling_edge(clock_2hz) 	
		elsif rising_edge(clock_2hz) then
			counter <= counter + 1;
		end if;
	end process;

-- the DE10 lite as 2 buttons KEY(0) and KEY(1)
-- we connect the first button to reset  the buttons at '1' when up and '0' when down
	reset_n <= KEY(0);

-- now we can see the counter increasing on 7seg
-- we connect some extra "wires" to show the activity of the clock and reset_button

	LEDR(0) <= reset_n;
	LEDR(1) <= clock_2hz;
	LEDR(9 downto 2) <= (others => '0');
	
-- to see something with an oscilloscope
   ARDUINO_IO(0) <= reset_n;
   ARDUINO_IO(1) <= clock_2hz;	
	
end top;
