----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:40:45 11/17/2017 
-- Design Name: 
-- Module Name:    id_exe - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity id_exe is port(
		clk : in std_logic;

		regA 			:  in std_logic_vector(15 downto 0);
		regB 			:  in std_logic_vector(15 downto 0);
		regAN 		:  in std_logic_vector(3 downto 0);
		regBN 		:  in std_logic_vector(3 downto 0);
		immediate	:  in std_logic_vector(15 downto 0);
		IDPC 			:  in std_logic_vector(15 downto 0);
		dstSrc		:	in std_logic_vector(3 downto 0);
		immeExt		:	in std_logic;
		oprSrcB		:	in std_logic;
		ALUop			:	in std_logic_vector(3 downto 0);
		isBranch		:	in std_logic;
		isCond		:	in std_logic;
		isRelative	:	in std_logic;
		isMFPC		:	in std_logic;
		ramWrite		:	in std_logic;
		ramRead		:	in std_logic;
		wbSrc			:	in std_logic;
		wbEN			:	in std_logic;
		
		regA_o 			: out std_logic_vector(15 downto 0);
		regB_o 			: out std_logic_vector(15 downto 0);
		regAN_o 			: out std_logic_vector(3 downto 0);
		regBN_o 			: out std_logic_vector(3 downto 0);
		immediate_o		: out std_logic_vector(15 downto 0);
		IDPC_o 			: out std_logic_vector(15 downto 0);
		dstSrc_o			:	out std_logic_vector(3 downto 0);
		immeExt_o		:	out std_logic;
		oprSrcB_o		:	out std_logic;
		ALUop_o			:	out std_logic_vector(3 downto 0);
		isBranch_o		:	out std_logic;
		isCond_o			:	out std_logic;
		isRelative_o	:	out std_logic;
		isMFPC_o			:	out std_logic;
		ramWrite_o		:	out std_logic;
		ramRead_o		:	out std_logic;
		wbSrc_o			:	out std_logic;
		wbEN_o			:	out std_logic
		
	);
end id_exe;

architecture Behavioral of id_exe is
	signal inner_regA 			:  std_logic_vector(15 downto 0);
	signal inner_regB 			:  std_logic_vector(15 downto 0);
	signal inner_regAN 		:  std_logic_vector(3 downto 0);
	signal inner_regBN 		:  std_logic_vector(3 downto 0);
	signal inner_immediate	:  std_logic_vector(15 downto 0);
	signal inner_IDPC 			:  std_logic_vector(15 downto 0);
	signal inner_dstSrc		:	std_logic_vector(3 downto 0);
	signal inner_immeExt		:	std_logic;
	signal inner_oprSrcB		:	std_logic;
	signal inner_ALUop			:	std_logic_vector(3 downto 0);
	signal inner_isBranch		:	std_logic;
	signal inner_isCond		:	std_logic;
	signal inner_isRelative	:	std_logic;
	signal inner_isMFPC		:	std_logic;
	signal inner_ramWrite		:	std_logic;
	signal inner_ramRead		:	std_logic;
	signal inner_wbSrc			:	std_logic;
	signal inner_wbEN			:	std_logic;
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			inner_regA <= regA;
			inner_regB <= regB;
			inner_regAN <= regAN;
			inner_regBN <= regBN;
			inner_immediate <= immediate;
			inner_IDPC <= IDPC;
			inner_dstSrc <= dstSrc;
			inner_immeExt <= immeExt;
			inner_oprSrcB <= oprSrcB;
			inner_ALUop	 <= ALUop;
			inner_isBranch <= isBranch;
			inner_isCond <= isCond;
			inner_isRelative <= isRelative;
			inner_isMFPC <= isMFPC;
			inner_ramWrite <= ramWrite;
			inner_ramRead <= ramRead;
			inner_wbSrc <= wbSrc;
			inner_wbEN <= wbEN;
		end if;
	end process;
	
	regA_o <= inner_regA;
	regB_o <= inner_regB;
	regAN_o <= inner_regAN;
	regBN_o <= inner_regBN;
	immediate_o <= inner_immediate;
	IDPC_o <= inner_IDPC;
	dstSrc_o <= inner_dstSrc;
	immeExt_o <= inner_immeExt;
	oprSrcB_o <= inner_oprSrcB;
	ALUop_o <= inner_ALUop;
	isBranch_o <= inner_isBranch;
	isCond_o <= inner_isCond;
	isRelative_o <= inner_isRelative;
	isMFPC_o <= inner_isMFPC;
	ramWrite_o <= inner_ramWrite;
	ramRead_o <= inner_ramRead;
	wbSrc_o <= inner_wbSrc;
	wbEN_o <= inner_wbEN;

end Behavioral;

