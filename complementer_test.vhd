-------------------------------------------------------------------------------
-- TestBench(complementer)
--
-- File name : complementer_test.vhdl
-- Purpose   : Generates stimuli
--           :
-- Library   : IEEE
-- Author(s) : Alessandro Martinelli
--
-- Simulator : Synopsys VSS v. 1999.10, on SUN Solaris 8
-------------------------------------------------------------------------------
-- Revision List
-- Version      Author  Date            	Changes
--
-- 1.0          AMarti  23 september 2017   New version
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY complementer_tb IS
END complementer_tb;

ARCHITECTURE complementer_test OF complementer_tb IS
	COMPONENT complementer
	generic (N : INTEGER:=10);
	port(	input	: in  std_logic_VECTOR (N-1 downto 0);
       	  	cmd		: in  std_logic;
		  	output	: out std_logic_VECTOR (N-1 downto 0);
		  	clock	: in  std_logic;
			reset	: in  std_logic);
	END COMPONENT;

	----------------------------------------------------------------------------
	CONSTANT N       :  INTEGER  := 5;       -- Bus Width
	CONSTANT MckPer  :  TIME     := 200 ns;  -- Master Clk period
	CONSTANT TestLen :  INTEGER  := 40;      -- No. of Count (MckPer/2) for test

-- I N P U T     S I G N A L S
	SIGNAL   clk  		: std_logic := '0';
	SIGNAL	 rst		: std_logic := '1';
	SIGNAL   input    	: std_logic_VECTOR (N-1 downto 0):="10110";
	SIGNAL	 cmd		: std_logic := '1';

-- O U T P U T     S I G N A L S
	SIGNAL   output    	: std_logic_VECTOR (N-1 downto 0);

	SIGNAL	 clk_cycle	: INTEGER;
	SIGNAL	 Testing	: Boolean := True;

BEGIN
   I : complementer GENERIC MAP(N=>5)
             PORT MAP(input,cmd,output,clk,rst);

	----------------------------------------------------------------------------

	-- Generates clk
	clk <= NOT clk AFTER MckPer/2 WHEN Testing ELSE '0';

   -- Runs simulation for TestLen cycles;
   Test_Proc: PROCESS(clk)
      VARIABLE count: INTEGER:= 0;
   BEGIN
     clk_cycle <= (count+1)/2;

     CASE count IS
          WHEN  11  => input <= "00111"; cmd <= '0';
          WHEN  15  => input <= "11111"; cmd <= '1';
          WHEN  19  => input <= "01010"; cmd <= '0'; 
		  WHEN  23  => input <= "10110"; cmd <= '1'; rst <= '0';
		  WHEN  27  => input <= "10111"; cmd <= '1';
		  WHEN  31  => input <= "10111"; cmd <= '1'; rst <= '1';

          WHEN (TestLen - 1) =>   Testing <= False;
          WHEN OTHERS => NULL;
     END CASE;

     count:= count + 1;
   END PROCESS Test_Proc;

END complementer_test;
