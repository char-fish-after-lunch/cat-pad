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

begin


end Behavioral;

