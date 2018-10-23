LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Interface IS
	PORT ( 	Clock		: IN STD_LOGIC;
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
END Interface;

ARCHITECTURE behavior OF Interface IS
	TYPE STATE_TYPE IS (Start, Wait_Ack_High_1, Wait_Ack_High_2, Wait_Ack_High_3, Wait_Ack_Low_1, Wait_Ack_Low_2,
								Wait_Ack_Low_3, Wait_Enable_Low);
	SIGNAL State	: STATE_TYPE;

BEGIN

	PROCESS (Clock, Enable, Ack)
	BEGIN
		IF RISING_EDGE(Clock) THEN
			CASE State IS
				WHEN Start =>
					LED <= X"00";

					LED(0) <= '1';
					Ready <= '0';
					CmdDone <= '0';
				
					IF (Enable = '1') THEN
						Data <= CmdToSend;
						Ready <= '1';
						State <= Wait_Ack_high_1;
					END IF;
				-- TODO -- Put in new states to implement Robot WiFi Interface Specification
				
				WHEN Wait_Ack_high_1 =>
					LED(1) <= '1';
					LED(0) <= '0';
					
					IF (Ack = '1') THEN
						Ready <= '0';
						State <= Wait_Ack_Low_1;
					END IF;
					
				WHEN Wait_Ack_low_1 =>
					LED(2) <= '1';
					
					IF (Ack = '0') THEN
						Data <= DataToSend;
						Ready <= '1';
						State <= Wait_Ack_High_2;
					END IF;
					
				WHEN Wait_Ack_High_2 =>
					LED(3) <= '1';
					
					IF (ACK = '1') THEN
						Data <= "ZZZZZZZZ";
						Ready <= '0';
						State <= Wait_Ack_Low_2;
					END IF;
					
				WHEN Wait_Ack_Low_2 =>

					LED(4) <= '1';

					IF (Ack = '0') THEN
						State <= Wait_Ack_High_3;
					END IF;
					
				WHEN Wait_Ack_High_3 =>
					LED(5) <= '1';
					
					IF (Ack = '1') THEN
							ReturnData <= Data;
							State <= Wait_Ack_Low_3;
					END IF;
					
 				WHEN Wait_Ack_Low_3 =>
					LED(6) <= '1';
										
					IF (Ack = '0') THEN
						CmdDone <= '1';
						State <= Wait_Enable_Low;
					END IF;
					
				WHEN Wait_Enable_low =>
					LED(7) <= '1';
					
					IF (Enable = '0') THEN
						State <= Start;
					END IF;

				WHEN OTHERS =>
					State <= Start;
						
			END CASE;
		END IF;
	END PROCESS;	
	
END behavior;