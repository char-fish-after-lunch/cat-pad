----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:14:06 12/01/2017 
-- Design Name: 
-- Module Name:    display_controller - Behavioral 
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
use work.io_components.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display_controller is port(
    clk_50m : in std_logic;
    
    ram2addr : out  std_logic_vector (17 downto 0);
    ram2data : inout  std_logic_vector (15 downto 0);
    ram2oe : out  std_logic;
    ram2rw : out  std_logic;
    ram2en : out  std_logic;

    vga_red : out std_logic_vector(2 downto 0);
    vga_green : out std_logic_vector(2 downto 0);
    vga_blue : out std_logic_vector(2 downto 0);

    vga_hs : out std_logic;
    vga_vs : out std_logic;

    ascii_input : in std_logic_vector(6 downto 0);
    ascii_place_x : in std_logic_vector(8 downto 0);
    ascii_place_y : in std_logic_vector(8 downto 0);
    is_idle : out std_logic;
    start_signal : in std_logic

);

end display_controller;

architecture Behavioral of display_controller is

	type display_state is (read_ram, write_vga_ram);
    signal disp_state : display_state := read_ram;

	signal ram2_get_addr : STD_LOGIC_VECTOR (17 downto 0) := (others => '0');
	signal ram2_write_data : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

    signal ram2_res : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal ram2_isRead : STD_LOGIC := '0';
	signal ram2_isUsed : STD_LOGIC := '0';


    signal tmp_ascii : std_logic_vector (63 downto 0) := (others => '0');
    signal tmp_x : std_logic_vector (8 downto 0) := "000000000";
    signal tmp_y : std_logic_vector (8 downto 0) := "000000000";

    signal tmp_x_shift : std_logic_vector (2 downto 0) := "000";
    signal tmp_y_shift : std_logic_vector (2 downto 0) := "000";
    
    signal s_vga_addr : std_logic_vector(17 downto 0);
    signal s_vga_data : std_logic_vector(15 downto 0) := (others => '0');


    signal s_is_idle : std_logic := '1';
    signal s_vga_enabled : std_logic := '0';
    signal s_vga_read_addr : std_logic := '0';
begin
	ram2_module: ram_module port map (
        clk => clk_50m,
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

    vga_module: vga_driver port map (
        vga_clk => clk_50m,
        vga_addr => s_vga_addr,
        vga_read_addr => s_vga_read_addr,
        vga_data => s_vga_data,

        vga_red => vga_red,
        vga_blue => vga_blue,
        vga_green => vga_green,

        vga_hs => vga_hs,
        vga_vs => vga_vs,
        vga_enabled => s_vga_enabled
    );
	     
    process(clk_50m)
    begin
        if (rising_edge(clk_50m)) then
            if (disp_state = write_vga_ram) then
                disp_state <= read_ram;
                s_vga_enabled <= '1';
            else
                disp_state <= write_vga_ram;
                s_vga_enabled <= '0';
            end if;
        end if;
    end process;

    process(clk_50m, disp_state, s_vga_data, s_vga_read_addr, s_vga_addr, ram2_res, tmp_x_shift, tmp_y_shift,
        s_is_idle, ascii_input, ascii_place_x, ascii_place_y)
    begin
        if (rising_edge(clk_50m)) then
            if (s_is_idle = '1') then
                if (start_signal = '1') then
                    tmp_ascii(63 downto 56) <= "00011100";
                    tmp_ascii(55 downto 48) <= "00100000";
                    tmp_ascii(47 downto 40) <= "01000000";
                    tmp_ascii(39 downto 32) <= "01111000";
                    tmp_ascii(31 downto 24) <= "01000100";
                    tmp_ascii(23 downto 16) <= "01000100";
                    tmp_ascii(15 downto 8)  <= "00111000";
                    tmp_ascii(7 downto 0)   <= "00000000";

                    tmp_x <= ascii_place_x;
                    tmp_y <= ascii_place_y;

                    tmp_x_shift <= "000";
                    tmp_y_shift <= "000";

                    s_is_idle <= '0';
                end if;
            end if;

            if (disp_state = read_ram) then
                ram2_get_addr <= s_vga_addr;
                ram2_isRead <= '1';
                ram2_isUsed <= '1';

                if (s_vga_read_addr = '1') then
                    s_vga_data <= ram2_res;
                else
                    s_vga_data <= (others => '0');
                end if;

                if (tmp_y_shift = "111") then
                    tmp_y_shift <= "000";
                    if (tmp_x_shift = "111") then
                        tmp_x_shift <= "000";
                        s_is_idle <= '1';
                    else 
                        tmp_x_shift <= tmp_x_shift + "001";
                    end if;
                else 
                    tmp_y_shift <= tmp_y_shift + "001";
                end if;

            else
                if (s_is_idle = '0') then
                    ram2_isUsed <= '1';
                    ram2_isRead <= '0';
                    ram2_get_addr <= (tmp_x + ("00000" & tmp_x_shift)) &
                        (tmp_y + ("00000" & tmp_y_shift));
                    ram2_write_data <= (others => tmp_ascii(63-conv_integer(tmp_x_shift & tmp_y_shift)));
                end if;

            end if;
        end if;
    end process;

    is_idle <= s_is_idle;

end Behavioral;

