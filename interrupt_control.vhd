library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity interrupt_control is
	port(
		wbInt: in std_logic; -- whether there is an interrupt in WB
		wbIntCode: in std_logic_vector(3 downto 0); -- interrupt code in WB
		wbERet : in std_logic; -- whether the instruction is an eret
		memAddress : in std_logic_vector(15 downto 0); -- the address of the next instruction

		cp0Status : in std_logic;
		cp0Epc : in std_logic_vector(15 downto 0);
		cp0Cause : in std_logic_vector(15 downto 0);

		-- external hardware ISRs
		ps2Request : in std_logic; -- PS/2 ISR
		
		memRamLock: out std_logic;
		pipelineClear: out std_logic; -- whether clear the whole pipeline

		cp0StatusUpdate : out std_logic;
		cp0EpcUpdate : out std_logic_vector(15 downto 0);
		cp0CauseUpdate : out std_logic_vector(15 downto 0)
		cp0ERetUpdate : out std_logic_vector;
		cp0TrapUpdate : out std_logic_vector
	);
end interrupt_control;

architecture behavioral of interrupt_control is
begin
	process(wbInt, wbIntCode, cp0Cause, cp0Epc, cp0Status, memAddress)
		variable cp0Changed : std_logic := '0';
		variable cp0CauseUpdateV : std_logic_vector(15 downto 0) := cp0Cause;
		variable cp0EpcUpdateV : std_logic_vector(15 downto 0) := cp0Epc;
		variable cp0StatusUpdateV : std_logic := cp0Status;	
	begin
		memRamLock <= '0';
		pipelineClear <= '0';
		cp0ERetUpdate <= '0';
		cp0TrapUpdate <= '0';

		if ps2Request = '1' then
			cp0Changed := '1';
			cp0CauseUpdateV(11) := '1' -- 11 for PS/2 ISR
		end if;

		if wbInt = '1' then
			-- an interrupt has happened!
			-- keep the address of the current address and the next address
			-- and prevents the next instruction from writing RAM (for it is now in the MEM stage)

			if cp0Status = '0' then -- if interrupt allowed
				cp0Changed := '1';
				cp0CauseUpdateV(to_unsigned(wbIntCode)) := '1'; 
			end if;
			
		elsif wbERet = '1' then
			cp0ERetUpdate <= '1';	
			-- we assume that eret and int cannot be 1 at the same time
		end if;
		if cp0Changed = '1' and cp0Status = '0' then
			-- this means that the CP0 running state would be changed (switched
			-- from the user mode to the kernel mode)
			memRamLock <= '1';
			pipelineClear <= '1';
			cp0EpcUpdateV := memAddress;
			cp0TrapUpdate <= '1';
		end if;
	
		cp0StatusUpdate <= cp0CauseUpdateV;
		cp0EpcUpdate <= cp0EpcUpdateV;
		cp0CauseUpdate <= cp0StatusUpdateV;

	end process;
end behavioral;

