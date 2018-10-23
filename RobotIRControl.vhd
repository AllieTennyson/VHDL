LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY RobotIRControl
	PORT ( 	Clock		: IN STD_LOGIC;
				Reset		: IN STD_LOGIC;
				IRInput 	: IN STD_LOGIC;	
				LED    	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				Output   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				TestOut	: OUT STD_LOGIC);
END RobotIRControl;
	
ARCHITECTURE BEHAVIOR OF RobotIRControl IS
	TYPE STATE_TYPE IS (Start, Low_Count, Get_Bits, Done, Half);
	SIGNAL State : STATE_TYPE;
	SIGNAL clk100KHz   : STD_LOGIC;
	SIGNAL CountLow : INTEGER RANGE 0 to 32000;
	SIGNAL CurCount : IntEGER Range 0 to 32000;
	SIGNAL bits : INTEGER Range 0 TO 8;
	SIGNAL Info : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL TestOut_2 : STD_LOGIC;
	
	COMPONENT clk_div
	PORT(clock_48Mhz			: IN	STD_LOGIC;
			clock_1MHz			: OUT	STD_LOGIC;
			clock_100KHz		: OUT	STD_LOGIC;
			clock_10KHz			: OUT	STD_LOGIC;
			clock_1KHz			: OUT	STD_LOGIC;
			clock_100Hz			: OUT	STD_LOGIC;
			clock_10Hz			: OUT	STD_LOGIC;
			clock_1Hz			: OUT	STD_LOGIC);
	END COMPONENT;
	
	BEGIN	
	CLK : clk_div PORT MAP (clock_48Mhz => Clock, clock_100KHz => clk100KHz);
	--clk100KHZ <= clock;
	LED <= Info;
	TestOut <= TestOut_2;
	
	
	PROCESS (clk100KHz, Reset)
	BEGIN
		IF Reset = '0' THEN
			State <= Start;
			Info <= X"00";
		ELSIF RISING_EDGE(clk100KHZ) THEN
			CASE State IS
				WHEN Start =>
					IF IRInput = '0' THEN
						CountLow <= 0;
						State <= Low_Count;
						TestOut_2 <= '0';
					END IF;
			 
				WHEN Low_Count =>
					CountLow <= CountLow + 1;
					IF IRInput = '1' THEN
						CurCount <= 0;
						bits <= 0;
						Info <= X"00";
						state <= Half;
						countLow <= (countLow * 9) / 10;
					END IF;
				
				WHEN Half =>
					curCount <= curCount + 1;
					IF CurCount = CountLow / 2 THEN
						bits <= bits + 1;
						TestOut_2 <= NOT TestOut_2;
						Info(6) <= IRInput;
						state <= Get_Bits;
						curCount <= 0;
					END IF;
					
				WHEN Get_Bits =>
					curCount <= curCount + 1;
					IF CurCount = CountLow THEN
						bits <= bits + 1;
						TestOut_2 <= NOT TestOut_2;
						Info(6-bits) <= IRInput;
						curCount <= 0;
						IF Bits = 6 THEN
							State <= Done;
						END IF;	
					END IF;
	
				WHEN Done => NULL;
					IF IRinput = '1' THEN
						Output <= Info;
						State <= Start;
					END IF;
					
				WHEN others =>
					State <= start;
				END Case;
		End IF;
	END PROCESS;
	
	
End ArcHITECTURE;	