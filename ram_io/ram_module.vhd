----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:25:02 11/25/2017 
-- Design Name: 
-- Module Name:    ram_module - Behavioral 
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

entity ram_module is port(
	clk : in STD_LOGIC;
	ram_addr : in STD_LOGIC_VECTOR (15 downto 0);
	ram_data : in STD_LOGIC_VECTOR (15 downto 0);
	ram_res  : out STD_LOGIC_VECTOR (15 downto 0);
	ram_isRead : in STD_LOGIC;
	ram_isUsed : in STD_LOGIC;
	
	ram_addr_o : out  STD_LOGIC_VECTOR (17 downto 0);
	put_data_o : inout  STD_LOGIC_VECTOR (15 downto 0);
	ram_oe_o   : out  STD_LOGIC;
	ram_rw_o   : out  STD_LOGIC;
	ram_en_o   : out  STD_LOGIC
);
end ram_module;

architecture Behavioral of ram_module is
	type ram_state is (unused, read_ram, write_ram);
	signal state : ram_state := unused;
	signal temp_data : STD_LOGIC_VECTOR (15 downto 0);
begin
	
	process(clk, ram_isRead, ram_isUsed)
	begin
		-- if the ram is in the first half of the period, then the state should change immediately
		-- according to isUsed and isRead
		if (ram_isUsed = '1') then
			if (ram_isRead = '1') then
				state <= read_ram;
			else
				state <= write_ram;
			end if;
		else
			state <= unused;
		end if;

		-- when the clk falls down, the state goes to the next state
	end process;

	process(state, ram_addr, ram_data, put_data_o)
	begin
		case state is
			when unused =>
				ram_en_o <= '1';
				ram_oe_o <= '1';
				ram_rw_o <= '1';
				put_data_o <= (others => 'Z');
			when read_ram =>
				put_data_o <= (others => 'Z');
				ram_addr_o <= "00" & ram_addr;
				ram_oe_o <= '0';
				ram_en_o <= '0';
				temp_data <= put_data_o;
			when write_ram =>
				ram_en_o <= '0';
				put_data_o <= ram_data;
				ram_addr_o <= "00" & ram_addr;
				ram_rw_o <= '0';
		end case;
	end process;
	
	ram_res <= temp_data;

end Behavioral;

