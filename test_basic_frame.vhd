library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.ALL;


entity test_basic_frame is
end test_basic_frame;

architecture Behavioral of test_basic_frame is
    signal
        rst: std_logic;
    signal
        clk: std_logic;
    signal
        manual_clk : STD_LOGIC;
        
    signal
        input : STD_LOGIC_VECTOR (15 downto 0);
    signal
        leds :  STD_LOGIC_VECTOR (15 downto 0);

        -- ram related 
    signal
        ram1addr : STD_LOGIC_VECTOR (17 downto 0);
    signal
        ram1data : STD_LOGIC_VECTOR (15 downto 0);
    signal
        ram1oe : STD_LOGIC;
    signal
        ram1rw : STD_LOGIC;
    signal
        ram1en : STD_LOGIC;
    signal
        ram2addr : STD_LOGIC_VECTOR (17 downto 0);
    signal
        ram2data : STD_LOGIC_VECTOR (15 downto 0);
    signal
        ram2oe : STD_LOGIC;
    signal
        ram2rw : STD_LOGIC;
    signal
        ram2en : STD_LOGIC;
    signal
        disp1 : STD_LOGIC_VECTOR (6 downto 0);
    signal
        disp2 : STD_LOGIC_VECTOR (6 downto 0);

        -- IO related
    signal
        rdn : STD_LOGIC;
    signal
        wrn : STD_LOGIC;
    signal
        tbre : STD_LOGIC;
    signal
        tsre : STD_LOGIC;
    signal
        data_ready : STD_LOGIC;
        
    signal
        test_ALUres :  STD_LOGIC_VECTOR (15 downto 0);
    signal
        test_regSrcA :  STD_LOGIC_VECTOR (3 downto 0);
    signal
        test_regSrcB :  STD_LOGIC_VECTOR (3 downto 0);
    signal
        test_regA :  STD_LOGIC_VECTOR (15 downto 0);
    signal
		  test_regB :  STD_LOGIC_VECTOR (15 downto 0);

	component cat_pad is port(
		
        rst: in std_logic;
        clk: in std_logic;
        manual_clk : in STD_LOGIC;
        
        input : in  STD_LOGIC_VECTOR (15 downto 0);
        leds : out  STD_LOGIC_VECTOR (15 downto 0);

        -- ram related 
        ram1addr : out  STD_LOGIC_VECTOR (17 downto 0);
        ram1data : inout  STD_LOGIC_VECTOR (15 downto 0);
        ram1oe : out  STD_LOGIC;
        ram1rw : out  STD_LOGIC;
        ram1en : out  STD_LOGIC;
        ram2addr : out  STD_LOGIC_VECTOR (17 downto 0);
        ram2data : inout  STD_LOGIC_VECTOR (15 downto 0);
        ram2oe : out  STD_LOGIC;
        ram2rw : out  STD_LOGIC;
        ram2en : out  STD_LOGIC;
        disp1 : out  STD_LOGIC_VECTOR (6 downto 0);
        disp2 : out  STD_LOGIC_VECTOR (6 downto 0);

        -- IO related
        rdn : out  STD_LOGIC;
        wrn : out  STD_LOGIC;
        tbre : in  STD_LOGIC;
        tsre : in  STD_LOGIC;
        data_ready : in  STD_LOGIC;
        test_ALUres : out  STD_LOGIC_VECTOR (15 downto 0);
        test_regSrcA : out  STD_LOGIC_VECTOR (3 downto 0);
        test_regSrcB : out  STD_LOGIC_VECTOR (3 downto 0);
        test_regA : out  STD_LOGIC_VECTOR (15 downto 0);
        test_regB : out  STD_LOGIC_VECTOR (15 downto 0)
	);
	end component;	
begin
	u_cat_pad: cat_pad port map(rst, clk, manual_clk, input, leds, ram1addr, ram1data, ram1oe, ram1rw, ram1en, ram2addr, ram2data,
        ram2oe, ram2rw, ram2en, disp1, disp2, rdn, wrn, tbre, tsre, data_ready, test_ALUres, test_regSrcA, test_regSrcB, test_regA, test_regB);

	process
	begin
		clk <= '1';
        wait for 1 ns;
        clk <= '0';
        wait for 1 ns;
	end process;
end Behavioral;

