----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:47:22 11/17/2017 
-- Design Name: 
-- Module Name:    write_back - Behavioral 
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

entity write_back is port(
		dstSrc	:	in std_logic_vector(3 downto 0);
		wbSrc		:	in std_logic;
		wbEN		:	in std_logic;
		
		ramData	: in std_logic_vector(15 downto 0);
		ALUres	: in std_logic_vector(15 downto 0);

		int		: in std_logic;
		intCode	: in std_logic_vector(3 downto 0);
		
		writeData : out std_logic_vector(15 downto 0);
		writeDst : out std_logic_vector(3 downto 0);
		isWriting : out std_logic

		int_o		: out std_logic;
		intCode_o	: out std_logic_vector(3 downto 0)
	);
end write_back;

architecture Behavioral of write_back is

begin
	
	process(wbEN, wbSrc, dstSrc, ALUres, ramData, int, intCode)
	begin
		if int = '1' then
			writeData <= (others => '0');
			writeDst <= (othes => '0');
			isWriting <= '0';

			int_o <= '1';
			intCode_o <= intCode;
		else
			isWriting <= wbEN;
			int_o <= '0';
			if (wbEN = '1') then
				if (wbSrc = '1') then
					writeData <= ALUres;
				else
					writeData <= ramData;
				end if;
				writeDst <= dstSrc;
			else
				writeData <= (others => '0');
				writeDst <= (others => '0');
			end if;
		end if;
	end process;

end Behavioral;

