----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:29:59 12/05/2017 
-- Design Name: 
-- Module Name:    ascii_decoder - Behavioral 
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

entity ascii_decoder is port(
    ascii_input : in std_logic_vector(6 downto 0);
    ascii_pic_out : out std_logic_vector(63 downto 0)
);
end ascii_decoder;

architecture Behavioral of ascii_decoder is
    signal tmp_graphic : std_logic_vector(63 downto 0);
begin
    ascii_pic_out <= not tmp_graphic;

    process(ascii_input)
    begin
        case ascii_input is
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
            when "0101110" =>  --.
                tmp_graphic(63 downto 56) <= "00000000";
                tmp_graphic(55 downto 48) <= "00000000";
                tmp_graphic(47 downto 40) <= "00000000";
                tmp_graphic(39 downto 32) <= "00000000";
                tmp_graphic(31 downto 24) <= "00110000";
                tmp_graphic(23 downto 16) <= "00110000";
                tmp_graphic(15 downto 8)  <= "00000000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0101111" =>  --/
                tmp_graphic(63 downto 56) <= "00000000";
                tmp_graphic(55 downto 48) <= "00000100";
                tmp_graphic(47 downto 40) <= "00001000";
                tmp_graphic(39 downto 32) <= "00010000";
                tmp_graphic(31 downto 24) <= "00100000";
                tmp_graphic(23 downto 16) <= "01000000";
                tmp_graphic(15 downto 8)  <= "00000000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0110000" =>  --0
                tmp_graphic(63 downto 56) <= "00111000";
                tmp_graphic(55 downto 48) <= "01000100";
                tmp_graphic(47 downto 40) <= "01001100";
                tmp_graphic(39 downto 32) <= "01010100";
                tmp_graphic(31 downto 24) <= "01100100";
                tmp_graphic(23 downto 16) <= "01000100";
                tmp_graphic(15 downto 8)  <= "00111000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0110001" =>  --1
                tmp_graphic(63 downto 56) <= "00010000";
                tmp_graphic(55 downto 48) <= "00110000";
                tmp_graphic(47 downto 40) <= "00010000";
                tmp_graphic(39 downto 32) <= "00010000";
                tmp_graphic(31 downto 24) <= "00010000";
                tmp_graphic(23 downto 16) <= "00010000";
                tmp_graphic(15 downto 8)  <= "00111000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0110010" =>  --2
                tmp_graphic(63 downto 56) <= "00111000";
                tmp_graphic(55 downto 48) <= "01000100";
                tmp_graphic(47 downto 40) <= "00000100";
                tmp_graphic(39 downto 32) <= "00001000";
                tmp_graphic(31 downto 24) <= "00010000";
                tmp_graphic(23 downto 16) <= "00110000";
                tmp_graphic(15 downto 8)  <= "01111100";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0110011" =>  --3
                tmp_graphic(63 downto 56) <= "01111100";
                tmp_graphic(55 downto 48) <= "00001000";
                tmp_graphic(47 downto 40) <= "00010000";
                tmp_graphic(39 downto 32) <= "00001000";
                tmp_graphic(31 downto 24) <= "00000100";
                tmp_graphic(23 downto 16) <= "01000100";
                tmp_graphic(15 downto 8)  <= "00111000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0110100" =>  --4
                tmp_graphic(63 downto 56) <= "00001000";
                tmp_graphic(55 downto 48) <= "00011000";
                tmp_graphic(47 downto 40) <= "00101000";
                tmp_graphic(39 downto 32) <= "01001000";
                tmp_graphic(31 downto 24) <= "01111100";
                tmp_graphic(23 downto 16) <= "00001000";
                tmp_graphic(15 downto 8)  <= "00001000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0110101" =>  --5
                tmp_graphic(63 downto 56) <= "01111100";
                tmp_graphic(55 downto 48) <= "01000000";
                tmp_graphic(47 downto 40) <= "01111000";
                tmp_graphic(39 downto 32) <= "00000100";
                tmp_graphic(31 downto 24) <= "00000100";
                tmp_graphic(23 downto 16) <= "01000100";
                tmp_graphic(15 downto 8)  <= "00111000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0110110" =>  --6
                tmp_graphic(63 downto 56) <= "00011100";
                tmp_graphic(55 downto 48) <= "00100000";
                tmp_graphic(47 downto 40) <= "01000000";
                tmp_graphic(39 downto 32) <= "01111100";
                tmp_graphic(31 downto 24) <= "01000100";
                tmp_graphic(23 downto 16) <= "01000100";
                tmp_graphic(15 downto 8)  <= "00111000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0110111" =>  --7
                tmp_graphic(63 downto 56) <= "01111100";
                tmp_graphic(55 downto 48) <= "00000100";
                tmp_graphic(47 downto 40) <= "00001000";
                tmp_graphic(39 downto 32) <= "00010000";
                tmp_graphic(31 downto 24) <= "00010000";
                tmp_graphic(23 downto 16) <= "00010000";
                tmp_graphic(15 downto 8)  <= "00010000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0111000" =>  --8
                tmp_graphic(63 downto 56) <= "00111000";
                tmp_graphic(55 downto 48) <= "01000100";
                tmp_graphic(47 downto 40) <= "01000100";
                tmp_graphic(39 downto 32) <= "00111000";
                tmp_graphic(31 downto 24) <= "01000100";
                tmp_graphic(23 downto 16) <= "01000100";
                tmp_graphic(15 downto 8)  <= "00111000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0111001" =>  --9
                tmp_graphic(63 downto 56) <= "00011000";
                tmp_graphic(55 downto 48) <= "01000100";
                tmp_graphic(47 downto 40) <= "01000100";
                tmp_graphic(39 downto 32) <= "00111100";
                tmp_graphic(31 downto 24) <= "00000100";
                tmp_graphic(23 downto 16) <= "00001000";
                tmp_graphic(15 downto 8)  <= "00110000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0111010" =>  --:
                tmp_graphic(63 downto 56) <= "00000000";
                tmp_graphic(55 downto 48) <= "00110000";
                tmp_graphic(47 downto 40) <= "00110000";
                tmp_graphic(39 downto 32) <= "00000000";
                tmp_graphic(31 downto 24) <= "00110000";
                tmp_graphic(23 downto 16) <= "00110000";
                tmp_graphic(15 downto 8)  <= "00000000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0111011" =>  --;
                tmp_graphic(63 downto 56) <= "00000000";
                tmp_graphic(55 downto 48) <= "00110000";
                tmp_graphic(47 downto 40) <= "00110000";
                tmp_graphic(39 downto 32) <= "00000000";
                tmp_graphic(31 downto 24) <= "00110000";
                tmp_graphic(23 downto 16) <= "00010000";
                tmp_graphic(15 downto 8)  <= "00100000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0111100" =>  --<
                tmp_graphic(63 downto 56) <= "00001000";
                tmp_graphic(55 downto 48) <= "00010000";
                tmp_graphic(47 downto 40) <= "00100000";
                tmp_graphic(39 downto 32) <= "01000000";
                tmp_graphic(31 downto 24) <= "00100000";
                tmp_graphic(23 downto 16) <= "00010000";
                tmp_graphic(15 downto 8)  <= "00001000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0111101" =>  --=
                tmp_graphic(63 downto 56) <= "00000000";
                tmp_graphic(55 downto 48) <= "00000000";
                tmp_graphic(47 downto 40) <= "01111100";
                tmp_graphic(39 downto 32) <= "00000000";
                tmp_graphic(31 downto 24) <= "01111100";
                tmp_graphic(23 downto 16) <= "00000000";
                tmp_graphic(15 downto 8)  <= "00000000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0111110" =>  -->
                tmp_graphic(63 downto 56) <= "01000000";
                tmp_graphic(55 downto 48) <= "00100000";
                tmp_graphic(47 downto 40) <= "00010000";
                tmp_graphic(39 downto 32) <= "00001000";
                tmp_graphic(31 downto 24) <= "00010000";
                tmp_graphic(23 downto 16) <= "00100000";
                tmp_graphic(15 downto 8)  <= "01000000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "0111111" =>  --?
                tmp_graphic(63 downto 56) <= "00111000";
                tmp_graphic(55 downto 48) <= "01000100";
                tmp_graphic(47 downto 40) <= "00000100";
                tmp_graphic(39 downto 32) <= "00001000";
                tmp_graphic(31 downto 24) <= "00010000";
                tmp_graphic(23 downto 16) <= "00000000";
                tmp_graphic(15 downto 8)  <= "00010000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "1000000" =>  --@
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
            when "1000010" => --B
                tmp_graphic(63 downto 56) <= "00111100";
                tmp_graphic(55 downto 48) <= "00100100";
                tmp_graphic(47 downto 40) <= "00100100";
                tmp_graphic(39 downto 32) <= "00111000";
                tmp_graphic(31 downto 24) <= "00100100";
                tmp_graphic(23 downto 16) <= "00100100";
                tmp_graphic(15 downto 8)  <= "00111000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "1000011" => --C
                tmp_graphic(63 downto 56) <= "00111000";
                tmp_graphic(55 downto 48) <= "01000100";
                tmp_graphic(47 downto 40) <= "01000000";
                tmp_graphic(39 downto 32) <= "01000000";
                tmp_graphic(31 downto 24) <= "01000000";
                tmp_graphic(23 downto 16) <= "01000100";
                tmp_graphic(15 downto 8)  <= "00111000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "1000100" => --D
                tmp_graphic(63 downto 56) <= "01111000";
                tmp_graphic(55 downto 48) <= "00100100";
                tmp_graphic(47 downto 40) <= "00100100";
                tmp_graphic(39 downto 32) <= "00100100";
                tmp_graphic(31 downto 24) <= "00100100";
                tmp_graphic(23 downto 16) <= "00100100";
                tmp_graphic(15 downto 8)  <= "01111000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "1000101" => --E
                tmp_graphic(63 downto 56) <= "01111100";
                tmp_graphic(55 downto 48) <= "01000000";
                tmp_graphic(47 downto 40) <= "01000000";
                tmp_graphic(39 downto 32) <= "01111100";
                tmp_graphic(31 downto 24) <= "01000000";
                tmp_graphic(23 downto 16) <= "01000000";
                tmp_graphic(15 downto 8)  <= "01111100";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "1000110" => --F
                tmp_graphic(63 downto 56) <= "01111100";
                tmp_graphic(55 downto 48) <= "01000000";
                tmp_graphic(47 downto 40) <= "01000000";
                tmp_graphic(39 downto 32) <= "01111000";
                tmp_graphic(31 downto 24) <= "01000000";
                tmp_graphic(23 downto 16) <= "01000000";
                tmp_graphic(15 downto 8)  <= "01000000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "1000111" => --G
                tmp_graphic(63 downto 56) <= "00111000";
                tmp_graphic(55 downto 48) <= "01000000";
                tmp_graphic(47 downto 40) <= "01000000";
                tmp_graphic(39 downto 32) <= "01001100";
                tmp_graphic(31 downto 24) <= "01000100";
                tmp_graphic(23 downto 16) <= "01000100";
                tmp_graphic(15 downto 8)  <= "00111100";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "1001000" => --H
                tmp_graphic(63 downto 56) <= "01000100";
                tmp_graphic(55 downto 48) <= "01000100";
                tmp_graphic(47 downto 40) <= "01000100";
                tmp_graphic(39 downto 32) <= "01111100";
                tmp_graphic(31 downto 24) <= "01000100";
                tmp_graphic(23 downto 16) <= "01000100";
                tmp_graphic(15 downto 8)  <= "01000100";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "1001001" => --I
                tmp_graphic(63 downto 56) <= "00111000";
                tmp_graphic(55 downto 48) <= "00010000";
                tmp_graphic(47 downto 40) <= "00010000";
                tmp_graphic(39 downto 32) <= "00010000";
                tmp_graphic(31 downto 24) <= "00010000";
                tmp_graphic(23 downto 16) <= "00010000";
                tmp_graphic(15 downto 8)  <= "00111000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when "1001010" => --J
                tmp_graphic(63 downto 56) <= "00011000";
                tmp_graphic(55 downto 48) <= "00001000";
                tmp_graphic(47 downto 40) <= "00001000";
                tmp_graphic(39 downto 32) <= "00001000";
                tmp_graphic(31 downto 24) <= "00001000";
                tmp_graphic(23 downto 16) <= "01001000";
                tmp_graphic(15 downto 8)  <= "00110000";
                tmp_graphic(7 downto 0)   <= "00000000";
            when others =>
                tmp_graphic(63 downto 0) <= (others => '0');
        end case;
    end process;
end Behavioral;

