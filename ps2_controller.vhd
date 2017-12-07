library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ps2_controller is
	port(
		clk	: in std_logic;
		ps2_clk	: inout std_logic;
		ps2_data : inout std_logic;

		error1 : out std_logic := '0';
		error2 : out std_logic := '0';
		error3 : out std_logic := '0';
		
		all_data : out std_logic_vector(10 downto 0) := (others => '0');
		
		data_request : out std_logic := '0';
		data : out std_logic_vector(7 downto 0) := (others => '0')
	);
end ps2_controller;

architecture Behavioral of ps2_controller is
	type State is (IDLE, RECEIVE_DATA, RECEIVE_PARITY, BUSY);
	type BitSerial is range 0 to 8;

	signal cur_state : State := IDLE;
	signal last_clk_state : State := IDLE;
	signal received : std_logic := '0';

	signal bit_serial : BitSerial := 0;

	signal parity : std_logic := '0';

	signal f_ps2_clk : std_logic := '1';
	signal f_ps2_data : std_logic := '1';
	
begin
	process(cur_state)
	begin
		case cur_state is
			when IDLE =>
				ps2_clk <= 'Z';
				ps2_data <= 'Z';
			when others =>
		end case;
	end process;

	process(f_ps2_clk)
	begin
		if falling_edge(f_ps2_clk) then
			case cur_state is
				when IDLE =>
					cur_state <= RECEIVE_DATA;
					bit_serial <= 0;
					parity <= '0';
					received <= '0';
					if f_ps2_data /= '0' then
						error1 <= '1';
					end if;
					all_data(0) <= f_ps2_data;
				when RECEIVE_DATA =>
					data(integer(bit_serial)) <= f_ps2_data;
					parity <= parity xor f_ps2_data;
					
					all_data(1 + integer(bit_serial)) <= f_ps2_data;
					if bit_serial = 7 then
						cur_state <= RECEIVE_PARITY;
					else
						bit_serial <= bit_serial + 1;
					end if;
				when RECEIVE_PARITY =>
					parity <= parity xor f_ps2_data;
					
					all_data(9) <= f_ps2_data;
					if parity /= '1' then
						-- a healthy byte received
						
						error2 <= '1';
					end if;
					received <= '1';
					cur_state <= BUSY;
				when BUSY =>
					all_data(10) <= f_ps2_data;
					if f_ps2_data /= '1' then
						error3 <= '1';
					end if;
					cur_state <= IDLE;
			end case;
		end if;
	end process;

	process(clk)
	begin
		if rising_edge(clk) then
			f_ps2_clk <= ps2_clk;
			f_ps2_data <= ps2_data;
			if last_clk_state = RECEIVE_PARITY and cur_state = BUSY and received = '1' then
				data_request <= '1';
			else
				data_request <= '0';
			end if;

			last_clk_state <= cur_state;
		end if;
	end process;
end Behavioral;


