library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity clock_divider IS
	generic (divider : integer := 4);
	port	(
		clk_in   : in  std_logic;
		clk_out  : out std_logic
	);
end clock_divider;

architecture rtl of clock_divider is

signal cnt : integer range 0 to divider - 1;
begin
	process (clk_in)
	begin
		if (rising_edge(clk_in)) then
			if cnt < (divider / 2) then
				clk_out <= '0';
			else	
				clk_out <= '1';
			end if;
			if cnt = divider -1 then
				cnt <= 0;
			else	
				cnt <= cnt + 1;
			end if;
		end if;
	end process;
end rtl;
