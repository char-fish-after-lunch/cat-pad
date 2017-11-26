----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:25:17 11/25/2017 
-- Design Name: 
-- Module Name:    uart_module - Behavioral 
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

entity uart_module is port(
	clk : in STD_LOGIC;
	uart_isRead : in STD_LOGIC;
	uart_isUsed : in STD_LOGIC;
	uart_data : in STD_LOGIC_VECTOR(15 downto 0);
	uart_res : out STD_LOGIC_VECTOR(15 downto 0);
	isData : in STD_LOGIC;

	put_data : inout STD_LOGIC_VECTOR (15 downto 0);
	rdn : out  STD_LOGIC;
	wrn : out  STD_LOGIC;
	tbre : in  STD_LOGIC;
	tsre : in  STD_LOGIC;
	data_ready : in  STD_LOGIC
);
end uart_module;

architecture Behavioral of uart_module is

begin
	rdn <= '1';
	wrn <= '1';
	uart_res <= (others => '0');
end Behavioral;

