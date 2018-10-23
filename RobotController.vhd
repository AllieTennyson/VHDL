LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY RobotController IS
	PORT ( 	Clock		: IN STD_LOGIC;
				Reset		: IN STD_LOGIC;
				Data		: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
				Ready		: OUT STD_LOGIC;
				Ack		: IN	STD_LOGIC;
				LED		: OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
			);
END RobotController;

ARCHITECTURE behavior OF RobotController IS
	TYPE STATE_TYPE IS (Start, SendCommand1, SendCommand2, WaitForCommandDone, WaitForCommandDoneReset, Done);
	SIGNAL State		: STATE_TYPE;
	SIGNAL NextState	: STATE_TYPE;
	SIGNAL InterfaceEnable: STD_LOGIC;
	SIGNAL CmdToSend 	: STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL DataToSend : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL DataReceived : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL ExpectedResult : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL CmdDone		: STD_LOGIC;
	SIGNAL clk1k		: STD_LOGIC;
	SIGNAL clk100		: STD_LOGIC;
	
	COMPONENT INTERFACE
		PORT(	Clock		: IN STD_LOGIC;
				Enable	: IN STD_LOGIC;
				CmdToSend: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				DataToSend: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
				ReturnData: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				Data		: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
				Ready		: OUT STD_LOGIC;
				Ack		: IN	STD_LOGIC;
				CmdDone	: OUT STD_LOGIC;
				LED		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT clk_div
		PORT(clock_48Mhz			: IN	STD_LOGIC;
			 clock_1MHz				: OUT	STD_LOGIC;
			 clock_100KHz			: OUT	STD_LOGIC;
			 clock_10KHz			: OUT	STD_LOGIC;
			 clock_1KHz				: OUT	STD_LOGIC;
			 clock_100Hz			: OUT	STD_LOGIC;
			 clock_10Hz				: OUT	STD_LOGIC;
			 clock_1Hz				: OUT	STD_LOGIC);
	END COMPONENT;

	
BEGIN
	FEATHER: INTERFACE PORT MAP (clk1k, InterfaceEnable, CmdToSend, DataToSend, DataReceived, Data, Ready, Ack, CmdDone, LED(7 DOWNTO 0));	
	CLK : clk_div PORT MAP (clock_48Mhz => Clock, clock_1KHz => clk1k, clock_100hz => clk100);

	PROCESS (clk100, Reset)
	BEGIN
		IF RESET = '0' THEN
			State <= Start;
		ELSIF RISING_EDGE(clk100) THEN
			CASE State IS
				WHEN Start =>
					InterfaceEnable <= '0';
					LED(9) <= '0';
					CmdToSend <= X"00";
					
					State <= SendCommand1;
					
				WHEN SendCommand1 =>
					CmdToSend <= X"F8";
					DataToSend <= X"02";
					ExpectedResult <= X"A5";
					NextState <= SendCommand2;
					State <= WaitForCommandDone;
					InterfaceEnable <= '1';

				WHEN SendCommand2 =>
					CmdToSend <= X"F9";
					DataToSend <= X"04";
					ExpectedResult <= X"5A";
					NextState <= SendCommand1;
					State <= WaitForCommandDone;
					InterfaceEnable <= '1';

						-- Wait for Feather to signal that command is completed and result returned
				WHEN WaitForCommandDone =>
					IF CmdDone = '1' THEN
						IF NOT (ExpectedResult = DataReceived) THEN	
							LED(9) <= '1';
						END IF;
							-- Disable Feather interface
						InterfaceEnable <= '0';
						State <= WaitForCommandDoneReset;
							-- Validate result data
					END IF;

						-- Wait for CmdDone to return to 0 before sending next command
				WHEN WaitForCommandDoneReset =>
					IF CmdDone = '0' THEN
						State <= NextState;
					END IF;

						-- Repeat with another command, data, and expected result
				WHEN Done =>
					State <= Done;
					
				WHEN OTHERS =>
					State <= Done;
						
			END CASE;
		END IF;
	END PROCESS;	
END behavior;


