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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram_interactor is port(
		clk : in std_logic;
		
		if_ram_addr	  : in std_logic_vector(15 downto 0);
		mem_ram_addr  : in std_logic_vector(15 downto 0);
		mem_ram_data  : in std_logic_vector(15 downto 0);
		
		-- signals from mem
		ramWrite	:	in std_logic;
		ramRead	:	in std_logic;
		
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
		data_ready : in  STD_LOGIC
	);
end ram_interactor;

architecture Behavioral of ram_interactor is
	signal fake_inst : std_logic_vector(15 downto 0);
begin
	-- a fake ram 

	process(if_ram_addr)
	begin
		case if_ram_addr is
		-- LI R1 1
		-- LI R2 1
		-- LI R4 9
		-- ADDU R1 R2 R1
		-- ADDU R1 R2 R2
		-- ADDIU R4 FF
		-- BNEZ R4 F9
		-- NOP
		-- NOP

		-- LI R1 1
		-- LI R2 1
		-- LI R4 9
		-- BEQZ R4 4
		-- ADDIU R4 FF
		-- ADDU R1 R2 R1
		-- ADDU R1 R2 R2
		-- B FB
		-- NOP
		-- NOP




			when "0000000000000000" => if_res_data <= "0110100100000001";
			when "0000000000000001" => if_res_data <= "0110101000000001";
			when "0000000000000010" => if_res_data <= "0110110000001001";
			when "0000000000000011" => if_res_data <= "0010010000000100";
			when "0000000000000100" => if_res_data <= "0100110011111111";
			when "0000000000000101" => if_res_data <= "1110000101000101";
			when "0000000000000110" => if_res_data <= "1110000101001001";
			when "0000000000000111" => if_res_data <= "0001011111111011";
			when others => if_res_data <= "0000100000000000"; -- NOP
		end case;
	end process;

	ram1addr <= (others => '0');
	ram1data <= (others => '0');
	ram1en <= '1';
	ram1rw <= '1';
	ram1oe <= '1';

	ram2addr <= (others => '0');
	ram2data <= (others => '0');
	ram2en <= '1';
	ram2rw <= '1';
	ram2oe <= '1';
	wrn <= '1';
	rdn <= '1';

	res_data <= (others => '0');
end Behavioral;

