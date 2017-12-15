-------------------------------------------------------------------------------
-- (Behavioral)
--
-- File name : negative_full_scale_detector.vhdl
-- Purpose   : Detects negative full scale input
--           
-- Library   : IEEE
-- Author(s) : Alessandro Martinelli
--
-- Simulator : Synopsys VSS v. 1999.10, on SUN Solaris 8
-------------------------------------------------------------------------------
-- Revision List
-- Version      Author  Date            	Changes
--
-- 1.0          AMarti  24 september 2017   New version
-- 1.1          AMarti  26 september 2017   Clock and reset added
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY negative_full_scale_detector is
	generic (N : INTEGER:=10);
	port( 
		a         	: in  std_logic_VECTOR (N-1 downto 0);
		b         	: in  std_logic_VECTOR (N-1 downto 0);
		invalid		: out std_logic;
		clock		: in  std_logic;
		reset		: in  std_logic);
END negative_full_scale_detector;

architecture BEHAVIOURAL of negative_full_scale_detector is
BEGIN
	VALIDITY_CHECK:process(clock)
	variable NEGATIVE_FULL_SCALE:std_logic_VECTOR (N-1 downto 0);
	begin
		IF (clock'EVENT AND clock='1') THEN
			NEGATIVE_FULL_SCALE(N-1) := '1';
			FOR i IN 0 TO N-2 LOOP	
				NEGATIVE_FULL_SCALE(i) := '0';
	   		END LOOP;	   
			if ((a = NEGATIVE_FULL_SCALE) OR (b = NEGATIVE_FULL_SCALE) OR (reset = '0')) then invalid <= '1'; else invalid <= '0';
			end if;
		END IF;
	END process VALIDITY_CHECK;
END BEHAVIOURAL;   

-- In questo modulo potrebbero andarci i controlli del tipo "se non e' passato abbastanza tempo
-- dal clock/reset, il risultato è non significativo.
