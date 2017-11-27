----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:25:17 11/25/2017 
-- Design Name: 
-- Module Name:    uart_module - Behavioral 
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

entity uart_module is port(
	clk : in STD_LOGIC;
	uart_isRead : in STD_LOGIC;
	uart_isUsed : in STD_LOGIC;
	uart_data : in STD_LOGIC_VECTOR(15 downto 0);
	uart_res : out STD_LOGIC_VECTOR(15 downto 0);
	isData : in STD_LOGIC;

	put_data : inout STD_LOGIC_VECTOR (15 downto 0);
	rdn : out  STD_LOGIC;
	wrn : out  STD_LOGIC;
	tbre : in  STD_LOGIC;
	tsre : in  STD_LOGIC;
	data_ready : in  STD_LOGIC
);
end uart_module;

architecture Behavioral of uart_module is
	signal can_read : STD_LOGIC := '0';
	signal can_write : STD_LOGIC := '0';
	type uart_procedure is (read_1, read_2, write_1, write_2, write_3, idling);
	signal state : uart_procedure := idling;

	signal res_data : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

	signal t_put_data : STD_LOGIC_VECTOR(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
	signal t_rdn : STD_LOGIC := '1';
	signal t_wrn : STD_LOGIC := '1';

begin

	put_data <= t_put_data;
	rdn <= t_rdn;
	wrn <= t_wrn;

	process(uart_isUsed, state, clk, tsre, tbre)
	begin
	
		if (rising_edge(clk)) then
		case state is
			when read_1 =>
				t_rdn <= '0';
				res_data <= put_data;
			 	state <= read_2;

			when read_2 =>
				t_rdn <= '1';
			 	state <= idling;

			when write_1 =>
				t_wrn <= '0';
				t_put_data <= uart_data;
				state <= write_2;
				
			when write_2 =>
				state <= write_3;
				t_wrn <= '1';

			when write_3 => 
				if (tsre = '1') then
					state <= idling;
				end if;

			when idling =>
				t_rdn <= '1';
				t_wrn <= '1';
				t_put_data <= (others => 'Z');
				if (uart_isUsed = '1') then
					if (uart_isRead = '1') then
						if (state = idling) then
							state <= read_1;
						end if;
					else 
						if (state = idling) then
							state <= write_1;
						end if;
					end if;
				else
					state <= idling;
				end if;
				
		end case;
		end if;
	end process;

	process(state, clk, put_data, data_ready)
	begin
		if (state = idling and data_ready = '1') then
			can_read <= '1';
		else
			can_read <= '0';
		end if;

		if (state = idling) then
			can_write <= '1';
		end if;

	end process;

	process(isData, put_data, state)
	begin
		if (state = read_1 or state = read_2 or state = idling) then
			if (isData = '1') then
				uart_res <= res_data;
			else
				uart_res <= "00000000000000" & can_read & can_write;
			end if;
		else
			uart_res <= (others => '0');
		end if;
	end process;
end Behavioral;

