----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:40:12 11/17/2017 
-- Design Name: 
-- Module Name:    inst_decode - Behavioral 
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
use work.consts.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity inst_decode is port(
		inst : in std_logic_vector(15 downto 0);
		regSrcA : in std_logic_vector(3 downto 0);
		regSrcB : in std_logic_vector(3 downto 0);
		immeCtrl : in std_logic_vector(2 downto 0);
		immeExt : in std_logic;
		
		regAN : out std_logic_vector(3 downto 0);
		regBN : out std_logic_vector(3 downto 0);
		immediate : out std_logic_vector(15 downto 0)
	);
end inst_decode;

architecture Behavioral of inst_decode is

begin
	regAN <= regSrcA;
	regBN <= regSrcB;
	
	process(immeCtrl, immeExt, inst)
	begin
		case immeCtrl is
			when imme_8b => 
				immediate(7 downto 0) <= inst(7 downto 0);
				if (immeExt = '1') then
					immediate(15 downto 8) <= (others => inst(7));
				else
					immediate(15 downto 8) <= (others => '0');
				end if;
			when imme_4b => 
				immediate(3 downto 0) <= inst(3 downto 0);
				immediate(15 downto 4) <= (others => inst(3));
			when imme_3b => 
				if (inst(4 downto 2) = "000") then
					immediate <= "0000000000001000";
				else
					immediate(2 downto 0) <= inst(4 downto 2);
					immediate(15 downto 3) <= (others => inst(4));
				end if;
			when imme_11b => 
				immediate(10 downto 0) <= inst(10 downto 0);
				immediate(15 downto 11) <= (others => inst(10));
			when imme_5b => 
				immediate(4 downto 0) <= inst(4 downto 0);
				immediate(15 downto 5) <= (others => inst(4));
			when others =>
				immediate <= "0000000000000000";
		end case;
	end process;
end Behavioral;

