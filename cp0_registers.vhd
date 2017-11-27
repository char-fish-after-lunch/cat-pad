library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity cp0_registers is
	port(
		clk : in std_logic;
		causeIn : in std_logic_vector(15 downto 0);
		epcIn : in std_logic_vector(15 downto 0);
		statusIn : in std_logic;
		trapIn : in std_logic;
		eretIn : in std_logic;

		cause : out std_logic_vector(15 downto 0);
		epc : out std_logic_vector(15 downto 0);
		status :  out std_logic;
		trap : out std_logic;
		eret : out std_logic
	);
end entity;

architecture Behavioral of cp0_registers is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			cause <= causeIn;
			epc <= epcIn;
			status <= statusIn;
			eret <= eretIn;
			trap <= trapIn;
		end if;
	end process;
end Behavioral;

