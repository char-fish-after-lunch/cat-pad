----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:38:32 11/17/2017 
-- Design Name: 
-- Module Name:    inst_fetch - Behavioral 
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

entity inst_fetch is port(
		pc: in std_logic_vector(15 downto 0);
		instr: out std_logic_vector(15 downto 0);

		if_addr: out std_logic_vector(15 downto 0);
		if_data: in std_logic_vector(15 downto 0);

		int_o: out std_logic;
		intCode_o: out std_logic_vector(3 downto 0)
	);
end inst_fetch;

architecture Behavioral of inst_fetch is

begin
	if_addr <= pc;
	instr <= if_data;
	int_o <= '0';
	intCode_o <= (others => '0');
end Behavioral;

