LIBRARY ieee;
	USE ieee.std_logic_1164.all;
	USE ieee.std_logic_unsigned.all;

ENTITY debouncer IS
	PORT	(
		clk	: IN  std_logic;
		key	: IN  std_logic;
		q		: OUT std_logic
	);
END ENTITY;

ARCHITECTURE behavior OF debouncer IS

	COMPONENT jk IS
		PORT	(
			clk	: IN  std_logic;
			d	   : IN  std_logic;
			q		: OUT std_logic
		);
	END COMPONENT;

	SIGNAL  phase1    : std_logic;
	SIGNAL  phase2 	: std_logic;
	
BEGIN
	jk1      :  jk PORT MAP (clk, key,    phase1);
	jk2      :  jk PORT MAP (clk, phase1, phase2);
	q <= phase1 and phase2;
END;
