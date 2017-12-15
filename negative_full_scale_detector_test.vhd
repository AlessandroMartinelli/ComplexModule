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

ENTITY negative_full_scale_detector_tb IS
END negative_full_scale_detector_tb;

ARCHITECTURE negative_full_scale_detector_test OF negative_full_scale_detector_tb IS
	COMPONENT negative_full_scale_detector
	generic (N : INTEGER:=10);
	port( 
		a         	: in  std_logic_VECTOR (N-1 downto 0);
		b         	: in  std_logic_VECTOR (N-1 downto 0);
		invalid		: out std_logic;
		clock		: in  std_logic;
		reset		: in  std_logic);
	END COMPONENT;

	----------------------------------------------------------------------------
	CONSTANT N       :  INTEGER  := 5;       -- Bus Width
	CONSTANT MckPer  :  TIME     := 200 ns;  -- Master Clk period
	CONSTANT TestLen :  INTEGER  := 40;      -- No. of Count (MckPer/2) for test

-- I N P U T     S I G N A L S
	SIGNAL   rst  			: std_logic := '1';
	SIGNAL   clk  			: std_logic := '0';
	SIGNAL   a_test    		: std_logic_VECTOR (N-1 downto 0):="01001";
	SIGNAL   b_test    		: std_logic_VECTOR (N-1 downto 0):="00101";

-- O U T P U T     S I G N A L S
	SIGNAL   invalid_test	: std_logic;

	SIGNAL	 clk_cycle	: INTEGER;
	SIGNAL	 Testing	: Boolean := True;

BEGIN
   I : negative_full_scale_detector GENERIC MAP(N=>5)
             PORT MAP(a_test,b_test,invalid_test,clk,rst);

	----------------------------------------------------------------------------

	-- Generates clk
	clk <= NOT clk AFTER MckPer/2 WHEN Testing ELSE '0';

   -- Runs simulation for TestLen cycles;
   Test_Proc: PROCESS(clk)
      VARIABLE count: INTEGER:= 0;
   BEGIN
     clk_cycle <= (count+1)/2;

     CASE count IS
          WHEN  11  => a_test <= "00000"; b_test <= "11101";
          WHEN  15  => a_test <= "00000"; b_test <= "11111";
          WHEN  19  => a_test <= "01010"; b_test <= "10000";
		  WHEN  23  => a_test <= "10000"; b_test <= "11111";
		  WHEN  27  => a_test <= "10000"; b_test <= "10000";

          WHEN (TestLen - 1) =>   Testing <= False;
          WHEN OTHERS => NULL;
     END CASE;

     count:= count + 1;
   END PROCESS Test_Proc;

END negative_full_scale_detector_test;
