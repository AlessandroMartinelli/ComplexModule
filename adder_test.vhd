-------------------------------------------------------------------------------
-- TestBench(adder)
--
-- File name : adder_test.vhdl
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

ENTITY adder_tb IS
END adder_tb;

ARCHITECTURE adder_test OF adder_tb IS
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

	----------------------------------------------------------------------------
	CONSTANT N       :  INTEGER  := 5;       -- Bus Width
	CONSTANT MckPer  :  TIME     := 200 ns;  -- Master Clk period
	CONSTANT TestLen :  INTEGER  := 40;      -- No. of Count (MckPer/2) for test

-- I N P U T     S I G N A L S
	SIGNAL   clk  		: std_logic := '0';
	SIGNAL	 rst		: std_logic := '1'; 
	SIGNAL   a_test		: std_logic_VECTOR (N-1 downto 0):="01001";
	SIGNAL   b_test		: std_logic_VECTOR (N-1 downto 0):="00101";
	SIGNAL   cin_test 	: std_logic:='0';
	-- Given initial values, expected result is sum_test="01110", cout='0'

-- O U T P U T     S I G N A L S
	SIGNAL   cout_test	: std_logic;
	SIGNAL   sum_test	: std_logic_VECTOR (N-1 downto 0);

	SIGNAL	 clk_cycle	: INTEGER;
	SIGNAL	 Testing	: Boolean := True;

BEGIN
   I : adder GENERIC MAP(N=>5)
             PORT MAP(a_test,b_test,cin_test,sum_test,cout_test, clk, rst);

	----------------------------------------------------------------------------

	-- Generates clk
	clk <= NOT clk AFTER MckPer/2 WHEN Testing ELSE '0';

   -- Runs simulation for TestLen cycles;
   Test_Proc: PROCESS(clk)
      VARIABLE count: INTEGER:= 0;
   BEGIN
     clk_cycle <= (count+1)/2;

     CASE count IS
          WHEN  11  => cin_test <= '1'; a_test <= "00000"; b_test <= "11101";
          WHEN  15  => cin_test <= '1'; a_test <= "00000"; b_test <= "11111";
          WHEN  19  => cin_test <= '0'; a_test <= "01010"; b_test <= "00000";
		  WHEN  23  => cin_test <= '0'; a_test <= "01110"; b_test <= "00000"; rst <= '0';
		  WHEN  27  => cin_test <= '1'; a_test <= "00110"; b_test <= "01100";
		  WHEN  31  => cin_test <= '1'; a_test <= "01110"; b_test <= "00000"; rst <= '1';

          WHEN (TestLen - 1) =>   Testing <= False;
          WHEN OTHERS => NULL;
     END CASE;

     count:= count + 1;
   END PROCESS Test_Proc;

END adder_test;
