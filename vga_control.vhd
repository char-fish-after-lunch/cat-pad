----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:03:15 11/25/2017 
-- Design Name: 
-- Module Name:    vga_control - Behavioral 
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_control is port(
        clk_in : in std_logic;
        rst : in std_logic;

        out_red : out std_logic_vector(2 downto 0);
        out_green : out std_logic_vector(2 downto 0);
        out_blue : out std_logic_vector(2 downto 0);

        test : out std_logic_vector(2 downto 0);
        hs : out std_logic;
        vs : out std_logic
    );
end vga_control;

architecture Behavioral of vga_control is
    -- some tmp signal
    signal clk, clk_2 : std_logic := '0';
    signal r_t, g_t, b_t, test_t : std_logic_vector (2 downto 0);
    signal hs_t,vs_t : std_logic;
    signal x, y : integer range 0 to 1000;

begin

    process (clk_in) -- make that 25Hz
	begin
		if clk_in'event and clk_in = '1' then
			clk <= not clk;
		end if;
    end process;
    
    process(clk, rst) --行区间扫描
    begin
        if rst = '0' then
			x <= 0;
		elsif clk'event and clk = '1' then
			if x = 799 then
				x <= 0;
			else
				x <= x + 1;
			end if;
		end if;
    end process;

    process(clk, rst) --场区间扫描
    begin
        if rst = '0' then
			y <= 0; 
			y <= 0;
        elsif clk'event and clk = '1' then
            if x = 799 then
                if y = 524 then
                    y <= 0;
                else
                    y <= y + 1;
                end if;
			end if;
        end if;
    end process;

    process(clk, rst) --设置行同步信号
    begin
        if rst = '0' then
            hs_t <= '1';
        elsif clk'event and clk = '1' then
            if x >= 656 and x < 752 then
		        hs_t <= '0';
		   	else
		        hs_t <= '1';
		   	end if;
        end if;
    end process;

    process(clk, rst) --设置场同步信号
    begin
        if rst = '0' then
            vs_t <= '1';
        elsif clk'event and clk = '1' then
            if y >= 490 and y < 492 then
		        vs_t <= '0';
		   	else
		        vs_t <= '1';
		   	end if;
        end if;
    end process;

    process(clk, rst) --行信号输出
    begin
        if rst = '0' then
            hs <= '0';
        elsif clk'event and clk = '1' then
            hs <= hs_t;
        end if;
    end process;

    process(clk, rst) --场信号输出
    begin
        if rst = '0' then
            vs <= '0';
        elsif clk'event and clk = '1' then
            vs <= vs_t;
        end if;
    end process;
    
    process(clk, rst, x, y)
    begin
        if rst = '0' then
            r_t <= "000";
            g_t <= "000";
            b_t <= "000";
            test_t <= "000";
        elsif clk'event and clk = '1' then
            if x < 20 and y < 20 then
                r_t <= "010";
                g_t <= "101";
                b_t <= "000";
                test_t <= "110";
            else
                r_t <= "111";
                g_t <= "111";
                b_t <= "010";
                test_t <= "100";
            end if;
        end if;
    end process;

    process(hs_t, vs_t, r_t, g_t, b_t)
    begin 
        if hs_t = '1' and vs_t = '1' then
			out_red <= r_t;
			out_green <= g_t;
			out_blue <= b_t;
			test <= test_t; --it is always this, why???
		else
			out_red <= (others => '0');
			out_green <= (others => '0');
			out_blue <= (others => '0');
			test <= test_t;
		end if;
    end process;

end Behavioral;

