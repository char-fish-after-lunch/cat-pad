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
		
		ps2_data	:	in std_logic_vector(7 downto 0);
		
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
		variable if_area : STD_LOGIC;
		variable mem_area : STD_LOGIC;
		variable if_sp : std_logic;
		variable mem_sp : std_logic;
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
		
		if_sp := '0';
		mem_sp := '0';

		if (if_ram_addr < "1000000000000000" or if_ram_addr = "1011111100000000" 
			or if_ram_addr = "1011111100000001" ) then
			if_area := '1';
			-- instruction or uart, use ram1
		else
			if_area := '0';
			-- data, use ram2
		end if;

		if (mem_ram_addr < "1000000000000000" or mem_ram_addr = "1011111100000000" 
			or mem_ram_addr = "1011111100000001" ) then
			mem_area := '1';
			-- instruction or uart, use ram1
		else
			mem_area := '0';
			-- data, use ram2
		end if;
		
		if if_ram_addr = "1011111100000100" then
			if_res_data <= (15 downto 8 => '0') & ps2_data;
			if_sp := '1';
		end if;
		
		if mem_ram_addr = "1011111100000100" then
			res_data <= (15 downto 8 => '0') & ps2_data;
			mem_sp := '1';
		end if;
		
		if (if_sp = '0' and mem_sp = '0' and if_area = mem_area and (ramRead = '1' or ramWrite = '1')) then
			hasConflict <= '1';
			-- when conflict happens, IF should be paused, MEM uses ram
			if (mem_area = '1') then
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
			else
				-- ram2
				if (ramRead = '1') then 
					ram2_get_addr <= mem_ram_addr;
					ram2_isRead <= '1';
					ram2_isUsed <= '1';
					res_data <= ram2_res;
				elsif (ramWrite = '1') then
					ram2_get_addr <= mem_ram_addr;
					ram2_isRead <= '0';
					ram2_isUsed <= '1';
					ram2_write_data <= mem_ram_data;
				end if;
			end if;
		else
			hasConflict <= '0';
			if if_sp = '0' then
				if (if_area = '1') then
					-- we assume that IF will never fetch instructions from uart 
					if if_ram_addr = "1011111100000100" then
						-- PS/2
						if_res_data <= (15 downto 8 => '0') & ps2_data;
					else
						ram1_get_addr <= if_ram_addr;
						ram1_isRead <= '1';
						ram1_isUsed <= '1';
						if_res_data <= ram1_res;
					end if;
				else
					ram2_get_addr <= if_ram_addr;
					ram2_isRead <= '1';
					ram2_isUsed <= '1';
					if_res_data <= ram2_res;
				end if;
			end if;
			
			if mem_sp = '0' then
				if (ramRead = '1' or ramWrite = '1') then
					if (mem_area = '1') then
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
					else
						-- ram2
						if (ramRead = '1') then 
							ram2_get_addr <= mem_ram_addr;
							ram2_isRead <= '1';
							ram2_isUsed <= '1';
							res_data <= ram2_res;
						elsif (ramWrite = '1') then
							ram2_get_addr <= mem_ram_addr;
							ram2_isRead <= '0';
							ram2_isUsed <= '1';
							ram2_write_data <= mem_ram_data;
						end if;
					end if;
				end if;
			end if;
		end if;


		-- case if_ram_addr is
		-- -- LI R1 1
		-- -- LI R2 1
		-- -- LI R4 9
		-- -- ADDU R1 R2 R1
		-- -- ADDU R1 R2 R2
		-- -- ADDIU R4 FF
		-- -- BNEZ R4 F9
		-- -- NOP
		-- -- NOP

		-- -- LI R1 1
		-- -- LI R2 1
		-- -- LI R4 9
		-- -- BEQZ R4 4
		-- -- ADDIU R4 FF
		-- -- ADDU R1 R2 R1
		-- -- ADDU R1 R2 R2
		-- -- B FB
		-- -- NOP
		-- -- NOP




		-- 	when "0000000000000000" => if_res_data <= "0110100100000001";
		-- 	when "0000000000000001" => if_res_data <= "0110101000000001";
		-- 	when "0000000000000010" => if_res_data <= "0110110000001001";
		-- 	when "0000000000000011" => if_res_data <= "0010010000000100";
		-- 	when "0000000000000100" => if_res_data <= "0100110011111111";
		-- 	when "0000000000000101" => if_res_data <= "1110000101000101";
		-- 	when "0000000000000110" => if_res_data <= "1110000101001001";
		-- 	when "0000000000000111" => if_res_data <= "0001011111111011";
		-- 	when others => if_res_data <= "0000100000000000"; -- NOP
		-- end case;
	end process;
	-- a fake ram 

	-- process(if_ram_addr)
	-- begin
	-- 	case if_ram_addr is
	-- 	-- LI R1 1
	-- 	-- LI R2 1
	-- 	-- LI R4 9
	-- 	-- ADDU R1 R2 R1
	-- 	-- ADDU R1 R2 R2
	-- 	-- ADDIU R4 FF
	-- 	-- BNEZ R4 F9
	-- 	-- NOP
	-- 	-- NOP



	-- 		when "0000000000000000" => if_res_data <= "0110100100000001"; 6901
	-- 		when "0000000000000001" => if_res_data <= "0110101000000001"; 6A01
	-- 		when "0000000000000010" => if_res_data <= "0110110000001001"; 6C09
	-- 		when "0000000000000011" => if_res_data <= "1110000101000101"; E145
	-- 		when "0000000000000100" => if_res_data <= "1110000101001001"; E149
	-- 		when "0000000000000101" => if_res_data <= "0100110011111111"; 4CFF
	-- 		when "0000000000000110" => if_res_data <= "0010110011111100"; 2CFC
	-- 		when others => if_res_data <= "0000100000000000"; -- NOP 0800
	-- 	end case;
	-- end process;





	-- ram1addr <= (others => '0');
	-- ram1data <= (others => '0');
	-- ram1en <= '1';
	-- ram1rw <= '1';
	-- ram1oe <= '1';

	-- ram2addr <= (others => '0');
	-- ram2data <= (others => '0');
	-- ram2en <= '1';
	-- ram2rw <= '1';
	-- ram2oe <= '1';
	-- wrn <= '1';
	-- rdn <= '1';

	-- res_data <= (others => '0');
end Behavioral;

