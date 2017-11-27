library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity test_vga_control is
end test_vga_control;

architecture Behavioral of test_vga_control is
    signal clk_in : std_logic;
    signal rst : std_logic;

    signal out_red : std_logic_vector(2 downto 0);
    signal out_green : std_logic_vector(2 downto 0);
    signal out_blue : std_logic_vector(2 downto 0);

    signal hs : std_logic;
    signal vs : std_logic;
	 
	signal romAddr : std_logic_vector(17 downto 0);
	signal romData : std_logic_vector(15 downto 0);
    signal vgaRead : std_logic;
    signal vgaWrite : std_logic;
    
    signal ramWriAddrIn : std_logic_vector(17 downto 0); 
    signal ramWriDataIn : std_logic_vector(15 downto 0); 
    signal ramWriAddrOut : std_logic_vector(17 downto 0);
    signal ramWriDataOut : std_logic_vector(15 downto 0);

    signal ramWrite : std_logic;

    signal save : std_logic;

    component vga_test is port(
        clk_in : in std_logic;
        rst : in std_logic;
        ramWrite : in std_logic;

        out_red : out std_logic_vector(2 downto 0);
        out_green : out std_logic_vector(2 downto 0);
        out_blue : out std_logic_vector(2 downto 0);
		  
		romAddr : out std_logic_vector(17 downto 0);
        romData : in std_logic_vector(15 downto 0); --rgb that only 8 downto 0 is useful
        vgaRead : out std_logic;
        vgaWrite : out std_logic;

        ramWriAddrIn : in std_logic_vector(17 downto 0); 
        ramWriDataIn : in std_logic_vector(15 downto 0); 
        ramWriAddrOut : out std_logic_vector(17 downto 0);
        ramWriDataOut : out std_logic_vector(15 downto 0);

        save : out std_logic;

        hs : out std_logic;
        vs : out std_logic
        );
    end component;

begin
    vga_test_0: vga_test port map(clk_in, rst, ramWrite, out_red,
        out_green, out_blue, romAddr, romData, vgaRead, vgaWrite,
        ramWriAddrIn, ramWriDataIn, ramWriAddrOut, ramWriDataOut, save, 
        hs, vs);
         
    process 
        variable l : line;
    begin
        rst <= '1';
        clk_in <= '1';
        ramWrite <= '0';
        romData <= "0001000100010001";
        ramWriAddrIn <= "101011000110101011";
        ramWriDataIn <= "1001010011010101";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        romData <= "0001000100010001";
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        ramWrite <= '0';
        romData <= "0001000100010001";
        ramWriAddrIn <= "101011000110101011";
        ramWriDataIn <= "1001010011010101";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        romData <= "0001000100010001";
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        ramWrite <= '1';
        romData <= "0001000100010001";
        ramWriAddrIn <= "101011000110101011";
        ramWriDataIn <= "1001010011010101";
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        romData <= "0001000100010001";
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        romData <= "0001000100010001";
        ramWriAddrIn <= "101011000010101011";
        ramWriDataIn <= "1001010101010101";
        ramWrite <= '1';
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        romData <= "0001000100010001";
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        romData <= "0001000100010001";
        ramWriAddrIn <= "101011000100001011";
        ramWriDataIn <= "1001001011010101";
        ramWrite <= '0';
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        romData <= "0001000100010001";
        wait for 25 ps;

        rst <= '1';
        clk_in <= '1';
        romData <= "0001000100010001";
        ramWriAddrIn <= "100001110110101011";
        ramWriDataIn <= "1001001011010101";
        ramWrite <= '1';
        wait for 25 ps;
        rst <= '1';
        clk_in <= '0';
        romData <= "0001000100010001";
        wait for 25 ps;

    end process;

end Behavioral;