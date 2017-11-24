library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.ALL;


entity test_forward_unit is
end test_forward_unit;

architecture Behavioral of test_forward_unit is
    signal regReadSrcA : std_logic_vector(3 downto 0);
    signal regReadSrcB : std_logic_vector(3 downto 0);
    signal memDst 	   : std_logic_vector(3 downto 0);
    signal wbDst 	   : std_logic_vector(3 downto 0);
    signal ramRead	   : std_logic;
    signal oprSrcB	   : std_logic;

    signal srcA        : std_logic_vector(1 downto 0);
    signal srcB        : std_logic_vector(1 downto 0);

    component forward_unit is port(
            regReadSrcA : in std_logic_vector(3 downto 0);
            regReadSrcB : in std_logic_vector(3 downto 0);
            memDst 		: in std_logic_vector(3 downto 0);
            wbDst 		: in std_logic_vector(3 downto 0);
            ramRead		: in std_logic;
            oprSrcB		: in std_logic;

            srcA	: out std_logic_vector(1 downto 0);
            srcB	: out std_logic_vector(1 downto 0)
        );
    end component;

begin
    forward_unit_0: forward_unit port map(regReadSrcA, regReadSrcB,
        memDst, wbDst, ramRead, oprSrcB, srcA, srcB);

    process
        variable l : line;
    begin
        regReadSrcA <= "0010";
        regReadSrcB <= "0011";
        memDst <= "0011";
        wbDst <= "0010";
        ramRead <= '0';
        oprSrcB <= '0';

        wait for 2 ns;

        regReadSrcA <= "0010";
        regReadSrcB <= "0011";
        memDst <= "0010";
        wbDst <= "0011";
        ramRead <= '0';
        oprSrcB <= '0';

        wait for 2 ns;
        
        regReadSrcA <= "0010";
        regReadSrcB <= "0011";
        memDst <= "0011";
        wbDst <= "0011";
        ramRead <= '0';
        oprSrcB <= '0';

        wait for 2 ns;
        
        regReadSrcA <= "0010";
        regReadSrcB <= "0011";
        memDst <= "0011";
        wbDst <= "0011";
        ramRead <= '1';
        oprSrcB <= '0';

        wait for 2 ns;
        
        regReadSrcA <= "0010";
        regReadSrcB <= "0000";
        memDst <= "0010";
        wbDst <= "0000";
        ramRead <= '0';
        oprSrcB <= '1';

        wait;
        
    end process;
end Behavioral;

