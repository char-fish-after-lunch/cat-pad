----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:32:26 11/25/2017 
-- Design Name: 
-- Module Name:    bootloader - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bootloader is port(
	clk : in std_logic;
	isBootloaded : in std_logic;
	flashByte : out std_logic;
	flashVpen : out std_logic;
	flashCE : out std_logic;
	flashOE : out std_logic;
	flashWE : out std_logic;
	flashRP : out std_logic;
	flash_addr : out std_logic_vector(22 downto 1);
	flash_data : inout std_logic_vector(15 downto 0);
	
	ram1addr : out  STD_LOGIC_VECTOR (17 downto 0);
	ram1data : inout  STD_LOGIC_VECTOR (15 downto 0);
	ram1oe : out  STD_LOGIC;
	ram1rw : out  STD_LOGIC;
	ram1en : out  STD_LOGIC;
	
	res_log : out STD_LOGIC_VECTOR (15 downto 0);
	bootloader_state : out STD_LOGIC_VECTOR (6 downto 0);

	
	rdn : out  STD_LOGIC;
	wrn : out  STD_LOGIC;

	isBootloaded_o : out STD_LOGIC
);
end bootloader;

architecture Behavioral of bootloader is
	signal tot_loaded : std_logic_vector(9 downto 0) := "0000000000";
	signal temp_data : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";

    type bootloader_states is(
        disabled, waiting,
        read1, read2, read3, read4, write1, write2,
        done
    );

    signal state, next_state : bootloader_states := waiting;
 
	signal isBooted : std_logic := '0';
	signal slowed_clk : std_logic ;
	signal counter : integer range 0 to 2000 := 0; 
	
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			counter <= counter + 1;
		end if;
	end process;
	
	process(counter)
	begin
		if (counter < 1000) then
			slowed_clk <= '0';
		else
			slowed_clk <= '1';
		end if;
	end process;

	rdn <= '1';
	wrn <= '1';
	process(isBootloaded, slowed_clk, next_state, state, tot_loaded)
	begin
		if (isBootloaded = '1') then 
			state <= disabled;
		else
			if (rising_edge(slowed_clk)) then
				if (state = write2) then
					if (tot_loaded /= "1111111111") then
						tot_loaded <= tot_loaded + "0000000001";
					end if;
				end if;
				state <= next_state;
			end if;
		end if;

	end process;

	process(state, tot_loaded)
	begin
		case state is
		when disabled =>
			next_state <= waiting;
		when waiting =>
			next_state <= read1;
		when read1 =>
			next_state <= read2;
		when read2 =>
			next_state <= read3;
		when read3 =>
			next_state <= read4;
		when read4 => 
			next_state <= write1;
		when write1 =>
		 	next_state <= write2;
		when write2 =>
			if (tot_loaded = "1111111111") then
				next_state <= done;
			else
				next_state <= waiting;
			end if;
		when done =>
			next_state <= disabled;
		end case;
	end process;


	process(slowed_clk, state, flash_data, tot_loaded)
	begin
		if (rising_edge(slowed_clk)) then
			flashByte <= '1';
			flashVpen <= '1';
			flashRP <= '1';

			isBooted <= '0';
			
			case state is
			when disabled =>
				flashCE <= '1';
				flash_data <= (others => 'Z');
				ram1addr <= (others => '0');
				ram1data <= (others => 'Z');
				ram1en <= '1';
				ram1oe <= '1';
				ram1rw <= '1';
				isBooted <= '1';

			when waiting => 
				flashCE <= '0';
				flashOE <= '1';
				flashWE <= '0';
				flash_data <= (others => 'Z');
				ram1addr <= (others => '0');
				ram1data <= (others => 'Z');
				ram1en <= '1';
				ram1oe <= '1';
				ram1rw <= '1';

			when read1 =>
				flash_data <= x"00FF";
				
			when read2 =>
				flashWE <= '1';
				
			when read3 =>
				flashOE <= '0';
				flash_addr <= "000000000000" & tot_loaded;
				flash_data <= (others => 'Z');
				
			when read4 =>
				temp_data <= flash_data;
				flashOE <= '1';
				
			when write1 =>
				
				flashCE <= '1';
				flash_data <= (others => 'Z');
				ram1en <= '0';
				ram1addr <= "00000000" & tot_loaded;
				ram1data <= temp_data;

			when write2 =>
				flashCE <= '1';
				flash_data <= (others => 'Z'); 
				
				ram1en <= '0';
				ram1addr <= "00000000" & tot_loaded;
				ram1data <= temp_data;
				ram1rw <= '0';

			when done =>
				isBooted <= '1';
							
			end case;
			res_log <= temp_data(7 downto 0) & tot_loaded(7 downto 0);
		end if;
	end process;

	isBootloaded_o <= isBooted;

	process(state)
	begin
		case state is 
			when disabled => bootloader_state <= "1111110";
			when waiting  => bootloader_state <= "0110000";
			when read1    => bootloader_state <= "1101101";
			when read2	  => bootloader_state <= "1111001";
			when read3	  => bootloader_state <= "0110011";
			when read4 	  => bootloader_state <= "1011011";
			when write1	  => bootloader_state <= "1011111";
			when write2   => bootloader_state <= "1110000";
			when done     => bootloader_state <= "1111111";
		end case;
	end process;

end Behavioral;

