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
    
    flashByte : out std_logic;
    flashVpen : out std_logic;
    flashCE : out std_logic;
    flashOE : out std_logic;
    flashWE : out std_logic;
    flashRP : out std_logic;
    flash_addr : out std_logic_vector(22 downto 1);
    flash_data : inout std_logic_vector(15 downto 0)


    -- test_ALUres : out  STD_LOGIC_VECTOR (15 downto 0);
    -- test_regSrcA : out  STD_LOGIC_VECTOR (3 downto 0);
    -- test_regSrcB : out  STD_LOGIC_VECTOR (3 downto 0);
    -- test_regA : out  STD_LOGIC_VECTOR (15 downto 0);
    -- test_regB : out  STD_LOGIC_VECTOR (15 downto 0)
);
end cat_pad;

architecture Behavioral of cat_pad is
	signal isBootloaded : std_logic := '0';

	signal s_next_pc_in : std_logic_vector(15 downto 0);
	signal s_next_pc_out : std_logic_vector(15 downto 0);
	signal s_pc_out : std_logic_vector(15 downto 0);
    signal s_instr : std_logic_vector(15 downto 0);

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

    -- exe 
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
    signal s_ALUres_o 	: std_logic_vector(15 downto 0);
    signal s_EXEPC		: std_logic_vector(15 downto 0);

    signal s_dstSrc_mem		: std_logic_vector(3 downto 0);
	signal s_ramWrite_mem	: std_logic;
	signal s_ramRead_mem	: std_logic;
	signal s_wbSrc_mem		: std_logic;
	signal s_wbEN_mem		: std_logic;
	
	signal s_regB_mem 		: std_logic_vector(15 downto 0);
	signal s_ALUres_mem 	: std_logic_vector(15 downto 0);
    
	-- ram interactor
    signal s_if_ram_addr    : std_logic_vector(15 downto 0);
    signal s_mem_ram_addr   : std_logic_vector(15 downto 0);
    signal s_mem_ram_data   : std_logic_vector(15 downto 0);
    signal s_res_data       : std_logic_vector(15 downto 0);
    signal s_if_res_data    : std_logic_vector(15 downto 0);
    signal s_ramWrite_ram	: std_logic;
    signal s_ramRead_ram	: std_logic;

    signal s_ram_data : std_logic_vector(15 downto 0);

    -- mem/wb
    signal s_dstSrc_wb	: std_logic_vector(3 downto 0);
    signal s_wbSrc_wb	: std_logic;
    signal s_wbEN_wb	: std_logic;
    signal s_ramData_wb	: std_logic_vector(15 downto 0);
    signal s_ALUres_wb	: std_logic_vector(15 downto 0);

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
	 
	 process(clk, manual_clk, isBootloaded, wrn_pad, rdn_pad, ram1en_pad, ram1oe_pad, ram1rw_pad, wrn_bootloader,
        rdn_bootloader, ram1en_bootloader, ram1oe_bootloader, ram1rw_bootloader, ram1addr_bootloader, ram1addr_pad)
	 begin
		-- if not bootloaded, all clock is blocked
		if (isBootloaded = '1') then
			real_clk <= manual_clk;
            wrn <= wrn_pad;
            rdn <= rdn_pad;
            ram1addr <= ram1addr_pad;
            ram1en <= ram1en_pad;
            ram1oe <= ram1oe_pad;
            ram1rw <= ram1rw_pad;
            leds <= s_ALUres;
				
			disp2 <= s_fwdSrcA & "000" & s_fwdSrcB;
            -- signals connect to real CPU
		else 
			real_clk <= '0';
            wrn <= wrn_bootloader;
            rdn <= rdn_bootloader;
            ram1addr <= ram1addr_bootloader;
            ram1en <= ram1en_bootloader;
            ram1oe <= ram1oe_bootloader;
            ram1rw <= ram1rw_bootloader;
            
            leds <= res_log;
				disp2 <= bootloader_state;
		end if;
	 end process;
	 
    u_pc_controller : pc_controller port map(clk => real_clk, next_pc_in => s_next_pc_in, next_pc_out => s_next_pc_out, pc_out => s_pc_out);
    
    u_inst_fetch : inst_fetch port map(pc => s_pc_out, instr => s_instr, if_addr => s_if_ram_addr, if_data => s_if_res_data);

    u_if_id : if_id port map(clk => real_clk, IFPC => s_next_pc_out, inst => s_instr, IFPC_o => s_IFPC_o, inst_o => s_inst_o);

    u_control : control port map(inst => s_inst_o, regSrcA => s_regSrcA, regSrcB => s_regSrcB, immeCtrl => s_immeCtrl, dstSrc => s_dstSrc,
        immeExt => s_immeExt, oprSrcB => s_oprSrcB, ALUop => s_ALUop, isBranch => s_isBranch, isCond => s_isCond, isRelative => s_isRelative,
        isMFPC => s_isMFPC, ramWrite => s_ramWrite, ramRead => s_ramRead, wbSrc => s_wbSrc, wbEN => s_wbEN);

    u_inst_decode : inst_decode port map(inst => s_inst_o, regSrcA => s_regSrcA, regSrcB => s_regSrcB, immeCtrl => s_immeCtrl,
        immeExt => s_immeExt, regAN => s_regAN, regBN => s_regBN, immediate => s_immediate);
		
    u_registers : registers port map(regSrcA => s_regSrcA, regSrcB => s_regSrcB, writeSrc => s_writeSrc, writeData => s_writeData,
        writeEN => s_writeEN, regA => s_regA, regB => s_regB);
    
    u_id_exe : id_exe port map(clk => real_clk, regA => s_regA, regB => s_regB, regAN => s_regAN, regBN => s_regBN, immediate => s_immediate,
        IDPC => s_IFPC_o, dstSrc => s_dstSrc, immeExt => s_immeExt, oprSrcB => s_oprSrcB, ALUop => s_ALUop, isBranch => s_isBranch, 
        isCond => s_isCond, isRelative => s_isRelative, isMFPC => s_isMFPC, ramWrite => s_ramWrite, ramRead => s_ramRead, wbSrc => s_wbSrc,
        wbEN => s_wbEN, regA_o => s_regA_o, regB_o => s_regB_o, regAN_o => s_regAN_o, regBN_o => s_regBN_o, immediate_o => s_immediate_o,
        IDPC_o => s_IDPC_o, dstSrc_o => s_dstSrc_exe, immeExt_o => s_immeExt_exe, oprSrcB_o => s_oprSrcB_exe, ALUop_o => s_ALUop_exe,
        isBranch_o => s_isBranch_exe, isCond_o => s_isCond_exe, isRelative_o => s_isRelative_exe, isMFPC_o => s_isMFPC_exe,
        ramWrite_o => s_ramWrite_exe, ramRead_o => s_ramRead_exe, wbSrc_o => s_wbSrc_exe, wbEN_o => s_wbEN_exe);

    
    u_execution : execution port map(regA => s_regA_o, regB => s_regB_o, regAN => s_regAN_o, regBN => s_regBN_o, immediate => s_immediate_o,
        PC => s_IDPC_o, oprSrcB => s_oprSrcB_exe, ALUres => s_ALUres, isMFPC => s_isMFPC_exe, ALU_oprA => s_ALU_oprA, ALU_oprB => s_ALU_oprB,
        shifted_PC => s_shifted_PC, B_ALU_res => s_B_ALU_res, fwdSrcA => s_fwdSrcA, fwdSrcB => s_fwdSrcB, mem_aluRes => s_ALUres_mem,
        wb_ramRes => s_ramData_wb, wb_aluRes => s_ALUres_wb, regA_fwd => s_regA_fwd, regB_fwd => s_regB_fwd, regB_o => s_regB_o_exe, 
        ALUres_o => s_ALUres_o, out_PC => s_EXEPC);
		
	 u_alu : alu port map(regA => s_ALU_oprA, regB => s_ALU_oprB, ALUop => s_ALUop_exe, ALUres => s_ALUres);

    u_branch_judger : branch_judger port map(next_PC => s_next_pc_out, ALUres => s_B_ALU_res, shifted_PC => s_shifted_PC, 
        isBranch => s_isBranch_exe, isCond => s_isCond_exe, isRelative => s_isRelative_exe, next_PC_o => s_next_pc_in);

    u_ex_mem : ex_mem port map(clk => real_clk, dstSrc => s_dstSrc_exe, ramWrite => s_ramWrite_exe, ramRead => s_ramRead_exe,
        wbSrc => s_wbSrc_exe, wbEN => s_wbEN_exe, regB => s_regB_o_exe, ALUres => s_ALUres_o, dstSrc_o => s_dstSrc_mem,
        ramWrite_o => s_ramWrite_mem, ramRead_o => s_ramRead_mem, wbSrc_o => s_wbSrc_mem, wbEN_o => s_wbEN_mem,
        regB_o => s_regB_mem, ALUres_o => s_ALUres_mem);

    u_mem_access : mem_access port map(ram_addr => s_ALUres_mem, ram_data_in => s_regB_mem, ramWrite => s_ramWrite_mem,
        ramRead => s_ramRead_mem, ramWrite_o => s_ramWrite_ram, ramRead_o => s_ramRead_ram, ram_data_o => s_mem_ram_data,
        ram_addr_o => s_mem_ram_addr, ram_return => s_res_data, ram_return_o => s_ram_data);
		
    u_mem_wb : mem_wb port map(clk => real_clk, dstSrc => s_dstSrc_mem, wbSrc => s_wbSrc_mem, wbEN => s_wbEN_mem,
        ramData => s_ram_data, ALUres => s_ALUres_mem, dstSrc_o => s_dstSrc_wb, wbSrc_o => s_wbSrc_wb, wbEN_o => s_wbEN_wb,
        ramData_o => s_ramData_wb, ALUres_o => s_ALUres_wb);
		
    u_ram_interactor: ram_interactor port map(clk => real_clk, if_ram_addr => s_if_ram_addr, mem_ram_addr => s_mem_ram_addr,
        mem_ram_data => s_mem_ram_data, ramWrite => s_ramWrite_ram, ramRead => s_ramRead_ram, res_data => s_res_data,
        if_res_data => s_if_res_data, ram1data => ram1data, ram1addr => ram1addr_pad, ram1oe => ram1oe_pad, ram1rw => ram1rw_pad, ram1en => ram1en_pad,
        ram2data => ram2data, ram2addr => ram2addr, ram2oe => ram2oe, ram2rw => ram2rw, ram2en => ram2en, rdn => rdn_pad, wrn => wrn_pad, 
        tbre => tbre, tsre => tsre, data_ready => data_ready);
    
    u_write_back : write_back port map(dstSrc => s_dstSrc_wb, wbSrc => s_wbSrc_wb, wbEN => s_wbEN_wb, ramData => s_ramData_wb,
        ALUres => s_ALUres_wb, writeData => s_writeData, writeDst => s_writeSrc, isWriting => s_writeEN);

    u_forward_unit : forward_unit port map(regReadSrcA => s_regA_fwd, regReadSrcB => s_regB_fwd, memDst => s_dstSrc_mem,
        wbDst => s_dstSrc_wb, ramRead => s_ramRead_mem, oprSrcB => s_oprSrcB_exe, srcA => s_fwdSrcA, srcB => s_fwdSrcB,
        wbSrc => s_wbSrc_wb);

    
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



    

    -- test_ALUres <= s_ALUres_o;
    -- test_regSrcA <= s_regSrcA;
    -- test_regSrcB <= s_regSrcB;
    -- test_regA <= s_ALU_oprB;


end Behavioral;

