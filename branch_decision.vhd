----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:31:52 11/23/2017 
-- Design Name: 
-- Module Name:    branch_decision - Behavioral 
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

entity branch_decision is port(
	next_pc_in : in std_logic_vector(15 downto 0);
	branch_target : in std_logic_vector(15 downto 0);
	branch_cond : in std_logic;
	is_branch 	: in std_logic;
	is_cond		: in std_logic;
	branch_en	: in std_logic		
	);
end branch_decision;

architecture Behavioral of branch_decision is
begin


end Behavioral;

