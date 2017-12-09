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
use work.consts.ALL;
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
    pixel_graphic : in std_logic_vector(64 downto 0);
    graphic_type : in std_logic_vector(3 downto 0);
    graphic_color : in std_logic_vector(8 downto 0);
    graphic_enlarge : in std_logic_vector(3 downto 0);
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


    signal tmp_ascii_input : std_logic_vector (6 downto 0) := (others => '0');
    signal tmp_ascii : std_logic_vector (63 downto 0) := (others => '0');
    signal tmp_x : std_logic_vector (8 downto 0) := "000000000";
    signal tmp_y : std_logic_vector (8 downto 0) := "000000000";

    signal tmp_x_shift : std_logic_vector (2 downto 0) := "000";
    signal tmp_y_shift : std_logic_vector (2 downto 0) := "000";

    signal tmp_shift_count_x : std_logic_vector(3 downto 0) := "0000";
    signal tmp_shift_count_y : std_logic_vector(3 downto 0) := "0000";
    signal tmp_shift_real_x : std_logic_vector(8 downto 0) := "000000000";
    signal tmp_shift_real_y : std_logic_vector(8 downto 0) := "000000000";
    signal tmp_enlarge : std_logic_vector(3 downto 0) := "0000";

    signal tmp_pixel_graphic : std_logic_vector(64 downto 0);
    signal tmp_graphic_type : std_logic_vector(3 downto 0);
    signal tmp_graphic_color : std_logic_vector(8 downto 0);
    
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

    ascii_decoder: ascii_decoder port map(
        ascii_input => tmp_ascii_input,
        ascii_pic_out => tmp_ascii
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

    process(clk_50m)
    begin
        if (rising_edge(clk_50m)) then

            if (disp_state = read_ram) then
                ram2_get_addr <= s_vga_addr;
                ram2_isRead <= '1';
                ram2_isUsed <= '1';

                if (s_vga_read_addr = '1') then
                    s_vga_data <= ram2_res;
                else
                    s_vga_data <= (others => '0');
                end if;

            else
                if (s_is_idle = '1') then
                    if (start_signal = '1') then
                        tmp_ascii_input <= ascii_input;

                        tmp_x <= ascii_place_x;
                        tmp_y <= ascii_place_y;

                        tmp_x_shift <= "000";
                        tmp_y_shift <= "000";
                        tmp_shift_count_x <= "0000";
                        tmp_shift_count_y <= "0000";
                        tmp_shift_real_x <= "000000000";
                        tmp_shift_real_y <= "000000000";
                        
                        tmp_enlarge <= graphic_enlarge;
                        tmp_pixel_graphic <= pixel_graphic;
                        tmp_graphic_type <= graphic_type;
                        tmp_graphic_color <= graphic_color;

                        s_is_idle <= '0';
                    end if;
                else
                    ram2_isUsed <= '1';
                    ram2_isRead <= '0';
                    ram2_get_addr <= (tmp_x + tmp_shift_real_x) &
                        (tmp_y + tmp_shift_real_y);

                    case tmp_graphic_type is
                        when graphic_type_ascii =>
                            if (tmp_ascii(63-conv_integer(tmp_x_shift & tmp_y_shift)) = '1') then
                                ram2_write_data <= "0000000" & tmp_graphic_color;                    
                                ram2_isUsed <= '1';
                            else
                                ram2_write_data <= (others => '1');
                                ram2_isUsed <= '0';
                            end if;
                        
                        when graphic_type_pixel =>
                            if (tmp_ascii_input(0) = '1') then
                                ram2_write_data <= "0000000" & tmp_graphic_color;
                                ram2_isUsed <= '1';
                            else
                                ram2_write_data <= (others => '1');
                                ram2_isUsed <= '0';
                            end if;

                            s_is_idle <= '1';

                        when graphic_type_bitmap =>
                            if (tmp_pixel_graphic(63-conv_integer(tmp_x_shift & tmp_y_shift)) = '1') then
                                ram2_write_data <= "0000000" & tmp_graphic_color;
                                ram2_isUsed <= '1';
                            else
                                ram2_write_data <= (others => '1');
                                ram2_isUsed <= '0';
                            end if;
                        when others =>
                            ram2_write_data <= (others => '1');
                            ram2_isUsed <= '0';
                    end case;

                    if (tmp_shift_count_y = tmp_enlarge) then
                        tmp_shift_count_y <= "0000";
                        if (tmp_y_shift = "111") then
                            tmp_shift_real_y <= "000000000";
                            tmp_y_shift <= "000";
                            if (tmp_shift_count_x = tmp_enlarge) then
                                tmp_shift_count_x <= "0000";
                                if (tmp_x_shift = "111") then
                                    tmp_shift_real_x <= "000000000";
                                    tmp_x_shift <= "000";
                                    s_is_idle <= '1';
                                else 
                                    tmp_x_shift <= tmp_x_shift + "001";
                                end if;
                            else
                                tmp_shift_count_x <= tmp_shift_count_x + "0001";
                                tmp_shift_real_x <= tmp_shift_real_x + "000000001";
                            end if;
                        else 
                            tmp_y_shift <= tmp_y_shift + "001";
                        end if;
                    else
                        tmp_shift_count_y <= tmp_shift_count_y + "0001";
                        tmp_shift_real_y <= tmp_shift_real_y + "000000001";
                    end if;
                end if;

            end if;
        end if;
    end process;

    is_idle <= s_is_idle;

end Behavioral;

