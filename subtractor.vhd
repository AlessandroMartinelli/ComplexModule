-------------------------------------------------------------------------------
-- (Behavioral)
--
-- File name : subtractor.vhdl
-- Purpose   : Synchronized N bit Ripple Borrow Subtractor
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

-- This module takes two n bit numbers and a borrow_in bit as input 
-- and outputs the difference on n bit of the inputs and a bit 
-- indicating whether there has been a final borrow or not (borrow_out)
ENTITY subtractor is
	generic (N : INTEGER:=10);
   	port( 
		minuend		: in  std_logic_VECTOR (N-1 downto 0);	
   		subtrahend	: in  std_logic_VECTOR (N-1 downto 0);	 
		borrow_in	: in  std_logic; 
		difference	: out std_logic_VECTOR (N-1 downto 0);	 
		borrow_out	: out std_logic;
		clock		: in  std_logic;
		reset		: in  std_logic);	 
END subtractor;   	 

ARCHITECTURE STRUCTURAL OF subtractor IS
	COMPONENT adder
	generic (N : INTEGER:=10);
	port(	input_a   	: in  std_logic_VECTOR (N-1 downto 0);
		  	input_b   	: in  std_logic_VECTOR (N-1 downto 0);
       	  	carry_in	: in  std_logic;
			sum       	: out std_logic_VECTOR (N-1 downto 0);
		  	carry_out	: out std_logic;
			clock		: in  std_logic;
			reset		: in  std_logic);
   END COMPONENT;
   
-- A subtractor may be implemented using an adder and passing as carry_in 
-- borrow_in complemented, as input_b the subtrahend complemented, and 
-- complementing carry_out in order to obtain borrow_out.
signal complemented_subtrahend: std_logic_VECTOR (N-1 downto 0);
signal complemented_borrow_in: std_logic;
signal complemented_borrow_out: std_logic;
   
begin		   
	complemented_subtrahend(N-1 downto 0) <= NOT subtrahend(N-1 downto 0);
	complemented_borrow_in <= NOT borrow_in;   
	I_adder:adder generic map(N=>N)
		port map (	input_a		=>minuend, 
					input_b		=>complemented_subtrahend, 
					carry_in	=>complemented_borrow_in, 
					sum			=>difference, 
					carry_out	=>complemented_borrow_out,
					clock		=>clock,
					reset		=>reset);	
	borrow_out <= NOT complemented_borrow_out;					
end STRUCTURAL;	

