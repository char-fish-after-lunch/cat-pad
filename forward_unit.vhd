----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:43:52 11/17/2017 
-- Design Name: 
-- Module Name:    forward_unit - Behavioral 
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

entity forward_unit is port(
		regReadSrcA : in std_logic_vector(3 downto 0);
		regReadSrcB : in std_logic_vector(3 downto 0);
		memDst 		: in std_logic_vector(3 downto 0);
		memWbEN		: in std_logic;
		wbDst 		: in std_logic_vector(3 downto 0);
		wbEN		: in std_logic;
		ramRead		: in std_logic;
		oprSrcB		: in std_logic;
		wbSrc		: in std_logic;
		--add one to check if it is reading from ram

		srcA	: out std_logic_vector(1 downto 0);
		srcB	: out std_logic_vector(1 downto 0)
	);
end forward_unit;

architecture Behavioral of forward_unit is

begin
	process(regReadSrcA, regReadSrcB, memDst, wbDst, ramRead, oprSrcB, wbSrc, wbEN, memWbEN)
	begin
	if(regReadSrcA = memDst and ramRead = '0' and memWbEN = '1') then
		srcA <= fwd_alu_res;
		--use data from mem
	elsif(regReadSrcA = wbDst and wbEN = '1') then
		if (wbSrc = '1') then
			srcA <= fwd_wb_alu;
		else
			srcA <= fwd_wb_ram;
		end if;
		--use data from wb
	else
		srcA <= fwd_original;
		--else use register or imm
	end if; 

	if(oprSrcB = '1') then
		srcB <= fwd_original;
		--never use register
	elsif(regReadSrcB = memDst and ramRead = '0' and memWbEN = '1') then
		srcB <= fwd_alu_res;
		--use data from mem
	elsif(regReadSrcB = wbDst and wbEN = '1') then
		if (wbSrc = '1') then
			srcB <= fwd_wb_alu;
		else
			srcB <= fwd_wb_ram;
		end if;
		--use data from wb
	else
		srcB <= fwd_original;
		--else use register or imm
	end if;
	end process;
end Behavioral;

