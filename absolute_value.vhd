-------------------------------------------------------------------------------
-- (Behavioral)
--
-- File name : absolute_value.vhdl
-- Purpose   : Calculate the absolute value of a 2-complement signed number.
--           :
-- Library   : IEEE
-- Author(s) : Alessandro Martinelli
--
-- Simulator : Synopsys VSS v. 1999.10, on SUN Solaris 8
-------------------------------------------------------------------------------
-- Revision List
-- Version      Author  Date            	Changes
--
-- 1.0          AMarti  24 September 2017   New version
-- 1.0          AMarti  26 September 2017   Clock and reset added
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- This module takes an integer number represented in 2-complement on n bit and
-- calculates its absolute value. In order to represent even the absolute value
-- of the negative full scale (-2^(n-1)), the output requires n bit, too.
-- With n-1 bit the absolute value of the negative full scale is not representable.
ENTITY absolute_value is
	generic (N : INTEGER:=10);
   	port( 
		integer_input	: in  std_logic_VECTOR (N-1 downto 0);		
		absolute_value	: out std_logic_VECTOR (N-2 downto 0)
	);
END absolute_value;   	 

ARCHITECTURE STRUCTURAL OF absolute_value IS
-- The absolute value module make use of 2 submodules, a complementer and an adder;
-- If the number is positive (integer_input(0) = '0'), the output is the input unchanged.
-- If instea the number is negative (integer_input(0) = '1'), the output is the
-- input complemented and incremented by 1. This is done wiring integer_input(0) both with
-- the "cmd" wire of complementer and the "carry_in" wire of incrementer.
	COMPONENT first_bit_xor 
	generic (N : INTEGER:=10);
	port(	input	: in  std_logic_VECTOR (N-1 downto 0);
       	  	cmd		: in  std_logic;
		  	output	: out std_logic_VECTOR (N-1 downto 0)
	);
	END COMPONENT;
	
	COMPONENT incrementer
		generic (N : INTEGER:=10);
		port(	input     	: in  std_logic_VECTOR (N-1 downto 0);
	       	 	carry_in   	: in  std_logic;
			 	sum         : out std_logic_VECTOR (N-1 downto 0)
		);
	END COMPONENT;
	   
	-- Stores the value of the input after it has been (possibly) complemented.   
	signal xored_input: std_logic_VECTOR (N-1 downto 0);				  
	
	-- Stores the value of the most significant bit of the input, i.e. the sign of the number
	signal msb: std_logic;	  
	
	-- Stores the output of the incrementer before its first bit is discarded
	-- in order to link the 'absolute_value' output to the N-1 less significant bit of the incrementer output
	signal sum_to_absolute_value : std_logic_VECTOR (N-1 downto 0);
	   
	BEGIN		   
		I_first_bit_xor:first_bit_xor generic map(N=>N)
			port map (	input 		=> integer_input, 
						cmd			=> msb, 
						output 		=> xored_input
			);	
		
		-- The incrementer; the most significant bit of the input (msb) is used as
		-- carry_in, thus the value coming from the xor barrier is actually incremented
		-- only if msb = '1'. The 'xored_input' has the first bit always set to '0', 
		-- so carry out can never occur.
		I_incrementer:incrementer generic map(N=>N)
			port map (	input 		=> xored_input, 
						carry_in	=> msb, 
						sum 		=> sum_to_absolute_value
			);		
			
		-- assign to the 'absolute_value' output only the N-1 less significant bit of the incrementer output		
		absolute_value <= sum_to_absolute_value(N-2 downto 0);		
			
		-- stores the sign of the integer input		
		msb <= integer_input(N-1);	
		
		-- The first xor is always between msb and itself, thus the result is always 0
		--xored_input(N-1) <= '0';	
	
		-- The first bit of the input is considered. If 0, the input number is positive
		-- and nothing has to be done (the output corresponds to the input). 
		-- Otherwise the input number has to be complemented and incremented by 1.	
end STRUCTURAL;	

