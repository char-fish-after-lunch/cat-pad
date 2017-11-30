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
		constant ALU_GR_S	: std_logic_vector(3 downto 0) := "1100";

		constant IMME_8B  : std_logic_vector(2 downto 0) := "000";
		constant IMME_4B  : std_logic_vector(2 downto 0) := "001";
		constant IMME_3B  : std_logic_vector(2 downto 0) := "010";
		constant IMME_11B : std_logic_vector(2 downto 0) := "011";
		constant IMME_5B  : std_logic_vector(2 downto 0) := "100";
		
		constant reg_IH  : std_logic_vector(3 downto 0) := "1000";
		constant reg_SP  : std_logic_vector(3 downto 0) := "1001";
		constant reg_T   : std_logic_vector(3 downto 0) := "1010";
		constant reg_O	: std_logic_vector(3 downto 0) := "1111";
		
		constant fwd_original  : std_logic_vector(1 downto 0) := "00";
		constant fwd_alu_res   : std_logic_vector(1 downto 0) := "01";
		constant fwd_wb_ram    : std_logic_vector(1 downto 0) := "10";
		constant fwd_wb_alu    : std_logic_vector(1 downto 0) := "11";
		
		

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
		constant INSTR_H_INT	: std_logic_vector(4 downto 0) := "11111";
		constant INSTR_H_ERET	: std_logic_vector(4 downto 0) := "00011";

		constant INSTR_H_GROUP1	: std_logic_vector(4 downto 0) := "11101";
		constant INSTR_H_GROUP2	: std_logic_vector(4 downto 0) := "01100";
		constant INSTR_H_GROUP3	: std_logic_vector(4 downto 0) := "11100";
		constant INSTR_H_GROUP4	: std_logic_vector(4 downto 0) := "11110";
		constant INSTR_H_GROUP5	: std_logic_vector(4 downto 0) := "00110";

		-- advanced instructions
end consts;

