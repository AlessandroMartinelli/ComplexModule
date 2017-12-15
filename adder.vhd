-------------------------------------------------------------------------------
-- (Behavioral)
--
-- File name : adder.vhdl
-- Purpose   : Synchronized N bit Ripple Carry Adder
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

-- This module takes two n bit numbers and a carry_in bit as input 
-- and outputs the sum on n bit of the inputs and a bit 
-- indicating whether there has been overflow or not (carry_out)
ENTITY adder is
	generic (N : INTEGER:=10);
	port(	
		input_a   	: in  std_logic_VECTOR (N-1 downto 0);
		input_b   	: in  std_logic_VECTOR (N-1 downto 0);
       	carry_in	: in  std_logic;
		sum       	: out std_logic_VECTOR (N-1 downto 0);
		carry_out	: out std_logic;
		clock		: in  std_logic;
		reset		: in  std_logic);
END adder;

architecture BEHAVIOURAL of adder is
BEGIN
	SUM_PROCESS:process(clock) 
	-- Variable used to store the carry produced as carry out in the 
	-- previous step, to be used as carry_in in the next step
	variable C:std_logic;
	begin		  
		IF (clock'EVENT AND clock='1') THEN
			C := carry_in; 
			FOR i IN 0 TO N-1 LOOP 
				-- When reset input is reset the output is 0.
	       		-- Otherwise calculates bit sum using carry from previous step, then carry out
	       		sum(i)<= reset AND (input_a(i) XOR input_b(i) XOR C);
	       		C:= reset AND ((input_a(i) AND input_b(i)) OR (input_a(i) AND C) OR (input_b(i) AND C));
   			END LOOP; 
			carry_out <= C;
		END IF;
	END process SUM_PROCESS;
END BEHAVIOURAL;
