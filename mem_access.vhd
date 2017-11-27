----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:42:59 11/17/2017 
-- Design Name: 
-- Module Name:    mem_access - Behavioral 
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

entity mem_access is port(

		int			: in std_logic;
		intCode		: in std_logic_vector(3 downto 0);

		ram_addr 	: in std_logic_vector(15 downto 0);
		ram_data_in : in std_logic_vector(15 downto 0);
		
		ramWrite	:	in std_logic;
		ramRead	:	in std_logic;
		
		-- signals sen to ram dispatcher
		ramWrite_o	:	out std_logic;
		ramRead_o	:	out std_logic;
		ram_addr_o  : out std_logic_vector(15 downto 0);
		ram_data_o  : out std_logic_vector(15 downto 0);
		
		-- result get from ram dispatcher
		ram_return	 : in std_logic_vector(15 downto 0);
		ram_return_o : out std_logic_vector(15 downto 0);

		int_o		: out std_logic;
		intCode_o	: out std_logic_vector(3 downto 0)
		
		
	);
end mem_access;

architecture Behavioral of mem_access is

begin
	process(ram_Write, ramRead, ram_addr, ram_data_in, ram_return, int, intCode)
	begin
		if int = '1' then
			ramWrite_o <= '0';
			ramRead_o <= '0';
			ram_addr_o <= (others => '0');
			ram_data_o <= (others => '0');
			ram_return_o <= (others => '0');

			int_o <= '1';
			intCode_o <= intCode;
		else
			ramWrite_o <= ramWrite;
			ramRead_o <= ramRead;
			ram_addr_o <= ram_addr;
			ram_data_o <= ram_data_in;
			
			ram_return_o <= ram_return;

			int_o <= '0';
		end if;
	end process;

end Behavioral;

