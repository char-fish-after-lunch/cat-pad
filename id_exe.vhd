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

begin


end Behavioral;

