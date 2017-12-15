-------------------------------------------------------------------------------
-- TestBench(subtractor)
--
-- File name : subtractor_test.vhdl
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

ENTITY subtractor_tb IS
END subtractor_tb;

ARCHITECTURE subtractor_test OF subtractor_tb IS
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

	----------------------------------------------------------------------------
	CONSTANT N       :  INTEGER  := 5;       -- Bus Width
	CONSTANT MckPer  :  TIME     := 200 ns;  -- Master Clk period
	CONSTANT TestLen :  INTEGER  := 40;      -- No. of Count (MckPer/2) for test

-- I N P U T     S I G N A L S
	SIGNAL   clk  		: std_logic := '0';
	SIGNAL   rst  		: std_logic := '1';
	SIGNAL   minuend    : std_logic_VECTOR (N-1 downto 0):="00111";
	SIGNAL   subtrahend	: std_logic_VECTOR (N-1 downto 0):="00001";
	SIGNAL   borrow_in  : std_logic:='0';

-- O U T P U T     S I G N A L S
	SIGNAL   difference : std_logic_VECTOR (N-1 downto 0);
	SIGNAL   borrow_out : std_logic;

	SIGNAL	 clk_cycle	: INTEGER;
	SIGNAL	 Testing	: Boolean := True;

BEGIN
   I : subtractor GENERIC MAP(N=>5)
             PORT MAP(minuend,subtrahend,borrow_in,difference,borrow_out,clk,rst);

	----------------------------------------------------------------------------

	-- Generates clk
	clk <= NOT clk AFTER MckPer/2 WHEN Testing ELSE '0';

   -- Runs simulation for TestLen cycles;
   Test_Proc: PROCESS(clk)
      VARIABLE count: INTEGER:= 0;
   BEGIN
     clk_cycle <= (count+1)/2;

     CASE count IS
          WHEN  11  => minuend <= "00000"; subtrahend <= "00011";
          WHEN  15  => minuend <= "00000"; subtrahend <= "11111";
          WHEN  19  => minuend <= "01010"; subtrahend <= "00011";
		  WHEN  23  => rst <= '0';
		  WHEN  27  => rst <= '1';
		  WHEN  31  => minuend <= "00000"; subtrahend <= "10000";

          WHEN (TestLen - 1) =>   Testing <= False;
          WHEN OTHERS => NULL;
     END CASE;

     count:= count + 1;
   END PROCESS Test_Proc;

END subtractor_test;
