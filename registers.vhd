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
	signal r0 : std_logic_vector(15 downto 0) := "0000000000000000";
	signal r1 : std_logic_vector(15 downto 0) := "0000000000000000";
	signal r2 : std_logic_vector(15 downto 0) := "0000000000000000";
	signal r3 : std_logic_vector(15 downto 0) := "0000000000000000";
	signal r4 : std_logic_vector(15 downto 0) := "0000000000000000";
	signal r5 : std_logic_vector(15 downto 0) := "0000000000000000";
	signal r6 : std_logic_vector(15 downto 0) := "0000000000000000";
	signal r7 : std_logic_vector(15 downto 0) := "0000000000000000";
	
	signal IH : std_logic_vector(15 downto 0) := "0000000000000000";
	signal SP : std_logic_vector(15 downto 0) := "0000000000000000";
	signal T : std_logic_vector(15 downto 0) := "0000000000000000";
begin
	process(regSrcA)
	begin
		case regSrcA is
			when "0000" => regA <= r0;
			when "0001" => regA <= r1;
			when "0010" => regA <= r2;
			when "0011" => regA <= r3;
			when "0100" => regA <= r4;
			when "0101" => regA <= r5;
			when "0110" => regA <= r6;
			when "0111" => regA <= r7;
			when reg_IH => regA <= IH;
			when reg_SP => regA <= SP;
			when reg_T  => regA <= T;
			when others => regA <= (others => '0');
		end case;
	end process;

	process(regSrcB)
	begin
		case regSrcB is
			when "0000" => regB <= r0;
			when "0001" => regB <= r1;
			when "0010" => regB <= r2;
			when "0011" => regB <= r3;
			when "0100" => regB <= r4;
			when "0101" => regB <= r5;
			when "0110" => regB <= r6;
			when "0111" => regB <= r7;
			when reg_IH => regB <= IH;
			when reg_SP => regB <= SP;
			when reg_T  => regB <= T;
			when others => regA <= (others => '0');
		end case;
	end process;
	
	process(writeEN, writeSrc, writeData)
	begin
		case writeSrc is
			when "0000" => r0 <= writeData;
			when "0001" => r1 <= writeData;
			when "0010" => r2 <= writeData;
			when "0011" => r3 <= writeData;
			when "0100" => r4 <= writeData;
			when "0101" => r5 <= writeData;
			when "0110" => r6 <= writeData;
			when "0111" => r7 <= writeData;
			when reg_IH => IH <= writeData;
			when reg_SP => SP <= writeData;
			when reg_T  => T <= writeData;
			when others => -- do nothing
		end case;
	end process;

end Behavioral;

