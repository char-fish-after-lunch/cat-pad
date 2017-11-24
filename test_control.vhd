library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.ALL;


entity test_control is
end test_control;

architecture Behavioral of test_control is
	signal 
		inst			:	std_logic_vector(15 downto 0);
	signal
		regSrcA		:	std_logic_vector(3 downto 0);
	signal
		regSrcB		:	std_logic_vector(3 downto 0);
	signal
		immeCtrl		:	std_logic_vector(2 downto 0);
	signal
		dstSrc		:	std_logic_vector(3 downto 0);
	signal
		immeExt		:	std_logic;
	signal
		oprSrcB		:	std_logic;
	signal
		ALUop			:	std_logic_vector(3 downto 0);
	signal
		isBranch		:	std_logic;
	signal
		isCond		:	std_logic;
	signal
		isRelative	:	std_logic;
	signal
		isMFPC		:	std_logic;
	signal
		ramWrite		:	std_logic;
	signal
		ramRead		:	std_logic;
	signal
		wbSrc		:	std_logic;
	signal
		wbEN		:	std_logic;

	component control is port(
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
		wbEN		:	out std_logic
		);
	end component;	
begin
	control_0: control port map(inst, regSrcA, regSrcB,
		immeCtrl, dstSrc, immeExt, oprSrcB, ALUop,
		isBranch, isCond, isRelative, isMFPC, ramWrite,
		ramRead, wbSrc, wbEN);
	process
		variable l : line;
	begin
		inst <= "0100100000000000";

		wait for 2 ns;
		write(l, inst);
		writeline(output, l);
		write(l, regSrcA);
		writeline(output, l);
		write(l, regSrcB);
		writeline(output, l);
		write(l, immeCtrl);
		writeline(output, l);
		write(l, dstSrc);
		writeline(output, l);
		write(l, immeExt);
		writeline(output, l);
		write(l, oprSrcB);
		writeline(output, l);
		write(l, ALUop);
		writeline(output, l);
		write(l, isBranch);
		writeline(output, l);
		write(l, isCond);
		writeline(output, l);
		write(l, isRelative);
		writeline(output, l);
		write(l, isMFPC);
		writeline(output, l);
		write(l, ramWrite);
		writeline(output, l);
		write(l, ramRead);
		writeline(output, l);
		write(l, wbSrc);
		writeline(output, l);
		write(l, wbEN);
		writeline(output, l);
		-- writeline(output, inst);
		wait;
	end process;
end Behavioral;

