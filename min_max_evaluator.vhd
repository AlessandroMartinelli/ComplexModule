-------------------------------------------------------------------------------
-- (min_max_evaluator)
--
-- File name : min_max_evaluator.vhdl
-- Purpose   : Absolute value evaluator
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

-- This module takes two n bit number in input and outputs the
-- higher of them on one wire, the lower one on the other wire.
-- The distinction is made by means of a subtractor. If there is
-- a borrow in, the number used as subtrahend is the greater;
-- otherwise the minuend is taken as maximum.
ENTITY min_max_evaluator is
	generic (N : INTEGER:=9);
   	port( 
		x	: in  std_logic_VECTOR (N-1 downto 0);	
   		y	: in  std_logic_VECTOR (N-1 downto 0);	 
		max	: out std_logic_VECTOR (N-1 downto 0);
		min	: out std_logic_VECTOR (N-1 downto 0);
		clk : in  std_logic;
		rst : in  std_logic);
END min_max_evaluator;   	 


ARCHITECTURE STRUCTURAL OF min_max_evaluator IS
	COMPONENT subtractor
	generic (N : INTEGER:=10);
   	port( 
		minuend		: in  std_logic_VECTOR (N-1 downto 0);	
   		subtrahend	: in  std_logic_VECTOR (N-1 downto 0);	 
		borrow_in	: in  std_logic; 
		difference	: out std_logic_VECTOR (N-1 downto 0);	 
		borrow_out	: out std_logic;
		clock		: in  std_logic;
		reset		: in  std_logic);	
   END COMPONENT;
   
-- The borrow out of the subtractor is used as command in order
-- to decide which one of the inputs is the greater. 
signal tristate_cmd : std_logic;

-- The subtractor. What is of interest is borrow_out, stating 
-- which of the input is greater, while 'difference' gives no information
-- about this.
begin		    
	I_subtractor:subtractor generic map(N=>N)
		port map (	minuend		=>x, 
					subtrahend	=>y, 
					borrow_in	=>'0',
					difference	=>open, 
					borrow_out	=>tristate_cmd,
					clock		=>clk,
					reset		=>rst);	
					
	max <= x when (tristate_cmd = '0') else y;
	min <= y when (tristate_cmd = '0') else x;	
end STRUCTURAL;	

