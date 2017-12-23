LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- This module takes an n bit natural number as input and
-- increments it only if carry_in is set. It does not have a
-- carry_out bit, since it has been developed for a project
-- where carry_out cannot occur.
ENTITY incrementer is
	generic (N : INTEGER:=10);
	port(	input		: in  std_logic_VECTOR (N-1 downto 0);
       	 	carry_in   	: in  std_logic;
		 	sum         : out std_logic_VECTOR (N-1 downto 0)
		);
END incrementer;

architecture BEHAVIOURAL of incrementer is
BEGIN
	SUM_PROCESS:process(input, carry_in)	
	
	-- Stores the carry out produced in the previous step, 
	-- to be used as carry_in in the subsequent step
	variable C:std_logic;
	begin
			C := carry_in;
			FOR i IN 0 TO N-1 LOOP
				-- Calculates bit sum using carry from
				-- previous step, then carry out
	       		sum(i) <= input(i) XOR C;
	       		C := input(i) AND C;
	   		END LOOP;			   
	END process SUM_PROCESS;
END BEHAVIOURAL;
