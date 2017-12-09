----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:43:13 11/17/2017 
-- Design Name: 
-- Module Name:    mem_wb - Behavioral 
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

entity mem_wb is port(
		clk : in std_logic;

		clear : in std_logic;

		dstSrc	:	in std_logic_vector(3 downto 0);
		wbSrc		:	in std_logic;
		wbEN		:	in std_logic;

		int			:	in std_logic;
		intCode		:	in std_logic_vector(3 downto 0);
		isERET		:	in std_logic;
		isBranch	:	in std_logic;
		
		dstSrc_o		:	out std_logic_vector(3 downto 0);
		wbSrc_o		:	out std_logic;
		wbEN_o		:	out std_logic;

		ramData	: in std_logic_vector(15 downto 0);
		ALUres	: in std_logic_vector(15 downto 0);

		PC		: in std_logic_vector(15 downto 0);
		PC_o	: out std_logic_vector(15 downto 0);

		isMTEPC	: in std_logic;

		isMTEPC_o : out std_logic;

		bubble	: in std_logic;
		bubble_o	: out std_logic;
		
		ramData_o	: out std_logic_vector(15 downto 0);
		ALUres_o		: out std_logic_vector(15 downto 0);

		isERET_o		:	out std_logic;

		int_o			:	out std_logic;
		intCode_o		:	out std_logic_vector(3 downto 0);
		isBranch_o		:	out std_logic
	);
end mem_wb;

architecture Behavioral of mem_wb is
	signal inner_dstSrc	:	std_logic_vector(3 downto 0);
	signal inner_wbSrc	:	std_logic;
	signal inner_wbEN		:	std_logic;
	
	signal inner_ramData	:  std_logic_vector(15 downto 0);
	signal inner_ALUres	:  std_logic_vector(15 downto 0);

	signal inner_isERET	: std_logic := '0';
	signal inner_int	: std_logic := '0';
	signal inner_intCode 	: std_logic_vector(3 downto 0);

	signal inner_bubble	: std_logic := '1';
	signal inner_PC		: std_logic_vector(15 downto 0);
	signal inner_isMTEPC	: std_logic := '0';
	signal inner_isBranch	: std_logic := '0';
	
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if clear = '0' then
				inner_dstSrc <= dstSrc;
				inner_wbSrc <= wbSrc;
				inner_wbEN <= wbEN;
				inner_ramData <= ramData;
				inner_ALUres <= ALUres;
				inner_int	<= int;
				inner_intCode	<= intCode;
				inner_isERET	<= isERET;
				inner_PC		<= PC;
				inner_bubble	<= bubble;
				inner_isMTEPC	<= isMTEPC;
				inner_isBranch	<= isBranch;
			else
				inner_dstSrc <= (others => '0');
				inner_wbSrc <= '0';
				inner_wbEN <= '0';
				inner_ramData <= (others => '0');
				inner_ALUres <= (others => '0');

				inner_int <= '0';
				inner_intCode <= (others => '0');
				inner_isERET <= '0';
				inner_PC	<= PC;
				inner_bubble	<= '1';
				inner_isMTEPC	<= '0';
				inner_isBranch <= '0';
			end if;
		end if;
	end process;
	
	dstSrc_o <= inner_dstSrc;
	wbSrc_o <= inner_wbSrc;
	wbEN_o <= inner_wbEN;
	ramData_o <= inner_ramData;
	ALUres_o <= inner_ALUres;

	int_o	<= inner_int;
	intCode_o	<= inner_intCode;
	isERET_o	<= inner_isERET;

	bubble_o	<= inner_bubble;
	PC_o		<= inner_PC;
	isMTEPC_o	<= inner_isMTEPC;
	isBranch_o	<= inner_isBranch;

end Behavioral;

