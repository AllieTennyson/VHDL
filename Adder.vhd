LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Adder IS
	PORT (X, Y, cin	:IN STD_LOGIC;
		cout, S			:OUT STD_LOGIC);
	END Adder;
	
ARCHITECTURE BEHAVIOR of Adder IS
BEGIN
	s <= X xor Y xor cin;
	cout <= (x and y) OR (cin AND x) OR (cin AND y);
End behavior;

