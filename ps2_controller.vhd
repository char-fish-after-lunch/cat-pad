library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ps2_controller is
	port(
		clk	: in std_logic;
		ps2_clk	: in std_logic;
		ps2_data : in std_logic;

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

	process(f_ps2_clk)
	begin
		if falling_edge(f_ps2_clk) then
			case cur_state is
				when IDLE =>
					cur_state <= RECEIVE_DATA;
					bit_serial <= 0;
					parity <= '0';
					received <= '0';
				when RECEIVE_DATA =>
					if bit_serial = 8 then
						cur_state <= RECEIVE_PARITY;
					else
						data(integer(bit_serial)) <= f_ps2_data;
						parity <= parity xor f_ps2_data;

						bit_serial <= bit_serial + 1;
					end if;
				when RECEIVE_PARITY =>
					parity <= parity xor f_ps2_data;
					if parity = '1' then
						-- a healthy byte received
						received <= '1';
					end if;
					cur_state <= BUSY;
				when BUSY =>
					cur_state <= IDLE;
			end case;
		end if;
	end process;

	process(clk)
	begin
		if falling_edge(clk) then
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


