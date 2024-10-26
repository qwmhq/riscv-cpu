-- Copyright (C) 2021  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "07/31/2024 00:00:16"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          RegisterFile
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY RegisterFile_vhd_vec_tst IS
END RegisterFile_vhd_vec_tst;
ARCHITECTURE RegisterFile_arch OF RegisterFile_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL data_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL r1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL r2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL rd : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL reset : STD_LOGIC;
SIGNAL rs1 : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL rs2 : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL wr_en : STD_LOGIC;
COMPONENT RegisterFile
	PORT (
	clk : IN STD_LOGIC;
	data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	r1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	r2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	rd : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	reset : IN STD_LOGIC;
	rs1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	rs2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	wr_en : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : RegisterFile
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	data_in => data_in,
	r1 => r1,
	r2 => r2,
	rd => rd,
	reset => reset,
	rs1 => rs1,
	rs2 => rs2,
	wr_en => wr_en
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
	FOR i IN 1 TO 49
	LOOP
		clk <= '0';
		WAIT FOR 10000 ps;
		clk <= '1';
		WAIT FOR 10000 ps;
	END LOOP;
	clk <= '0';
	WAIT FOR 10000 ps;
	clk <= '1';
	WAIT FOR 9000 ps;
	clk <= '0';
WAIT;
END PROCESS t_prcs_clk;
-- data_in[31]
t_prcs_data_in_31: PROCESS
BEGIN
	data_in(31) <= '0';
WAIT;
END PROCESS t_prcs_data_in_31;
-- data_in[30]
t_prcs_data_in_30: PROCESS
BEGIN
	data_in(30) <= '0';
WAIT;
END PROCESS t_prcs_data_in_30;
-- data_in[29]
t_prcs_data_in_29: PROCESS
BEGIN
	data_in(29) <= '0';
WAIT;
END PROCESS t_prcs_data_in_29;
-- data_in[28]
t_prcs_data_in_28: PROCESS
BEGIN
	data_in(28) <= '0';
WAIT;
END PROCESS t_prcs_data_in_28;
-- data_in[27]
t_prcs_data_in_27: PROCESS
BEGIN
	data_in(27) <= '0';
WAIT;
END PROCESS t_prcs_data_in_27;
-- data_in[26]
t_prcs_data_in_26: PROCESS
BEGIN
	data_in(26) <= '0';
WAIT;
END PROCESS t_prcs_data_in_26;
-- data_in[25]
t_prcs_data_in_25: PROCESS
BEGIN
	data_in(25) <= '0';
WAIT;
END PROCESS t_prcs_data_in_25;
-- data_in[24]
t_prcs_data_in_24: PROCESS
BEGIN
	data_in(24) <= '0';
WAIT;
END PROCESS t_prcs_data_in_24;
-- data_in[23]
t_prcs_data_in_23: PROCESS
BEGIN
	data_in(23) <= '0';
WAIT;
END PROCESS t_prcs_data_in_23;
-- data_in[22]
t_prcs_data_in_22: PROCESS
BEGIN
	data_in(22) <= '0';
WAIT;
END PROCESS t_prcs_data_in_22;
-- data_in[21]
t_prcs_data_in_21: PROCESS
BEGIN
	data_in(21) <= '0';
WAIT;
END PROCESS t_prcs_data_in_21;
-- data_in[20]
t_prcs_data_in_20: PROCESS
BEGIN
	data_in(20) <= '0';
WAIT;
END PROCESS t_prcs_data_in_20;
-- data_in[19]
t_prcs_data_in_19: PROCESS
BEGIN
	data_in(19) <= '0';
WAIT;
END PROCESS t_prcs_data_in_19;
-- data_in[18]
t_prcs_data_in_18: PROCESS
BEGIN
	data_in(18) <= '0';
WAIT;
END PROCESS t_prcs_data_in_18;
-- data_in[17]
t_prcs_data_in_17: PROCESS
BEGIN
	data_in(17) <= '0';
WAIT;
END PROCESS t_prcs_data_in_17;
-- data_in[16]
t_prcs_data_in_16: PROCESS
BEGIN
	data_in(16) <= '0';
WAIT;
END PROCESS t_prcs_data_in_16;
-- data_in[15]
t_prcs_data_in_15: PROCESS
BEGIN
	data_in(15) <= '0';
WAIT;
END PROCESS t_prcs_data_in_15;
-- data_in[14]
t_prcs_data_in_14: PROCESS
BEGIN
	data_in(14) <= '0';
WAIT;
END PROCESS t_prcs_data_in_14;
-- data_in[13]
t_prcs_data_in_13: PROCESS
BEGIN
	data_in(13) <= '0';
WAIT;
END PROCESS t_prcs_data_in_13;
-- data_in[12]
t_prcs_data_in_12: PROCESS
BEGIN
	data_in(12) <= '0';
WAIT;
END PROCESS t_prcs_data_in_12;
-- data_in[11]
t_prcs_data_in_11: PROCESS
BEGIN
	data_in(11) <= '0';
WAIT;
END PROCESS t_prcs_data_in_11;
-- data_in[10]
t_prcs_data_in_10: PROCESS
BEGIN
	data_in(10) <= '0';
WAIT;
END PROCESS t_prcs_data_in_10;
-- data_in[9]
t_prcs_data_in_9: PROCESS
BEGIN
	data_in(9) <= '0';
WAIT;
END PROCESS t_prcs_data_in_9;
-- data_in[8]
t_prcs_data_in_8: PROCESS
BEGIN
	data_in(8) <= '0';
WAIT;
END PROCESS t_prcs_data_in_8;
-- data_in[7]
t_prcs_data_in_7: PROCESS
BEGIN
	data_in(7) <= '0';
WAIT;
END PROCESS t_prcs_data_in_7;
-- data_in[6]
t_prcs_data_in_6: PROCESS
BEGIN
	data_in(6) <= '0';
	WAIT FOR 20000 ps;
	data_in(6) <= '1';
	WAIT FOR 20000 ps;
	data_in(6) <= '0';
WAIT;
END PROCESS t_prcs_data_in_6;
-- data_in[5]
t_prcs_data_in_5: PROCESS
BEGIN
	data_in(5) <= '0';
	WAIT FOR 340000 ps;
	data_in(5) <= '1';
	WAIT FOR 320000 ps;
	data_in(5) <= '0';
WAIT;
END PROCESS t_prcs_data_in_5;
-- data_in[4]
t_prcs_data_in_4: PROCESS
BEGIN
	data_in(4) <= '0';
	WAIT FOR 180000 ps;
	data_in(4) <= '1';
	WAIT FOR 160000 ps;
	data_in(4) <= '0';
	WAIT FOR 160000 ps;
	data_in(4) <= '1';
	WAIT FOR 160000 ps;
	data_in(4) <= '0';
WAIT;
END PROCESS t_prcs_data_in_4;
-- data_in[3]
t_prcs_data_in_3: PROCESS
BEGIN
	data_in(3) <= '0';
	WAIT FOR 100000 ps;
	data_in(3) <= '1';
	WAIT FOR 80000 ps;
	FOR i IN 1 TO 3
	LOOP
		data_in(3) <= '0';
		WAIT FOR 80000 ps;
		data_in(3) <= '1';
		WAIT FOR 80000 ps;
	END LOOP;
	data_in(3) <= '0';
WAIT;
END PROCESS t_prcs_data_in_3;
-- data_in[2]
t_prcs_data_in_2: PROCESS
BEGIN
	data_in(2) <= '0';
	WAIT FOR 20000 ps;
	data_in(2) <= '1';
	WAIT FOR 20000 ps;
	data_in(2) <= '0';
	WAIT FOR 20000 ps;
	data_in(2) <= '1';
	WAIT FOR 40000 ps;
	FOR i IN 1 TO 7
	LOOP
		data_in(2) <= '0';
		WAIT FOR 40000 ps;
		data_in(2) <= '1';
		WAIT FOR 40000 ps;
	END LOOP;
	data_in(2) <= '0';
WAIT;
END PROCESS t_prcs_data_in_2;
-- data_in[1]
t_prcs_data_in_1: PROCESS
BEGIN
	data_in(1) <= '0';
	WAIT FOR 40000 ps;
	data_in(1) <= '1';
	WAIT FOR 20000 ps;
	FOR i IN 1 TO 15
	LOOP
		data_in(1) <= '0';
		WAIT FOR 20000 ps;
		data_in(1) <= '1';
		WAIT FOR 20000 ps;
	END LOOP;
	data_in(1) <= '0';
WAIT;
END PROCESS t_prcs_data_in_1;
-- data_in[0]
t_prcs_data_in_0: PROCESS
BEGIN
	data_in(0) <= '0';
	WAIT FOR 20000 ps;
	data_in(0) <= '1';
	WAIT FOR 20000 ps;
	data_in(0) <= '0';
WAIT;
END PROCESS t_prcs_data_in_0;
-- rd[4]
t_prcs_rd_4: PROCESS
BEGIN
	rd(4) <= '0';
	WAIT FOR 340000 ps;
	rd(4) <= '1';
	WAIT FOR 320000 ps;
	rd(4) <= '0';
WAIT;
END PROCESS t_prcs_rd_4;
-- rd[3]
t_prcs_rd_3: PROCESS
BEGIN
	rd(3) <= '0';
	WAIT FOR 180000 ps;
	rd(3) <= '1';
	WAIT FOR 160000 ps;
	rd(3) <= '0';
	WAIT FOR 160000 ps;
	rd(3) <= '1';
	WAIT FOR 160000 ps;
	rd(3) <= '0';
WAIT;
END PROCESS t_prcs_rd_3;
-- rd[2]
t_prcs_rd_2: PROCESS
BEGIN
	rd(2) <= '0';
	WAIT FOR 100000 ps;
	rd(2) <= '1';
	WAIT FOR 80000 ps;
	FOR i IN 1 TO 3
	LOOP
		rd(2) <= '0';
		WAIT FOR 80000 ps;
		rd(2) <= '1';
		WAIT FOR 80000 ps;
	END LOOP;
	rd(2) <= '0';
WAIT;
END PROCESS t_prcs_rd_2;
-- rd[1]
t_prcs_rd_1: PROCESS
BEGIN
	rd(1) <= '0';
	WAIT FOR 60000 ps;
	rd(1) <= '1';
	WAIT FOR 40000 ps;
	FOR i IN 1 TO 7
	LOOP
		rd(1) <= '0';
		WAIT FOR 40000 ps;
		rd(1) <= '1';
		WAIT FOR 40000 ps;
	END LOOP;
	rd(1) <= '0';
WAIT;
END PROCESS t_prcs_rd_1;
-- rd[0]
t_prcs_rd_0: PROCESS
BEGIN
	rd(0) <= '0';
	WAIT FOR 40000 ps;
	rd(0) <= '1';
	WAIT FOR 20000 ps;
	rd(0) <= '0';
	WAIT FOR 20000 ps;
	rd(0) <= '1';
	WAIT FOR 20000 ps;
	FOR i IN 1 TO 14
	LOOP
		rd(0) <= '0';
		WAIT FOR 20000 ps;
		rd(0) <= '1';
		WAIT FOR 20000 ps;
	END LOOP;
	rd(0) <= '0';
WAIT;
END PROCESS t_prcs_rd_0;

-- reset
t_prcs_reset: PROCESS
BEGIN
	reset <= '0';
	WAIT FOR 960000 ps;
	reset <= '1';
	WAIT FOR 10000 ps;
	reset <= '0';
WAIT;
END PROCESS t_prcs_reset;
-- rs1[4]
t_prcs_rs1_4: PROCESS
BEGIN
	rs1(4) <= '0';
	WAIT FOR 630000 ps;
	rs1(4) <= '1';
	WAIT FOR 350000 ps;
	rs1(4) <= '0';
WAIT;
END PROCESS t_prcs_rs1_4;
-- rs1[3]
t_prcs_rs1_3: PROCESS
BEGIN
	rs1(3) <= '0';
	WAIT FOR 470000 ps;
	rs1(3) <= '1';
	WAIT FOR 160000 ps;
	rs1(3) <= '0';
	WAIT FOR 160000 ps;
	rs1(3) <= '1';
	WAIT FOR 190000 ps;
	rs1(3) <= '0';
WAIT;
END PROCESS t_prcs_rs1_3;
-- rs1[2]
t_prcs_rs1_2: PROCESS
BEGIN
	rs1(2) <= '0';
	WAIT FOR 390000 ps;
	rs1(2) <= '1';
	WAIT FOR 80000 ps;
	FOR i IN 1 TO 2
	LOOP
		rs1(2) <= '0';
		WAIT FOR 80000 ps;
		rs1(2) <= '1';
		WAIT FOR 80000 ps;
	END LOOP;
	rs1(2) <= '0';
	WAIT FOR 80000 ps;
	rs1(2) <= '1';
	WAIT FOR 110000 ps;
	rs1(2) <= '0';
WAIT;
END PROCESS t_prcs_rs1_2;
-- rs1[1]
t_prcs_rs1_1: PROCESS
BEGIN
	rs1(1) <= '0';
	WAIT FOR 350000 ps;
	rs1(1) <= '1';
	WAIT FOR 40000 ps;
	FOR i IN 1 TO 6
	LOOP
		rs1(1) <= '0';
		WAIT FOR 40000 ps;
		rs1(1) <= '1';
		WAIT FOR 40000 ps;
	END LOOP;
	rs1(1) <= '0';
	WAIT FOR 40000 ps;
	rs1(1) <= '1';
	WAIT FOR 70000 ps;
	rs1(1) <= '0';
WAIT;
END PROCESS t_prcs_rs1_1;
-- rs1[0]
t_prcs_rs1_0: PROCESS
BEGIN
	rs1(0) <= '0';
	WAIT FOR 330000 ps;
	rs1(0) <= '1';
	WAIT FOR 20000 ps;
	FOR i IN 1 TO 14
	LOOP
		rs1(0) <= '0';
		WAIT FOR 20000 ps;
		rs1(0) <= '1';
		WAIT FOR 20000 ps;
	END LOOP;
	rs1(0) <= '0';
	WAIT FOR 20000 ps;
	rs1(0) <= '1';
	WAIT FOR 50000 ps;
	rs1(0) <= '0';
WAIT;
END PROCESS t_prcs_rs1_0;
-- rs2[4]
t_prcs_rs2_4: PROCESS
BEGIN
	rs2(4) <= '0';
	WAIT FOR 950000 ps;
	rs2(4) <= '1';
	WAIT FOR 260000 ps;
	rs2(4) <= '0';
WAIT;
END PROCESS t_prcs_rs2_4;
-- rs2[3]
t_prcs_rs2_3: PROCESS
BEGIN
	rs2(3) <= '0';
	WAIT FOR 790000 ps;
	rs2(3) <= '1';
	WAIT FOR 160000 ps;
	rs2(3) <= '0';
	WAIT FOR 160000 ps;
	rs2(3) <= '1';
	WAIT FOR 100000 ps;
	rs2(3) <= '0';
WAIT;
END PROCESS t_prcs_rs2_3;
-- rs2[2]
t_prcs_rs2_2: PROCESS
BEGIN
	rs2(2) <= '0';
	WAIT FOR 710000 ps;
	rs2(2) <= '1';
	WAIT FOR 80000 ps;
	FOR i IN 1 TO 2
	LOOP
		rs2(2) <= '0';
		WAIT FOR 80000 ps;
		rs2(2) <= '1';
		WAIT FOR 80000 ps;
	END LOOP;
	rs2(2) <= '0';
	WAIT FOR 80000 ps;
	rs2(2) <= '1';
	WAIT FOR 20000 ps;
	rs2(2) <= '0';
WAIT;
END PROCESS t_prcs_rs2_2;
-- rs2[1]
t_prcs_rs2_1: PROCESS
BEGIN
	rs2(1) <= '0';
	WAIT FOR 670000 ps;
	rs2(1) <= '1';
	WAIT FOR 40000 ps;
	FOR i IN 1 TO 6
	LOOP
		rs2(1) <= '0';
		WAIT FOR 40000 ps;
		rs2(1) <= '1';
		WAIT FOR 40000 ps;
	END LOOP;
	rs2(1) <= '0';
WAIT;
END PROCESS t_prcs_rs2_1;
-- rs2[0]
t_prcs_rs2_0: PROCESS
BEGIN
	rs2(0) <= '0';
	WAIT FOR 650000 ps;
	rs2(0) <= '1';
	WAIT FOR 20000 ps;
	FOR i IN 1 TO 13
	LOOP
		rs2(0) <= '0';
		WAIT FOR 20000 ps;
		rs2(0) <= '1';
		WAIT FOR 20000 ps;
	END LOOP;
	rs2(0) <= '0';
WAIT;
END PROCESS t_prcs_rs2_0;

-- wr_en
t_prcs_wr_en: PROCESS
BEGIN
	wr_en <= '0';
	WAIT FOR 30000 ps;
	wr_en <= '1';
	WAIT FOR 310000 ps;
	wr_en <= '0';
	WAIT FOR 160000 ps;
	wr_en <= '1';
	WAIT FOR 160000 ps;
	wr_en <= '0';
WAIT;
END PROCESS t_prcs_wr_en;
END RegisterFile_arch;
