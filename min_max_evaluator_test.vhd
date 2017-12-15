						   								-------------------------------------------------------------------------------
-- TestBench(min_max_evaluator)
--
-- File name : min_max_evaluator_test.vhdl
-- Purpose   : Generates stimuli
--           :
-- Library   : IEEE
-- Author(s) : Alessandro Martinelli
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

ENTITY min_max_evaluator_tb IS
END min_max_evaluator_tb;

ARCHITECTURE max_min_evaluator_test OF min_max_evaluator_tb IS
	COMPONENT min_max_evaluator
	generic (N : INTEGER:=9);
   	port( 
		x	: in  std_logic_VECTOR (N-1 downto 0);	
   		y	: in  std_logic_VECTOR (N-1 downto 0);	 
		max	: out std_logic_VECTOR (N-1 downto 0);
		min	: out std_logic_VECTOR (N-1 downto 0);
		clk : in  std_logic;
		rst : in  std_logic);
	END COMPONENT;

	----------------------------------------------------------------------------
	CONSTANT N       :  INTEGER  := 5;       -- Bus Width
	CONSTANT MckPer  :  TIME     := 200 ns;  -- Master Clk period
	CONSTANT TestLen :  INTEGER  := 40;      -- No. of Count (MckPer/2) for test

-- I N P U T     S I G N A L S
	SIGNAL   clk  : std_logic := '0';
	SIGNAL   rst  : std_logic := '1';
	SIGNAL   a    : std_logic_VECTOR (N-1 downto 0):="00111";
	SIGNAL   b    : std_logic_VECTOR (N-1 downto 0):="00001";

-- O U T P U T     S I G N A L S
	SIGNAL   max    : std_logic_VECTOR (N-1 downto 0);
	SIGNAL   min    : std_logic_VECTOR (N-1 downto 0);

	SIGNAL	 clk_cycle	: INTEGER;
	SIGNAL	 Testing	: Boolean := True;

BEGIN
   I : min_max_evaluator GENERIC MAP(N=>5)
             PORT MAP(a,b,max,min,clk,rst);

	----------------------------------------------------------------------------

	-- Generates clk
	clk <= NOT clk AFTER MckPer/2 WHEN Testing ELSE '0';

   -- Runs simulation for TestLen cycles;
   Test_Proc: PROCESS(clk)
      VARIABLE count: INTEGER:= 0;
   BEGIN
     clk_cycle <= (count+1)/2;

     CASE count IS
          WHEN  11  => a <= "00000"; b <= "00011";
          WHEN  15  => a <= "00000"; b <= "11111";
          WHEN  19  => a <= "01010"; b <= "00011";
		  WHEN  23  => a <= "00000"; b <= "10000"; 
		  WHEN  27  => rst <= '0';
		  WHEN  31  => rst <= '1';
		  WHEN  35  => a <= "10101"; b <= "10101"; 

          WHEN (TestLen - 1) =>   Testing <= False;
          WHEN OTHERS => NULL;
     END CASE;

     count:= count + 1;
   END PROCESS Test_Proc;

END max_min_evaluator_test;
