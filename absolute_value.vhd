LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- This module takes a n bit 2-complement integer number and
-- calculates its absolute value on n-1 bits. With n-1 bit 
-- the absolute value of the negative full scale 
-- is not representable. This is acceptable for the purpose 
-- of this project, where the input is assumed to be simmetric, 
-- i.e. between [-2^(n-1)-1, 2^(n-1)-1].
ENTITY absolute_value is
	generic (N : INTEGER:=10);
   	port( 
		integer_input	: in  std_logic_VECTOR (N-1 downto 0);		
		absolute_value	: out std_logic_VECTOR (N-2 downto 0)
	);
END absolute_value;   	 

ARCHITECTURE MIXED OF absolute_value IS	  
-- The absolute value module performs two operations: 
-- (1) a bit-wise xor on each bit of the input with the first bit 
-- of the input (in other words, inverts the input if 
-- the first bit of the input is 1, otherwise the input is 
-- unchanged (2) the resulting value is incremented only if 
-- the first bit of the input was originally 1. This operation 
-- is done by means of a dedicated component, called incrementer.
	
COMPONENT incrementer
	generic (N : INTEGER:=10);
	port(	input     	: in  std_logic_VECTOR (N-1 downto 0);
       	 	carry_in   	: in  std_logic;
		 	sum         : out std_logic_VECTOR (N-1 downto 0)
	);
END COMPONENT;
   
-- Stores the input after it has been (possibly) inverted.   
signal xored_input: std_logic_VECTOR (N-1 downto 0);				  

-- Stores the output of the incrementer before its msb bit 
-- is discarded (since the 'absolute_value' module outputs
-- a natural number on n-1 bits)
signal sum_to_absolute_value : std_logic_VECTOR (N-1 downto 0);	 

-- Stores the most significant bit of the input
signal increment : std_logic;
   
BEGIN		  
	-- The incrementer; the most significant bit of the input 
	-- (incrementer) is used as carry_in, thus the value 
	-- coming from the xor barrier is actually incremented
	-- only if msb = '1'. The 'xored_input' has the first bit 
	-- always set to '0', so carry out can never occur.
	I_incrementer:incrementer generic map(N=>N)
		port map (	input 		=> xored_input, 
					carry_in	=> increment, 
					sum 		=> sum_to_absolute_value
		);		
		
	-- assign to the 'absolute_value' output the n-1 
	-- less significant bit of the incrementer output		
	absolute_value <= sum_to_absolute_value(N-2 downto 0);		
	
	ABS_PROCESS:process(integer_input)	 
	-- the most significant bit of the input, like 'increment'
	variable msb: std_logic;	
	begin	 
		msb := integer_input(N-1);	
		-- bit-wise xor
		FOR i IN 0 TO N-1 LOOP
			xored_input(i) <= (integer_input(i) XOR msb);
		END LOOP;	
		increment <= msb;
	END process ABS_PROCESS;
end MIXED; 