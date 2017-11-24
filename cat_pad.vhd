----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:36:15 11/17/2017 
-- Design Name: 
-- Module Name:    cat_pad - Behavioral 
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

entity cat_pad is port(
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
    data_ready : in  STD_LOGIC
);
end cat_pad;

architecture Behavioral of cat_pad is

begin


end Behavioral;

