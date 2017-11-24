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

		dstSrc	:	in std_logic_vector(3 downto 0);
		wbSrc		:	in std_logic;
		wbEN		:	in std_logic;
		
		dstSrc_o		:	out std_logic_vector(3 downto 0);
		wbSrc_o		:	out std_logic;
		wbEN_o		:	out std_logic;

		ramData	: in std_logic_vector(15 downto 0);
		ALUres	: in std_logic_vector(15 downto 0);
		
		ramData_o	: out std_logic_vector(15 downto 0);
		ALUres_o		: out std_logic_vector(15 downto 0)
	);
end mem_wb;

architecture Behavioral of mem_wb is
	signal inner_dstSrc	:	std_logic_vector(3 downto 0);
	signal inner_wbSrc	:	std_logic;
	signal inner_wbEN		:	std_logic;
	
	signal inner_ramData	:  std_logic_vector(15 downto 0);
	signal inner_ALUres	:  std_logic_vector(15 downto 0);
	
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			inner_dstSrc <= dstSrc;
			inner_wbSrc <= wbSrc;
			inner_wbEN <= wbEN;
			inner_ramData <= ramData;
			inner_ALUres <= ALUres;
		end if;
	end process;
	
	dstSrc_o <= inner_dstSrc;
	wbSrc_o <= inner_wbSrc;
	wbEN_o <= inner_wbEN;
	ramData_o <= inner_ramData;
	ALUres_o <= inner_ALUres;

end Behavioral;

