--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package io_components is
    component ram_module port(
        clk : in STD_LOGIC;
        ram_addr : in STD_LOGIC_VECTOR (15 downto 0);
        ram_data : in STD_LOGIC_VECTOR (15 downto 0);
        ram_res  : out STD_LOGIC_VECTOR (15 downto 0);
        ram_isRead : in STD_LOGIC;
        ram_isUsed : in STD_LOGIC;
        
        ram_addr_o : out  STD_LOGIC_VECTOR (17 downto 0);
        put_data_o : inout  STD_LOGIC_VECTOR (15 downto 0);
        ram_oe_o	  : out  STD_LOGIC;
        ram_rw_o   : out  STD_LOGIC;
        ram_en_o   : out  STD_LOGIC
    );
    end component;

    component uart_module port(
        clk : in STD_LOGIC;
        uart_isRead : in STD_LOGIC;
        uart_isUsed : in STD_LOGIC;
	    uart_res : out STD_LOGIC_VECTOR(15 downto 0);
        uart_data : in STD_LOGIC_VECTOR(15 downto 0);
        isData : in STD_LOGIC;

        put_data : inout STD_LOGIC_VECTOR (15 downto 0);
        rdn : out  STD_LOGIC;
        wrn : out  STD_LOGIC;
        tbre : in  STD_LOGIC;
        tsre : in  STD_LOGIC;
        data_ready : in  STD_LOGIC;
    	test_log : out STD_LOGIC_VECTOR(15 downto 0)
    );
    end component;

end io_components;
