library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity interrupt_control is
	port(
		wbInt: in std_logic; -- whether there is an interrupt in WB
		wbIntCode: in std_logic_vector(7 downto 0) -- interrupt code in WB
		
		memRamLock: out std_logic;
		pipelineClear: out std_logic; -- whether clear the whole pipeline

				
		
		-- force the PC to ...
		setPC: out std_logic;
		setPCVal: out std_logic_vector(15 downto 0); 
	);
end interrupt_control;

architecture behavioral of interrupt_control is
begin
	process(wbInt, wbIntCode)
	begin
		memRamLock <= '0';
		pipelineClear <= '0';
		setPC <= '0';

		if wbInt then
			-- an interrupt has happened!
			-- keep the address of the current address and the next address
			-- and prevents the next instruction from writing RAM (for it is now in the MEM stage)
			memRamLock <= '1';
			pipelineClear <= '1';

			setPC <= '1';
			setPCVal <= (15 downto 4 => '0') & "101"; -- set PC to 0x0005, the start of the interrupt handler
		end if;
	end process;
end behavioral;

