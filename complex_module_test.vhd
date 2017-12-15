-------------------------------------------------------------------------------
-- TestBench(adder)
--
-- File name : adder_test.vhdl
-- Purpose   : Generates stimuli
--           :
-- Library   : IEEE
-- Author(s) : Luca Fanucci
-- Copyrigth : CSMDR-CNR 2001. No part may be reproduced
--           : in any form without the prior written permission by CNR.
--
-- Simulator : Synopsys VSS v. 1999.10, on SUN Solaris 8
-------------------------------------------------------------------------------
-- Revision List
-- Version      Author  Date            Changes
--
-- 1.0          LFanu   24 April 2001   New version
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY complex_module_tb IS
END complex_module_tb;

ARCHITECTURE complex_module_test OF complex_module_tb IS
	COMPONENT complex_module
	generic (N : INTEGER:=10);
   	port( 
	   	real_part		: in  std_logic_VECTOR (N-1 downto 0);	
	   	imaginary_part	: in  std_logic_VECTOR (N-1 downto 0);	
	    invalid_result	: out std_logic;
		module			: out std_logic_VECTOR (N-1 downto 0);
		clock			: in  std_logic;
		reset			: in  std_logic);
	END COMPONENT;

	----------------------------------------------------------------------------
	CONSTANT N       :  INTEGER  := 10;       -- Bus Width			  		-- TODO l'ho portato da 5 a 10
	CONSTANT MckPer  :  TIME     := 200 ns;  -- Master Clk period
	CONSTANT TestLen :  INTEGER  := 100;      -- No. of Count (MckPer/2) for test

-- I N P U T     S I G N A L S	
	SIGNAL	 rst					: std_logic := '1';
	SIGNAL   clk  					: std_logic := '0';
	SIGNAL   real_part_test    		: std_logic_VECTOR (N-1 downto 0):="0011011001";
	SIGNAL   imaginary_part_test    : std_logic_VECTOR (N-1 downto 0):="1101001101";

-- O U T P U T     S I G N A L S
	SIGNAL   invalid_result_test	: std_logic;
	SIGNAL   complex_module_test    : std_logic_VECTOR (N-1 downto 0);

	SIGNAL	 clk_cycle	: INTEGER;
	SIGNAL	 Testing	: Boolean := True;

BEGIN
   I : complex_module GENERIC MAP(N=>10)
             PORT MAP(real_part_test,imaginary_part_test,invalid_result_test,complex_module_test,clk,rst);

	----------------------------------------------------------------------------

	-- Generates clk
	clk <= NOT clk AFTER MckPer/2 WHEN Testing ELSE '0';

   -- Runs simulation for TestLen cycles;
   Test_Proc: PROCESS(clk)
      VARIABLE count: INTEGER:= 0;
   BEGIN
     clk_cycle <= (count+1)/2;

     CASE count IS
		  WHEN  11  => real_part_test <= "0000011100"; imaginary_part_test <= "0000010111";	
		  WHEN  21  => real_part_test <= "1010001010"; imaginary_part_test <= "1000000000";
          WHEN  31  => real_part_test <= "1111100000"; imaginary_part_test <= "1111111111";
		  WHEN  41  => real_part_test <= "1101100000"; imaginary_part_test <= "1001001111";
          WHEN  51  => real_part_test <= "1010101010"; imaginary_part_test <= "0100100010"; 
		  WHEN  61  => rst <= '0';
		  WHEN  71  => rst <= '1'; real_part_test <= "1010101010"; imaginary_part_test <= "0100100010";

          WHEN (TestLen - 1) =>   Testing <= False;
          WHEN OTHERS => NULL;
     END CASE;

     count:= count + 1;
   END PROCESS Test_Proc;

END complex_module_test;
