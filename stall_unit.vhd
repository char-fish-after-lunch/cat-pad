----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:46:12 11/17/2017 
-- Design Name: 
-- Module Name:    stall_unit - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--	This is the stall unit for CATPAD.
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


entity stall_unit is
	port(
		exeWbEN: in std_logic;
		exeDstSrc: in std_logic_vector(3 downto 0);
		exeRamRead: in std_logic;
		idRegSrcA: in std_logic_vector(3 downto 0);
		idRegSrcB: in std_logic_vector(3 downto 0);

		pcPause: out std_logic;
		idKeep: out std_logic;
		exeClear: out std_logic
	);
end stall_unit;

architecture Behavioral of stall_unit is

begin
	process(exeWbEN, exeDstSrc, exeRamRead, idRegSrcA, idRegSrcB)
	begin
		-- deals with RAW conflict
		if (exeWbEN = '1') and (exeRamRead = '1') and
			((exeDstSrc = idRegSrcA) or (exeDstSrc = idRegSrcB)) then
			pcPause <= '1';
			idKeep <= '1';
			exeClear <= '1';
		else
			pcPause <= '0';
			idKeep <= '0';
			exeClear <= '0';
		end if;
	end process;

end Behavioral;

