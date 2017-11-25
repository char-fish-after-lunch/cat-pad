----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:32:26 11/25/2017 
-- Design Name: 
-- Module Name:    bootloader - Behavioral 
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

entity bootloader is port(
	clk : in std_logic;
	isBootloaded : in std_logic;
	flashByte : out std_logic;
	flashVpen : out std_logic;
	flashCE : out std_logic;
	flashOE : out std_logic;
	flashWE : out std_logic;
	flashRP : out std_logic;
	flash_addr : out std_logic_vector(22 downto 0);
	flash_data : inout std_logic_vector(15 downto 0);
	
	ram1addr : out  STD_LOGIC_VECTOR (17 downto 0);
	ram1data : inout  STD_LOGIC_VECTOR (15 downto 0);
	ram1oe : out  STD_LOGIC;
	ram1rw : out  STD_LOGIC;
	ram1en : out  STD_LOGIC;
	
	rdn : out  STD_LOGIC;
	wrn : out  STD_LOGIC;

	isBootloaded_o : out STD_LOGIC
);
end bootloader;

architecture Behavioral of bootloader is

begin


end Behavioral;

