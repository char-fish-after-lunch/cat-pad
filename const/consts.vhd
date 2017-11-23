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
		
		constant reg_IH  : std_logic_vector(3 downto 0) := "1000";
		constant reg_SP  : std_logic_vector(3 downto 0) := "1001";
		constant reg_T   : std_logic_vector(3 downto 0) := "1010";
		
		constant fwd_original  : std_logic_vector(3 downto 0) := "00";
		constant fwd_alu_res   : std_logic_vector(3 downto 0) := "01";
		constant fwd_wb_ram    : std_logic_vector(3 downto 0) := "10";
		constant fwd_wb_alu    : std_logic_vector(3 downto 0) := "11";
		
		


end consts;

