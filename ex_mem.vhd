----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:41:57 11/17/2017 
-- Design Name: 
-- Module Name:    ex_mem - Behavioral 
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

entity ex_mem is port(
	clk : in std_logic;
	
	dstSrc	:	in std_logic_vector(3 downto 0);
	ramWrite	:	in std_logic;
	ramRead	:	in std_logic;
	wbSrc		:	in std_logic;
	wbEN		:	in std_logic;
	
	regB 		:  in std_logic_vector(15 downto 0);
	ALUres 	:	in std_logic_vector(15 downto 0);
	
	dstSrc_o		:	out std_logic_vector(3 downto 0);
	ramWrite_o	:	out std_logic;
	ramRead_o	:	out std_logic;
	wbSrc_o		:	out std_logic;
	wbEN_o		:	out std_logic;
	
	regB_o 		:  out std_logic_vector(15 downto 0);
	ALUres_o 	:	out std_logic_vector(15 downto 0)
);
end ex_mem;

architecture Behavioral of ex_mem is

begin


end Behavioral;

