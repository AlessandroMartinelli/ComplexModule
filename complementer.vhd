-------------------------------------------------------------------------------
-- (Behavioral)
--
-- File name : complementer.vhdl
-- Purpose   : Performs single bit complement IF cmd variable is set
--           
-- Library   : IEEE
-- Author(s) : Alessandro Martinelli
--
-- Simulator : Synopsys VSS v. 1999.10, on SUN Solaris 8
-------------------------------------------------------------------------------
-- Revision List
-- Version      Author  Date            	Changes
--
-- 1.0          AMarti  23 september 2017   New version
-- 1.1          AMarti  25 september 2017   Clock and reset added
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- This module takes an n bit string in input and performs
-- a single-bit complement if cmd input is set. 
-- Otherwise it does nothing.	
ENTITY complementer is
	generic (N : INTEGER:=10);
	port(	input	: in  std_logic_VECTOR (N-1 downto 0);
       	  	cmd		: in  std_logic;
		  	output	: out std_logic_VECTOR (N-1 downto 0);
		  	clock	: in  std_logic;
			reset	: in  std_logic);
END complementer;

architecture BEHAVIOURAL of complementer is
BEGIN
	COMPLEMENT_PROCESS:process(clock)
	begin	
		IF (clock'EVENT AND clock='1') THEN
			FOR i IN 0 TO N-1 LOOP
				-- When reset input is reset the output is 0. 
				-- Otherwise xor operations are performed
				output(i) <= reset AND (input(i) XOR cmd);
	   		END LOOP; 
		END IF;
	END process COMPLEMENT_PROCESS;
END BEHAVIOURAL;
