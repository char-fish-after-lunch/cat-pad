library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity interrupt_control is
	port(
		wbInt: in std_logic; -- whether there is an interrupt in WB
		wbIntCode: in std_logic_vector(3 downto 0); -- interrupt code in WB
		wbERet : in std_logic; -- whether the instruction is an eret
		memAddress : in std_logic_vector(15 downto 0); -- the address of the next instruction

		cp0Status : in std_logic;
		cp0Epc : in std_logic_vector(15 downto 0);
		cp0Cause : in std_logic_vector(15 downto 0);
		cp0ERet : in std_logic;
		cp0Trap : in std_logic;

		-- external hardware ISRs
		ps2Request : in std_logic; -- PS/2 ISR
		
		memRamLock: out std_logic;
		pipelineClear: out std_logic; -- whether clear the whole pipeline

		cp0StatusUpdate : out std_logic;
		cp0EpcUpdate : out std_logic_vector(15 downto 0);
		cp0CauseUpdate : out std_logic_vector(15 downto 0);
		cp0ERetUpdate : out std_logic;
		cp0TrapUpdate : out std_logic;

		pcSet : out std_logic;
		pcSetVal : out std_logic_vector(15 downto 0)
	);
end interrupt_control;

architecture behavioral of interrupt_control is
begin
	process(wbInt, wbIntCode, cp0Cause, cp0Epc, cp0Status, memAddress)
		type Cause is range 0 to 10;

		variable cp0IntEvent : std_logic := '0';
		variable cp0CauseUpdateV : std_logic_vector(15 downto 0) := cp0Cause;
		variable cp0EpcUpdateV : std_logic_vector(15 downto 0) := cp0Epc;
		variable cp0StatusUpdateV : std_logic := cp0Status;	
		variable cp0NextCause : Cause := 0;
	begin
		memRamLock <= '0';
		pipelineClear <= '0';
		cp0ERetUpdate <= '0';
		cp0TrapUpdate <= '0';
		pcSet <= '0';


		if ps2Request = '1' then
			cp0IntEvent := '1';
			cp0CauseUpdateV(10) := '1'; -- 11 for PS/2 ISR
		end if;

		if wbInt = '1' then
			-- an interrupt has happened!
			-- keep the address of the current address and the next address
			-- and prevents the next instruction from writing RAM (for it is now in the MEM stage)

			if cp0Status = '0' then -- if interrupt allowed
				cp0IntEvent := '1';
				cp0CauseUpdateV(to_integer(unsigned(wbIntCode))) := '1'; 
			end if;
			
		elsif wbERet = '1' then
			cp0ERetUpdate <= '1';	
			-- we assume that eret and int cannot be 1 at the same time
		end if;

		if cp0ERet = '1' then
			-- switch to user mode
			
			if cp0CauseUpdateV(11 downto 0) = (10 downto 0 => '0') then

				cp0StatusUpdateV := '0'; -- allow interrupt
				pcSet <= '1';
				pcSetVal <= cp0Epc;
			else
				-- pending interrupts exist
				-- go back to the interrupt handler
				for i in Cause loop
					if cp0CauseUpdateV(integer(i)) = '1' then 
						cp0NextCause := i;
					end if;
				end loop;
				cp0CauseUpdateV(integer(cp0NextCause)) := '0';
				cp0CauseUpdateV(14 downto 11) := std_logic_vector(to_unsigned(integer(cp0NextCause), 4));

				pcSet <= '1';
				pcSetVal <= (15 downto 3 => '0') & "101";
			end if;
		elsif cp0Trap = '1' then
			-- switch to kernel mode
			for i in Cause loop
				if cp0CauseUpdateV(integer(i)) = '1' then 
					cp0NextCause := i;
				end if;
			end loop;
			cp0CauseUpdateV(integer(cp0NextCause)) := '0';
			cp0CauseUpdateV(14 downto 11) := std_logic_vector(to_unsigned(integer(cp0NextCause), 4));

			pcSet <= '1';
			pcSetVal <= (15 downto 3 => '0') & "101";

			cp0StatusUpdateV := '1';
		end if;



		if cp0IntEvent = '1' and cp0StatusUpdateV = '0' then
			-- this means that the CP0 running state would be changed (switched
			-- from the user mode to the kernel mode)
			memRamLock <= '1';
			pipelineClear <= '1';
			cp0EpcUpdateV := memAddress;
			cp0TrapUpdate <= '1';
		end if;
	
		cp0StatusUpdate <= cp0StatusUpdateV;
		cp0EpcUpdate <= cp0EpcUpdateV;
		cp0CauseUpdate <= cp0CauseUpdateV;

	end process;
end behavioral;

