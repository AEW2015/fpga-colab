-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Tue May 24 08:58:38 2022
-- Host        : DESKTOP-I75K8PP running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/git/rps/rad_test/duts/kron/kron_prj_001_devkit2_UART/kron_prj_001_devkit2_UART.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.vhdl
-- Design      : clk_wiz_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcku060-ffva1517-1-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_wiz_0 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );

end clk_wiz_0;


architecture STRUCTURE of clk_wiz_0 is

component clk_wiz_0_inner
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  -- Status and control signals
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

begin

clk_wis_i : clk_wiz_0_inner
   port map ( 
  -- Clock out ports  
   clk_out1 => clk_out1,
  -- Status and control signals                
   locked => locked,
   -- Clock in ports
   clk_in1 => clk_in1_p
 );

end;
