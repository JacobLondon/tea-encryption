// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Wed Nov 27 18:54:11 2019
// Host        : cygnus running 64-bit Ubuntu 19.04
// Command     : write_verilog -force -mode synth_stub
//               /home/jacob/Workspace/vhdl/tea-encryption/src/hardware/vivado/XTea.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk25, reset, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk25,reset,locked,clk_in1" */;
  output clk25;
  input reset;
  output locked;
  input clk_in1;
endmodule
