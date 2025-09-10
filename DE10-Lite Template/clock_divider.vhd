-- same thing here we use only the library needed
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

-- we create the entity that will divide a frequency
-- note that the frequency source must be a multiple for the target frequency
-- this is very important if you want to produce a frequency for a serial port
-- sometimes it is possible to play on the duty cycle with a fractinal clock divider 
-- to get better frequency from the divider
entity clock_divider IS
   -- a generic is  way to passe parameters to modify the design
	-- here the default divider is 4 but it will take the valued define in the instantiation
	generic (divider : integer := 4);
	port	(
		clk_in   : in  std_logic;   -- high frequency
		clk_out  : out std_logic    -- frequencey divided by the division factor
	);
end clock_divider;

architecture rtl of clock_divider is
-- here we define the counter use to count the cycle need between signal change
signal cnt : integer range 0 to divider - 1;

begin
	process (clk_in)
	begin
		if (rising_edge(clk_in)) then
			if cnt < (divider / 2) then
			   -- if we are in the first half of the counter the clock is set to '0'
				clk_out <= '0';
			else	
			   -- if we are in the second half of the counter the clock is set to '1'
				clk_out <= '1';
			end if;
			if cnt = divider -1 then
			   -- if the counter reach the limit we reset the counter to zero
				cnt <= 0;
			else	
			   -- we simply increase the counter
				cnt <= cnt + 1;
			end if;
		end if;
	end process;
end rtl;
