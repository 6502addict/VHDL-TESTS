library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std;

entity fibo is
	generic (N       : integer := 32);
	port    (clk     : in  std_logic;
		      reset_n : in  std_logic;	
	   	   fib     : out std_logic_vector(N - 1 downto 0)
	); 
END fibo;

architecture behavioral of fibo is
   signal a, b, c : integer range 0 to 2**N-1;
begin
	process (clk, reset_n, a, b, c)
	begin	
		if (reset_n = '0') THEN
			b <= 1;
			c <= 0;
		elsif rising_edge(clk) then
			c <= b;
			b <= a;
		end if;
		a <= b + c;
	end process;
	fib <= conv_std_logic_vector(c, N);
END behavioral;

	
			