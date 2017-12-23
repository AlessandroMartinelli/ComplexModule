LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY incrementer_tb IS
END incrementer_tb;

ARCHITECTURE incrementer_test OF incrementer_tb IS
	COMPONENT incrementer
	generic (N : INTEGER:=10);
	port(	input		: in  std_logic_VECTOR (N-1 downto 0);
       	 	carry_in   	: in  std_logic;
		 	sum         : out std_logic_VECTOR (N-1 downto 0)
		);
	END COMPONENT;

	-------------------------------------------------------------
	CONSTANT N       :  INTEGER  := 10;       -- Bus Width
	CONSTANT MckPer  :  TIME     := 200 ns;  -- Master Clk period
	CONSTANT TestLen :  INTEGER  := 30;      -- No. of Count (MckPer/2) for test

-- I N P U T     S I G N A L S
	SIGNAL   clk  		: std_logic := '0';
	SIGNAL   a_test		: std_logic_VECTOR (N-1 downto 0):="0000000000";
	SIGNAL   cin_test  	: std_logic:='0';

-- O U T P U T     S I G N A L S
	SIGNAL   sum_test	: std_logic_VECTOR (N-1 downto 0);

	SIGNAL	 clk_cycle	: INTEGER;
	SIGNAL	 Testing	: Boolean := True;

BEGIN
   I : incrementer GENERIC MAP(N=>5)
             PORT MAP(a_test, cin_test, sum_test);

	-------------------------------------------------------------

	-- Generates clk
	clk <= NOT clk AFTER MckPer/2 WHEN Testing ELSE '0';

   -- Runs simulation for TestLen cycles;
   Test_Proc: PROCESS(clk)
      VARIABLE count: INTEGER:= 0;
   BEGIN
     clk_cycle <= (count+1)/2;

     CASE count IS
          WHEN  03  => cin_test <= '1'; a_test <= "0000000000";
          WHEN  07  => cin_test <= '0'; a_test <= "1111111111";
		  WHEN  11  => cin_test <= '1'; a_test <= "1111111111";
          WHEN  15  => cin_test <= '0'; a_test <= "0101010101";
		  WHEN  19  => cin_test <= '1'; a_test <= "0101010101";
		  WHEN  23  => cin_test <= '1'; a_test <= "0111111111";
		  WHEN  27  => cin_test <= '1'; a_test <= "1111111110";

          WHEN (TestLen - 1) =>   Testing <= False;
          WHEN OTHERS => NULL;
     END CASE;

     count:= count + 1;
   END PROCESS Test_Proc;

END incrementer_test;
