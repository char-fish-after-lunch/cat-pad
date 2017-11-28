library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity interrupt_control is
	port(
		wbInt: in std_logic; -- whether there is an interrupt in WB
		wbIntCode: in std_logic_vector(3 downto 0); -- interrupt code in WB
		wbERet : in std_logic; -- whether the instruction is an eret
		wbIsMTEPC : in std_logic;
		wbALUres : in std_logic_vector(15 downto 0);
		
		memPC : in std_logic_vector(15 downto 0); -- PC in different stages
		exePC : in std_logic_vector(15 downto 0);
		idPC  : in std_logic_vector(15 downto 0);
		ifPC  : in std_logic_vector(15 downto 0);		

		wbBubble	: in std_logic;
		memBubble	: in std_logic;
		exeBubble	: in std_logic;
		idBubble	: in std_logic;
		

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
	process(wbInt, wbIntCode, wbERet, cp0Cause, cp0Epc, cp0Status, memPC, exePC, idPC, ifPC, cp0Trap, cp0ERet, 
			ps2Request, idBubble, exeBubble, memBubble, wbBubble,
			wbIsMTEPC, wbALUres)
			type Cause is range 0 to 10;

		variable cp0IntEvent : std_logic;
		variable cp0CauseUpdateV : std_logic_vector(15 downto 0);
		variable cp0EpcUpdateV : std_logic_vector(15 downto 0);
		variable cp0StatusUpdateV : std_logic;	
		variable cp0NextCause : Cause;
	begin
		cp0IntEvent := '0';
		cp0CauseUpdateV := cp0Cause;
		cp0EpcUpdateV := cp0Epc;
		cp0StatusUpdateV := cp0Status;
		cp0NextCause := 0;


		memRamLock <= '0';
		pipelineClear <= '0';
		cp0ERetUpdate <= '0';
		cp0TrapUpdate <= '0';
		pcSet <= '0';

		if wbIsMTEPC = '1' and cp0Status = '1' then
			cp0EpcUpdateV := wbALUres;
		end if;


		if ps2Request = '1' then
			cp0CauseUpdateV(10) := '1'; -- 11 for PS/2 ISR
			if cp0ERet = '0' and cp0Trap = '0' and cp0Status = '0' then
				-- no switching bewteen the user mode and the kernel mode
				cp0IntEvent := '1';
			end if;
		end if;

		if wbInt = '1' then
			-- an interrupt has happened!
			-- keep the address of the current address and the next address
			-- and prevents the next instruction from writing RAM (for it is now in the MEM stage)

			cp0CauseUpdateV(to_integer(unsigned(wbIntCode))) := '1'; 
			if cp0ERet = '0' and cp0Trap = '0' and cp0Status = '0' then -- if interrupt allowed
				cp0IntEvent := '1';
			end if;
			
		elsif wbERet = '1' then
			cp0IntEvent := '1';
			cp0ERetUpdate <= '1';	
			-- we assume that eret and int cannot be 1 at the same time
		end if;

		if cp0ERet = '1' then
			-- switch to user mode
			
			if cp0CauseUpdateV(10 downto 0) = (10 downto 0 => '0') then

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



		if cp0IntEvent = '1' then
			memRamLock <= '1';
			pipelineClear <= '1';
			if cp0StatusUpdateV = '0' then
			-- this means that the CP0 running state would be changed (switched
			-- from the user mode to the kernel mode)
				if wbBubble = '0' or memBubble = '0' then -- if there is an instruction in WB or MEM
					cp0EpcUpdateV := std_logic_vector(to_unsigned(to_integer(unsigned(memPC)) - 1, 16));
				elsif exeBubble = '0' then
					cp0EpcUpdateV := std_logic_vector(to_unsigned(to_integer(unsigned(exePC)) - 1, 16));
				elsif idBubble = '0' then
					cp0EpcUpdateV := std_logic_vector(to_unsigned(to_integer(unsigned(idPC)) - 1, 16));
				else
					cp0EpcUpdateV := std_logic_vector(to_unsigned(to_integer(unsigned(ifPC)) - 1, 16));
				end if;
				cp0TrapUpdate <= '1';
			end if;
		end if;
	
		cp0StatusUpdate <= cp0StatusUpdateV;
		cp0EpcUpdate <= cp0EpcUpdateV;
		cp0CauseUpdate <= cp0CauseUpdateV;

	end process;
end behavioral;

