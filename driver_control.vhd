----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:23:22 11/28/2017 
-- Design Name: 
-- Module Name:    driver_control - Behavioral 
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

entity driver_control is port(
    clk_in : in std_logic;

    vgaAdd : in std_logic;
    vgaDel : in std_logic;

    ascii_in : in std_logic_vector(6 downto 0);

    vgaWrite : out std_logic;
    vgaAddr : out std_logic_vector(17 downto 0);
    vgaData : out std_logic_vector(15 downto 0);

    rst : in std_logic
);
end driver_control;

architecture Behavioral of driver_control is
    --something to save in
    type writing_state is (waiting, writing);
    signal w_state : writing_state := waiting;
    signal writing_line : integer range 0 to 300;   --record the line that is being written
                                                    --it means waiting when state:=0
    signal tmp_graphic : std_logic_vector(63 downto 0); --save the graphics
    signal writing_x, writing_y : integer range 0 to 520 := 24; --save the place of graphic in vga
    signal clk : std_logic := '0';
    signal begin_write : std_logic := '0';

begin

    process (clk_in) -- make that 25MHz
	begin
		if clk_in'event and clk_in = '1' then
			clk <= not clk;
		end if;
    end process;

    process (clk, rst, tmp_graphic, vgaAdd, vgaDel, ascii_in)
    begin
        if rst = '0' then
            tmp_graphic(63 downto 56) <= "00000000";
            tmp_graphic(55 downto 48) <= "00000000";
            tmp_graphic(47 downto 40) <= "00000000";
            tmp_graphic(39 downto 32) <= "00000000";
            tmp_graphic(31 downto 24) <= "00000000";
            tmp_graphic(23 downto 16) <= "00000000";
            tmp_graphic(15 downto 8)  <= "00000000";
            tmp_graphic(7 downto 0)   <= "00000000";

            w_state <= waiting;
            vgaWrite <= '0';
            vgaAddr <= (others => '0');
            vgaData <= (others => '0');
        elsif clk'event and clk = '0' then
            case w_state is
                when waiting =>             --waiting to write
                    vgaWrite <= '0';
                    vgaAddr <= (others => '0');
                    vgaData <= (others => '0');
                    if vgaAdd = '1' then --when add
                        case ascii_in is
                            when "0100001" => --!
                                tmp_graphic(63 downto 56) <= "00010000";
                                tmp_graphic(55 downto 48) <= "00010000";
                                tmp_graphic(47 downto 40) <= "00010000";
                                tmp_graphic(39 downto 32) <= "00010000";
                                tmp_graphic(31 downto 24) <= "00000000";
                                tmp_graphic(23 downto 16) <= "00000000";
                                tmp_graphic(15 downto 8)  <= "00010000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0100010" => --""
                                tmp_graphic(63 downto 56) <= "00000000";
                                tmp_graphic(55 downto 48) <= "00100100";
                                tmp_graphic(47 downto 40) <= "00100100";
                                tmp_graphic(39 downto 32) <= "00100100";
                                tmp_graphic(31 downto 24) <= "00000000";
                                tmp_graphic(23 downto 16) <= "00000000";
                                tmp_graphic(15 downto 8)  <= "00000000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0100011" => --#
                                tmp_graphic(63 downto 56) <= "00101000";
                                tmp_graphic(55 downto 48) <= "00101000";
                                tmp_graphic(47 downto 40) <= "01111100";
                                tmp_graphic(39 downto 32) <= "00101000";
                                tmp_graphic(31 downto 24) <= "00101000";
                                tmp_graphic(23 downto 16) <= "01111100";
                                tmp_graphic(15 downto 8)  <= "00101000";
                                tmp_graphic(7 downto 0)   <= "00101000";
                            when "0100100" => --$
                                tmp_graphic(63 downto 56) <= "00010000";
                                tmp_graphic(55 downto 48) <= "00111100";
                                tmp_graphic(47 downto 40) <= "01010000";
                                tmp_graphic(39 downto 32) <= "00111000";
                                tmp_graphic(31 downto 24) <= "00010100";
                                tmp_graphic(23 downto 16) <= "01111000";
                                tmp_graphic(15 downto 8)  <= "00010000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0100101" => --%
                                tmp_graphic(63 downto 56) <= "01100000";
                                tmp_graphic(55 downto 48) <= "01100100";
                                tmp_graphic(47 downto 40) <= "00001000";
                                tmp_graphic(39 downto 32) <= "00010000";
                                tmp_graphic(31 downto 24) <= "00100000";
                                tmp_graphic(23 downto 16) <= "01001100";
                                tmp_graphic(15 downto 8)  <= "00001100";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0100110" => --&
                                tmp_graphic(63 downto 56) <= "00110000";
                                tmp_graphic(55 downto 48) <= "01001000";
                                tmp_graphic(47 downto 40) <= "01010000";
                                tmp_graphic(39 downto 32) <= "00100000";
                                tmp_graphic(31 downto 24) <= "01010100";
                                tmp_graphic(23 downto 16) <= "01001000";
                                tmp_graphic(15 downto 8)  <= "00110100";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0100111" => --'
                                tmp_graphic(63 downto 56) <= "00000000";
                                tmp_graphic(55 downto 48) <= "00100000";
                                tmp_graphic(47 downto 40) <= "00010000";
                                tmp_graphic(39 downto 32) <= "00100000";
                                tmp_graphic(31 downto 24) <= "00000000";
                                tmp_graphic(23 downto 16) <= "00000000";
                                tmp_graphic(15 downto 8)  <= "00000000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0101000" => --(
                                tmp_graphic(63 downto 56) <= "00001000";
                                tmp_graphic(55 downto 48) <= "00010000";
                                tmp_graphic(47 downto 40) <= "00100000";
                                tmp_graphic(39 downto 32) <= "00100000";
                                tmp_graphic(31 downto 24) <= "00100000";
                                tmp_graphic(23 downto 16) <= "00010000";
                                tmp_graphic(15 downto 8)  <= "00001000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0101001" => --)
                                tmp_graphic(63 downto 56) <= "00100000";
                                tmp_graphic(55 downto 48) <= "00010000";
                                tmp_graphic(47 downto 40) <= "00001000";
                                tmp_graphic(39 downto 32) <= "00001000";
                                tmp_graphic(31 downto 24) <= "00001000";
                                tmp_graphic(23 downto 16) <= "00010000";
                                tmp_graphic(15 downto 8)  <= "00100000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0101010" => --*
                                tmp_graphic(63 downto 56) <= "00000000";
                                tmp_graphic(55 downto 48) <= "00010000";
                                tmp_graphic(47 downto 40) <= "01010100";
                                tmp_graphic(39 downto 32) <= "00111000";
                                tmp_graphic(31 downto 24) <= "01010100";
                                tmp_graphic(23 downto 16) <= "00010000";
                                tmp_graphic(15 downto 8)  <= "00000000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0101011" => --+
                                tmp_graphic(63 downto 56) <= "00000000";
                                tmp_graphic(55 downto 48) <= "00010000";
                                tmp_graphic(47 downto 40) <= "00010000";
                                tmp_graphic(39 downto 32) <= "01111100";
                                tmp_graphic(31 downto 24) <= "00010000";
                                tmp_graphic(23 downto 16) <= "00010000";
                                tmp_graphic(15 downto 8)  <= "00000000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0101100" => --,
                                tmp_graphic(63 downto 56) <= "00000000";
                                tmp_graphic(55 downto 48) <= "00000000";
                                tmp_graphic(47 downto 40) <= "00000000";
                                tmp_graphic(39 downto 32) <= "00000000";
                                tmp_graphic(31 downto 24) <= "00110000";
                                tmp_graphic(23 downto 16) <= "00010000";
                                tmp_graphic(15 downto 8)  <= "00100000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0101101" => ---
                                tmp_graphic(63 downto 56) <= "00000000";
                                tmp_graphic(55 downto 48) <= "00000000";
                                tmp_graphic(47 downto 40) <= "00000000";
                                tmp_graphic(39 downto 32) <= "01111100";
                                tmp_graphic(31 downto 24) <= "00000000";
                                tmp_graphic(23 downto 16) <= "00000000";
                                tmp_graphic(15 downto 8)  <= "00000000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0101110" --.
                                tmp_graphic(63 downto 56) <= "00000000";
                                tmp_graphic(55 downto 48) <= "00000000";
                                tmp_graphic(47 downto 40) <= "00000000";
                                tmp_graphic(39 downto 32) <= "00000000";
                                tmp_graphic(31 downto 24) <= "00110000";
                                tmp_graphic(23 downto 16) <= "00110000";
                                tmp_graphic(15 downto 8)  <= "00000000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0101111" --/
                                tmp_graphic(63 downto 56) <= "00000000";
                                tmp_graphic(55 downto 48) <= "00000100";
                                tmp_graphic(47 downto 40) <= "00001000";
                                tmp_graphic(39 downto 32) <= "00010000";
                                tmp_graphic(31 downto 24) <= "00100000";
                                tmp_graphic(23 downto 16) <= "01000000";
                                tmp_graphic(15 downto 8)  <= "00000000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0110000" --0
                                tmp_graphic(63 downto 56) <= "00111000";
                                tmp_graphic(55 downto 48) <= "01000100";
                                tmp_graphic(47 downto 40) <= "01001100";
                                tmp_graphic(39 downto 32) <= "01010100";
                                tmp_graphic(31 downto 24) <= "01100100";
                                tmp_graphic(23 downto 16) <= "01000100";
                                tmp_graphic(15 downto 8)  <= "00111000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0110001" --1
                                tmp_graphic(63 downto 56) <= "00010000";
                                tmp_graphic(55 downto 48) <= "00110000";
                                tmp_graphic(47 downto 40) <= "00010000";
                                tmp_graphic(39 downto 32) <= "00010000";
                                tmp_graphic(31 downto 24) <= "00010000";
                                tmp_graphic(23 downto 16) <= "00010000";
                                tmp_graphic(15 downto 8)  <= "00111000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0110010" --2
                                tmp_graphic(63 downto 56) <= "00111000";
                                tmp_graphic(55 downto 48) <= "01000100";
                                tmp_graphic(47 downto 40) <= "00000100";
                                tmp_graphic(39 downto 32) <= "00001000";
                                tmp_graphic(31 downto 24) <= "00010000";
                                tmp_graphic(23 downto 16) <= "00110000";
                                tmp_graphic(15 downto 8)  <= "01111100";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0110011" --3
                                tmp_graphic(63 downto 56) <= "01111100";
                                tmp_graphic(55 downto 48) <= "00001000";
                                tmp_graphic(47 downto 40) <= "00010000";
                                tmp_graphic(39 downto 32) <= "00001000";
                                tmp_graphic(31 downto 24) <= "00000100";
                                tmp_graphic(23 downto 16) <= "01000100";
                                tmp_graphic(15 downto 8)  <= "00111000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0110100" --4
                                tmp_graphic(63 downto 56) <= "00001000";
                                tmp_graphic(55 downto 48) <= "00011000";
                                tmp_graphic(47 downto 40) <= "00101000";
                                tmp_graphic(39 downto 32) <= "01001000";
                                tmp_graphic(31 downto 24) <= "01111100";
                                tmp_graphic(23 downto 16) <= "00001000";
                                tmp_graphic(15 downto 8)  <= "00001000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0110101" --5
                                tmp_graphic(63 downto 56) <= "01111100";
                                tmp_graphic(55 downto 48) <= "01000000";
                                tmp_graphic(47 downto 40) <= "01111000";
                                tmp_graphic(39 downto 32) <= "00000100";
                                tmp_graphic(31 downto 24) <= "00000100";
                                tmp_graphic(23 downto 16) <= "01000100";
                                tmp_graphic(15 downto 8)  <= "00111000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0110110" --6
                                tmp_graphic(63 downto 56) <= "00011100";
                                tmp_graphic(55 downto 48) <= "00100000";
                                tmp_graphic(47 downto 40) <= "0100000";
                                tmp_graphic(39 downto 32) <= "01111100";
                                tmp_graphic(31 downto 24) <= "01000100";
                                tmp_graphic(23 downto 16) <= "01000100";
                                tmp_graphic(15 downto 8)  <= "00111000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0110111" --7
                                tmp_graphic(63 downto 56) <= "01111100";
                                tmp_graphic(55 downto 48) <= "00000100";
                                tmp_graphic(47 downto 40) <= "00001000";
                                tmp_graphic(39 downto 32) <= "00010000";
                                tmp_graphic(31 downto 24) <= "00010000";
                                tmp_graphic(23 downto 16) <= "00010000";
                                tmp_graphic(15 downto 8)  <= "00010000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0111000" --8
                                tmp_graphic(63 downto 56) <= "00111000";
                                tmp_graphic(55 downto 48) <= "01000100";
                                tmp_graphic(47 downto 40) <= "01000100";
                                tmp_graphic(39 downto 32) <= "00111000";
                                tmp_graphic(31 downto 24) <= "01000100";
                                tmp_graphic(23 downto 16) <= "01000100";
                                tmp_graphic(15 downto 8)  <= "00111000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0111001" --9
                                tmp_graphic(63 downto 56) <= "00011000";
                                tmp_graphic(55 downto 48) <= "01000100";
                                tmp_graphic(47 downto 40) <= "01000100";
                                tmp_graphic(39 downto 32) <= "00111100";
                                tmp_graphic(31 downto 24) <= "00000100";
                                tmp_graphic(23 downto 16) <= "00001000";
                                tmp_graphic(15 downto 8)  <= "00110000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0111010" --:
                                tmp_graphic(63 downto 56) <= "00000000";
                                tmp_graphic(55 downto 48) <= "00110000";
                                tmp_graphic(47 downto 40) <= "00110000";
                                tmp_graphic(39 downto 32) <= "00000000";
                                tmp_graphic(31 downto 24) <= "00110000";
                                tmp_graphic(23 downto 16) <= "00110000";
                                tmp_graphic(15 downto 8)  <= "00000000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0111011" --;
                                tmp_graphic(63 downto 56) <= "00000000";
                                tmp_graphic(55 downto 48) <= "00110000";
                                tmp_graphic(47 downto 40) <= "00110000";
                                tmp_graphic(39 downto 32) <= "00000000";
                                tmp_graphic(31 downto 24) <= "00110000";
                                tmp_graphic(23 downto 16) <= "00010000";
                                tmp_graphic(15 downto 8)  <= "00100000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0111100" --<
                                tmp_graphic(63 downto 56) <= "00001000";
                                tmp_graphic(55 downto 48) <= "00010000";
                                tmp_graphic(47 downto 40) <= "00100000";
                                tmp_graphic(39 downto 32) <= "01000000";
                                tmp_graphic(31 downto 24) <= "00100000";
                                tmp_graphic(23 downto 16) <= "00010000";
                                tmp_graphic(15 downto 8)  <= "00001000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0111101" --=
                                tmp_graphic(63 downto 56) <= "00000000";
                                tmp_graphic(55 downto 48) <= "00000000";
                                tmp_graphic(47 downto 40) <= "01111100";
                                tmp_graphic(39 downto 32) <= "00000000";
                                tmp_graphic(31 downto 24) <= "01111100";
                                tmp_graphic(23 downto 16) <= "00000000";
                                tmp_graphic(15 downto 8)  <= "00000000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0111110" -->
                                tmp_graphic(63 downto 56) <= "01000000";
                                tmp_graphic(55 downto 48) <= "00100000";
                                tmp_graphic(47 downto 40) <= "00010000";
                                tmp_graphic(39 downto 32) <= "00001000";
                                tmp_graphic(31 downto 24) <= "00010000";
                                tmp_graphic(23 downto 16) <= "00100000";
                                tmp_graphic(15 downto 8)  <= "01000000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "0111111" --?
                                tmp_graphic(63 downto 56) <= "00111000";
                                tmp_graphic(55 downto 48) <= "01000100";
                                tmp_graphic(47 downto 40) <= "00000100";
                                tmp_graphic(39 downto 32) <= "00001000";
                                tmp_graphic(31 downto 24) <= "00010000";
                                tmp_graphic(23 downto 16) <= "00000000";
                                tmp_graphic(15 downto 8)  <= "00010000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "1000000" --@
                                tmp_graphic(63 downto 56) <= "00111000";
                                tmp_graphic(55 downto 48) <= "01000100";
                                tmp_graphic(47 downto 40) <= "00000100";
                                tmp_graphic(39 downto 32) <= "00110100";
                                tmp_graphic(31 downto 24) <= "01010100";
                                tmp_graphic(23 downto 16) <= "01010100";
                                tmp_graphic(15 downto 8)  <= "00111000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when "1000001" => --A
                                tmp_graphic(63 downto 56) <= "00110000";
                                tmp_graphic(55 downto 48) <= "01111000";
                                tmp_graphic(47 downto 40) <= "11001100";
                                tmp_graphic(39 downto 32) <= "11001100";
                                tmp_graphic(31 downto 24) <= "11111100";
                                tmp_graphic(23 downto 16) <= "11001100";
                                tmp_graphic(15 downto 8)  <= "11001100";
                                tmp_graphic(7 downto 0)   <= "00000000";
                            when others =>
                                tmp_graphic(63 downto 56) <= "00000000";
                                tmp_graphic(55 downto 48) <= "00000000";
                                tmp_graphic(47 downto 40) <= "00000000";
                                tmp_graphic(39 downto 32) <= "00000000";
                                tmp_graphic(31 downto 24) <= "00000000";
                                tmp_graphic(23 downto 16) <= "00000000";
                                tmp_graphic(15 downto 8)  <= "00000000";
                                tmp_graphic(7 downto 0)   <= "00000000";
                        end case;

                        w_state <= writing;
                        writing_line <= 0;
                    elsif vgaDel = '1' then --when delete
                        tmp_graphic(63 downto 56) <= "00000000";
                        tmp_graphic(55 downto 48) <= "00000000";
                        tmp_graphic(47 downto 40) <= "00000000";
                        tmp_graphic(39 downto 32) <= "00000000";
                        tmp_graphic(31 downto 24) <= "00000000";
                        tmp_graphic(23 downto 16) <= "00000000";
                        tmp_graphic(15 downto 8)  <= "00000000";
                        tmp_graphic(7 downto 0)   <= "00000000";

                        w_state <= writing;
                        writing_line <= 128;
                    end if;
                when writing =>             --is writing now
                    --adding states
                    if writing_line >= 0 and writing_line < 63 then --write new
                        vgaWrite <= '1';
                        vgaAddr(17 downto 9) <= conv_std_logic_vector(writing_x + 
                            conv_integer(conv_std_logic_vector(writing_line, 9)(2 downto 0)), 9);
                        vgaAddr(8 downto 0) <= conv_std_logic_vector(writing_y + 
                            conv_integer(conv_std_logic_vector(writing_line, 9)(8 downto 3)), 9);
                        vgaData <= (others => tmp_graphic(63 - writing_line));
                        writing_line <= writing_line + 1;
                    elsif writing_line = 63 then --jump to 263
                        vgaWrite <= '1';
                        vgaAddr(17 downto 9) <= conv_std_logic_vector(writing_x + 
                            conv_integer(conv_std_logic_vector(writing_line, 9)(2 downto 0)), 9);
                        vgaAddr(8 downto 0) <= conv_std_logic_vector(writing_y + 
                            conv_integer(conv_std_logic_vector(writing_line, 9)(8 downto 3)), 9);
                        vgaData <= (others => tmp_graphic(63 - writing_line));
                        writing_line <= 263;
                    elsif writing_line = 263 then --write next one
                        vgaWrite <= '0';
                        vgaAddr <= (others => '0');
                        vgaData <= (others => '0');

                        tmp_graphic(63 downto 56) <= "00000000";
                        tmp_graphic(55 downto 48) <= "00000000";
                        tmp_graphic(47 downto 40) <= "00000000";
                        tmp_graphic(39 downto 32) <= "00000000";
                        tmp_graphic(31 downto 24) <= "00000000";
                        tmp_graphic(23 downto 16) <= "00000000";
                        tmp_graphic(15 downto 8)  <= "00000000";
                        tmp_graphic(7 downto 0)   <= "11111111";

                        -- change the x & y
                        if writing_x < 480 and writing_y < 480 then
                            writing_x <= writing_x + 8;
                        elsif writing_y < 480 then
                            writing_x <= 24;
                            writing_y <= writing_y + 8;
                        else 
                            writing_x <= 24;
                            writing_y <= 24;
                        end if;
                        writing_line <= 64;
                    elsif writing_line >= 64 and writing_line < 127 then --write _
                        vgaWrite <= '1';
                        vgaAddr(17 downto 9) <= conv_std_logic_vector(writing_x + 
                            conv_integer(conv_std_logic_vector(writing_line, 9)(2 downto 0)), 9);
                        vgaAddr(8 downto 0) <= conv_std_logic_vector(writing_y + 
                            conv_integer(conv_std_logic_vector(writing_line - 64, 9)(8 downto 3)), 9);
                        vgaData <= (others => tmp_graphic(127 - writing_line));
                        writing_line <= writing_line + 1;
                    elsif writing_line = 127 then --jump to ending
                        vgaWrite <= '1';
                        vgaAddr(17 downto 9) <= conv_std_logic_vector(writing_x + 
                            conv_integer(conv_std_logic_vector(writing_line, 9)(2 downto 0)), 9);
                        vgaAddr(8 downto 0) <= conv_std_logic_vector(writing_y + 
                            conv_integer(conv_std_logic_vector(writing_line - 64, 9)(8 downto 3)), 9);
                        vgaData <= (others => tmp_graphic(127 - writing_line));
                        writing_line <= 264;
                    elsif writing_line = 264 then --end writing new char
                        w_state <= waiting;
                        vgaWrite <= '0';
                        vgaAddr <= (others => '0');
                        vgaData <= (others => '0');
                        writing_line <= 0;

                    --delete states
                    elsif writing_line >= 128 and writing_line < 191 then --delete this one
                        vgaWrite <= '1';
                        vgaAddr(17 downto 9) <= conv_std_logic_vector(writing_x + 
                            conv_integer(conv_std_logic_vector(writing_line, 9)(2 downto 0)), 9);
                        vgaAddr(8 downto 0) <= conv_std_logic_vector(writing_y + 
                            conv_integer(conv_std_logic_vector(writing_line - 128, 9)(8 downto 3)), 9);
                        vgaData <= (others => tmp_graphic(191 - writing_line));
                        writing_line <= writing_line + 1;
                    elsif writing_line = 191 then --jump to the last one
                        vgaWrite <= '1';
                        vgaAddr(17 downto 9) <= conv_std_logic_vector(writing_x + 
                            conv_integer(conv_std_logic_vector(writing_line, 9)(2 downto 0)), 9);
                        vgaAddr(8 downto 0) <= conv_std_logic_vector(writing_y + 
                            conv_integer(conv_std_logic_vector(writing_line - 128, 9)(8 downto 3)), 9);
                        vgaData <= (others => tmp_graphic(191 - writing_line));     
                        writing_line <= 265;  
                    elsif writing_line = 265 then --delete last one
                        vgaWrite <= '0';
                        vgaAddr <= (others => '0');
                        vgaData <= (others => '0');

                        tmp_graphic(63 downto 56) <= "00000000";
                        tmp_graphic(55 downto 48) <= "00000000";
                        tmp_graphic(47 downto 40) <= "00000000";
                        tmp_graphic(39 downto 32) <= "00000000";
                        tmp_graphic(31 downto 24) <= "00000000";
                        tmp_graphic(23 downto 16) <= "00000000";
                        tmp_graphic(15 downto 8)  <= "00000000";
                        tmp_graphic(7 downto 0)   <= "11111111";
                        
                        -- change the x & y
                        if writing_x > 24 and writing_y > 24 then
                            writing_x <= writing_x - 8;
                        elsif writing_y > 24 then
                            writing_x <= 480;
                            writing_y <= writing_y - 8;
                        else 
                            writing_x <= 24;
                            writing_y <= 24;
                        end if;
                        writing_line <= 192;
                    elsif writing_line >= 192 and writing_line < 255 then --write _
                        vgaWrite <= '1';
                        vgaAddr(17 downto 9) <= conv_std_logic_vector(writing_x + 
                            conv_integer(conv_std_logic_vector(writing_line, 9)(2 downto 0)), 9);
                        vgaAddr(8 downto 0) <= conv_std_logic_vector(writing_y + 
                            conv_integer(conv_std_logic_vector(writing_line - 192, 9)(8 downto 3)), 9);
                        vgaData <= (others => tmp_graphic(255 - writing_line));
                        writing_line <= writing_line + 1;
                    elsif writing_line = 255 then 
                        vgaWrite <= '1';
                        vgaAddr(17 downto 9) <= conv_std_logic_vector(writing_x + 
                            conv_integer(conv_std_logic_vector(writing_line, 9)(2 downto 0)), 9);
                        vgaAddr(8 downto 0) <= conv_std_logic_vector(writing_y + 
                            conv_integer(conv_std_logic_vector(writing_line - 192, 9)(8 downto 3)), 9);
                        vgaData <= (others => tmp_graphic(255 - writing_line));
                        writing_line <= 266;
                    elsif writing_line = 266 then --end deleting it
                        w_state <= waiting;
                        vgaWrite <= '0';
                        vgaAddr <= (others => '0');
                        vgaData <= (others => '0');
                        writing_line <= 0;
                    else
                        writing_line <= 0;
                        vgaWrite <= '0';
                        vgaAddr <= (others => '0');
                        vgaData <= (others => '0');
                    end if;
            end case;
        end if;
    end process;

end Behavioral;