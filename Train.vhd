 LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164;

ENTITY Train IS
PORT(clock, Reset, w:IN STD_LOGIC;
		   y:OUT STD_LOGIC);
END Train;

ARCHITECTURE BEHAVIOR OF Train IS
	TYPE STATETYPE IS (start, detect1, detect10, detect101);
	SIGNAL CurState : StateType;
BEGIN
	PROCESS(clock, reset, w)
	BEGIN
		IF reset = '0' THEN
			curState <= start;
		ELSEIF RISING_EDGE(clock) THEN
			CASE curState IS
				WHEN start =>
					IF w = '1' THEN
						curState <= Detect1;
					END IF;
				WHEN Detect1 =>
					IF w = '0' THEN
						curState <= Detect10;
					END IF;
				WHEN Detect10 =>
					IF w = '1' THEN
						curState <= Detect101;
					ELSE
						curState <= start;
					END IF;
				WHEN Detect101 =>
					IF w = '0' THEN
						curState <= Detect10;
					ELSE
						curState <= Detect1;
					END IF;
				WHEN others =>
					curState <= start;
				END Case;
			End IF;
		END PROCESS;
					