----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:39:48 11/17/2017 
-- Design Name: 
-- Module Name:    registers - Behavioral 
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

entity registers is port(
		regSrcA : in std_logic_vector(3 downto 0);
		regSrcB : in std_logic_vector(3 downto 0);
		
		writeSrc 	: in std_logic_vector(3 downto 0);
		writeData 	: in std_logic_vector(15 downto 0);
		
		writeEN		: in std_logic;
	
		regA : out std_logic_vector(15 downto 0);
		regB : out std_logic_vector(15 downto 0)
	);
end registers;

architecture Behavioral of registers is
	signal regs : std_logic_vector(7 downto 0) := "00000000";
	signal IH : std_logic := '0';
	signal SP : std_logic := '0';
	signal T : std_logic := '0';
begin
	process(regSrcA)
	begin
		case regSrcA is
			when "0000" => regA <= regs(0);
			when "0001" => regA <= regs(1);
			when "0010" => regA <= regs(2);
			when "0011" => regA <= regs(3);
			when "0100" => regA <= regs(4);
			when "0101" => regA <= regs(5);
			when "0110" => regA <= regs(6);
			when "0111" => regA <= regs(7);
			when reg_IH => regA <= IH;
			when reg_SP => regA <= SP;
			when reg_T  => regA <= T;
		end case;
	end process;

	process(regSrcB)
	begin
		case regSrcB is
			when "0000" => regB <= regs(0);
			when "0001" => regB <= regs(1);
			when "0010" => regB <= regs(2);
			when "0011" => regB <= regs(3);
			when "0100" => regB <= regs(4);
			when "0101" => regB <= regs(5);
			when "0110" => regB <= regs(6);
			when "0111" => regB <= regs(7);
			when reg_IH => regB <= IH;
			when reg_SP => regB <= SP;
			when reg_T  => regB <= T;
		end case;
	end process;
	
	process(writeEN, writeSrc, writeData)
	begin
		case writeSrc is
			when "0000" => regs(0) <= writeData;
			when "0001" => regs(1) <= writeData;
			when "0010" => regs(2) <= writeData;
			when "0011" => regs(3) <= writeData;
			when "0100" => regs(4) <= writeData;
			when "0101" => regs(5) <= writeData;
			when "0110" => regs(6) <= writeData;
			when "0111" => regs(7) <= writeData;
			when reg_IH => IH <= writeData;
			when reg_SP => SP <= writeData;
			when reg_T  => T <= writeData;
		end case;
	end process;

end Behavioral;

