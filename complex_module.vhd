-------------------------------------------------------------------------------
-- (Behavioral)
--
-- File name : complex_module.vhdl
-- Purpose   : Complex module evaluator
--           
-- Library   : IEEE
-- Author(s) : Alessandro Martinelli
--
-- Simulator : Synopsys VSS v. 1999.10, on SUN Solaris 8
-------------------------------------------------------------------------------
-- Revision List
-- Version      Author  Date            	Changes
--
-- 1.0          AMarti  24 september 2017   New version
-- 1.1          AMarti  27 september 2017   Clock and reset added
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY complex_module is
	generic (N : INTEGER:=10);
   	port( 
	   	real_part		: in  std_logic_VECTOR (N-1 downto 0);	
	   	imaginary_part	: in  std_logic_VECTOR (N-1 downto 0);	
	    invalid_result	: out std_logic;
		module			: out std_logic_VECTOR (N-1 downto 0);
		clock			: in  std_logic;
		reset			: in  std_logic);
END complex_module;   	 


ARCHITECTURE STRUCTURAL OF complex_module IS 

	COMPONENT absolute_value 
		generic (N : INTEGER:=10);
	   	port( 
			integer_input	: in  std_logic_VECTOR (N-1 downto 0);		
			absolute_value	: out std_logic_VECTOR (N-1 downto 0);
			clock			: in  std_logic;
			reset			: in  std_logic);	
	END COMPONENT;
	
	COMPONENT negative_full_scale_detector 
		generic (N : INTEGER:=10);
		port( 
			a         : in  std_logic_VECTOR (N-1 downto 0);
			b         : in  std_logic_VECTOR (N-1 downto 0);
			invalid	: out std_logic;
			clock		: in  std_logic;
			reset		: in  std_logic);
	END COMPONENT;	
	
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
	
	COMPONENT adder
		generic (N : INTEGER:=10);
		port(	
			input_a   	: in  std_logic_VECTOR (N-1 downto 0);
			input_b   	: in  std_logic_VECTOR (N-1 downto 0);
	       	carry_in	: in  std_logic;
			sum       	: out std_logic_VECTOR (N-1 downto 0);
			carry_out	: out std_logic;
			clock		: in  std_logic;
			reset		: in  std_logic);	
	END COMPONENT;
	
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

signal abs_to_x				: std_logic_VECTOR (N-1 downto 0);		-- forse qui ci va N-2?
signal abs_to_y				: std_logic_VECTOR (N-1 downto 0);		-- forse qui ci va N-2?
signal max_to_adder			: std_logic_VECTOR (N-2 downto 0);		-- forse qui ci va N-2?
signal min_to_adder			: std_logic_VECTOR (N-2 downto 0);		-- forse qui ci va N-2?		  
signal min_to_adder_on2		: std_logic_VECTOR (N-2 downto 0);		-- forse qui ci va N-2?		  
signal partial_to_add		: std_logic_VECTOR (N-2 downto 0);
signal partial_to_add_carry	: std_logic;
signal partial_to_sub		: std_logic_VECTOR (N-2 downto 0);	
signal partial_to_sub_carry	: std_logic;
signal global_add_input		: std_logic_VECTOR (N-1 downto 0);
signal global_sub_input		: std_logic_VECTOR (N-1 downto 0);
signal global_sub_input_on16: std_logic_VECTOR (N-1 downto 0);
--signal negative_full_scale	: std_logic_VECTOR (N-1 downto 0);
--signal invalid				: std_logic;							-- al momento e' inutilizzato
   
begin		
	min_to_adder_on2 		<= '0' & min_to_adder(N-2 downto 1);	 
	global_add_input 		<= partial_to_add_carry & partial_to_add;
	global_sub_input 		<= partial_to_sub_carry & partial_to_sub;
	global_sub_input_on16	<= "0000" & global_sub_input(N-1 downto 4);	 
	
	I1_absolute_value:absolute_value generic map(N=>N)
		port map (	integer_input 	=> real_part,
					absolute_value 	=> abs_to_x,
					clock			=> clock,
					reset			=> reset); 
		
	I2_absolute_value:absolute_value generic map(N=>N)
		port map (	integer_input 	=> imaginary_part,
					absolute_value 	=> abs_to_y,
					clock			=> clock,
					reset			=> reset); 
		
	I_negative_full_scale_detector:negative_full_scale_detector generic map(N=>N)
		port map (	a 		=> real_part,
					b 		=> imaginary_part,
					invalid	=> invalid_result,
					clock			=> clock,
					reset			=> reset); 
					
	I_min_max_evaluator:min_max_evaluator generic map(N=>N-1)
		port map (	x		=> abs_to_x(N-2 downto 0),
					y		=> abs_to_y(N-2 downto 0),	
					max 	=> max_to_adder,
					min 	=> min_to_adder,
					clk		=> clock,
					rst	=> reset); 
					
	I1_adder:adder generic map(N=>N-1)
	port map (	input_a		=> min_to_adder_on2,
				input_b		=> max_to_adder,
				carry_in	=> '0',
				sum			=> partial_to_add,
				carry_out 	=> partial_to_add_carry,
				clock		=> clock,
				reset		=> reset); 				
				
	I2_adder:adder generic map(N=>N-1)
	port map (	input_a		=> min_to_adder,
				input_b		=> max_to_adder,
				carry_in	=> '0',
				sum			=> partial_to_sub,
				carry_out 	=> partial_to_sub_carry,
				clock		=> clock,
				reset		=> reset); 				
				
	-- The final subtractor. It takes in input two positive quantities, with the first
	-- one always greater than the second one for composition, thus there
	-- is no need to consider the borrow_out wire.
	I_subtractor:subtractor generic map(N=>N)
	port map (	minuend		=> global_add_input,
				subtrahend	=> global_sub_input_on16,
				borrow_in	=> '0',
				difference  => module,
				borrow_out	=> open,
				clock		=> clock,
				reset		=> reset); 			
end STRUCTURAL;	

