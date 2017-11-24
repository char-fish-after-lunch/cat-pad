----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:39:34 11/17/2017 
-- Design Name: 
-- Module Name:    control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.consts.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is port(
	inst			:	in std_logic_vector(15 downto 0);
	regSrcA		:	out std_logic_vector(3 downto 0);
	regSrcB		:	out std_logic_vector(3 downto 0);
	immeCtrl		:	out std_logic_vector(2 downto 0);
	dstSrc		:	out std_logic_vector(3 downto 0);
	immeExt		:	out std_logic;
	oprSrcB		:	out std_logic;
	ALUop			:	out std_logic_vector(3 downto 0);
	isBranch		:	out std_logic;
	isCond		:	out std_logic;
	isRelative	:	out std_logic;
	isMFPC		:	out std_logic;
	ramWrite		:	out std_logic;
	ramRead		:	out std_logic;
	wbSrc		:	out std_logic;
	wbEN		:	out std_logic
	);
end control;

architecture Behavioral of control is
	alias instrType is inst(15 downto 11);
begin
	process(inst)
		variable branch : std_logic_vector(2 downto 0) := "000";
		variable ramCtrl : std_logic_vector(1 downto 0) := "00";
		variable wbCtrl : std_logic_vector(1 downto 0) := "00";
	begin

		regSrcA		<= "0000";
		regSrcB		<= "0000";
		immeCtrl	<= "000";
		dstSrc		<= "0000";
		immeExt		<= '1';
		oprSrcB		<= '0';
		ALUop		<= "0000";
		branch		:= "000";
		ramCtrl		:= "00";
		wbCtrl		:= "00";
		isMFPC		<= '0';
		case instrType is
			when INSTR_H_ADDIU =>
				regSrcA		<= "0" & inst(10 downto 8);
				dstSrc		<= "0" & inst(10 downto 8);
				oprSrcB		<= '1';
				wbCtrl		:= "11";
			when INSTR_H_ADDIU3 =>
				regSrcA		<= "0" & inst(7 downto 5);
				immeCtrl	<= "001";
				dstSrc		<= "0" & inst(10 downto 8);
				oprSrcB		<= '1';
				wbCtrl		:= "11";
			when INSTR_H_B =>
				immeCtrl	<= "011";
				oprSrcB		<= '1';
				ALUop		<= "1010";
				branch		:= "101";
				wbCtrl		:= "10";
			when INSTR_H_BEQZ =>
				regSrcA		<= "0" & inst(10 downto 8);
				ALUop		<= "0111";
				branch		:= "111";
			when INSTR_H_BNEZ =>
				regSrcA		<= "0" & inst(10 downto 8);
				ALUop		<= "1000";
				branch		:= "111";
			when INSTR_H_LI =>
				dstSrc		<= "0" & inst(10 downto 8);
				oprSrcB		<= '1';
				ALUop		<= "1010";
				wbCtrl		:= "11";
				immeExt		<= '0';
			when INSTR_H_LW =>
				regSrcA		<= "0" & inst(10 downto 8);
				immeCtrl	<= "100";
				dstSrc		<= "0" & inst(7 downto 5);
				oprSrcB		<= '1';
				ramCtrl		:= "01";
				wbCtrl		:= "10";
			when INSTR_H_LW_SP =>
				regSrcA		<= "1001";
				dstSrc		<= "0" & inst(10 downto 8);
				oprSrcB		<= '1';
				ramCtrl		:= "01";
				wbCtrl		:= "10";
			when INSTR_H_NOP =>
			-- does nothing for NOP
			when INSTR_H_SW =>
				regSrcA		<= "0" & inst(10 downto 8);
				regSrcB		<= "0" & inst(7 downto 5);
				immeCtrl	<= "100";
				oprSrcB		<= '1';
				ramCtrl		:= "10";
			when INSTR_H_SW_SP =>
				regSrcA		<= "1001";
				regSrcB		<= "0" & inst(10 downto 8);
				oprSrcB		<= '1';
				ramCtrl		:= "10";
			when INSTR_H_GROUP1 =>
				case inst(4 downto 0) is
					when "01100" =>
						-- AND
						regSrcA		<= "0" & inst(10 downto 8);
						regSrcB		<= "0" & inst(7 downto 5);
						dstSrc		<= "0" & inst(10 downto 8);
						ALUop		<= "0010";
						wbCtrl		:= "11";
					when "01010" =>
						-- CMP
						regSrcA		<= "0" & inst(10 downto 8);
						regSrcB		<= "0" & inst(7 downto 5);
						dstSrc		<= "1010";
						ALUop		<= "1000";
						wbCtrl		:= "11";
					when "00000" =>
						case inst(7 downto 5) is
							when "000" =>
								-- JR
								regSrcA		<= "0" & inst(10 downto 8);
								ALUop		<= "1001";
								branch		:= "100";
							when "010" =>
								-- MFPC
								dstSrc		<= "0" & inst(10 downto 8);
								ALUop		<= "1001";
								wbCtrl		:= "11";
								isMFPC		<= '1';
							when others =>
						end case;
					when "01101" =>
						-- OR
						regSrcA		<= "0" & inst(10 downto 8);
						regSrcB		<= "0" & inst(7 downto 5);
						dstSrc		<= "0" & inst(10 downto 8);
						ALUop		<= "0011";
						wbCtrl		:= "11";
					when "00100" =>
						-- SLLV
						regSrcA		<= "0" & inst(7 downto 5);
						regSrcB		<= "0" & inst(10 downto 8);
						dstSrc		<= "0" & inst(7 downto 5);
						ALUop		<= "0100";
						wbCtrl		:= "11";
					when "00010" =>
						-- SLTU
						regSrcA		<= "0" & inst(10 downto 8);
						regSrcB		<= "0" & inst(7 downto 5);
						dstSrc		<= "1010";
						ALUop		<= "1011";
						wbCtrl		:= "11";
					when "00110" =>
						-- SRLV
						regSrcA		<= "0" & inst(7 downto 5);
						regSrcB		<= "0" & inst(10 downto 8);
						dstSrc		<= "0" & inst(7 downto 5);
						ALUop		<= "0110";
						wbCtrl		:= "11";
					when others =>
				end case;
			when INSTR_H_GROUP2 =>
				case inst(10 downto 8) is
					when "000" =>
						-- BTEQZ
						regSrcA		<= "1010";
						ALUop		<= "0111";
						branch		:= "111";
					when "011" =>
						-- ADDSP
						wbCtrl		:= "11";
						regSrcA		<= "1001";
						dstSrc		<= "1001";
						oprSrcB		<= '1';
						wbCtrl		:= "11";
					when "001" =>
						-- BTNEZ
						regSrcA		<= "1010";
						dstSrc		<= "0" & inst(4 downto 2);
						ALUop		<= "0111";
						branch		:= "110";
					when others =>
				end case;
			when INSTR_H_GROUP3 =>
				case inst(1 downto 0) is
					when "10" =>
						-- ADDU
						regSrcA		<= "0" & inst(10 downto 8);
						regSrcB		<= "0" & inst(7 downto 5);
						dstSrc		<= "0" & inst(4 downto 2);
						wbCtrl		:= "11";
					when "11" =>
						-- SUBU
						regSrcA		<= "0" & inst(10 downto 8);
						regSrcB		<= "0" & inst(7 downto 5);
						dstSrc		<= "0" & inst(4 downto 2);
						ALUop		<= "0001";
						wbCtrl		:= "11";
					when others =>
				end case;
			when INSTR_H_GROUP4 =>
				case inst(7 downto 0) is
					when "01000000" =>
						-- MFIH
						regSrcA		<= "1000";
						dstSrc		<= "0" & inst(10 downto 8);
						ALUop		<= "1001";
						wbCtrl		:= "11";
					when "00000001" =>
						-- MTIH
						regSrcA		<= "0" & inst(10 downto 8);
						dstSrc		<= "1000";
						ALUop		<= "1001";
						wbCtrl		:= "11";
					when others =>
				end case;
			when INSTR_H_GROUP5 =>
				case inst(1 downto 0) is
					when "00" =>
						-- SLL
						regSrcA		<= "0" & inst(7 downto 5);
						immeCtrl	<= "010";
						dstSrc		<= "0" & inst(10 downto 8);
						oprSrcB		<= '1';
						ALUop		<= "0100";
						wbCtrl		:= "11";
					when "10" =>
						-- SRL
						regSrcA		<= "0" & inst(7 downto 5);
						immeCtrl	<= "010";
						dstSrc		<= "0" & inst(10 downto 8);
						oprSrcB		<= '1';
						ALUop		<= "0110";
						wbCtrl		:= "11";
					when "11" =>
						-- SRA
						regSrcA		<= "0" & inst(7 downto 5);
						immeCtrl	<= "010";
						dstSrc		<= "0" & inst(10 downto 8);
						oprSrcB		<= '1';
						ALUop		<= "0101";
						wbCtrl		:= "11";

					when others =>
				end case;
			when others=>
		end case;

		isBranch <= branch(2);
		isCond <= branch(1);
		isRelative <= branch(0);

		ramWrite <= ramCtrl(1);
		ramRead <= ramCtrl(0);

		wbSrc <= wbCtrl(1);
		wbEN <= wbCtrl(0);
	end process;


end Behavioral;

