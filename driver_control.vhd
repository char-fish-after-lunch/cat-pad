----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:03:15 11/25/2017 
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
    signal writing_line : integer range 0 to 70;   --record the line that is being written
                                                    --it means waiting when state:=0
    signal tmp_graphic : std_logic_vector(63 downto 0); 
    signal writing_x, writing_y : integer range 0 to 520 := 20; --save the place of graphic in vga
    signal clk : std_logic := 0;

begin

    process (clk_in) -- make that 25MHz
	begin
		if clk_in'event and clk_in = '1' then
			clk <= not clk;
		end if;
    end process;

    process (clk, rst, vgaAdd, vgaDel, ascii_in)
    begin
        case writing_state is
            when waiting =>
            when writing =>
                if writing_line = 63 then
                    writing_state <= waiting;
                    vgaWrite <= '0';
                    vgaAddr <= (others => '0');
                    vgaData <= (others => '0');
                    tmp_graphic <= (others => '0');
                    writing_line <= 0;
                    -- change the x & y
                    if x < 492 and y < 492 then
                        x <= x + 8;
                        y <= y + 8;
                    elsif y < 492 then
                        x <= 20;
                        y <= y + 8;
                    else 
                        x <= 20;
                        y <= 20;
                    end if;
                else
                    vgaWrite <= '1';
                    vgaAddr(17 downto 9) <= conv_std_logic_vector(writing_x + (writing_line rem 8));
                    vgaAddr(8 downto 0) <= conv_std_logic_vector(writing_y + (writing_line mod 8));
                    vgaData <= (others => tmp_graphic(writing_line));
                    writing_line <= writing_line + 1;
                end if;
        end case;
    end process;

end Behavioral;