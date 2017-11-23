--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package consts is
		constant alu_add : std_logic_vector(3 downto 0) := "0000";
		constant alu_sub : std_logic_vector(3 downto 0) := "0001";
		constant alu_and : std_logic_vector(3 downto 0) := "0010";
		constant alu_or  : std_logic_vector(3 downto 0) := "0011";
		constant alu_sll : std_logic_vector(3 downto 0) := "0100";
		constant alu_slr : std_logic_vector(3 downto 0) := "0101";
		constant alu_sar : std_logic_vector(3 downto 0) := "0110";
		constant alu_equ : std_logic_vector(3 downto 0) := "0111";
		constant alu_neq : std_logic_vector(3 downto 0) := "1000";
		constant alu_o_a : std_logic_vector(3 downto 0) := "1001";
		constant alu_o_b : std_logic_vector(3 downto 0) := "1010";
		constant alu_gr  : std_logic_vector(3 downto 0) := "1011";

		constant imme_8b  : std_logic_vector(2 downto 0) := "000";
		constant imme_4b  : std_logic_vector(2 downto 0) := "001";
		constant imme_3b  : std_logic_vector(2 downto 0) := "010";
		constant imme_11b : std_logic_vector(2 downto 0) := "011";
		constant imme_5b  : std_logic_vector(2 downto 0) := "100";
		


end consts;

package body consts is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end consts;
