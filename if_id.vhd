----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:38:51 11/17/2017 
-- Design Name: 
-- Module Name:    if_id - Behavioral 
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

entity if_id is port(
	clk : in std_logic;

	keep : in std_logic;
	clear : in std_logic;

	IFPC : in std_logic_vector(15 downto 0);
	inst : in std_logic_vector(15 downto 0);
	int : in std_logic;
	intCode : in std_logic_vector(3 downto 0);


	IFPC_o : out std_logic_vector(15 downto 0);
	inst_o : out std_logic_vector(15 downto 0);
	int_o : out std_logic;
	intCode_o : out std_logic_vector(3 downto 0);
	bubble_o : out std_logic 
);
end if_id;

architecture Behavioral of if_id is
	signal inner_IFPC : std_logic_vector(15 downto 0);
	signal inner_inst : std_logic_vector(15 downto 0);
	signal inner_int : std_logic;
	signal inner_intCode : std_logic_vector(3 downto 0);
	signal inner_bubble : std_logic := '1';
begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if clear = '1' then
				inner_IFPC <= IFPC; -- do not clear PC
				inner_bubble <= '1'; -- is a bubble
				inner_inst <= "0000100000000000";
				inner_int <= '0';
				inner_intCode <= (3 downto 0 => '0');
			elsif keep = '0' then
				inner_IFPC <= IFPC;
				inner_inst <= inst;
				inner_int <= int;
				inner_intCode <= intCode;
				inner_bubble <= '0';
			end if;
		end if;
	end process;
	
	IFPC_o <= inner_IFPC;
	inst_o <= inner_inst;
	int_o <= inner_int;
	intCode_o <= inner_intCode;
	bubble_o <= inner_bubble;

end Behavioral;

