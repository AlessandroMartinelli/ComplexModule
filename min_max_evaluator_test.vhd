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
		min	: out std_logic_VECTOR (N-1 downto 0)
	);
	END COMPONENT;

	----------------------------------------------------------------------------
	CONSTANT N       :  INTEGER  := 10;       -- Bus Width
	CONSTANT MckPer  :  TIME     := 200 ns;  -- Master Clk period
	CONSTANT TestLen :  INTEGER  := 18;      -- No. of Count (MckPer/2) for test

-- I N P U T     S I G N A L S
	SIGNAL   clk  : std_logic := '0';
	SIGNAL   a    : std_logic_VECTOR (N-1 downto 0):="0000000000";
	SIGNAL   b    : std_logic_VECTOR (N-1 downto 0):="0000000000";

-- O U T P U T     S I G N A L S
	SIGNAL   max    : std_logic_VECTOR (N-1 downto 0);
	SIGNAL   min    : std_logic_VECTOR (N-1 downto 0);

	SIGNAL	 clk_cycle	: INTEGER;
	SIGNAL	 Testing	: Boolean := True;

BEGIN
   I : min_max_evaluator GENERIC MAP(N=>10)
             PORT MAP(a,b,max,min);

	----------------------------------------------------------------------------

	-- Generates clk
	clk <= NOT clk AFTER MckPer/2 WHEN Testing ELSE '0';

   -- Runs simulation for TestLen cycles;
   Test_Proc: PROCESS(clk)
      VARIABLE count: INTEGER:= 0;
   BEGIN
     clk_cycle <= (count+1)/2;

     CASE count IS
          WHEN  04  => a <= "0000001010"; b <= "0000000011";
          WHEN  08  => a <= "0000000000"; b <= "1111111111";
		  WHEN  12  => a <= "0000011111"; b <= "0000011111";

          WHEN (TestLen - 1) =>   Testing <= False;
          WHEN OTHERS => NULL;
     END CASE;

     count:= count + 1;
   END PROCESS Test_Proc;

END max_min_evaluator_test;
