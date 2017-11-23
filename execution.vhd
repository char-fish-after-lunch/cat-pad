----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:41:33 11/17/2017 
-- Design Name: 
-- Module Name:    execution - Behavioral 
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

entity execution is port(
		regA 			:  in std_logic_vector(15 downto 0);
		regB 			:  in std_logic_vector(15 downto 0);
		regAN 		:  in std_logic_vector(3 downto 0);
		regBN 		:  in std_logic_vector(3 downto 0);
		immediate	:  in std_logic_vector(15 downto 0);
		PC 			:  in std_logic_vector(15 downto 0);
		oprSrcB		:	in std_logic;
		ALUres		:	in std_logic_vector(15 downto 0);
		isMFPC		:	in std_logic;
		
		-- signal from forward unit
		fwdSrcA	: in std_logic_vector(1 downto 0);
		fwdSrcB	: in std_logic_vector(1 downto 0);
		
		-- signals used to decide forward unit result
		mem_aluRes	: in std_logic_vector(15 downto 0);
		wb_ramRes	: in std_logic_vector(15 downto 0);
		wb_aluRes	: in std_logic_vector(15 downto 0);
		wbSrc			: in std_logic;
		
		regA_o 		:  out std_logic_vector(15 downto 0);
		regB_o 		:  out std_logic_vector(15 downto 0);
		
		regB_o 		:  out std_logic_vector(15 downto 0);
		ALUres_o 	:	out std_logic_vector(15 downto 0);
		out_PC		:	out std_logic_vector(15 downto 0)
	);
end execution;

architecture Behavioral of execution is

begin


end Behavioral;

