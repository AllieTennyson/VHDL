LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY VendingMachine IS
PORT( w				: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		clock, reset: IN STD_LOGIC;
		dispense				: OUT STD_LOGIC);
END VendingMachine;

ARCHITECTURE BEHAVIOR OF VendingMachine IS
	TYPE StateType IS  (none, detect10, detect20, detect25, detect30, detect35, detect40, detect45, detect50, dispenseState);
	SIGNAL curState : StateType;
BEGIN
	PROCESS(clock, reset, w)
	BEGIN
		IF reset = '0' THEN
			curState <= none;
		ELSIF RISING_EDGE(clock) THEN
			CASE curState IS
				--10/25 cents
				WHEN none =>
					IF w = "01" THEN
						curState <= detect10;
					ELSIF w = "10" THEN
						curState <= detect25;
					END IF;
				--1020/2535 cents
				WHEN detect10 =>
					IF w = "01" THEN
						curState <= detect20;
					ELSIF w = "10" THEN
						curState <= detect35;
					END IF;
				--1030/2545 cents
				WHEN detect20 =>
					IF w = "01" THEN
						curState <= detect30;
					ELSIF w = "10" THEN
						curState <= detect45;
					END IF;
				--1040/2550 cents
				WHEN detect30 =>
					IF w = "01" THEN
						curState <= detect40;
					ELSIF w = "10" THEN
						curState <= detect50;
					END IF;
				--1050/25dispense cents
				WHEN detect40 =>
					IF w = "01" THEN
						curState <= detect50;
					ELSIF w = "10" THEN
						curState <= dispenseState;
					END IF;
				--2535/2550 cents
				WHEN detect25 =>
					IF w = "01" THEN
						curState <= detect35;
					ELSIF w = "10" THEN
						curState <= detect50;
					END IF;
				--2545/25dispense cents
				WHEN detect35 =>
					IF w = "01" THEN
						curState <= detect45;
					ELSIF w = "10" THEN
						curState <= dispenseState;
					END IF;
				--2550/25dispense cents
				WHEN detect45 =>
					IF w = "01" THEN
						curState <= detect50;
					ELSIF w = "10" THEN
						curState <= dispenseState;
					END IF;
				--25dispense/25dispense
				WHEN detect50 =>
					IF w = "01" THEN
						curstate <= dispenseState;
					ELSIF w = "10" THEN
						curState <= dispenseState;
					END IF;
				WHEN dispenseState =>
					IF w = "01" THEN
						curState <= detect10;
					ELSIF w = "10" THEN
						curState <= detect25;
					END IF;
				WHEN others =>
					curState <= none;
				END Case;
			End IF;
		END PROCESS;
		dispense <= '1' WHEN curState = dispenseState
			else '0';
	END BEHAVIOR;