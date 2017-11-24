library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.ALL;


entity test_execution is
end test_execution;

architecture Behavioral of test_execution is
    signal regA         :  std_logic_vector(15 downto 0);
    signal regB 		:  std_logic_vector(15 downto 0);
    signal regAN 		:  std_logic_vector(3 downto 0);
    signal regBN 		:  std_logic_vector(3 downto 0);
    signal immediate	:  std_logic_vector(15 downto 0);
    signal PC 			:  std_logic_vector(15 downto 0);
    signal oprSrcB		:  std_logic;
    signal ALUres		:  std_logic_vector(15 downto 0);
    signal isMFPC		:  std_logic;

    signal ALU_oprA 	:  std_logic_vector(15 downto 0);
    signal ALU_oprB 	:  std_logic_vector(15 downto 0);

    signal shifted_PC	:  std_logic_vector(15 downto 0);
    signal B_ALU_res	:  std_logic_vector(15 downto 0); 

    signal fwdSrcA	    :  std_logic_vector(1 downto 0);
    signal fwdSrcB	    :  std_logic_vector(1 downto 0);

    signal mem_aluRes	:  std_logic_vector(15 downto 0);
    signal wb_ramRes	:  std_logic_vector(15 downto 0);
    signal wb_aluRes	:  std_logic_vector(15 downto 0);

    signal regA_fwd 	:  std_logic_vector(3 downto 0);
    signal regB_fwd 	:  std_logic_vector(3 downto 0);
    
    signal regB_o 		:  std_logic_vector(15 downto 0);
    signal ALUres_o 	:  std_logic_vector(15 downto 0);
    signal out_PC		:  std_logic_vector(15 downto 0);

    component execution is port(
            regA 		:  in std_logic_vector(15 downto 0);
            regB 		:  in std_logic_vector(15 downto 0);
            regAN 		:  in std_logic_vector(3 downto 0);
            regBN 		:  in std_logic_vector(3 downto 0);
            immediate	:  in std_logic_vector(15 downto 0);
            PC 			:  in std_logic_vector(15 downto 0);
            oprSrcB		:  in std_logic;
            ALUres		:  in std_logic_vector(15 downto 0);
            isMFPC		:  in std_logic;
            
            -- send to ALU
            ALU_oprA 	:  out std_logic_vector(15 downto 0);
            ALU_oprB 	:  out std_logic_vector(15 downto 0);
            
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
            regA_fwd 	:  out std_logic_vector(3 downto 0);
            regB_fwd 	:  out std_logic_vector(3 downto 0);
            
            regB_o 		:  out std_logic_vector(15 downto 0);
            ALUres_o 	:	out std_logic_vector(15 downto 0);
            out_PC		:	out std_logic_vector(15 downto 0)
        );
    end component;

begin
    execution_0: execution port map(regA, regB, regAN, regBN, 
        immediate, PC, oprSrcB, ALUres, isMFPC, ALU_oprA, ALU_oprB, 
        shifted_PC, B_ALU_res, fwdSrcA, fwdSrcB, mem_aluRes, 
        wb_ramRes, wb_aluRes, regA_fwd, regB_fwd, regB_o, 
        ALUres_o, out_PC);

    process
        variable l : line;

    begin
        regA <= "0000000000000000";
        regB <= "0000000000000000";
        regAN <= "0000";
        regBN <= "0000";
        immediate <= "0101010101010101";
        PC <= "0000000000000000";
        oprSrcB <= '1';
        ALUres <= "0000000000000000";
        isMFPC <= '0';

        fwdSrcA <= "00";
        fwdSrcB <= "00";
        
        mem_aluRes <= "0000000000000000";
        wb_ramRes <= "0000000000000000";
        wb_aluRes <= "0000000000000000";

        wait for 2 ns;
        wait;

    end process;
end Behavioral;