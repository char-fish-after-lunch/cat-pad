----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:17:51 11/17/2017 
-- Design Name: 
-- Module Name:    pc_controller - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pc_controller is port(
	clk : in std_logic;
	-- pause : in std_logic;
	next_pc_in : in std_logic_vector(15 downto 0);
	pc_pause : in std_logic;
	next_pc_out : out std_logic_vector(15 downto 0);
	pc_out : out std_logic_vector(15 downto 0)
	
	);
end pc_controller;

architecture Behavioral of pc_controller is
	signal inner_pc : std_logic_vector(15 downto 0) := "0000000000000000";
begin
	
	process(clk)
	begin
		if (rising_edge(clk) and (pc_pause = '0')) then
			inner_pc <= next_pc_in;
		end if;
	end process;
	
	next_pc_out <= inner_pc + "0000000000000001";
	pc_out <= inner_pc;
	
end Behavioral;

