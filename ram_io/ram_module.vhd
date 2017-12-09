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
	ram_addr : in STD_LOGIC_VECTOR (17 downto 0);
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
	type procedure_state is (prepare, get_data);
	signal state : ram_state := unused;
	signal pro_state : procedure_state := prepare;
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
		if (clk = '1') then
			pro_state <= prepare;
		else
			pro_state <= get_data;
		end if;
	end process;

	process(state, pro_state, ram_addr, ram_data, put_data_o)
	begin
		ram_en_o <= '1';
		ram_oe_o <= '1';
		ram_rw_o <= '1';
		put_data_o <= (others => 'Z');
		case state is
			when unused =>
			when read_ram =>
				if (pro_state = prepare) then 
					put_data_o <= (others => 'Z');
					ram_addr_o <= ram_addr;
					ram_oe_o <= '0';
					ram_en_o <= '0';
					temp_data <= put_data_o;
				else
					put_data_o <= (others => 'Z');
					ram_addr_o <= ram_addr;
					ram_oe_o <= '0';
					ram_en_o <= '0';
					temp_data <= put_data_o;
				end if;

			when write_ram =>
				if (pro_state = prepare) then
					ram_en_o <= '0';
					put_data_o <= ram_data;
					ram_addr_o <= ram_addr;
					ram_rw_o <= '1';
				else
					ram_en_o <= '0';
					put_data_o <= ram_data;
					ram_addr_o <= ram_addr;
					ram_rw_o <= '0';
				end if;
		end case;
	end process;
	
	ram_res <= temp_data;

end Behavioral;

