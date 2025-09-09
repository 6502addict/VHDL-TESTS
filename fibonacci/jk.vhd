LIBRARY ieee;
	USE ieee.std_logic_1164.all;
	USE ieee.std_logic_unsigned.all;

ENTITY jk IS
	PORT	(
		clk	: IN  std_logic;
		d	   : IN  std_logic;
		q		: OUT std_logic
	);
END ENTITY;

ARCHITECTURE behavior OF jk IS
BEGIN
	PROCESS (clk, d)
	BEGIN
		IF (rising_edge(clk)) THEN
			q <= d;
		END IF;
	END PROCESS;
END;

