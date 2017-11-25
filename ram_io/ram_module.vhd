----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:25:02 11/25/2017 
-- Design Name: 
-- Module Name:    ram_module - Behavioral 
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

entity ram_module is port(
	clk : in STD_LOGIC;
	ram_addr : in STD_LOGIC_VECTOR (15 downto 0);
	ram_data : in STD_LOGIC_VECTOR (15 downto 0);
	ram_res  : out STD_LOGIC_VECTOR (15 downto 0);
	ram_isRead : in STD_LOGIC;
	ram_isUsed : in STD_LOGIC;
	
	ram_addr_o : out  STD_LOGIC_VECTOR (17 downto 0);
	put_data_o : inout  STD_LOGIC_VECTOR (15 downto 0);
	ram_oe_o   : out  STD_LOGIC;
	ram_rw_o   : out  STD_LOGIC;
	ram_en_o   : out  STD_LOGIC
);
end ram_module;

architecture Behavioral of ram_module is
	
begin
	

end Behavioral;

