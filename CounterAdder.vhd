Library ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY CounterAdder IS
	PORT(clock	: IN STD_LOGIC;
		  Q		: OUT std_logic_vector (2 downto 0));
END CounterAdder;

ARCHITECTURE BEHAVIOR OF CounterAdder IS
Signal T : std_logic_vector (2 downto 0);
	BEGIN
		Process(clock, T)
			BEGIN
				IF RISING_EDGE (clock) THEN
					T(0) <= Not T(0);
					END IF;
					
				IF FALLING_EDGE (T(0)) THEN
					T(1) <= Not T(1);
					END IF;
					
				IF FALLING_EDGE (T(1))	THEN
					T(2) <= Not T(2);
				END IF;
			END PROCESS;
			Q <= T;
		END BEHAVIOR;
		