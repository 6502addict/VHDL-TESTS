library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.std_logic_unsigned;
	
	
-- we define the entity "describing the 6 7seg of the DE10 Lite"
entity hexdisplay is
	port (
		data : in    std_logic_vector(23 downto 0);
		dig0 : out   std_logic_vector(7 downto 0);
		dig1 : out   std_logic_vector(7 downto 0);
		dig2 : out   std_logic_vector(7 downto 0);
		dig3 : out   std_logic_vector(7 downto 0);
		dig4 : out   std_logic_vector(7 downto 0);
		dig5 : out   std_logic_vector(7 downto 0)
	);
end hexdisplay;

architecture hexdisplay of hexdisplay is

-- we define the component that map each 7seg digit
component disp7seg is
	port (
		data:	in 	 std_logic_vector(3 downto 0);
		seg:	out    std_logic_vector(7 downto 0)
	);
end component;

begin
-- here we map each bloks of 4 bit from data to each 7seg
	h0: disp7seg      port map (data => data(3  downto  0), seg => dig0);
	h1: disp7seg      port map (data => data(7  downto  4), seg => dig1);
	h2: disp7seg      port map (data => data(11 downto  8), seg => dig2);
	h3: disp7seg      port map (data => data(15 downto 12), seg => dig3);
	h4: disp7seg      port map (data => data(19 downto 16), seg => dig4);
	h5: disp7seg      port map (data => data(23 downto 20), seg => dig5);

end hexdisplay;
