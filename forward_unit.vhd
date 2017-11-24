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
		wbDst 		: in std_logic_vector(3 downto 0);
		ramRead		: in std_logic;
		oprSrcB		: in std_logic;
		--加一个判断是不是从内存里面读指令
		
		srcA	: out std_logic_vector(1 downto 0);
		srcB	: out std_logic_vector(1 downto 0)
	);
end forward_unit;

architecture Behavioral of forward_unit is

begin
	if(regReadSrcA = memDst and regReadSrcA = wbDst and ramRead = '0') then
		srcA <= fwd_wb_ram;
		--both need to write, use mem
	elsif(regReadSrcA = memDst and ramRead = '0') then
		srcA <= fwd_alu_res
		--use data from mem
	elsif(regReadSrcA = wbDst and ramRead = '0') then
		srcA <= fwd_wb_alu;
		--use data from wb
	else
		srcA <= fwd_original;
		--else use register or imm
	end if;

	if(oprSrcB = '1') then
		srcB <= fwd_original;
		--never use register
	elsif(regReadSrcB = memDst and regReadSrcB = wbDst and ramRead = '0') then
		srcB <= fwd_wb_ram;
		--both need to write, use mem
	elsif(regReadSrcB = memDst and ramRead = '0') then
		srcB <= fwd_alu_res;
		--use data from mem
	elsif(regReadSrcB = wbDst and ramRead = '0') then
		srcB <= fwd_wb_alu;
		--use data from wb
	else
		srcB <= fwd_original;
		--else use register or imm
	end if;

end Behavioral;

