----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:41:16 11/17/2017 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.ALL;

use work.consts.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is port(
		regA : in std_logic_vector(15 downto 0);
		regB : in std_logic_vector(15 downto 0);
		ALUop : in std_logic_vector(3 downto 0);
		ALUres : out std_logic_vector(15 downto 0)
	);
end alu;

architecture Behavioral of alu is
	
begin
	process(regA, regB, ALUop)
	begin
		case (ALUop) is
			when alu_add => ALUres <= regA + regB;
			when alu_sub => ALUres <= regA - regB;
			when alu_and => ALUres <= regA and regB;
			when alu_or  => ALUres <= regA or regB;
			when alu_sll => ALUres <= std_logic_vector(shift_left(unsigned(regA), to_integer(signed(regB))));
			when alu_slr => ALUres <= std_logic_vector(shift_right(unsigned(regA), to_integer(signed(regB))));
			when alu_sar => ALUres <= std_logic_vector(shift_right(signed(regA), to_integer(signed(regB))));
			when alu_equ => 
				if (regA = regB) then
					ALUres <= "0000000000000001";
				else 
					ALUres <= "0000000000000000";
				end if;
				
			when alu_neq => 
				if (regA = regB) then
					ALUres <= "0000000000000000";
				else 
					ALUres <= "0000000000000001";
				end if;
				
			when alu_o_a => ALUres <= regA;
			when alu_o_b => ALUres <= regB;
			when alu_gr  => 
				if (regA < regB) then
					ALUres <= "0000000000000001";
				else 
					ALUres <= "0000000000000000";
				end if;
			when alu_gr_s =>
				if regA(15) = regB(15) then
					if regA < regB then
						ALUres <= "0000000000000001";
					else
						ALUres <= "0000000000000000";
					end if;
				elsif regA(15) = '1' then
					ALUres <= "0000000000000000";
				else
					ALUres <= "0000000000000001";
				end if;
			when others => ALUres <= "0000000000000000";
		end case;
	end process;
end Behavioral;

