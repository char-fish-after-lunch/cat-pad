library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity cp0_registers is
	port(
		cause: in std_logic_vector(7 downto 0);
		epc: in std_logic_vector(15 downto 0)


		
		cause_o: out std_logic;
		epc_o: out std_logic;
		status_o: out std_logic
	);
	
end entity;

