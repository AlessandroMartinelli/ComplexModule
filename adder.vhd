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
		carry_out	: out std_logic
	);
END adder;

architecture BEHAVIOURAL of adder is
BEGIN
	SUM_PROCESS:process(input_a, input_B, carry_in) 
	-- Stores the carry out of the previous step,
	-- to be used as carry_in in the next step
	variable C:std_logic;
	begin		  
			C := carry_in; 
			FOR i IN 0 TO N-1 LOOP
				-- Calculates bit sum using carry from
				-- previous step, then carry out
	       		sum(i)<= input_a(i) XOR input_b(i) XOR C;
	       		C:= (input_a(i) AND input_b(i)) OR 
				   (input_a(i) AND C) OR (input_b(i) AND C);
   			END LOOP; 
			carry_out <= C;
	END process SUM_PROCESS;
END BEHAVIOURAL;
