library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_forward_unit is port(
	idRamWrite: in std_logic;
	idRegA: in std_logic_vector(15 downto 0);
	idRegB: in std_logic_vector(15 downto 0);
	idImme: in std_logic_vector(15 downto 0);

	exeRamWrite: in std_logic;
	exeAluRes: in std_logic_vector(15 downto 0);
	exeRegB: in std_logic_vector(15 downto 0);

	address: in std_logic_vector(15 downto 0);
	originalInstr: in std_logic_vector(15 downto 0);

	instr: out std_logic_vector(15 downto 0)
);
end instruction_forward_unit;

architecture Behavioral of instruction_forward_unit is
begin
	process(idRamWrite, idRegA, idRegB, idImme,
		exeRamWrite, exeAluRes, exeRegB,
		originalInstr)
	begin
		
		if idRamWrite = '1' and 
			std_logic_vector((unsigned(idRegA)) + (unsigned(idImme))) = address then
			instr <= idRegB;
		elsif exeRamWrite = '1' and exeAluRes = address then
			instr <= exeRegB;
		else
			instr <= originalInstr;
		end if;
		
	end process;
end Behavioral;


