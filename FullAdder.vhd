LIBRARY ieee;
USE ieee.std_logic_1164.all;

Entity FullAdder IS
	PORT (x3, x2, x1, x0	:IN STD_LOGIC;
			y3, y2, y1, y0	:IN STD_LOGIC;
			s3, s2, s1, s0	:OUT STD_LOGIC;
			cout				:OUT STD_LOGIC);
	END FullAdder;
	
ARCHITECTURE BEHAVIOR of FullAdder IS
Signal c1, c2, c3	: STD_LOGIC;
COMPONENT Adder
	PORT (X, Y, cin	:IN STD_LOGIC;
	      cout, S	   :OUT STD_LOGIC);
END COMPONENT;

BEGIN
	stage0: Adder PORT MAP( x0, y0,'0', c1, s0);
	stage1: Adder PORT MAP( x1, y1, c1, c2, s1);
	stage2: Adder PORT MAP( x2, y2,c2, c3, s2);
	stage3: Adder PORT MAP( x3, y3,c3, cout, s3);
End behavior;

