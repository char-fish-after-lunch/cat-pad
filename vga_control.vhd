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
        ramWrite : in std_logic; --input shi neng duan

        out_red : out std_logic_vector(2 downto 0);
        out_green : out std_logic_vector(2 downto 0);
        out_blue : out std_logic_vector(2 downto 0);

        romAddr : out std_logic_vector(17 downto 0);
        romData : in std_logic_vector(15 downto 0); --rgb that only 8 downto 0 is useful
        vgaRead : out std_logic;
        vgaWrite : out std_logic; --output as shi neng duan

        ramWriAddrIn : in std_logic_vector(17 downto 0); --video card function 
        ramWriDataIn : in std_logic_vector(15 downto 0); --in
        ramWriAddrOut : out std_logic_vector(17 downto 0); --record it for a while and then 
        ramWriDataOut : out std_logic_vector(15 downto 0); --send it to the ram

        save : out std_logic;

        hs : out std_logic;
        vs : out std_logic
    );
end vga_control;

architecture Behavioral of vga_control is
    -- some tmp signal
    signal clk, clk_60 : std_logic := '0';
    signal r_t, g_t, b_t : std_logic_vector (2 downto 0);
    signal hs_t,vs_t : std_logic;
    signal x, y : integer range 0 to 1000;
    signal readData : std_logic;
    signal tmp_Addr : std_logic_vector(17 downto 0); --record those addr and data for a while
    signal tmp_Data : std_logic_vector(15 downto 0);
    signal something_save : std_logic := '0';

begin

    process (clk_in) -- make that 25MHz
	begin
		if clk_in'event and clk_in = '1' then
			clk <= not clk;
		end if;
    end process;

    --VGA functions:
    
    process(clk, rst, x) --800x525
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

    process(clk, rst, y, x) --800X525
    begin
        if rst = '0' then
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

    process(clk, rst, x) --656~752
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

    process(clk, rst, y) --490~492
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

    process(clk, rst, hs_t) --for hs
	 begin
        if rst = '0' then
            hs <= '0';
        elsif clk'event and clk = '1' then
            hs <= hs_t;
        end if;
    end process;

    process(clk, rst, vs_t) --for vs
	begin
        if rst = '0' then
            vs <= '0';
        elsif clk'event and clk = '1' then
            vs <= vs_t;
        end if;
    end process;
    
    process(clk, rst, x, y) --control the rgb
    begin
        if rst = '0' then
            vgaRead <= '0';
            r_t <= "000";
            g_t <= "000";
            b_t <= "000";
        elsif clk'event and clk = '1' then
            if x >= 0 and x < 640 and y >= 0 and y < 480 then
                if x >= 64 and x < 576 and y >= 0 and y < 480 then
                    vgaRead <= '1';
                    romAddr(17 downto 9) <= conv_std_logic_vector(x-64, 9);
                    romAddr(8 downto 0) <= conv_std_logic_vector(y, 9);
                    r_t <= romData(8 downto 6);
                    g_t <= romData(5 downto 3);
                    b_t <= romData(2 downto 0);
                else
                    vgaRead <= '0';
                    romAddr(17 downto 0) <= (others => '0');
                    r_t <= (others => '0');
                    g_t <= (others => '0');
                    b_t <= (others => '0');
                end if;
            else
                vgaRead <= '0';
                r_t <= (others => '0');
                g_t <= (others => '0');
                b_t <= (others => '0');
            end if;
        end if;
    end process;

    process(hs_t, vs_t, r_t, g_t, b_t) --put them into output
    begin 
        if hs_t = '1' and vs_t = '1' then
			out_red <= r_t;
			out_green <= g_t;
			out_blue <= b_t;
		else
			out_red <= (others => '0');
			out_green <= (others => '0');
			out_blue <= (others => '0');
		end if;
    end process;

    --video card functions:

    process(clk, rst, ramWriAddrIn, ramWriDataIn, ramWrite, readData, something_save) --when some data
    begin
        if rst = '0' then
            vgaWrite <= '0'; --shi neng wei ling
            ramWriAddrOut <= (others => '0');
            ramWriDataOut <= (others => '0');
            tmp_Addr <= (others => '0');
            tmp_Data <= (others => '0');
            something_save <= '0';
        elsif clk'event and clk = '1' then  --if the state is read
            vgaWrite <= '0';
            ramWriAddrOut <= (others => '0');
            ramWriDataOut <= (others => '0');
            if ramWrite = '1' then --if need to write, then save it
                tmp_Addr <= ramWriAddrIn;
                tmp_Data <= ramWriDataIn;
                something_save <= '1';
            end if;
        elsif clk'event and clk = '0' then -- if the state is write
            if ramWrite = '1' and something_save = '0' then
                vgaWrite <= '1';
                ramWriAddrOut <= ramWriAddrIn;
                ramWriDataOut <= ramWriDataIn;
            elsif ramWrite = '1' and something_save = '1' then
                vgaWrite <= '1';
                ramWriAddrOut <= tmp_Addr;
                ramWriDataOut <= tmp_Data;
                tmp_Addr <= ramWriAddrIn;
                tmp_Data <= ramWriDataIn;
                something_save <= '1';
            elsif ramWrite = '0' and something_save = '1' then
                vgaWrite <= '1';
                ramWriAddrOut <= tmp_Addr;
                ramWriDataOut <= tmp_Data;
                tmp_Addr <= (others => '0');
                tmp_Data <= (others => '0');
                something_save <= '0';
            else
                vgaWrite <= '0';
                ramWriAddrOut <= (others => '0');
                ramWriDataOut <= (others => '0');
            end if;
        end if;
        save <= something_save;
    end process;

end Behavioral;

