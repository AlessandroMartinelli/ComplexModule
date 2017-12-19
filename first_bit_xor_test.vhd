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

ENTITY first_bit_xor_tb IS
END first_bit_xor_tb;

ARCHITECTURE first_bit_xor_test OF first_bit_xor_tb IS
	COMPONENT first_bit_xor
	generic (N : INTEGER:=10);
	port(	input	: in  std_logic_VECTOR (N-1 downto 0);	 
			cmd		: in  std_logic;
		  	output	: out std_logic_VECTOR (N-1 downto 0)
		);
	END COMPONENT;

	----------------------------------------------------------------------------
	CONSTANT N       :  INTEGER  := 10;       -- Bus Width
	CONSTANT MckPer  :  TIME     := 200 ns;  -- Master Clk period
	CONSTANT TestLen :  INTEGER  := 40;      -- No. of Count (MckPer/2) for test

-- I N P U T     S I G N A L S
	SIGNAL   clk  		: std_logic := '0';
	SIGNAL   input_test	: std_logic_VECTOR (N-1 downto 0):="0000000000";	 
	SIGNAL 	 cmd_test	: std_logic := '0';

-- O U T P U T     S I G N A L S
	SIGNAL   output_test: std_logic_VECTOR (N-1 downto 0);

	SIGNAL	 clk_cycle	: INTEGER;
	SIGNAL	 Testing	: Boolean := True;

BEGIN
   I : first_bit_xor GENERIC MAP(N=>10)
             PORT MAP(input_test,cmd_test,output_test);

	----------------------------------------------------------------------------

	-- Generates clk
	clk <= NOT clk AFTER MckPer/2 WHEN Testing ELSE '0';

   -- Runs simulation for TestLen cycles;
   Test_Proc: PROCESS(clk)
      VARIABLE count: INTEGER:= 0;
   BEGIN
     clk_cycle <= (count+1)/2;

     CASE count IS
          WHEN  03  => input_test <= "0111111111"; cmd_test <= '0';
          WHEN  07  => input_test <= "0000000000"; cmd_test <= '0';
          WHEN  11  => input_test <= "1100110011"; cmd_test <= '1';
		  WHEN  15  => input_test <= "1111111111"; cmd_test <= '1';
		  WHEN  19  => input_test <= "1000000000"; cmd_test <= '1';
		  WHEN  23  => input_test <= "1000000001"; cmd_test <= '1';

          WHEN (TestLen - 1) =>   Testing <= False;
          WHEN OTHERS => NULL;
     END CASE;

     count:= count + 1;
   END PROCESS Test_Proc;

END first_bit_xor_test;
