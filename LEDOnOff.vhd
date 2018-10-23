LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Lab5 IS
	PORT (Power, Decide, Clock, Switch0, Switch1		: IN	STD_LOGIC;
			LED	 	: OUT	STD_LOGIC_VECTOR (0 to 3) );
END Lab5;

ARCHITECTURE behavior OF Lab5 IS
	SIGNAL SignalYes, SignalNo	: STD_LOGIC;
	

BEGIN
	PROCESS (Switch0, Switch1, Power)
	BEGIN
		If Switch0 = '1' THEN
			LED(0) <= SignalYes;
			LED(1) <= '0';
		Else
			LED(0) <= '0';
			LED(1) <= SignalYes;
		End If;
		
		IF Switch1 = '1' THEN
			LED(2) <= SignalNo;
			LED(3) <= '0';
		Else
			LED(2) <= '0';
			LED(3) <= SignalNo;
		End If;
	
	End Process;
			
	PROCESS (Clock, Power, Decide)
	BEGIN
		If Power = '0' THEN
			IF Decide = '1' THEN
				SignalYes <= Clock;
				SignalNo <= NOT(Clock);	
			END IF;
		Else
			SignalYes <= '0';
			SignalNo <= '0';
		END IF;
	END PROCESS;
END behavior;

	
