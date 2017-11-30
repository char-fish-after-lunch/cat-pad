library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity test_driver_control is
end test_driver_control;

architecture Behavioral of test_driver_control is
    signal clk_in : std_logic;

    signal vgaAdd : std_logic;
    signal vgaDel : std_logic;

    signal ascii_in : std_logic_vector(6 downto 0);

    signal vgaWrite : std_logic;
    signal vgaAddr : std_logic_vector(17 downto 0);
    signal vgaData : std_logic_vector(15 downto 0);

    signal rst : std_logic;

    component driver_control is port(
        clk_in : in std_logic;
        
        vgaAdd : in std_logic;
        vgaDel : in std_logic;
    
        ascii_in : in std_logic_vector(6 downto 0);
    
        vgaWrite : out std_logic;
        vgaAddr : out std_logic_vector(17 downto 0);
        vgaData : out std_logic_vector(15 downto 0);
    
        rst : in std_logic
        );
    end component;

begin
    driver_control_0: driver_control port map(clk_in, vgaAdd, vgaDel,
        ascii_in, vgaWrite, vgaAddr, vgaData, rst);
         
    process 
        variable l : line;
    begin
        rst <= '1';
        clk_in <= '1';
        vgaAdd <= '0';
        vgaDel <= '0';
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        vgaDel <= '1';
        ascii_in <= "1000001";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        vgaAdd <= '0';
        ascii_in <= "1000001";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        vgaAdd <= '0';
        ascii_in <= "1000001";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        vgaAdd <= '0';
        ascii_in <= "1000001";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        vgaAdd <= '0';
        ascii_in <= "1000001";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        vgaAdd <= '0';
        ascii_in <= "1000001";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        vgaAdd <= '0';
        ascii_in <= "1000001";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        vgaAdd <= '0';
        ascii_in <= "1000001";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        vgaAdd <= '0';
        ascii_in <= "1000001";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        vgaAdd <= '0';
        ascii_in <= "1000001";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        vgaAdd <= '0';
        ascii_in <= "1000001";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        wait for 25 ps;
    end process;

end Behavioral;