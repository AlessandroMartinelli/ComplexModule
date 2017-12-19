-------------------------------------------------------------------------------
-- TestBench(absolute_value)
--
-- File name : absolute_value_test.vhdl
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
-- 1.0          AMarti  24 september 2017   New version
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY absolute_value_tb IS
END absolute_value_tb;

ARCHITECTURE absolute_value_test OF absolute_value_tb IS
	COMPONENT absolute_value
	generic (N : INTEGER:=10);
   	port( 
		integer_input	: in  std_logic_VECTOR (N-1 downto 0);		
		absolute_value	: out std_logic_VECTOR (N-2 downto 0)
	);
	END COMPONENT;

	----------------------------------------------------------------------------
	CONSTANT N       :  INTEGER  := 5;       -- Bus Width
	CONSTANT MckPer  :  TIME     := 200 ns;  -- Master Clk period
	CONSTANT TestLen :  INTEGER  := 40;      -- No. of Count (MckPer/2) for test

-- I N P U T     S I G N A L S
	SIGNAL   clk  		: std_logic := '0';
	SIGNAL   input    	: std_logic_VECTOR (N-1 downto 0):="00000";

-- O U T P U T     S I G N A L S
	SIGNAL   abs_val    : std_logic_VECTOR (N-2 downto 0);
	SIGNAL	 clk_cycle	: INTEGER;
	SIGNAL	 Testing	: Boolean := True;

BEGIN
   I : absolute_value GENERIC MAP(N=>5)
             PORT MAP(input,abs_val);

	----------------------------------------------------------------------------

	-- Generates clk
	clk <= NOT clk AFTER MckPer/2 WHEN Testing ELSE '0';

   -- Runs simulation for TestLen cycles;
   Test_Proc: PROCESS(clk)
      VARIABLE count: INTEGER:= 0;
   BEGIN
     clk_cycle <= (count+1)/2;

     CASE count IS		
		  WHEN  07  => input <= "11000";
		  WHEN  11  => input <= "00111";
          WHEN  15  => input <= "00000";
          WHEN  19  => input <= "11111";
          WHEN  23  => input <= "10000";
		  WHEN  27  => input <= "10110"; 
		  WHEN  31  => input <= "11110";

          WHEN (TestLen - 1) =>   Testing <= False;
          WHEN OTHERS => NULL;
     END CASE;

     count:= count + 1;
   END PROCESS Test_Proc;

END absolute_value_test;
