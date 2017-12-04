----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:16:42 12/01/2017 
-- Design Name: 
-- Module Name:    vga_driver - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_driver is port(
    vga_clk : in std_logic;
    vga_addr : out std_logic_vector(17 downto 0);
    vga_read_addr : out std_logic;
    vga_data : in std_logic_vector(15 downto 0);

    vga_red : out std_logic_vector(2 downto 0);
    vga_blue : out std_logic_vector(2 downto 0);
    vga_green : out std_logic_vector(2 downto 0);

    vga_hs : out std_logic;
    vga_vs : out std_logic;
    vga_enabled : in std_logic
);
end vga_driver;

architecture Behavioral of vga_driver is
    signal inner_clk : std_logic := '0';
    signal r_t, g_t, b_t : std_logic_vector (2 downto 0);
    signal hs_t, vs_t : std_logic;
    signal x : integer range 0 to 799;
    signal y : integer range 0 to 524;
    signal is_reading : std_logic := '0';
begin

    process(vga_clk, vga_data, vga_enabled, x, y) -- make that 25MHz
	begin
		if rising_edge(vga_clk) then
			if (vga_enabled = '1') then
                r_t <= vga_data(8 downto 6);
                g_t <= vga_data(5 downto 3);
                b_t <= vga_data(2 downto 0);
                inner_clk <= '1';
            else
                
                if x >= 0 and x < 640 and y >= 0 and y < 480 then
                    if x >= 64 and x < 576 and y >= 0 and y < 480 then
                        vga_addr(17 downto 9) <= conv_std_logic_vector(x-64, 9);
                        vga_addr(8 downto 0) <= conv_std_logic_vector(y, 9);
                    else
                        vga_addr(17 downto 0) <= (others => '0');
                        is_reading <= '0';
                    end if;
                else
                    vga_addr(17 downto 0) <= (others => '0');
                    is_reading <= '0';
                end if;
                
                inner_clk <= '0';
            end if;
		end if;
    end process;

    vga_read_addr <= is_reading;

    process(inner_clk, x, y) --800x525
    begin
		if rising_edge(inner_clk) then
            if x = 799 then
                y <= y + 1;
			end if;
            x <= x + 1;
		end if;
    end process;

    process(inner_clk, x) --656~752
    begin
        if rising_edge(inner_clk) then
            if x >= 656 and x < 752 then
		        hs_t <= '0';
		   	else
		        hs_t <= '1';
		   	end if;
        end if;
    end process;

    process(inner_clk, y) --490~492
    begin
        if rising_edge(inner_clk) then
            if y >= 490 and y < 492 then
		        vs_t <= '0';
		   	else
		        vs_t <= '1';
		   	end if;
        end if;
    end process;

    process(inner_clk, hs_t, vs_t) --for hs
	begin
        if rising_edge(inner_clk) then
            vga_hs <= hs_t;
            vga_vs <= vs_t;
        end if;
    end process;

    process(hs_t, vs_t, r_t, g_t, b_t) --put them into output
    begin 
        if hs_t = '1' and vs_t = '1' then
			vga_red <= r_t;
			vga_green <= g_t;
			vga_blue <= b_t;
		else
			vga_red <= (others => '0');
			vga_green <= (others => '0');
			vga_blue <= (others => '0');
		end if;
    end process;

    



end Behavioral;

