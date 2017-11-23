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
		constant ALU_ADD : std_logic_vector(3 downto 0) := "0000";
		constant ALU_SUB : std_logic_vector(3 downto 0) := "0001";
		constant ALU_AND : std_logic_vector(3 downto 0) := "0010";
		constant ALU_OR  : std_logic_vector(3 downto 0) := "0011";
		constant ALU_SLL : std_logic_vector(3 downto 0) := "0100";
		constant ALU_SLR : std_logic_vector(3 downto 0) := "0101";
		constant ALU_SAR : std_logic_vector(3 downto 0) := "0110";
		constant ALU_EQU : std_logic_vector(3 downto 0) := "0111";
		constant ALU_NEQ : std_logic_vector(3 downto 0) := "1000";
		constant ALU_O_A : std_logic_vector(3 downto 0) := "1001";
		constant ALU_O_B : std_logic_vector(3 downto 0) := "1010";
		constant ALU_GR  : std_logic_vector(3 downto 0) := "1011";

		constant IMME_8B  : std_logic_vector(2 downto 0) := "000";
		constant IMME_4B  : std_logic_vector(2 downto 0) := "001";
		constant IMME_3B  : std_logic_vector(2 downto 0) := "010";
		constant IMME_11B : std_logic_vector(2 downto 0) := "011";
		constant IMME_5B  : std_logic_vector(2 downto 0) := "100";
		

		-- consts for instruction headers
		constant INSTR_H_ADDIU	: std_logic_vector(4 downto 0) := "01001";
		constant INSTR_H_ADDIU3	: std_logic_vector(4 downto 0) := "01000";
		constant INSTR_H_B	: std_logic_vector(4 downto 0) := "00010";
		constant INSTR_H_BEQZ	: std_logic_vector(4 downto 0) := "00100";
		constant INSTR_H_BNEZ	: std_logic_vector(4 downto 0) := "00101";
		constant INSTR_H_LI	: std_logic_vector(4 downto 0) := "01101";
		constant INSTR_H_LW	: std_logic_vector(4 downto 0) := "10011";
		constant INSTR_H_LW_SP	: std_logic_vector(4 downto 0) := "10010";
		constant INSTR_H_NOP	: std_logic_vector(4 downto 0) := "00001";
		constant INSTR_H_SW	: std_logic_vector(4 downto 0) := "11011";
		constant INSTR_H_SW_SP	: std_logic_vector(4 downto 0) := "11010";

		constant INSTR_H_GROUP1	: std_logic_vector(4 downto 0) := "11101";
		constant INSTR_H_GROUP2	: std_logic_vector(4 downto 0) := "01100";
		constant INSTR_H_GROUP3	: std_logic_vector(4 downto 0) := "11100";
		constant INSTR_H_GROUP4	: std_logic_vector(4 downto 0) := "11110";
		constant INSTR_H_GROUP5	: std_logic_vector(4 downto 0) := "00110";

		-- advanced instructions
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
