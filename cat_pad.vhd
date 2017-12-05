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
use IEEE.NUMERIC_STD.ALL;
use work.components.ALL;
use work.consts.ALL;

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
    clk_11m : in std_logic;
    
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
	 
	 
	 -- PS/2
	 
	 ps2_data: in std_logic;
	 ps2_clk: in std_logic;
    
    flashByte : out std_logic;
    flashVpen : out std_logic;
    flashCE : out std_logic;
    flashOE : out std_logic;
    flashWE : out std_logic;
    flashRP : out std_logic;
    flash_addr : out std_logic_vector(22 downto 1);
    flash_data : inout std_logic_vector(15 downto 0);


    test_ALUres : out  STD_LOGIC_VECTOR (15 downto 0);
    test_regSrcA : out  STD_LOGIC_VECTOR (3 downto 0);
    test_regSrcB : out  STD_LOGIC_VECTOR (3 downto 0);
    test_regA : out  STD_LOGIC_VECTOR (15 downto 0);
    test_regB : out  STD_LOGIC_VECTOR (15 downto 0);

    vga_red : out std_logic_vector(2 downto 0);
    vga_green : out std_logic_vector(2 downto 0);
    vga_blue : out std_logic_vector(2 downto 0);

    vga_hs : out std_logic;
    vga_vs : out std_logic
);
end cat_pad;

architecture Behavioral of cat_pad is
	signal isBootloaded : std_logic := '0';

	signal s_pc_inc : std_logic;
	signal s_next_pc_in : std_logic_vector(15 downto 0);
	signal s_next_pc_o : std_logic_vector(15 downto 0);
	signal s_pc_pause : std_logic;
	signal s_next_pc_out : std_logic_vector(15 downto 0);
	signal s_pc_out : std_logic_vector(15 downto 0);
    signal s_instr : std_logic_vector(15 downto 0);
    signal s_raw_instr : std_logic_vector(15 downto 0);

    signal s_int_if : std_logic;
    signal s_intCode_if : std_logic_vector(3 downto 0);
    
    signal s_int_id : std_logic;
    signal s_intCode_id : std_logic_vector(3 downto 0);

    signal s_IFPC_o : std_logic_vector(15 downto 0);
    signal s_inst_o : std_logic_vector(15 downto 0);
    signal s_regSrcA : std_logic_vector(3 downto 0);
	signal s_regSrcB : std_logic_vector(3 downto 0);
	signal s_immeCtrl :	std_logic_vector(2 downto 0);
	signal s_dstSrc	: std_logic_vector(3 downto 0);
	signal s_immeExt : std_logic;
	signal s_oprSrcB : std_logic;
	signal s_ALUop : std_logic_vector(3 downto 0);
	signal s_isBranch : std_logic;
	signal s_isCond	: std_logic;
	signal s_isRelative	: std_logic;
	signal s_isMFPC : std_logic;
	signal s_ramWrite : std_logic;
	signal s_ramRead : std_logic;
	signal s_wbSrc : std_logic;
    signal s_wbEN : std_logic;
    signal s_isINT  : std_logic;
    signal s_isERET  : std_logic;
	signal s_isMFEPC : std_logic;
	signal s_isMTEPC : std_logic;
	signal s_isMFCS : std_logic;
    
    signal s_regAN : std_logic_vector(3 downto 0);
    signal s_regBN : std_logic_vector(3 downto 0);
    signal s_immediate : std_logic_vector(15 downto 0);

    signal s_writeSrc 	: std_logic_vector(3 downto 0);
    signal s_writeData 	: std_logic_vector(15 downto 0);
    signal s_writeEN	: std_logic;

    signal s_regA : std_logic_vector(15 downto 0);
    signal s_regB : std_logic_vector(15 downto 0);
    
    signal s_regA_o : std_logic_vector(15 downto 0);
    signal s_regB_o : std_logic_vector(15 downto 0);
    signal s_regAN_o : std_logic_vector(3 downto 0);
    signal s_regBN_o : std_logic_vector(3 downto 0);
    signal s_immediate_o : std_logic_vector(15 downto 0);
    signal s_IDPC_o : std_logic_vector(15 downto 0);
    signal s_regSrcA_exe : std_logic_vector(3 downto 0);
	signal s_regSrcB_exe : std_logic_vector(3 downto 0);
	signal s_immeCtrl_exe :	std_logic_vector(2 downto 0);
	signal s_dstSrc_exe	: std_logic_vector(3 downto 0);
	signal s_immeExt_exe : std_logic;
	signal s_oprSrcB_exe : std_logic;
	signal s_ALUop_exe : std_logic_vector(3 downto 0);
	signal s_isBranch_exe : std_logic;
	signal s_isCond_exe	: std_logic;
	signal s_isRelative_exe	: std_logic;
    signal s_isMFPC_exe : std_logic;
	signal s_ramWrite_exe : std_logic;
	signal s_ramRead_exe : std_logic;
	signal s_wbSrc_exe : std_logic;
	signal s_wbEN_exe : std_logic;
	signal s_isMFEPC_exe : std_logic;
	signal s_isMTEPC_exe : std_logic;
	signal s_isMFCS_exe : std_logic;
	signal s_id_keep: std_logic;
    signal s_id_clear: std_logic;
	signal s_epcSrc_exe: std_logic_vector(1 downto 0);
	signal s_isINT_exe : std_logic;
    
    signal s_int_exe    : std_logic;
    signal s_intCode_exe    : std_logic_vector(3 downto 0);

    signal s_post_int_exe   : std_logic;
    signal s_post_intCode_exe   : std_logic_vector(3 downto 0);

	signal s_bubble_id	: std_logic;
	signal s_bubble_exe	: std_logic;
	signal s_bubble_mem	: std_logic;
	signal s_bubble_wb	: std_logic;

    -- exe 
	signal s_exe_clear: std_logic;
    signal s_ALUres		: std_logic_vector(15 downto 0);
    signal s_ALU_oprA 	: std_logic_vector(15 downto 0);
    signal s_ALU_oprB 	: std_logic_vector(15 downto 0);
    signal s_shifted_PC	: std_logic_vector(15 downto 0);
    signal s_B_ALU_res	: std_logic_vector(15 downto 0);
    signal s_fwdSrcA	: std_logic_vector(1 downto 0);
    signal s_fwdSrcB	: std_logic_vector(1 downto 0);

    signal s_regA_fwd 	: std_logic_vector(3 downto 0);
    signal s_regB_fwd 	: std_logic_vector(3 downto 0);
    signal s_regB_o_exe : std_logic_vector(15 downto 0);
	signal s_isMTEPC_mem : std_logic;
    signal s_ALUres_o 	: std_logic_vector(15 downto 0);
    signal s_EXEPC		: std_logic_vector(15 downto 0);
	signal s_isERET_exe	: std_logic;

	signal s_willBranch	: std_logic;

    signal s_dstSrc_mem		: std_logic_vector(3 downto 0);
	signal s_ramWrite_mem	: std_logic;
	signal s_ramRead_mem	: std_logic;
	signal s_wbSrc_mem		: std_logic;
	signal s_wbEN_mem		: std_logic;
	signal s_isERET_mem	: std_logic;
	
	signal s_regB_mem 		: std_logic_vector(15 downto 0);
	signal s_ALUres_mem 	: std_logic_vector(15 downto 0);
    signal s_int_mem    : std_logic;
    signal s_intCode_mem    : std_logic_vector(3 downto 0);
    signal s_post_int_mem   : std_logic;
    signal s_post_intCode_mem   : std_logic_vector(3 downto 0);
    signal s_mem_clear      : std_logic;
    
	-- ram interactor
    signal s_if_ram_addr    : std_logic_vector(15 downto 0);
    signal s_mem_ram_addr   : std_logic_vector(15 downto 0);
    signal s_mem_ram_data   : std_logic_vector(15 downto 0);
    signal s_res_data       : std_logic_vector(15 downto 0);
    signal s_if_res_data    : std_logic_vector(15 downto 0);
    signal s_ramWrite_ram	: std_logic;
    signal s_ramRead_ram	: std_logic;
    signal s_wb_clear       : std_logic;

    signal s_ram_data : std_logic_vector(15 downto 0);

    signal s_PC_mem : std_logic_vector(15 downto 0);

    -- mem/wb
	signal s_isMTEPC_wb : std_logic;
    signal s_dstSrc_wb	: std_logic_vector(3 downto 0);
    signal s_wbSrc_wb	: std_logic;
    signal s_wbEN_wb	: std_logic;
    signal s_ramData_wb	: std_logic_vector(15 downto 0);
    signal s_ALUres_wb	: std_logic_vector(15 downto 0);

	signal s_isERET_wb	: std_logic;
    signal s_int_wb    : std_logic;
    signal s_intCode_wb    : std_logic_vector(3 downto 0);
    signal s_post_int_wb    : std_logic;
    signal s_post_intCode_wb    : std_logic_vector(3 downto 0);
	signal s_PC_wb			: std_logic_vector(15 downto 0);
	-- stall unit
	signal s_stall_set_pc	: std_logic;
	signal s_stall_set_pc_val	: std_logic_vector(15 downto 0);

	signal real_clk : std_logic := '0';

    signal wrn_bootloader : std_logic;
    signal rdn_bootloader : std_logic;
     
    signal ram1addr_bootloader : STD_LOGIC_VECTOR (17 downto 0);
    signal ram1oe_bootloader : STD_LOGIC;
    signal ram1rw_bootloader : STD_LOGIC;
    signal ram1en_bootloader : STD_LOGIC;

    
    signal wrn_pad : std_logic;
    signal rdn_pad : std_logic;
     
    signal ram1addr_pad : STD_LOGIC_VECTOR (17 downto 0);
    signal ram1oe_pad : STD_LOGIC;
    signal ram1rw_pad : STD_LOGIC;
    signal ram1en_pad : STD_LOGIC;
	 
	 signal 
		res_log : STD_LOGIC_VECTOR (15 downto 0);

	 signal 
		bootloader_state : STD_LOGIC_VECTOR (6 downto 0);

    signal
		test_reg_out_1 : std_logic_vector(15 downto 0);
    signal
		test_reg_out_2 : std_logic_vector(15 downto 0);
    signal
		s_test_log : std_logic_vector(15 downto 0);

    signal s_hasConflict : std_logic;
	 
    signal s_ram2oe : STD_LOGIC;
    signal s_ram2rw : STD_LOGIC;
    signal s_ram2en : STD_LOGIC;


    --- cp0 (aka interrupt control)
    signal s_cp0_cause_update : std_logic_vector(15 downto 0);
    signal s_cp0_epc_update : std_logic_vector(15 downto 0);
    signal s_cp0_status_update : std_logic;
    signal s_cp0_trap_update : std_logic;
    signal s_cp0_eret_update : std_logic;

    signal s_cp0_cause : std_logic_vector(15 downto 0);
    signal s_cp0_epc: std_logic_vector(15 downto 0);
    signal s_cp0_status: std_logic;
    signal s_cp0_trap: std_logic;
    signal s_cp0_eret: std_logic;

    signal s_ram_lock_mem : std_logic;
    signal s_pipeline_clear : std_logic;

    signal s_cp0_set_pc : std_logic;
    signal s_cp0_set_pc_val : std_logic_vector(15 downto 0);

    signal s_stall_id_clear: std_logic;
    signal s_stall_id_keep: std_logic;
    signal s_stall_exe_clear: std_logic;
	 
	 
	 --- PS/2
	 signal s_ps2_request: std_logic;
	 signal s_ps2_data_o: std_logic_vector(7 downto 0);


     
    signal s_vga_red : std_logic_vector(2 downto 0);
    signal s_vga_green : std_logic_vector(2 downto 0);
    signal s_vga_blue : std_logic_vector(2 downto 0);

    signal s_vga_hs : std_logic;
    signal s_vga_vs : std_logic;
begin

	u_bootloader : bootloader port map(
        clk => clk,
        isBootloaded => isBootloaded,
        flashByte => flashByte,
        flashVpen => flashVpen,
        flashCE => flashCE,
        flashOE => flashOE,
        flashWE => flashWE,
        flashRP => flashRP,
        flash_addr => flash_addr,
        flash_data => flash_data,
        ram1addr => ram1addr_bootloader,
        ram1data => ram1data,
        ram1oe => ram1oe_bootloader,
        ram1en => ram1en_bootloader,
        ram1rw => ram1rw_bootloader,
        wrn => wrn_bootloader,
        rdn => rdn_bootloader,
        isBootloaded_o => isBootloaded,
		  bootloader_state => bootloader_state,
		  res_log => res_log
    ); 
	 
	 process(clk, clk_11m, isBootloaded, wrn_pad, rdn_pad, ram1en_pad, ram1oe_pad, ram1rw_pad, wrn_bootloader,
        rdn_bootloader, ram1en_bootloader, ram1oe_bootloader, ram1rw_bootloader, ram1addr_bootloader, ram1addr_pad, s_hasConflict,
		   s_ALUres, bootloader_state, s_mem_ram_addr, s_dstSrc_mem, s_ramData_wb, s_wbSrc_mem, s_regB_mem, s_wbEN_mem,
           s_vga_vs, s_vga_hs, s_vga_blue, input, s_vga_red, s_vga_green, s_pc_out)
        variable tmp1 : std_logic := '0';
        variable tmp2 : std_logic := '0';
        variable tmp3 : std_logic := '0';
        variable tmp4 : std_logic := '0';
        variable tmp5 : std_logic := '0';
        variable tmp6 : std_logic := '0';
        variable tmp7 : std_logic := '0';
        variable tmp8 : std_logic := '0';
		  variable ps2_counter : std_logic_vector(7 downto 0) := "00000000";
	 begin
		-- if not bootloaded, all clock is blocked
		if(rising_edge(ps2_clk)) then
			ps2_counter := std_logic_vector(to_unsigned(to_integer(unsigned(ps2_counter)) + 1, 8));
		end if;
		if (isBootloaded = '1') then
            if (input = "1111111111111111") then
                real_clk <= manual_clk;
            else 
	    		real_clk <= clk_11m;
            end if;
            wrn <= wrn_pad;
            rdn <= rdn_pad;
            ram1addr <= ram1addr_pad;
            ram1en <= ram1en_pad;
            ram1oe <= ram1oe_pad;
            ram1rw <= ram1rw_pad;
            -- leds <= tmp1 & tmp2 & tmp3 & ps2_data & ps2_clk & s_ps2_request & s_cp0_set_pc & s_cp0_status & ps2_counter;
            leds <= s_vga_red & s_vga_green & s_vga_blue & s_vga_hs & s_vga_vs & "00000";
				--leds <= test_reg_out_1;
			disp2 <= s_dstSrc_mem(3 downto 0) & s_wbEN_mem & s_wbSrc_mem & s_ramWrite_ram;
            -- signals connect to real CPU
		else 
			real_clk <= '0';
            wrn <= wrn_bootloader;
            rdn <= rdn_bootloader;
            ram1addr <= ram1addr_bootloader;
            ram1en <= ram1en_bootloader;
            ram1oe <= ram1oe_bootloader;
            ram1rw <= ram1rw_bootloader;
            
			disp2 <= bootloader_state;
			leds <= "0101010101010101";
		end if;
	 end process;

     ram2en <= s_ram2en;
     ram2oe <= s_ram2oe;
     ram2rw <= s_ram2rw;
     
    u_pc_controller : pc_controller port map(clk => real_clk, next_pc_in => s_next_pc_in, next_pc_out => s_next_pc_out, pc_out => s_pc_out,
											pc_pause => s_pc_pause);
    
    u_inst_fetch : inst_fetch port map(pc => s_pc_out, instr => s_raw_instr, if_addr => s_if_ram_addr, if_data => s_if_res_data,
        int_o => s_int_if, intCode_o => s_intCode_if);

    u_if_id : if_id port map(clk => real_clk, IFPC => s_next_pc_out, inst => s_instr, IFPC_o => s_IFPC_o, inst_o => s_inst_o, keep => s_id_keep,
							clear => s_id_clear, int => s_int_if, intCode => s_intCode_if, int_o => s_int_id, intCode_o => s_intCode_id,
						bubble_o => s_bubble_id);

    u_control : control port map(inst => s_inst_o, regSrcA => s_regSrcA, regSrcB => s_regSrcB, immeCtrl => s_immeCtrl, dstSrc => s_dstSrc,
        immeExt => s_immeExt, oprSrcB => s_oprSrcB, ALUop => s_ALUop, isBranch => s_isBranch, isCond => s_isCond, isRelative => s_isRelative,
		isMFPC => s_isMFPC, ramWrite => s_ramWrite, ramRead => s_ramRead, wbSrc => s_wbSrc, wbEN => s_wbEN, isINT => s_isINT, isERET => s_isERET,
		isMFEPC => s_isMFEPC, 
		isMTEPC => s_isMTEPC,
		isMFCS => s_isMFCS
	);

    u_inst_decode : inst_decode port map(inst => s_inst_o, regSrcA => s_regSrcA, regSrcB => s_regSrcB, immeCtrl => s_immeCtrl,
        immeExt => s_immeExt, regAN => s_regAN, regBN => s_regBN, immediate => s_immediate);
		
    u_registers : registers port map(clk => real_clk, regSrcA => s_regSrcA, regSrcB => s_regSrcB, writeSrc => s_writeSrc, 
        writeData => s_writeData, writeEN => s_writeEN, regA => s_regA, regB => s_regB, test_reg_out_1 => test_reg_out_1,
         test_reg_out_2 => test_reg_out_2);
    
    u_id_exe : id_exe port map(clk => real_clk, regA => s_regA, regB => s_regB, regAN => s_regAN, regBN => s_regBN, immediate => s_immediate,
        IDPC => s_IFPC_o, dstSrc => s_dstSrc, immeExt => s_immeExt, oprSrcB => s_oprSrcB, ALUop => s_ALUop, isBranch => s_isBranch, 
        isCond => s_isCond, isRelative => s_isRelative, isMFPC => s_isMFPC, ramWrite => s_ramWrite, ramRead => s_ramRead, wbSrc => s_wbSrc,
        wbEN => s_wbEN, regA_o => s_regA_o, regB_o => s_regB_o, regAN_o => s_regAN_o, regBN_o => s_regBN_o, immediate_o => s_immediate_o,
        IDPC_o => s_IDPC_o, dstSrc_o => s_dstSrc_exe, immeExt_o => s_immeExt_exe, oprSrcB_o => s_oprSrcB_exe, ALUop_o => s_ALUop_exe,
        isBranch_o => s_isBranch_exe, isCond_o => s_isCond_exe, isRelative_o => s_isRelative_exe, isMFPC_o => s_isMFPC_exe,
        ramWrite_o => s_ramWrite_exe, ramRead_o => s_ramRead_exe, wbSrc_o => s_wbSrc_exe, wbEN_o => s_wbEN_exe, clear => s_exe_clear,
        isINT => s_isINT, int => s_int_id, intCode => s_intCode_id, int_o => s_int_exe, intCode_o => s_intCode_exe,
		isINT_o => s_isINT_exe,
		isERET => s_isERET,
		isERET_o => s_isERET_exe,
		bubble => s_bubble_id,
		bubble_o => s_bubble_exe,

		isMFEPC => s_isMFEPC,
		isMTEPC => s_isMTEPC,
		isMFCS => s_isMFCS,

		isMFEPC_o => s_isMFEPC_exe,
		isMTEPC_o => s_isMTEPC_exe,
		isMFCS_o => s_isMFCS_exe
	);

    
    u_execution : execution port map(regA => s_regA_o, regB => s_regB_o, regAN => s_regAN_o, regBN => s_regBN_o, immediate => s_immediate_o,
        PC => s_IDPC_o, oprSrcB => s_oprSrcB_exe, ALUres => s_ALUres, isMFPC => s_isMFPC_exe, ALU_oprA => s_ALU_oprA, ALU_oprB => s_ALU_oprB,
        shifted_PC => s_shifted_PC, B_ALU_res => s_B_ALU_res, fwdSrcA => s_fwdSrcA, fwdSrcB => s_fwdSrcB, mem_aluRes => s_ALUres_mem,
        wb_ramRes => s_ramData_wb, wb_aluRes => s_ALUres_wb, regA_fwd => s_regA_fwd, regB_fwd => s_regB_fwd, regB_o => s_regB_o_exe, 
        ALUres_o => s_ALUres_o, out_PC => s_EXEPC, isINT => s_isINT_exe, int => s_int_exe, intCode => s_intCode_exe,
        int_o => s_post_int_exe, intCode_o => s_post_intCode_exe,
		isMFEPC => s_isMFEPC_exe,
		isMFCS => s_isMFCS_exe,
		cp0Epc => s_cp0_epc,
		cp0EpcSrc => s_epcSrc_exe,
		cp0Cause => s_cp0_cause	
	);
		
	 u_alu : alu port map(regA => s_ALU_oprA, regB => s_ALU_oprB, ALUop => s_ALUop_exe, ALUres => s_ALUres);

    u_branch_judger : branch_judger port map(next_PC => s_next_pc_out, ALUres => s_B_ALU_res, shifted_PC => s_shifted_PC, 
        isBranch => s_isBranch_exe, isCond => s_isCond_exe, isRelative => s_isRelative_exe, next_PC_o => s_next_pc_o, willBranch => s_willBranch);

    u_ex_mem : ex_mem port map(clk => real_clk, dstSrc => s_dstSrc_exe, ramWrite => s_ramWrite_exe, ramRead => s_ramRead_exe,
        wbSrc => s_wbSrc_exe, wbEN => s_wbEN_exe, regB => s_regB_o_exe, ALUres => s_ALUres_o, dstSrc_o => s_dstSrc_mem,
        ramWrite_o => s_ramWrite_mem, ramRead_o => s_ramRead_mem, wbSrc_o => s_wbSrc_mem, wbEN_o => s_wbEN_mem,
        regB_o => s_regB_mem, ALUres_o => s_ALUres_mem, int => s_post_int_exe, intCode => s_post_intCode_exe,
        int_o => s_int_mem,
        intCode_o => s_intCode_mem,
		isERET => s_isERET_exe,
		isERET_o => s_isERET_mem,
        PC => s_IDPC_o,
        PC_o => s_PC_mem,
		clear => s_mem_clear,
		bubble => s_bubble_exe,
		bubble_o => s_bubble_mem,

		isMTEPC => s_isMTEPC_exe,
		isMTEPC_o => s_isMTEPC_mem
	);

    u_mem_access : mem_access port map(ram_addr => s_ALUres_mem, ram_data_in => s_regB_mem, ramWrite => s_ramWrite_mem,
        ramRead => s_ramRead_mem, ramWrite_o => s_ramWrite_ram, ramRead_o => s_ramRead_ram, ram_data_o => s_mem_ram_data,
        ram_addr_o => s_mem_ram_addr, ram_return => s_res_data, ram_return_o => s_ram_data,
        int => s_int_mem, intCode => s_intCode_mem,
        int_o => s_post_int_mem, intcode_o => s_post_intCode_mem,
		ramLock => s_ram_lock_mem);
		
    u_mem_wb : mem_wb port map(clk => real_clk, dstSrc => s_dstSrc_mem, wbSrc => s_wbSrc_mem, wbEN => s_wbEN_mem,
        ramData => s_ram_data, ALUres => s_ALUres_mem, dstSrc_o => s_dstSrc_wb, wbSrc_o => s_wbSrc_wb, wbEN_o => s_wbEN_wb,
        ramData_o => s_ramData_wb, ALUres_o => s_ALUres_wb,
		isERET => s_isERET_mem,
		isERET_o => s_isERET_wb,
        int => s_post_int_mem,
        intCode => s_post_intCode_mem,
        int_o => s_int_wb, 
        intCode_o => s_intCode_wb,
		clear => s_wb_clear,
		bubble => s_bubble_mem,
		bubble_o => s_bubble_wb,
		PC => s_PC_mem,
		PC_o => s_PC_wb,

		isMTEPC => s_isMTEPC_mem,
		isMTEPC_o => s_isMTEPC_wb
	);
		
    u_ram_interactor: ram_interactor port map(clk => real_clk, clk_11m => real_clk, clk_50m => clk,
        if_ram_addr => s_if_ram_addr, mem_ram_addr => s_mem_ram_addr,
        mem_ram_data => s_mem_ram_data, ramWrite => s_ramWrite_ram, ramRead => s_ramRead_ram, res_data => s_res_data,
        if_res_data => s_if_res_data, ram1data => ram1data, ram1addr => ram1addr_pad, ram1oe => ram1oe_pad, ram1rw => ram1rw_pad, ram1en => ram1en_pad,
        ram2data => ram2data, ram2addr => ram2addr, ram2oe => s_ram2oe, ram2rw => s_ram2rw, ram2en => s_ram2en, rdn => rdn_pad, wrn => wrn_pad, 
        tbre => tbre, tsre => tsre, data_ready => data_ready, hasConflict => s_hasConflict, test_log => s_test_log,
        vga_blue => s_vga_blue, vga_green => s_vga_green, vga_red => s_vga_red, vga_hs => s_vga_hs, vga_vs => s_vga_vs,
		ps2_data => s_ps2_data_o, isBootloaded => isBootloaded);
    
    vga_red <= s_vga_red;
    vga_blue <= s_vga_blue;
    vga_green <= s_vga_green;
    vga_hs <= s_vga_hs;
    vga_vs <= s_vga_vs;


    
    u_write_back : write_back port map(dstSrc => s_dstSrc_wb, wbSrc => s_wbSrc_wb, wbEN => s_wbEN_wb, ramData => s_ramData_wb,
        ALUres => s_ALUres_wb, writeData => s_writeData, writeDst => s_writeSrc, isWriting => s_writeEN, 
		int => s_int_wb,
		intCode => s_intCode_wb,
		int_o => s_post_int_wb,
		intCode_o => s_post_intCode_wb);

    u_forward_unit : forward_unit port map(regReadSrcA => s_regA_fwd, regReadSrcB => s_regB_fwd, memDst => s_dstSrc_mem,
        wbDst => s_dstSrc_wb, ramRead => s_ramRead_mem, oprSrcB => s_oprSrcB_exe, srcA => s_fwdSrcA, srcB => s_fwdSrcB,
        wbSrc => s_wbSrc_wb, wbEN => s_wbEN_wb, memWbEN => s_wbEN_mem,
		memIsMTEPC => s_isMTEPC_mem,
		wbIsMTEPC => s_isMTEPC_wb,
		epcSrc => s_epcSrc_exe
	);

	u_stall_unit : stall_unit port map(
					clk => real_clk,
					exeWbEN => s_wbEN_exe,
					exeDstSrc => s_dstSrc_exe,
					exeRamRead => s_ramRead_exe,
					idRegSrcA => s_regAN,
					idRegSrcB => s_regBN,
					exeBranchJudge => s_willBranch,
					exeBranchTo => s_next_pc_o,
					pcPause => s_pc_pause,
					idKeep => s_stall_id_keep,
					idClear => s_stall_id_clear,
					exeClear => s_stall_exe_clear,
					pcInc => s_pc_inc,
					ifAddr => s_pc_out,
					setPC => s_stall_set_pc,
					setPCVal => s_stall_set_pc_val,
					ramConflict => s_hasConflict
				);

	u_instruction_forward_unit : instruction_forward_unit port map(
					idRamWrite => s_ramWrite,
					idRegA => s_regA,
					idRegB => s_regB,
					idImme => s_immediate,
					exeRamWrite => s_ramWrite_exe,
					exeAluRes => s_ALUres,
					exeRegB => s_regB_o_exe,
					address => s_pc_out,
					originalInstr => s_raw_instr,
					instr => s_instr 
                );
    
    u_cp0_registers : cp0_registers port map(
        clk => real_clk,
        causeIn => s_cp0_cause_update,
        epcIn => s_cp0_epc_update,
        statusIn => s_cp0_status_update,
        trapIn => s_cp0_trap_update,
        eretIn => s_cp0_eret_update,
        cause => s_cp0_cause,
        epc => s_cp0_epc,
        status => s_cp0_status,
        trap => s_cp0_trap,
        eret => s_cp0_eret
    );

    u_interrupt_control : interrupt_control port map(
        wbInt => s_int_wb,
        wbIntCode => s_intCode_wb,
        wbERet => s_isERET_wb,
		wbIsMTEPC => s_isMTEPC_wb,
		wbALUres => s_ALUres_wb,
        memPC => s_PC_mem, -- it seems that this is the shifted PC
		exePC => s_IDPC_o,
		idPC => s_IFPC_o,
		ifPC => s_pc_out,
        cp0Status => s_cp0_status,
        cp0Epc => s_cp0_epc,
        cp0Cause => s_cp0_cause,
        cp0ERet => s_cp0_eret,
        cp0Trap => s_cp0_trap,
        ps2Request => s_ps2_request,
        memRamLock => s_ram_lock_mem,
        pipelineClear => s_pipeline_clear,
        cp0StatusUpdate => s_cp0_status_update,
        cp0EpcUpdate => s_cp0_epc_update,
        cp0CauseUpdate => s_cp0_cause_update,
        cp0ERetUpdate => s_cp0_eret_update,
        cp0TrapUpdate => s_cp0_trap_update,
        pcSet => s_cp0_set_pc,
        pcSetVal => s_cp0_set_pc_val,

		wbBubble => s_bubble_wb,
		memBubble => s_bubble_mem,
		exeBubble => s_bubble_exe,
		idBubble => s_bubble_id
    );
	 
	 u_ps2_controller : ps2_controller port map (
		clk => real_clk,
		ps2_clk => ps2_clk,
		ps2_data => ps2_data,
		data_request => s_ps2_request,
		data => s_ps2_data_o
	 );

	process(s_next_pc_o, s_next_pc_out, s_pc_inc, s_stall_set_pc,
			s_stall_set_pc_val, s_cp0_set_pc, s_cp0_set_pc_val)
    begin
        if s_cp0_set_pc = '1' then
            s_next_pc_in <= s_cp0_set_pc_val;
		elsif s_stall_set_pc = '1' then
			s_next_pc_in <= s_stall_set_pc_val;
		elsif s_pc_inc = '1' then
			s_next_pc_in <= s_next_pc_out;
		else
			s_next_pc_in <= s_next_pc_o;
		end if;
	end process;

    -- test_regB <= s_regA_fwd & s_regB_fwd & s_dstSrc_mem & s_dstSrc_wb;

    process(s_pc_out)
    begin
        case s_pc_out(3 downto 0) is
            when "0001" => disp1 <= "0110000";
            when "0010" => disp1 <= "1101101";
            when "0011" => disp1 <= "1111001";
            when "0100" => disp1 <= "0110011";
            when "0101" => disp1 <= "1011011";
            when "0110" => disp1 <= "1011011";
            when "0111" => disp1 <= "1110000";
            when "1000" => disp1 <= "1111111";
            when "1001" => disp1 <= "1111011";
            when others => disp1 <= "1111111";
        end case;
    end process;

    process(s_pipeline_clear, s_stall_id_clear, s_stall_exe_clear,
        s_stall_id_keep)
    begin
        s_id_clear <= '0';
        s_exe_clear <= '0';
        s_mem_clear <= '0';
        s_wb_clear <= '0';
		s_id_keep <= '0';
        if s_pipeline_clear = '1' then
            s_id_clear <= '1';
            s_exe_clear <= '1';
            s_mem_clear <= '1';
            s_wb_clear <= '1';
        else
            if s_stall_id_clear = '1' then
                s_id_clear <= '1';
            end if;
            if s_stall_exe_clear = '1' then
                s_exe_clear <= '1';
            end if;
            if s_stall_id_keep = '1' then
                s_id_keep <= '1';
            end if;
        end if;
    end process;

    

    -- test_ALUres <= s_ALUres_o;
    -- test_regSrcA <= s_regSrcA;
    -- test_regSrcB <= s_regSrcB;
    -- test_regA <= s_ALU_oprB;


end Behavioral;

