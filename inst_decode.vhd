----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:40:12 11/17/2017 
-- Design Name: 
-- Module Name:    inst_decode - Behavioral 
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
use cat_pad.consts.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity inst_decode is port(
		inst : in std_logic_vector(15 downto 0);
		regSrcA : in std_logic_vector(3 downto 0);
		regSrcB : in std_logic_vector(3 downto 0);
		immeCtrl : in std_logic_vector(2 downto 0);
		immeExt : in std_logic;
		
		regAN : out std_logic_vector(3 downto 0);
		regBN : out std_logic_vector(3 downto 0);
		immediate : out std_logic_vector(15 downto 0)
	);
end inst_decode;

architecture Behavioral of inst_decode is

begin


end Behavioral;

