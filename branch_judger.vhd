----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:56:47 11/24/2017 
-- Design Name: 
-- Module Name:    branch_judger - Behavioral 
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

entity branch_judger is port(
	ALUres		:  in std_logic_vector(15 downto 0); -- ALU result
	shifted_PC	:	in std_logic_vector(15 downto 0); -- PC + immediate
	next_PC		:	in std_logic_vector(15 downto 0); -- PC + 1
	isBranch		:	in std_logic;
	isCond		:	in std_logic;
	isRelative	:	in std_logic;

	next_PC_o	: out std_logic_vector(15 downto 0)  -- real next PC
);
end branch_judger;

architecture Behavioral of branch_judger is

begin

	process(isBranch, isCond, isRelative, ALUres, shifted_PC, next_PC)
	begin
		if (isBranch = '1') then
			if (isCond = '1') then
				if (ALUres(0) = '1') then
					if (isRelative = '1') then
						next_PC_o <= shifted_PC;
					else
						next_PC_o <= ALUres;
					end if;
				else
					next_PC_o <= next_PC; -- condition not satisfied
				end if;
			else 
				if (isRelative = '1') then
					next_PC_o <= shifted_PC;
				else
					next_PC_o <= ALUres;
				end if;
			end if;
		else
			next_PC_o <= next_PC;
		end if;
	end process;

end Behavioral;

