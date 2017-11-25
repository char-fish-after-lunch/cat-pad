----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:46:12 11/17/2017 
-- Design Name: 
-- Module Name:    stall_unit - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--	This is the stall unit for CATPAD.
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


entity stall_unit is
	port(
		clk : in std_logic;

		exeWbEN: in std_logic;
		exeDstSrc: in std_logic_vector(3 downto 0);
		exeRamRead: in std_logic;
		idRegSrcA: in std_logic_vector(3 downto 0);
		idRegSrcB: in std_logic_vector(3 downto 0);
		exeBranchJudge: in std_logic;
		exeBranchTo: in std_logic_vector(15 downto 0);
		ifAddr: in std_logic_vector(15 downto 0);
		ramConflict: in std_logic;

		pcPause: out std_logic;
		idKeep: out std_logic;
		idClear: out std_logic;
		exeClear: out std_logic;
		pcInc: out std_logic;
		setPC: out std_logic;
		setPCVal: out std_logic_vector(15 downto 0)
	);
end stall_unit;

architecture Behavioral of stall_unit is
	type SuspendState is (CONTINUOUS, DELAYED, SUSPENDED);

	signal suspend : SuspendState := CONTINUOUS;
	signal suspendUpdate : SuspendState := CONTINUOUS;
	signal stashedPC : std_logic_vector(15 downto 0) := (15 downto 0 => '0');
	signal stashedPCUpdate : std_logic_vector(15 downto 0) := (15 downto 0 => '0');
begin
	process(exeWbEN, exeDstSrc, exeRamRead, idRegSrcA, idRegSrcB,
		exeBranchJudge, exeBranchTo, ifAddr, suspend, stashedPC)
	begin
		pcPause <= '0';
		idClear <= '0';
		idKeep <= '0';
		exeClear <= '0';
		pcInc <= '0';
		setPC <= '0';
		suspendUpdate <= CONTINUOUS;

		case suspend is
			when CONTINUOUS =>
				-- deals with RAW conflict
				if (exeWbEN = '1') and (exeRamRead = '1') and
					((exeDstSrc = idRegSrcA) or (exeDstSrc = idRegSrcB)) then
					pcPause <= '1';
					idKeep <= '1';
					exeClear <= '1';
					pcInc <= '1';
				end if;
				if (exeBranchJudge = '1') and (exeBranchTo /= ifAddr) then
					-- the last fetched instruction is cleared
					idClear <= '1';
				else
					-- the last fetched instruction is correct
					if ramConflict = '1' then
						suspendUpdate <= DELAYED;
					else
						-- no conflict
						pcInc <= '1';
					end if;
				end if;

			when DELAYED =>
				if ramConflict = '1' then
					pcPause <= '1';
					idClear <= '1';
					if exeBranchJudge = '1' then
						stashedPCUpdate <= exeBranchTo;
						suspendUpdate <= SUSPENDED;
					else
						suspendUpdate <= DELAYED;
					end if;
				else
					suspendUpdate <= CONTINUOUS;
				end if;

			when SUSPENDED =>
				-- there is a suspended instruction (due to RAM conflict)
				if ramConflict = '1' then
					-- still conflict
					pcPause <= '1';
					idClear <= '1';
					stashedPCUpdate <= stashedPC;
					suspendUpdate <= SUSPENDED;
				else
					-- no conflict any more
					setPC <= '1';
					setPCVal <= stashedPC;
					suspendUpdate <= CONTINUOUS;
				end if;
		end case;
	end process;

	process(clk)
	begin
		if rising_edge(clk) then
			suspend <= suspendUpdate;
			stashedPC <= stashedPCUpdate;
		end if;
	end process;

end Behavioral;

