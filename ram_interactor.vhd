----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:27:10 11/23/2017 
-- Design Name: 
-- Module Name:    ram_interactor - Behavioral 
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
use work.io_components.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram_interactor is port(
		clk : in std_logic;
    	clk_11m : in std_logic;
		
		if_ram_addr	  : in std_logic_vector(15 downto 0);
		mem_ram_addr  : in std_logic_vector(15 downto 0);
		mem_ram_data  : in std_logic_vector(15 downto 0);
		
		-- signals from mem
		ramWrite :	in std_logic;
		ramRead	 :	in std_logic;
		
		res_data : out std_logic_vector(15 downto 0);
		if_res_data : out std_logic_vector(15 downto 0);


		-- ram related 
		ram1addr : out  STD_LOGIC_VECTOR (17 downto 0);
		ram1data : inout  STD_LOGIC_VECTOR (15 downto 0);
		ram1oe : out  STD_LOGIC;
		ram1rw : out  STD_LOGIC;
		ram1en : out  STD_LOGIC;
		ram2addr : out  STD_LOGIC_VECTOR (17 downto 0);
		ram2data : inout  STD_LOGIC_VECTOR (15 downto 0);
		ram2oe : out  STD_LOGIC;
		ram2rw : out  STD_LOGIC;
		ram2en : out  STD_LOGIC;

		-- IO related
		rdn : out  STD_LOGIC;
		wrn : out  STD_LOGIC;
		tbre : in  STD_LOGIC;
		tsre : in  STD_LOGIC;
		data_ready : in  STD_LOGIC;

		hasConflict : out STD_LOGIC;
    	test_log : out STD_LOGIC_VECTOR(15 downto 0)
	);
end ram_interactor;

architecture Behavioral of ram_interactor is
	-- signal fake_inst : std_logic_vector(15 downto 0);
	signal ram1_get_addr : STD_LOGIC_VECTOR (15 downto 0);
	signal ram1_write_data : STD_LOGIC_VECTOR (15 downto 0);
        
    signal ram1_res : STD_LOGIC_VECTOR (15 downto 0);
    signal ram1_isRead : STD_LOGIC;
	signal ram1_isUsed : STD_LOGIC;

	signal ram2_get_addr : STD_LOGIC_VECTOR (15 downto 0);
	signal ram2_write_data : STD_LOGIC_VECTOR (15 downto 0);
        
    signal ram2_res : STD_LOGIC_VECTOR (15 downto 0);
    signal ram2_isRead : STD_LOGIC;
	signal ram2_isUsed : STD_LOGIC;
	
	signal uart_isRead : STD_LOGIC;
	signal uart_isUsed : STD_LOGIC;
	signal uart_data : STD_LOGIC_VECTOR(15 downto 0);
	signal uart_res : STD_LOGIC_VECTOR(15 downto 0);
	signal uart_isData : STD_LOGIC;

begin
	ram1_module: ram_module port map (
        clk => clk,
        ram_addr => ram1_get_addr,
        ram_data => ram1_write_data,
        ram_res  => ram1_res,
        ram_isRead => ram1_isRead,
        ram_isUsed => ram1_isUsed,

        ram_addr_o => ram1addr,
        put_data_o => ram1data,
        ram_oe_o   => ram1oe,
        ram_rw_o   => ram1rw,
        ram_en_o   => ram1en
    );

	ram2_module: ram_module port map (
        clk => clk,
        ram_addr => ram2_get_addr,
        ram_data => ram2_write_data,
        ram_res  => ram2_res,
        ram_isRead => ram2_isRead,
        ram_isUsed => ram2_isUsed,

        ram_addr_o => ram2addr,
        put_data_o => ram2data,
        ram_oe_o   => ram2oe,
        ram_rw_o   => ram2rw,
        ram_en_o   => ram2en
    );

	uart_module: uart_module port map(
		clk => clk_11m,
		uart_isRead => uart_isRead,
		uart_isUsed => uart_isUsed,
		uart_data => uart_data,
		uart_res => uart_res,
		isData => uart_isData,

		put_data => ram1data,
		rdn => rdn,
		wrn => wrn,
		tbre => tbre,
		tsre => tsre,
		data_ready => data_ready,
		test_log => test_log
	);

	process(if_ram_addr, mem_ram_addr, mem_ram_data, ramRead, ramWrite, uart_res, ram1_res, ram2_res)

	begin
		-- signal initialize: everything is disabled
		ram1_get_addr <= "0000000000000000";
		ram1_write_data <= "0000000000000000";
		ram1_isRead <= '0';
		ram1_isUsed <= '0';

		ram2_get_addr <= "0000000000000000";
		ram2_write_data <= "0000000000000000";
		ram2_isRead <= '0';
		ram2_isUsed <= '0';
		
		uart_isRead <= '0';
		uart_isUsed <= '0';
		uart_data <= "0000000000000000";
		uart_isData <= '0';
		
		if (ramRead = '1' or ramWrite = '1') then
			hasConflict <= '1';
			-- when conflict happens, IF should be paused, MEM uses ram
			if (mem_ram_addr = "1011111100000000" or mem_ram_addr = "1011111100000001") then
				-- uart
				if (ramRead = '1') then 
					uart_isRead <= '1';
					uart_isUsed <= '1';
					res_data <= uart_res;
				elsif (ramWrite = '1') then
					uart_isRead <= '0';
					uart_isUsed <= '1';
					uart_data <= mem_ram_data;
				end if;

				if (mem_ram_addr = "1011111100000000") then
					uart_isData <= '1';
				else
					uart_isData <= '0';
				end if;
			else
				-- ram1
				if (ramRead = '1') then 
					ram1_get_addr <= mem_ram_addr;
					ram1_isRead <= '1';
					ram1_isUsed <= '1';
					res_data <= ram1_res;
				elsif (ramWrite = '1') then
					ram1_get_addr <= mem_ram_addr;
					ram1_isRead <= '0';
					ram1_isUsed <= '1';
					ram1_write_data <= mem_ram_data;
				end if;
			end if;
			-- else
			-- 	-- ram2
			-- 	if (ramRead = '1') then 
			-- 		ram2_get_addr <= mem_ram_addr;
			-- 		ram2_isRead <= '1';
			-- 		ram2_isUsed <= '1';
			-- 		res_data <= ram2_res;
			-- 	elsif (ramWrite = '1') then
			-- 		ram2_get_addr <= mem_ram_addr;
			-- 		ram2_isRead <= '0';
			-- 		ram2_isUsed <= '1';
			-- 		ram2_write_data <= mem_ram_data;
			-- 	end if;
			-- end if;

		end if;

	end process;

end Behavioral;

