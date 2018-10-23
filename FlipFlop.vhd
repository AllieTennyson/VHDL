LIBRARY ieee;
Use ieee.std_logic_1164.all;

ENTITY FlipFlop is PORT (Clock	: IN STD_LOGIC;
								 Q				: OUT STD_LOGIC);
								 
END FlipFlop;

Architecture Behavior of FlipFlop IS
	SIGNAL T:STD_LOGIC;	
BEGIN
	PROCESS (T, clock)
	BEGIN
		IF RISING_EDGE(clock) THEN
			T <= NOT T;
		END IF;
	END PROCESS;
	
	Q <= T;
	
END BEHAVIOR;