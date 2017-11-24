----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:53:11 11/25/2017 
-- Design Name: 
-- Module Name:    flash_io - Behavioral 
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

entity flash_io is port ( 
        clk : in std_logic;

        flash_ce0 : out  std_logic;
        flash_ce1 : out  std_logic;
        flash_ce2 : out  std_logic;
        flash_byte : out  std_logic;
        flash_vpen : out  std_logic;
        flash_rp : out  std_logic;
        flash_oe : out  std_logic;
        flash_we : out  std_logic;
        flash_addr : out  std_logic_vector (22 downto 0);
        flash_data : inout  std_logic_vector (15 downto 0);
        flash_sr : out  std_logic_vector (7 downto 0);

        flashRead : in std_logic;  --this will be 1 if it is use
        flashWrite : in std_logic; --record whether to write or read
        flashErase : in std_logic; --erase

        addr_in : in std_logic_vector(22 downto 0);
        data_in : in std_logic_vector(15 downto 0);
        data_out : out  std_logic_vector (15 downto 0)
    );
end flash_io;

architecture Behavioral of flash_io is

begin
    flash_ce0 <= '0';
    flash_ce1 <= '0';
    flash_ce2 <= '0';
    flash_byte <= '1';
    flash_vpen <= '1';
    flash_rp <= '1';

    process(flashWrite, data_in)
    begin
        if (flashWrite = '1') then
            flash_oe <= '0';
            flash_we <= '0';
            flash_data <= x"0040";
            flash_we <= '1'
            flash_we <= '0';
        end if;


end Behavioral;

