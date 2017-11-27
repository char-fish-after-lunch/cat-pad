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

	int		: 	in std_logic;
	intCode	:	in std_logic_vector(3 downto 0);
	
	dstSrc_o		:	out std_logic_vector(3 downto 0);
	ramWrite_o	:	out std_logic;
	ramRead_o	:	out std_logic;
	wbSrc_o		:	out std_logic;
	wbEN_o		:	out std_logic;
	
	regB_o 		:  out std_logic_vector(15 downto 0);
	ALUres_o 	:	out std_logic_vector(15 downto 0)

	int_o		: 	in std_logic;
	intCode_o	:	in std_logic_vector(3 downto 0);
);
end ex_mem;

architecture Behavioral of ex_mem is
	
	signal inner_dstSrc		:	std_logic_vector(3 downto 0) := "0000";
	signal inner_ramWrite	:	std_logic := '0';
	signal inner_ramRead		:	std_logic := '0';
	signal inner_wbSrc		:	std_logic := '0';
	signal inner_wbEN			:	std_logic := '0';
	
	signal inner_regB 		:  std_logic_vector(15 downto 0) := "0000000000000000";
	signal inner_ALUres 		:	std_logic_vector(15 downto 0) := "0000000000000000";
	
	signal inner_int: 	std_logic;
	signal inner_intCode	:	std_logic_vector(3 downto 0);
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			inner_dstSrc <= dstSrc;
			inner_ramWrite	<=	ramWrite;
			inner_ramRead	<=	ramRead;
			inner_wbSrc	<=	wbSrc;
			inner_wbEN	<=	wbEN;
			inner_regB	<=	regB;
			inner_ALUres	<=	ALUres;
			inner_int	<= int;
			inner_intCode <= intCode;
		end if;
	end process;
	
	dstSrc_o 	<= inner_dstSrc;
	ramWrite_o  <= inner_ramWrite;
	ramRead_o	<=	inner_ramRead;
	wbSrc_o		<=	inner_wbSrc;
	wbEN_o		<=	inner_wbEN;
	regB_o		<=	inner_regB;
	ALUres_o		<=	inner_ALUres;

	int_o		<=	inner_int;
	intCode_o	<=	inner_intCode;

end Behavioral;

