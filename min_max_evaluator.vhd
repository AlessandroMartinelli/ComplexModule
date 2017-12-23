LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- This module takes two n bit natural number as input 
-- and outputs the higher one as 'max', the lower one as 'min'.
-- The distinction is made by means of a subtractor. If there is
-- a borrow, the number used as subtrahend is the greater one,
-- otherwise the one taken as maximum is the minuend.
ENTITY min_max_evaluator is
	generic (N : INTEGER:=10);
   	port( 
		x	: in  std_logic_VECTOR (N-1 downto 0);	
   		y	: in  std_logic_VECTOR (N-1 downto 0);	 
		max	: out std_logic_VECTOR (N-1 downto 0);
		min	: out std_logic_VECTOR (N-1 downto 0)
	);
END min_max_evaluator;   	 


ARCHITECTURE STRUCTURAL OF min_max_evaluator IS
	COMPONENT subtractor
	generic (N : INTEGER:=10);
   	port( 
		minuend		: in  std_logic_VECTOR (N-1 downto 0);	
   		subtrahend	: in  std_logic_VECTOR (N-1 downto 0);	 
		borrow_in	: in  std_logic; 
		difference	: out std_logic_VECTOR (N-1 downto 0);	 
		borrow_out	: out std_logic);	
   END COMPONENT;
   
-- The borrow out of the subtractor is used as command in order
-- to decide which one of the inputs is the greater one. 
signal tristate_cmd : std_logic;

-- The subtractor. The interesting value borrow_out, who tell us
-- which one of the inputs is the greater one, 
-- while 'difference' gives us no information on this aspect.
begin		    
	I_subtractor:subtractor generic map(N=>N)
		port map (	minuend		=>x, 
					subtrahend	=>y, 
					borrow_in	=>'0',
					difference	=>open, 
					borrow_out	=>tristate_cmd);	
					
	max <= x when (tristate_cmd = '0') else y;
	min <= y when (tristate_cmd = '0') else x;	
end STRUCTURAL;	

