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
	type uart_state is (unused, read_uart, write_uart);
	type uart_procedure is (prepare, done, idling);
	signal state : uart_state := unused;
	signal pro_state : uart_procedure := idling;


	signal res_data : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

	signal t_put_data : STD_LOGIC_VECTOR(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
	signal t_rdn : STD_LOGIC := '1';
	signal t_wrn : STD_LOGIC := '1';

begin

	
	process(clk, uart_isRead, uart_isUsed, isData)
	begin
		if (uart_isUsed = '1') then
			if (uart_isRead = '1') then
				if (isData = '1') then
					state <= read_uart;
				else
					state <= unused;
				end if;
			else
				if (isData = '1') then
					state <= write_uart;
				else			
					state <= unused;
				end if;
			end if;
		else
			state <= unused;
		end if;

		-- when the clk falls down, the state goes to the next state
		if (clk = '1') then
			pro_state <= prepare;
		else
			pro_state <= done;
		end if;
	end process;

	-- process(clk)
	-- begin
	-- 	if (clk = '0') then
			rdn <= t_rdn;
			wrn <= t_wrn;
	-- 	else
	-- 		rdn <= '1';
	-- 		wrn <= '1';
	-- 	end if;
	-- end process;


	process(state, pro_state, tsre, uart_data, isData, data_ready, put_data)
		variable v_can_write : STD_LOGIC := '1';
	begin
		t_rdn <= '1';
		t_wrn <= '1';
		t_put_data <= (others => 'Z');

		case state is
			when unused =>
			when read_uart =>
				if (pro_state = prepare) then
					t_rdn <= '0';
					res_data <= put_data;
				else 
					t_rdn <= '1';
				end if;
			when write_uart =>
				if (pro_state = prepare) then
					v_can_write := '0';
					t_wrn <= '1';
					t_put_data <= uart_data;
				else 
					t_wrn <= '0';
					t_put_data <= uart_data;
				end if;
		end case;

		if (tsre = '1' and v_can_write = '0') then
			v_can_write := '1';
		end if;

		can_write <= v_can_write;
		
	end process;



	process(state, t_put_data)
	begin
		if (state = write_uart) then
			put_data <= t_put_data;
		else
			put_data <= (others => 'Z');
		end if;
	end process;


	process(state, data_ready)
	begin
		if (data_ready = '1') then
			can_read <= '1';
		else
			can_read <= '0';
		end if;
	end process;

	process(isData, put_data, state, can_read, can_write, res_data)
	begin
		if (state = read_uart) then
			if (isData = '1') then
				uart_res <= res_data;
			else
				uart_res <= "00000000000000" & can_read & can_write;
			end if;
		else
			if (isData = '0') then
				uart_res <= "00000000000000" & can_read & can_write;
			else
				uart_res <= (others => '0');
			end if;
		end if;
	end process;
end Behavioral;

