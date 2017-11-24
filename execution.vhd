----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:41:33 11/17/2017 
-- Design Name: 
-- Module Name:    execution - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.consts.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity execution is port(
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
		out_PC		:	out std_logic_vector(15 downto 0)
	);
end execution;

architecture Behavioral of execution is

begin
	out_PC <= PC;
	regA_fwd <= regAN;
	regB_fwd <= regBN;
	regB_o <= regB;
	B_ALU_res <= ALUres;
	
	shifted_PC <= PC + immediate;
	
	process(isMFPC, ALUres, PC)
	begin
		if (isMFPC = '1') then
			ALUres_o <= PC;
		else
			ALUres_o <= ALUres;
		end if;
	end process;
	
	process(fwdSrcA, mem_aluRes, wb_ramRes, wb_aluRes, regA)
	begin
		case fwdSrcA is
			when fwd_original => ALU_oprA <= regA;
			when fwd_alu_res  => ALU_oprA <= mem_aluRes;
			when fwd_wb_ram   => ALU_oprA <= wb_ramRes;
			when fwd_wb_alu   => ALU_oprA <= wb_aluRes;
			when others => ALU_oprA <= regA;
		end case;
	end process;
	
	process(fwdSrcB, mem_aluRes, wb_ramRes, wb_aluRes, oprSrcB, regB, immediate)
	begin
		case fwdSrcB is
			when fwd_original =>
				if (oprSrcB = '1') then
					ALU_oprB <= immediate;
				else
					ALU_oprB <= regB;
				end if;
			when fwd_alu_res  => ALU_oprB <= mem_aluRes;
			when fwd_wb_ram   => ALU_oprB <= wb_ramRes;
			when fwd_wb_alu   => ALU_oprB <= wb_aluRes;
			when others => 
				if (oprSrcB = '1') then
					ALU_oprB <= immediate;
				else
					ALU_oprB <= regB;
				end if;
		end case;
	end process;
	

end Behavioral;

