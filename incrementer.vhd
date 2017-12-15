-------------------------------------------------------------------------------
-- (Behavioral)
--
-- File name : incrementer.vhdl
-- Purpose   : Synchronized N bit Ripple Carry Incrementer
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
-- 1.1          AMarti  26 september 2017   Clock and reset added
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY incrementer is
	generic (N : INTEGER:=10);
	port(	input		: in  std_logic_VECTOR (N-1 downto 0);
       	 	carry_in   	: in  std_logic;
		 	sum         : out std_logic_VECTOR (N-1 downto 0); 
			carry_out	: out std_logic
		);
END incrementer;

architecture BEHAVIOURAL of incrementer is
BEGIN
	SUM_PROCESS:process(input, carry_in)	
	
	-- Variable used to store the carry out produced in the 
	-- previous step, to be used as carry_in in the subsequent step
	variable C:std_logic;
	begin
			C := carry_in;
			FOR i IN 0 TO N-1 LOOP
	       		-- Calculates bit sum using carry from previous step, then carry out
	       		sum(i) <= input(i) XOR C;
	       		C := input(i) AND C;
	   		END LOOP;			   
			carry_out <= C;
	END process SUM_PROCESS;
END BEHAVIOURAL;
