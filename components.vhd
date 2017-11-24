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

package components is
    component alu port(
		regA : in std_logic_vector(15 downto 0);
		regB : in std_logic_vector(15 downto 0);
		ALUop : in std_logic_vector(3 downto 0);
		ALUres : out std_logic_vector(15 downto 0));
    end component; 

    component branch_judger port(
        ALUres		:  in std_logic_vector(15 downto 0); -- ALU result
        shifted_PC	:	in std_logic_vector(15 downto 0); -- PC + immediate
        next_PC		:	in std_logic_vector(15 downto 0); -- PC + 1
        isBranch		:	in std_logic;
        isCond		:	in std_logic;
        isRelative	:	in std_logic;

        next_PC_o	: out std_logic_vector(15 downto 0));
	end component; 
    
    component control port(
        inst			:	in std_logic_vector(15 downto 0);
        regSrcA		:	out std_logic_vector(3 downto 0);
        regSrcB		:	out std_logic_vector(3 downto 0);
        immeCtrl		:	out std_logic_vector(2 downto 0);
        dstSrc		:	out std_logic_vector(3 downto 0);
        immeExt		:	out std_logic;
        oprSrcB		:	out std_logic;
        ALUop			:	out std_logic_vector(3 downto 0);
        isBranch		:	out std_logic;
        isCond		:	out std_logic;
        isRelative	:	out std_logic;
        isMFPC		:	out std_logic;
        ramWrite		:	out std_logic;
        ramRead		:	out std_logic;
        wbSrc		:	out std_logic;
        wbEN		:	out std_logic);
    end component;

    component ex_mem port(
        clk : in std_logic;
        
        dstSrc	:	in std_logic_vector(3 downto 0);
        ramWrite	:	in std_logic;
        ramRead	:	in std_logic;
        wbSrc		:	in std_logic;
        wbEN		:	in std_logic;
        
        regB 		:  in std_logic_vector(15 downto 0);
        ALUres 	:	in std_logic_vector(15 downto 0);
        
        dstSrc_o		:	out std_logic_vector(3 downto 0);
        ramWrite_o	:	out std_logic;
        ramRead_o	:	out std_logic;
        wbSrc_o		:	out std_logic;
        wbEN_o		:	out std_logic;
        
        regB_o 		:  out std_logic_vector(15 downto 0);
        ALUres_o 	:	out std_logic_vector(15 downto 0));
    end component;

    component execution port(
		regA 			:  in std_logic_vector(15 downto 0);
		regB 			:  in std_logic_vector(15 downto 0);
		regAN 		:  in std_logic_vector(3 downto 0);
		regBN 		:  in std_logic_vector(3 downto 0);
		immediate	:  in std_logic_vector(15 downto 0);
		PC 			:  in std_logic_vector(15 downto 0);
		oprSrcB		:	in std_logic;
		ALUres		:	in std_logic_vector(15 downto 0);
		isMFPC		:	in std_logic;
		
		-- send to ALU
		ALU_oprA 		:  out std_logic_vector(15 downto 0);
		ALU_oprB 		:  out std_logic_vector(15 downto 0);
		
		-- send to branch judger
		shifted_PC	:  out std_logic_vector(15 downto 0);
		B_ALU_res	:  out std_logic_vector(15 downto 0);
		
		-- signal from forward unit
		fwdSrcA	: in std_logic_vector(1 downto 0);
		fwdSrcB	: in std_logic_vector(1 downto 0);
		
		-- signals used to decide forward unit result
		mem_aluRes	: in std_logic_vector(15 downto 0);
		wb_ramRes	: in std_logic_vector(15 downto 0);
		wb_aluRes	: in std_logic_vector(15 downto 0);
		
		-- send to forward unit to detect conflicts
		regA_fwd 		:  out std_logic_vector(3 downto 0);
		regB_fwd 		:  out std_logic_vector(3 downto 0);
		
		regB_o 		:  out std_logic_vector(15 downto 0);
		ALUres_o 	:	out std_logic_vector(15 downto 0);
		out_PC		:	out std_logic_vector(15 downto 0));
    end component;


    component forward_unit port(
		regReadSrcA : in std_logic_vector(3 downto 0);
		regReadSrcB : in std_logic_vector(3 downto 0);
		memDst 		: in std_logic_vector(3 downto 0);
		wbDst 		: in std_logic_vector(3 downto 0);
		
		srcA	: out std_logic_vector(1 downto 0);
		srcB	: out std_logic_vector(1 downto 0));
    end component;


    component id_exe port(
		clk : in std_logic;

		regA 			:  in std_logic_vector(15 downto 0);
		regB 			:  in std_logic_vector(15 downto 0);
		regAN 		:  in std_logic_vector(3 downto 0);
		regBN 		:  in std_logic_vector(3 downto 0);
		immediate	:  in std_logic_vector(15 downto 0);
		IDPC 			:  in std_logic_vector(15 downto 0);
		dstSrc		:	in std_logic_vector(3 downto 0);
		immeExt		:	in std_logic;
		oprSrcB		:	in std_logic;
		ALUop			:	in std_logic_vector(3 downto 0);
		isBranch		:	in std_logic;
		isCond		:	in std_logic;
		isRelative	:	in std_logic;
		isMFPC		:	in std_logic;
		ramWrite		:	in std_logic;
		ramRead		:	in std_logic;
		wbSrc			:	in std_logic;
		wbEN			:	in std_logic;
		
		regA_o 			: out std_logic_vector(15 downto 0);
		regB_o 			: out std_logic_vector(15 downto 0);
		regAN_o 			: out std_logic_vector(3 downto 0);
		regBN_o 			: out std_logic_vector(3 downto 0);
		immediate_o		: out std_logic_vector(15 downto 0);
		IDPC_o 			: out std_logic_vector(15 downto 0);
		dstSrc_o			:	out std_logic_vector(3 downto 0);
		immeExt_o		:	out std_logic;
		oprSrcB_o		:	out std_logic;
		ALUop_o			:	out std_logic_vector(3 downto 0);
		isBranch_o		:	out std_logic;
		isCond_o			:	out std_logic;
		isRelative_o	:	out std_logic;
		isMFPC_o			:	out std_logic;
		ramWrite_o		:	out std_logic;
		ramRead_o		:	out std_logic;
		wbSrc_o			:	out std_logic;
		wbEN_o			:	out std_logic);
    end component;

    component if_id port(
        clk : in std_logic;

        IFPC : in std_logic_vector(15 downto 0);
        inst : in std_logic_vector(15 downto 0);
        IFPC_o : out std_logic_vector(15 downto 0);
        inst_o : out std_logic_vector(15 downto 0));
    end component;

    component inst_decode port(
		inst : in std_logic_vector(15 downto 0);
		regSrcA : in std_logic_vector(3 downto 0);
		regSrcB : in std_logic_vector(3 downto 0);
		immeCtrl : in std_logic_vector(2 downto 0);
		immeExt : in std_logic;
		
		regAN : out std_logic_vector(3 downto 0);
		regBN : out std_logic_vector(3 downto 0);
		immediate : out std_logic_vector(15 downto 0));
    end component;

    component inst_fetch port(
		pc: in std_logic_vector(15 downto 0);
		instr: out std_logic_vector(15 downto 0);
		clk: in std_logic);
    end component;
    

    component mem_access port(
		ram_addr 	: in std_logic_vector(15 downto 0);
		ram_data_in : in std_logic_vector(15 downto 0);
		
		ramWrite	:	in std_logic;
		ramRead	:	in std_logic;
		
		-- signals sen to ram dispatcher
		ramWrite_o	:	out std_logic;
		ramRead_o	:	out std_logic;
		ram_addr_o  : out std_logic_vector(15 downto 0);
		ram_data_o  : out std_logic_vector(15 downto 0);
		
		-- result get from ram dispatcher
		ram_return	 : in std_logic_vector(15 downto 0);
		ram_return_o : out std_logic_vector(15 downto 0));
    end component;
    
    component mem_wb port(
		clk : in std_logic;

		dstSrc	:	in std_logic_vector(3 downto 0);
		wbSrc		:	in std_logic;
		wbEN		:	in std_logic;
		
		dstSrc_o		:	out std_logic_vector(3 downto 0);
		wbSrc_o		:	out std_logic;
		wbEN_o		:	out std_logic;

		ramData	: in std_logic_vector(15 downto 0);
		ALUres	: in std_logic_vector(15 downto 0);
		
		ramData_o	: out std_logic_vector(15 downto 0);
		ALUres_o		: out std_logic_vector(15 downto 0));
    end component;
    
    component pc_controller port(
        clk : in std_logic;
        -- pause : in std_logic;
        next_pc_in : in std_logic_vector(15 downto 0);
        next_pc_out : out std_logic_vector(15 downto 0);
        pc_out : out std_logic_vector(15 downto 0));
    end component;


    component ram_interactor port(
		clk : in std_logic;
		
		if_ram_addr	  : in std_logic_vector(15 downto 0);
		mem_ram_addr  : in std_logic_vector(15 downto 0);
		mem_ram_data  : in std_logic_vector(15 downto 0);
		
		-- signals from mem
		ramWrite	:	in std_logic;
		ramRead	:	in std_logic;
		
		res_data : out std_logic_vector(15 downto 0));
    end component;

    component registers port(
		regSrcA : in std_logic_vector(3 downto 0);
		regSrcB : in std_logic_vector(3 downto 0);
		
		writeSrc 	: in std_logic_vector(3 downto 0);
		writeData 	: in std_logic_vector(15 downto 0);
		
		writeEN		: in std_logic;
	
		regA : out std_logic_vector(15 downto 0);
		regB : out std_logic_vector(15 downto 0));
    end component;

    -- component stall_unit port(

    -- );
    -- end component;

    component write_back port(
		dstSrc	:	in std_logic_vector(3 downto 0);
		wbSrc	:	in std_logic;
		wbEN	:	in std_logic;
		
		ramData	: in std_logic_vector(15 downto 0);
		ALUres	: in std_logic_vector(15 downto 0);
		
		writeData : out std_logic_vector(15 downto 0);
		writeDst : out std_logic_vector(3 downto 0);
		isWriting : out std_logic);
    end component;
    -- component 
    -- end component;
    -- component 
    -- end component;

end components;