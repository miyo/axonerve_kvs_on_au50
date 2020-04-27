/******************************************************************************
// (c) Copyright 2017 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
******************************************************************************/
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor             : Xilinx
// \   \   \/     Version            : 1.0
//  \   \         Application        : MIG
//  /   /         Filename           : example_top_syn.sv
// /___/   /\     Date Last Modified : $Date$
// \   \  /  \    Date Created       : Tue Jan 3 2017
//  \___\/\___\
//
//Device: UltraScale+ HBM
//Design Name: HBM
//*****************************************************************************

`include "defines_h.vh"
`timescale 1ps/1ps
////////////////////////////////////////////////////////////////////////////////
// Module Delcaration
////////////////////////////////////////////////////////////////////////////////
module HBM_CONTROLLER ( 
    APB_0_PCLK, APB_0_PRESET_N, AXI_ACLK_IN_0, AXI_ARESET_N_0, 
    HBM_REF_CLK_0, AXI_ACLK, 
    AXI_00_ARADDR, AXI_00_ARBURST, AXI_00_ARID,  AXI_00_ARLEN, AXI_00_ARSIZE, AXI_00_ARVALID, 
    AXI_00_AWADDR, AXI_00_AWBURST, AXI_00_AWID,  AXI_00_AWLEN, AXI_00_AWSIZE, AXI_00_AWVALID, 
    AXI_00_RREADY, AXI_00_BREADY,  AXI_00_WDATA, AXI_00_WLAST, AXI_00_WSTRB,  AXI_00_WVALID,  
    //AXI_00_WDATA_PARITY, 
    AXI_00_ARREADY, AXI_00_AWREADY, AXI_00_RDATA, AXI_00_RID,   AXI_00_RLAST,  AXI_00_RRESP,
    AXI_00_RVALID,  AXI_00_WREADY,  AXI_00_BID,   AXI_00_BRESP, AXI_00_BVALID, 
    AXI_00_RDATA_PARITY, 
    AXI_01_ARADDR, AXI_01_ARBURST, AXI_01_ARID,  AXI_01_ARLEN, AXI_01_ARSIZE, AXI_01_ARVALID, 
    AXI_01_AWADDR, AXI_01_AWBURST, AXI_01_AWID,  AXI_01_AWLEN, AXI_01_AWSIZE, AXI_01_AWVALID, 
    AXI_01_RREADY, AXI_01_BREADY,  AXI_01_WDATA, AXI_01_WLAST, AXI_01_WSTRB,  AXI_01_WVALID,  
    //AXI_01_WDATA_PARITY, 
    AXI_01_ARREADY, AXI_01_AWREADY, AXI_01_RDATA, AXI_01_RID,   AXI_01_RLAST,  AXI_01_RRESP, 
    AXI_01_RVALID,  AXI_01_WREADY,  AXI_01_BID,   AXI_01_BRESP, AXI_01_BVALID, 
    AXI_01_RDATA_PARITY, 
    AXI_02_ARADDR, AXI_02_ARBURST, AXI_02_ARID,  AXI_02_ARLEN, AXI_02_ARSIZE, AXI_02_ARVALID, 
    AXI_02_AWADDR, AXI_02_AWBURST, AXI_02_AWID,  AXI_02_AWLEN, AXI_02_AWSIZE, AXI_02_AWVALID, 
    AXI_02_RREADY, AXI_02_BREADY,  AXI_02_WDATA, AXI_02_WLAST, AXI_02_WSTRB,  AXI_02_WVALID,  
    //AXI_02_WDATA_PARITY, 
    AXI_02_ARREADY, AXI_02_AWREADY, AXI_02_RDATA, AXI_02_RID,   AXI_02_RLAST,  AXI_02_RRESP, 
    AXI_02_RVALID,  AXI_02_WREADY,  AXI_02_BID,   AXI_02_BRESP, AXI_02_BVALID, 
    AXI_02_RDATA_PARITY, 
    AXI_03_ARADDR, AXI_03_ARBURST, AXI_03_ARID,  AXI_03_ARLEN, AXI_03_ARSIZE, AXI_03_ARVALID, 
    AXI_03_AWADDR, AXI_03_AWBURST, AXI_03_AWID,  AXI_03_AWLEN, AXI_03_AWSIZE, AXI_03_AWVALID, 
    AXI_03_RREADY, AXI_03_BREADY,  AXI_03_WDATA, AXI_03_WLAST, AXI_03_WSTRB,  AXI_03_WVALID, 
    //AXI_03_WDATA_PARITY, 
    AXI_03_ARREADY, AXI_03_AWREADY, AXI_03_RDATA, AXI_03_RID,   AXI_03_RLAST,  AXI_03_RRESP, 
    AXI_03_RVALID,  AXI_03_WREADY,  AXI_03_BID,   AXI_03_BRESP, AXI_03_BVALID, 
    AXI_03_RDATA_PARITY, 
    AXI_04_ARADDR, AXI_04_ARBURST, AXI_04_ARID,  AXI_04_ARLEN, AXI_04_ARSIZE, AXI_04_ARVALID, 
    AXI_04_AWADDR, AXI_04_AWBURST, AXI_04_AWID,  AXI_04_AWLEN, AXI_04_AWSIZE, AXI_04_AWVALID, 
    AXI_04_RREADY, AXI_04_BREADY,  AXI_04_WDATA, AXI_04_WLAST, AXI_04_WSTRB,  AXI_04_WVALID, 
    //AXI_04_WDATA_PARITY, 
    AXI_04_ARREADY, AXI_04_AWREADY, AXI_04_RDATA, AXI_04_RID,   AXI_04_RLAST,  AXI_04_RRESP, 
    AXI_04_RVALID,  AXI_04_WREADY,  AXI_04_BID,   AXI_04_BRESP, AXI_04_BVALID, 
    AXI_04_RDATA_PARITY, 
    AXI_05_ARADDR, AXI_05_ARBURST, AXI_05_ARID,  AXI_05_ARLEN, AXI_05_ARSIZE, AXI_05_ARVALID, 
    AXI_05_AWADDR, AXI_05_AWBURST, AXI_05_AWID,  AXI_05_AWLEN, AXI_05_AWSIZE, AXI_05_AWVALID, 
    AXI_05_RREADY, AXI_05_BREADY,  AXI_05_WDATA, AXI_05_WLAST, AXI_05_WSTRB,  AXI_05_WVALID, 
    //AXI_05_WDATA_PARITY, 
    AXI_05_ARREADY, AXI_05_AWREADY, AXI_05_RDATA, AXI_05_RID,   AXI_05_RLAST,  AXI_05_RRESP, 
    AXI_05_RVALID,  AXI_05_WREADY,  AXI_05_BID,   AXI_05_BRESP, AXI_05_BVALID, 
    AXI_05_RDATA_PARITY, 
    AXI_06_ARADDR, AXI_06_ARBURST, AXI_06_ARID,  AXI_06_ARLEN, AXI_06_ARSIZE, AXI_06_ARVALID, 
    AXI_06_AWADDR, AXI_06_AWBURST, AXI_06_AWID,  AXI_06_AWLEN, AXI_06_AWSIZE, AXI_06_AWVALID, 
    AXI_06_RREADY, AXI_06_BREADY,  AXI_06_WDATA, AXI_06_WLAST, AXI_06_WSTRB,  AXI_06_WVALID, 
    //AXI_06_WDATA_PARITY, 
    AXI_06_ARREADY, AXI_06_AWREADY, AXI_06_RDATA, AXI_06_RID,   AXI_06_RLAST,  AXI_06_RRESP, 
    AXI_06_RVALID,  AXI_06_WREADY,  AXI_06_BID,   AXI_06_BRESP, AXI_06_BVALID, 
    AXI_06_RDATA_PARITY, 
    AXI_07_ARADDR, AXI_07_ARBURST, AXI_07_ARID,  AXI_07_ARLEN, AXI_07_ARSIZE, AXI_07_ARVALID, 
    AXI_07_AWADDR, AXI_07_AWBURST, AXI_07_AWID,  AXI_07_AWLEN, AXI_07_AWSIZE, AXI_07_AWVALID, 
    AXI_07_RREADY, AXI_07_BREADY,  AXI_07_WDATA, AXI_07_WLAST, AXI_07_WSTRB,  AXI_07_WVALID, 
    //AXI_07_WDATA_PARITY, 
    AXI_07_ARREADY, AXI_07_AWREADY, AXI_07_RDATA, AXI_07_RID,   AXI_07_RLAST,  AXI_07_RRESP, 
    AXI_07_RVALID,  AXI_07_WREADY,  AXI_07_BID,   AXI_07_BRESP, AXI_07_BVALID, 
    AXI_07_RDATA_PARITY, 
    AXI_08_ARADDR, AXI_08_ARBURST, AXI_08_ARID,  AXI_08_ARLEN, AXI_08_ARSIZE, AXI_08_ARVALID, 
    AXI_08_AWADDR, AXI_08_AWBURST, AXI_08_AWID,  AXI_08_AWLEN, AXI_08_AWSIZE, AXI_08_AWVALID, 
    AXI_08_RREADY, AXI_08_BREADY,  AXI_08_WDATA, AXI_08_WLAST, AXI_08_WSTRB,  AXI_08_WVALID, 
    //AXI_08_WDATA_PARITY, 
    AXI_08_ARREADY, AXI_08_AWREADY, AXI_08_RDATA, AXI_08_RID,   AXI_08_RLAST,  AXI_08_RRESP, 
    AXI_08_RVALID,  AXI_08_WREADY,  AXI_08_BID,   AXI_08_BRESP, AXI_08_BVALID, 
    AXI_08_RDATA_PARITY, 
    AXI_09_ARADDR, AXI_09_ARBURST, AXI_09_ARID,  AXI_09_ARLEN, AXI_09_ARSIZE, AXI_09_ARVALID, 
    AXI_09_AWADDR, AXI_09_AWBURST, AXI_09_AWID,  AXI_09_AWLEN, AXI_09_AWSIZE, AXI_09_AWVALID, 
    AXI_09_RREADY, AXI_09_BREADY,  AXI_09_WDATA, AXI_09_WLAST, AXI_09_WSTRB,  AXI_09_WVALID, 
    //AXI_09_WDATA_PARITY, 
    AXI_09_ARREADY, AXI_09_AWREADY, AXI_09_RDATA, AXI_09_RID,   AXI_09_RLAST,  AXI_09_RRESP, 
    AXI_09_RVALID,  AXI_09_WREADY,  AXI_09_BID,   AXI_09_BRESP, AXI_09_BVALID, 
    AXI_09_RDATA_PARITY, 
    AXI_10_ARADDR, AXI_10_ARBURST, AXI_10_ARID,  AXI_10_ARLEN, AXI_10_ARSIZE, AXI_10_ARVALID, 
    AXI_10_AWADDR, AXI_10_AWBURST, AXI_10_AWID,  AXI_10_AWLEN, AXI_10_AWSIZE, AXI_10_AWVALID, 
    AXI_10_RREADY, AXI_10_BREADY,  AXI_10_WDATA, AXI_10_WLAST, AXI_10_WSTRB,  AXI_10_WVALID, 
    //AXI_10_WDATA_PARITY, 
    AXI_10_ARREADY, AXI_10_AWREADY, AXI_10_RDATA, AXI_10_RID,   AXI_10_RLAST,  AXI_10_RRESP, 
    AXI_10_RVALID,  AXI_10_WREADY,  AXI_10_BID,   AXI_10_BRESP, AXI_10_BVALID, 
    AXI_10_RDATA_PARITY, 
    AXI_11_ARADDR, AXI_11_ARBURST, AXI_11_ARID,  AXI_11_ARLEN, AXI_11_ARSIZE, AXI_11_ARVALID, 
    AXI_11_AWADDR, AXI_11_AWBURST, AXI_11_AWID,  AXI_11_AWLEN, AXI_11_AWSIZE, AXI_11_AWVALID, 
    AXI_11_RREADY, AXI_11_BREADY,  AXI_11_WDATA, AXI_11_WLAST, AXI_11_WSTRB,  AXI_11_WVALID, 
    //AXI_11_WDATA_PARITY, 
    AXI_11_ARREADY, AXI_11_AWREADY, AXI_11_RDATA, AXI_11_RID,   AXI_11_RLAST,  AXI_11_RRESP, 
    AXI_11_RVALID,  AXI_11_WREADY,  AXI_11_BID,   AXI_11_BRESP, AXI_11_BVALID, 
    AXI_11_RDATA_PARITY, 
    AXI_12_ARADDR, AXI_12_ARBURST, AXI_12_ARID,  AXI_12_ARLEN, AXI_12_ARSIZE, AXI_12_ARVALID, 
    AXI_12_AWADDR, AXI_12_AWBURST, AXI_12_AWID,  AXI_12_AWLEN, AXI_12_AWSIZE, AXI_12_AWVALID, 
    AXI_12_RREADY, AXI_12_BREADY,  AXI_12_WDATA, AXI_12_WLAST, AXI_12_WSTRB,  AXI_12_WVALID, 
    //AXI_12_WDATA_PARITY, 
    AXI_12_ARREADY, AXI_12_AWREADY, AXI_12_RDATA, AXI_12_RID,   AXI_12_RLAST,  AXI_12_RRESP, 
    AXI_12_RVALID,  AXI_12_WREADY,  AXI_12_BID,   AXI_12_BRESP, AXI_12_BVALID, 
    AXI_12_RDATA_PARITY, 
    AXI_13_ARADDR, AXI_13_ARBURST, AXI_13_ARID,  AXI_13_ARLEN, AXI_13_ARSIZE, AXI_13_ARVALID, 
    AXI_13_AWADDR, AXI_13_AWBURST, AXI_13_AWID,  AXI_13_AWLEN, AXI_13_AWSIZE, AXI_13_AWVALID, 
    AXI_13_RREADY, AXI_13_BREADY,  AXI_13_WDATA, AXI_13_WLAST, AXI_13_WSTRB,  AXI_13_WVALID, 
    //AXI_13_WDATA_PARITY, 
    AXI_13_ARREADY, AXI_13_AWREADY, AXI_13_RDATA, AXI_13_RID,   AXI_13_RLAST,  AXI_13_RRESP, 
    AXI_13_RVALID,  AXI_13_WREADY,  AXI_13_BID,   AXI_13_BRESP, AXI_13_BVALID, 
    AXI_13_RDATA_PARITY, 
    AXI_14_ARADDR, AXI_14_ARBURST, AXI_14_ARID,  AXI_14_ARLEN, AXI_14_ARSIZE, AXI_14_ARVALID, 
    AXI_14_AWADDR, AXI_14_AWBURST, AXI_14_AWID,  AXI_14_AWLEN, AXI_14_AWSIZE, AXI_14_AWVALID, 
    AXI_14_RREADY, AXI_14_BREADY,  AXI_14_WDATA, AXI_14_WLAST, AXI_14_WSTRB,  AXI_14_WVALID, 
    //AXI_14_WDATA_PARITY, 
    AXI_14_ARREADY, AXI_14_AWREADY, AXI_14_RDATA, AXI_14_RID,   AXI_14_RLAST,  AXI_14_RRESP, 
    AXI_14_RVALID,  AXI_14_WREADY,  AXI_14_BID,   AXI_14_BRESP, AXI_14_BVALID, 
    AXI_14_RDATA_PARITY, 
    AXI_15_ARADDR, AXI_15_ARBURST, AXI_15_ARID,  AXI_15_ARLEN, AXI_15_ARSIZE, AXI_15_ARVALID, 
    AXI_15_AWADDR, AXI_15_AWBURST, AXI_15_AWID,  AXI_15_AWLEN, AXI_15_AWSIZE, AXI_15_AWVALID, 
    AXI_15_RREADY, AXI_15_BREADY,  AXI_15_WDATA, AXI_15_WLAST, AXI_15_WSTRB,  AXI_15_WVALID, 
    //AXI_15_WDATA_PARITY, 
    AXI_15_ARREADY, AXI_15_AWREADY, AXI_15_RDATA, AXI_15_RID,   AXI_15_RLAST,  AXI_15_RRESP, 
    AXI_15_RVALID,  AXI_15_WREADY,  AXI_15_BID,   AXI_15_BRESP, AXI_15_BVALID, 
    AXI_15_RDATA_PARITY, 
    
    APB_0_PWDATA, APB_0_PADDR, APB_0_PSEL, APB_0_PWRITE, APB_0_PENABLE, 
    APB_0_PRDATA, APB_0_PREADY, APB_0_PSLVERR, 
    apb_complete_0, 

    AXI_ACLK_00, AXI_ACLK_01, AXI_ACLK_02, AXI_ACLK_03, 
    AXI_ACLK_04, AXI_ACLK_05, AXI_ACLK_06,

    DRAM_0_STAT_CATTRIP, DRAM_0_STAT_TEMP 
    );

////////////////////////////////////////////////////////////////////////////////
// Localparams
////////////////////////////////////////////////////////////////////////////////
  parameter APP_DATA_WIDTH   = 256 ; 
  parameter APP_ADDR_WIDTH   = 33  ; 
  localparam MMCM_CLKFBOUT_MULT_F  = 48;
  localparam MMCM_CLKOUT0_DIVIDE_F = 2;
  localparam MMCM_DIVCLK_DIVIDE    = 6;
  localparam MMCM_CLKIN1_PERIOD    = 10.000;
  
  localparam MMCM1_CLKFBOUT_MULT_F  = 48;
  localparam MMCM1_CLKOUT0_DIVIDE_F = 2;
  localparam MMCM1_DIVCLK_DIVIDE    = 6;
  localparam MMCM1_CLKIN1_PERIOD    = 10.000;

////////////////////////////////////////////////////////////////////////////////
// Wire Delcaration
////////////////////////////////////////////////////////////////////////////////
    input wire                      AXI_ACLK_IN_0 ; 
    input wire                      AXI_ARESET_N_0 ; 
    input wire                      HBM_REF_CLK_0 ;
    output wire                     AXI_ACLK ; 
    
    output wire                     AXI_ACLK_00 ;
    output wire                     AXI_ACLK_01 ;
    output wire                     AXI_ACLK_02 ;
    output wire                     AXI_ACLK_03 ;
    output wire                     AXI_ACLK_04 ;
    output wire                     AXI_ACLK_05 ;
    output wire                     AXI_ACLK_06 ;
    
    
    input wire [32 : 0]             AXI_00_ARADDR ;
    input wire [1 : 0]              AXI_00_ARBURST ;
    input wire [5 : 0]              AXI_00_ARID ;
    input wire [3 : 0]              AXI_00_ARLEN ;
    input wire [2 : 0]              AXI_00_ARSIZE ;
    input wire                      AXI_00_ARVALID ;
    input wire [32 : 0]             AXI_00_AWADDR ;
    input wire [1 : 0]              AXI_00_AWBURST ;
    input wire [5 : 0]              AXI_00_AWID ;
    input wire [3 : 0]              AXI_00_AWLEN ;
    input wire [2 : 0]              AXI_00_AWSIZE ;
    input wire                      AXI_00_AWVALID ;
    input wire                      AXI_00_RREADY ;
    input wire                      AXI_00_BREADY ;
    input wire [255 : 0]            AXI_00_WDATA ;
    input wire                      AXI_00_WLAST ;
    input wire [31 : 0]             AXI_00_WSTRB ;
    input wire                      AXI_00_WVALID ;
    input wire [32 : 0]             AXI_01_ARADDR ;
    input wire [1 : 0]              AXI_01_ARBURST ;
    input wire [5 : 0]              AXI_01_ARID ;
    input wire [3 : 0]              AXI_01_ARLEN ;
    input wire [2 : 0]              AXI_01_ARSIZE ;
    input wire                      AXI_01_ARVALID ;
    input wire [32 : 0]             AXI_01_AWADDR ;
    input wire [1 : 0]              AXI_01_AWBURST ;
    input wire [5 : 0]              AXI_01_AWID ;
    input wire [3 : 0]              AXI_01_AWLEN ;
    input wire [2 : 0]              AXI_01_AWSIZE ;
    input wire                      AXI_01_AWVALID ;
    input wire                      AXI_01_RREADY ;
    input wire                      AXI_01_BREADY ;
    input wire [255 : 0]            AXI_01_WDATA ;
    input wire                      AXI_01_WLAST ;
    input wire [31 : 0]             AXI_01_WSTRB ;
    input wire                      AXI_01_WVALID ;
    input wire [32 : 0]             AXI_02_ARADDR ;
    input wire [1 : 0]              AXI_02_ARBURST ;
    input wire [5 : 0]              AXI_02_ARID ;
    input wire [3 : 0]              AXI_02_ARLEN ;
    input wire [2 : 0]              AXI_02_ARSIZE ;
    input wire                      AXI_02_ARVALID ;
    input wire [32 : 0]             AXI_02_AWADDR ;
    input wire [1 : 0]              AXI_02_AWBURST ;
    input wire [5 : 0]              AXI_02_AWID ;
    input wire [3 : 0]              AXI_02_AWLEN ;
    input wire [2 : 0]              AXI_02_AWSIZE ;
    input wire                      AXI_02_AWVALID ;
    input wire                      AXI_02_RREADY ;
    input wire                      AXI_02_BREADY ;
    input wire [255 : 0]            AXI_02_WDATA ;
    input wire                      AXI_02_WLAST ;
    input wire [31 : 0]             AXI_02_WSTRB ;
    input wire                      AXI_02_WVALID ;
    input wire [32 : 0]             AXI_03_ARADDR ;
    input wire [1 : 0]              AXI_03_ARBURST ;
    input wire [5 : 0]              AXI_03_ARID ;
    input wire [3 : 0]              AXI_03_ARLEN ;
    input wire [2 : 0]              AXI_03_ARSIZE ;
    input wire                      AXI_03_ARVALID ;
    input wire [32 : 0]             AXI_03_AWADDR ;
    input wire [1 : 0]              AXI_03_AWBURST ;
    input wire [5 : 0]              AXI_03_AWID ;
    input wire [3 : 0]              AXI_03_AWLEN ;
    input wire [2 : 0]              AXI_03_AWSIZE ;
    input wire                      AXI_03_AWVALID ;
    input wire                      AXI_03_RREADY ;
    input wire                      AXI_03_BREADY ;
    input wire [255 : 0]            AXI_03_WDATA ;
    input wire                      AXI_03_WLAST ;
    input wire [31 : 0]             AXI_03_WSTRB ;
    input wire                      AXI_03_WVALID ;
    input wire [32 : 0]             AXI_04_ARADDR ;
    input wire [1 : 0]              AXI_04_ARBURST ;
    input wire [5 : 0]              AXI_04_ARID ;
    input wire [3 : 0]              AXI_04_ARLEN ;
    input wire [2 : 0]              AXI_04_ARSIZE ;
    input wire                      AXI_04_ARVALID ;
    input wire [32 : 0]             AXI_04_AWADDR ;
    input wire [1 : 0]              AXI_04_AWBURST ;
    input wire [5 : 0]              AXI_04_AWID ;
    input wire [3 : 0]              AXI_04_AWLEN ;
    input wire [2 : 0]              AXI_04_AWSIZE ;
    input wire                      AXI_04_AWVALID ;
    input wire                      AXI_04_RREADY ;
    input wire                      AXI_04_BREADY ;
    input wire [255 : 0]            AXI_04_WDATA ;
    input wire                      AXI_04_WLAST ;
    input wire [31 : 0]             AXI_04_WSTRB ;
    input wire                      AXI_04_WVALID ;
    input wire [32 : 0]             AXI_05_ARADDR ;
    input wire [1 : 0]              AXI_05_ARBURST ;
    input wire [5 : 0]              AXI_05_ARID ;
    input wire [3 : 0]              AXI_05_ARLEN ;
    input wire [2 : 0]              AXI_05_ARSIZE ;
    input wire                      AXI_05_ARVALID ;
    input wire [32 : 0]             AXI_05_AWADDR ;
    input wire [1 : 0]              AXI_05_AWBURST ;
    input wire [5 : 0]              AXI_05_AWID ;
    input wire [3 : 0]              AXI_05_AWLEN ;
    input wire [2 : 0]              AXI_05_AWSIZE ;
    input wire                      AXI_05_AWVALID ;
    input wire                      AXI_05_RREADY ;
    input wire                      AXI_05_BREADY ;
    input wire [255 : 0]            AXI_05_WDATA ;
    input wire                      AXI_05_WLAST ;
    input wire [31 : 0]             AXI_05_WSTRB ;
    input wire                      AXI_05_WVALID ;
    input wire [32 : 0]             AXI_06_ARADDR ;
    input wire [1 : 0]              AXI_06_ARBURST ;
    input wire [5 : 0]              AXI_06_ARID ;
    input wire [3 : 0]              AXI_06_ARLEN ;
    input wire [2 : 0]              AXI_06_ARSIZE ;
    input wire                      AXI_06_ARVALID ;
    input wire [32 : 0]             AXI_06_AWADDR ;
    input wire [1 : 0]              AXI_06_AWBURST ;
    input wire [5 : 0]              AXI_06_AWID ;
    input wire [3 : 0]              AXI_06_AWLEN ;
    input wire [2 : 0]              AXI_06_AWSIZE ;
    input wire                      AXI_06_AWVALID ;
    input wire                      AXI_06_RREADY ;
    input wire                      AXI_06_BREADY ;
    input wire [255 : 0]            AXI_06_WDATA ;
    input wire                      AXI_06_WLAST ;
    input wire [31 : 0]             AXI_06_WSTRB ;
    input wire                      AXI_06_WVALID ;
    input wire [32 : 0]             AXI_07_ARADDR ;
    input wire [1 : 0]              AXI_07_ARBURST ;
    input wire [5 : 0]              AXI_07_ARID ;
    input wire [3 : 0]              AXI_07_ARLEN ;
    input wire [2 : 0]              AXI_07_ARSIZE ;
    input wire                      AXI_07_ARVALID ;
    input wire [32 : 0]             AXI_07_AWADDR ;
    input wire [1 : 0]              AXI_07_AWBURST ;
    input wire [5 : 0]              AXI_07_AWID ;
    input wire [3 : 0]              AXI_07_AWLEN ;
    input wire [2 : 0]              AXI_07_AWSIZE ;
    input wire                      AXI_07_AWVALID ;
    input wire                      AXI_07_RREADY ;
    input wire                      AXI_07_BREADY ;
    input wire [255 : 0]            AXI_07_WDATA ;
    input wire                      AXI_07_WLAST ;
    input wire [31 : 0]             AXI_07_WSTRB ;
    input wire                      AXI_07_WVALID ;
    input wire [32 : 0]             AXI_08_ARADDR ;
    input wire [1 : 0]              AXI_08_ARBURST ;
    input wire [5 : 0]              AXI_08_ARID ;
    input wire [3 : 0]              AXI_08_ARLEN ;
    input wire [2 : 0]              AXI_08_ARSIZE ;
    input wire                      AXI_08_ARVALID ;
    input wire [32 : 0]             AXI_08_AWADDR ;
    input wire [1 : 0]              AXI_08_AWBURST ;
    input wire [5 : 0]              AXI_08_AWID ;
    input wire [3 : 0]              AXI_08_AWLEN ;
    input wire [2 : 0]              AXI_08_AWSIZE ;
    input wire                      AXI_08_AWVALID ;
    input wire                      AXI_08_RREADY ;
    input wire                      AXI_08_BREADY ;
    input wire [255 : 0]            AXI_08_WDATA ;
    input wire                      AXI_08_WLAST ;
    input wire [31 : 0]             AXI_08_WSTRB ;
    input wire                      AXI_08_WVALID ;
    input wire [32 : 0]             AXI_09_ARADDR ;
    input wire [1 : 0]              AXI_09_ARBURST ;
    input wire [5 : 0]              AXI_09_ARID ;
    input wire [3 : 0]              AXI_09_ARLEN ;
    input wire [2 : 0]              AXI_09_ARSIZE ;
    input wire                      AXI_09_ARVALID ;
    input wire [32 : 0]             AXI_09_AWADDR ;
    input wire [1 : 0]              AXI_09_AWBURST ;
    input wire [5 : 0]              AXI_09_AWID ;
    input wire [3 : 0]              AXI_09_AWLEN ;
    input wire [2 : 0]              AXI_09_AWSIZE ;
    input wire                      AXI_09_AWVALID ;
    input wire                      AXI_09_RREADY ;
    input wire                      AXI_09_BREADY ;
    input wire [255 : 0]            AXI_09_WDATA ;
    input wire                      AXI_09_WLAST ;
    input wire [31 : 0]             AXI_09_WSTRB ;
    input wire                      AXI_09_WVALID ;
    input wire [32 : 0]             AXI_10_ARADDR ;
    input wire [1 : 0]              AXI_10_ARBURST ;
    input wire [5 : 0]              AXI_10_ARID ;
    input wire [3 : 0]              AXI_10_ARLEN ;
    input wire [2 : 0]              AXI_10_ARSIZE ;
    input wire                      AXI_10_ARVALID ;
    input wire [32 : 0]             AXI_10_AWADDR ;
    input wire [1 : 0]              AXI_10_AWBURST ;
    input wire [5 : 0]              AXI_10_AWID ;
    input wire [3 : 0]              AXI_10_AWLEN ;
    input wire [2 : 0]              AXI_10_AWSIZE ;
    input wire                      AXI_10_AWVALID ;
    input wire                      AXI_10_RREADY ;
    input wire                      AXI_10_BREADY ;
    input wire [255 : 0]            AXI_10_WDATA ;
    input wire                      AXI_10_WLAST ;
    input wire [31 : 0]             AXI_10_WSTRB ;
    input wire                      AXI_10_WVALID ;
    input wire [32 : 0]             AXI_11_ARADDR ;
    input wire [1 : 0]              AXI_11_ARBURST ;
    input wire [5 : 0]              AXI_11_ARID ;
    input wire [3 : 0]              AXI_11_ARLEN ;
    input wire [2 : 0]              AXI_11_ARSIZE ;
    input wire                      AXI_11_ARVALID ;
    input wire [32 : 0]             AXI_11_AWADDR ;
    input wire [1 : 0]              AXI_11_AWBURST ;
    input wire [5 : 0]              AXI_11_AWID ;
    input wire [3 : 0]              AXI_11_AWLEN ;
    input wire [2 : 0]              AXI_11_AWSIZE ;
    input wire                      AXI_11_AWVALID ;
    input wire                      AXI_11_RREADY ;
    input wire                      AXI_11_BREADY ;
    input wire [255 : 0]            AXI_11_WDATA ;
    input wire                      AXI_11_WLAST ;
    input wire [31 : 0]             AXI_11_WSTRB ;
    input wire                      AXI_11_WVALID ;
    input wire [32 : 0]             AXI_12_ARADDR ;
    input wire [1 : 0]              AXI_12_ARBURST ;
    input wire [5 : 0]              AXI_12_ARID ;
    input wire [3 : 0]              AXI_12_ARLEN ;
    input wire [2 : 0]              AXI_12_ARSIZE ;
    input wire                      AXI_12_ARVALID ;
    input wire [32 : 0]             AXI_12_AWADDR ;
    input wire [1 : 0]              AXI_12_AWBURST ;
    input wire [5 : 0]              AXI_12_AWID ;
    input wire [3 : 0]              AXI_12_AWLEN ;
    input wire [2 : 0]              AXI_12_AWSIZE ;
    input wire                      AXI_12_AWVALID ;
    input wire                      AXI_12_RREADY ;
    input wire                      AXI_12_BREADY ;
    input wire [255 : 0]            AXI_12_WDATA ;
    input wire                      AXI_12_WLAST ;
    input wire [31 : 0]             AXI_12_WSTRB ;
    input wire                      AXI_12_WVALID ;
    input wire [32 : 0]             AXI_13_ARADDR ;
    input wire [1 : 0]              AXI_13_ARBURST ;
    input wire [5 : 0]              AXI_13_ARID ;
    input wire [3 : 0]              AXI_13_ARLEN ;
    input wire [2 : 0]              AXI_13_ARSIZE ;
    input wire                      AXI_13_ARVALID ;
    input wire [32 : 0]             AXI_13_AWADDR ;
    input wire [1 : 0]              AXI_13_AWBURST ;
    input wire [5 : 0]              AXI_13_AWID ;
    input wire [3 : 0]              AXI_13_AWLEN ;
    input wire [2 : 0]              AXI_13_AWSIZE ;
    input wire                      AXI_13_AWVALID ;
    input wire                      AXI_13_RREADY ;
    input wire                      AXI_13_BREADY ;
    input wire [255 : 0]            AXI_13_WDATA ;
    input wire                      AXI_13_WLAST ;
    input wire [31 : 0]             AXI_13_WSTRB ;
    input wire                      AXI_13_WVALID ;
    input wire [32 : 0]             AXI_14_ARADDR ;
    input wire [1 : 0]              AXI_14_ARBURST ;
    input wire [5 : 0]              AXI_14_ARID ;
    input wire [3 : 0]              AXI_14_ARLEN ;
    input wire [2 : 0]              AXI_14_ARSIZE ;
    input wire                      AXI_14_ARVALID ;
    input wire [32 : 0]             AXI_14_AWADDR ;
    input wire [1 : 0]              AXI_14_AWBURST ;
    input wire [5 : 0]              AXI_14_AWID ;
    input wire [3 : 0]              AXI_14_AWLEN ;
    input wire [2 : 0]              AXI_14_AWSIZE ;
    input wire                      AXI_14_AWVALID ;
    input wire                      AXI_14_RREADY ;
    input wire                      AXI_14_BREADY ;
    input wire [255 : 0]            AXI_14_WDATA ;
    input wire                      AXI_14_WLAST ;
    input wire [31 : 0]             AXI_14_WSTRB ;
    input wire                      AXI_14_WVALID ;
    input wire [32 : 0]             AXI_15_ARADDR ;
    input wire [1 : 0]              AXI_15_ARBURST ;
    input wire [5 : 0]              AXI_15_ARID ;
    input wire [3 : 0]              AXI_15_ARLEN ;
    input wire [2 : 0]              AXI_15_ARSIZE ;
    input wire                      AXI_15_ARVALID ;
    input wire [32 : 0]             AXI_15_AWADDR ;
    input wire [1 : 0]              AXI_15_AWBURST ;
    input wire [5 : 0]              AXI_15_AWID ;
    input wire [3 : 0]              AXI_15_AWLEN ;
    input wire [2 : 0]              AXI_15_AWSIZE ;
    input wire                      AXI_15_AWVALID ;
    input wire                      AXI_15_RREADY ;
    input wire                      AXI_15_BREADY ;
    input wire [255 : 0]            AXI_15_WDATA ;
    input wire                      AXI_15_WLAST ;
    input wire [31 : 0]             AXI_15_WSTRB ;
    input wire                      AXI_15_WVALID ;
    input wire [31 : 0]             APB_0_PWDATA ;
    input wire [21 : 0]             APB_0_PADDR ;
    (* mark_debug = "true" *)input wire                      APB_0_PCLK ;
    (* mark_debug = "true" *)input wire                      APB_0_PENABLE ;
    (* mark_debug = "true" *)input wire                      APB_0_PRESET_N ;
    (* mark_debug = "true" *)input wire                      APB_0_PSEL ;
    (* mark_debug = "true" *)input wire                      APB_0_PWRITE ;
    output wire                     AXI_00_ARREADY ;
    output wire                     AXI_00_AWREADY ;
    output wire [31 : 0]            AXI_00_RDATA_PARITY ;
    output wire [255 : 0]           AXI_00_RDATA ;
    output wire [5 : 0]             AXI_00_RID ;
    output wire                     AXI_00_RLAST ;
    output wire [1 : 0]             AXI_00_RRESP ;
    output wire                     AXI_00_RVALID ;
    output wire                     AXI_00_WREADY ;
    output wire [5 : 0]             AXI_00_BID ;
    output wire [1 : 0]             AXI_00_BRESP ;
    output wire                     AXI_00_BVALID ;
    output wire                     AXI_01_ARREADY ;
    output wire                     AXI_01_AWREADY ;
    output wire [31 : 0]            AXI_01_RDATA_PARITY ;
    output wire [255 : 0]           AXI_01_RDATA ;
    output wire [5 : 0]             AXI_01_RID ;
    output wire                     AXI_01_RLAST ;
    output wire [1 : 0]             AXI_01_RRESP ;
    output wire                     AXI_01_RVALID ;
    output wire                     AXI_01_WREADY ;
    output wire [5 : 0]             AXI_01_BID ;
    output wire [1 : 0]             AXI_01_BRESP ;
    output wire                     AXI_01_BVALID ;
    output wire                     AXI_02_ARREADY ;
    output wire                     AXI_02_AWREADY ;
    output wire [31 : 0]            AXI_02_RDATA_PARITY ;
    output wire [255 : 0]           AXI_02_RDATA ;
    output wire [5 : 0]             AXI_02_RID ;
    output wire                     AXI_02_RLAST ;
    output wire [1 : 0]             AXI_02_RRESP ;
    output wire                     AXI_02_RVALID ;
    output wire                     AXI_02_WREADY ;
    output wire [5 : 0]             AXI_02_BID ;
    output wire [1 : 0]             AXI_02_BRESP ;
    output wire                     AXI_02_BVALID ;
    output wire                     AXI_03_ARREADY ;
    output wire                     AXI_03_AWREADY ;
    output wire [31 : 0]            AXI_03_RDATA_PARITY ;
    output wire [255 : 0]           AXI_03_RDATA ;
    output wire [5 : 0]             AXI_03_RID ;
    output wire                     AXI_03_RLAST ;
    output wire [1 : 0]             AXI_03_RRESP ;
    output wire                     AXI_03_RVALID ;
    output wire                     AXI_03_WREADY ;
    output wire [5 : 0]             AXI_03_BID ;
    output wire [1 : 0]             AXI_03_BRESP ;
    output wire                     AXI_03_BVALID ;
    output wire                     AXI_04_ARREADY ;
    output wire                     AXI_04_AWREADY ;
    output wire [31 : 0]            AXI_04_RDATA_PARITY ;
    output wire [255 : 0]           AXI_04_RDATA ;
    output wire [5 : 0]             AXI_04_RID ;
    output wire                     AXI_04_RLAST ;
    output wire [1 : 0]             AXI_04_RRESP ;
    output wire                     AXI_04_RVALID ;
    output wire                     AXI_04_WREADY ;
    output wire [5 : 0]             AXI_04_BID ;
    output wire [1 : 0]             AXI_04_BRESP ;
    output wire                     AXI_04_BVALID ;
    output wire                     AXI_05_ARREADY ;
    output wire                     AXI_05_AWREADY ;
    output wire [31 : 0]            AXI_05_RDATA_PARITY ;
    output wire [255 : 0]           AXI_05_RDATA ;
    output wire [5 : 0]             AXI_05_RID ;
    output wire                     AXI_05_RLAST ;
    output wire [1 : 0]             AXI_05_RRESP ;
    output wire                     AXI_05_RVALID ;
    output wire                     AXI_05_WREADY ;
    output wire [5 : 0]             AXI_05_BID ;
    output wire [1 : 0]             AXI_05_BRESP ;
    output wire                     AXI_05_BVALID ;
    output wire                     AXI_06_ARREADY ;
    output wire                     AXI_06_AWREADY ;
    output wire [31 : 0]            AXI_06_RDATA_PARITY ;
    output wire [255 : 0]           AXI_06_RDATA ;
    output wire [5 : 0]             AXI_06_RID ;
    output wire                     AXI_06_RLAST ;
    output wire [1 : 0]             AXI_06_RRESP ;
    output wire                     AXI_06_RVALID ;
    output wire                     AXI_06_WREADY ;
    output wire [5 : 0]             AXI_06_BID ;
    output wire [1 : 0]             AXI_06_BRESP ;
    output wire                     AXI_06_BVALID ;
    output wire                     AXI_07_ARREADY ;
    output wire                     AXI_07_AWREADY ;
    output wire [31 : 0]            AXI_07_RDATA_PARITY ;
    output wire [255 : 0]           AXI_07_RDATA ;
    output wire [5 : 0]             AXI_07_RID ;
    output wire                     AXI_07_RLAST ;
    output wire [1 : 0]             AXI_07_RRESP ;
    output wire                     AXI_07_RVALID ;
    output wire                     AXI_07_WREADY ;
    output wire [5 : 0]             AXI_07_BID ;
    output wire [1 : 0]             AXI_07_BRESP ;
    output wire                     AXI_07_BVALID ;
    output wire                     AXI_08_ARREADY ;
    output wire                     AXI_08_AWREADY ;
    output wire [31 : 0]            AXI_08_RDATA_PARITY ;
    output wire [255 : 0]           AXI_08_RDATA ;
    output wire [5 : 0]             AXI_08_RID ;
    output wire                     AXI_08_RLAST ;
    output wire [1 : 0]             AXI_08_RRESP ;
    output wire                     AXI_08_RVALID ;
    output wire                     AXI_08_WREADY ;
    output wire [5 : 0]             AXI_08_BID ;
    output wire [1 : 0]             AXI_08_BRESP ;
    output wire                     AXI_08_BVALID ;
    output wire                     AXI_09_ARREADY ;
    output wire                     AXI_09_AWREADY ;
    output wire [31 : 0]            AXI_09_RDATA_PARITY ;
    output wire [255 : 0]           AXI_09_RDATA ;
    output wire [5 : 0]             AXI_09_RID ;
    output wire                     AXI_09_RLAST ;
    output wire [1 : 0]             AXI_09_RRESP ;
    output wire                     AXI_09_RVALID ;
    output wire                     AXI_09_WREADY ;
    output wire [5 : 0]             AXI_09_BID ;
    output wire [1 : 0]             AXI_09_BRESP ;
    output wire                     AXI_09_BVALID ;
    output wire                     AXI_10_ARREADY ;
    output wire                     AXI_10_AWREADY ;
    output wire [31 : 0]            AXI_10_RDATA_PARITY ;
    output wire [255 : 0]           AXI_10_RDATA ;
    output wire [5 : 0]             AXI_10_RID ;
    output wire                     AXI_10_RLAST ;
    output wire [1 : 0]             AXI_10_RRESP ;
    output wire                     AXI_10_RVALID ;
    output wire                     AXI_10_WREADY ;
    output wire [5 : 0]             AXI_10_BID ;
    output wire [1 : 0]             AXI_10_BRESP ;
    output wire                     AXI_10_BVALID ;
    output wire                     AXI_11_ARREADY ;
    output wire                     AXI_11_AWREADY ;
    output wire [31 : 0]            AXI_11_RDATA_PARITY ;
    output wire [255 : 0]           AXI_11_RDATA ;
    output wire [5 : 0]             AXI_11_RID ;
    output wire                     AXI_11_RLAST ;
    output wire [1 : 0]             AXI_11_RRESP ;
    output wire                     AXI_11_RVALID ;
    output wire                     AXI_11_WREADY ;
    output wire [5 : 0]             AXI_11_BID ;
    output wire [1 : 0]             AXI_11_BRESP ;
    output wire                     AXI_11_BVALID ;
    output wire                     AXI_12_ARREADY ;
    output wire                     AXI_12_AWREADY ;
    output wire [31 : 0]            AXI_12_RDATA_PARITY ;
    output wire [255 : 0]           AXI_12_RDATA ;
    output wire [5 : 0]             AXI_12_RID ;
    output wire                     AXI_12_RLAST ;
    output wire [1 : 0]             AXI_12_RRESP ;
    output wire                     AXI_12_RVALID ;
    output wire                     AXI_12_WREADY ;
    output wire [5 : 0]             AXI_12_BID ;
    output wire [1 : 0]             AXI_12_BRESP ;
    output wire                     AXI_12_BVALID ;
    output wire                     AXI_13_ARREADY ;
    output wire                     AXI_13_AWREADY ;
    output wire [31 : 0]            AXI_13_RDATA_PARITY ;
    output wire [255 : 0]           AXI_13_RDATA ;
    output wire [5 : 0]             AXI_13_RID ;
    output wire                     AXI_13_RLAST ;
    output wire [1 : 0]             AXI_13_RRESP ;
    output wire                     AXI_13_RVALID ;
    output wire                     AXI_13_WREADY ;
    output wire [5 : 0]             AXI_13_BID ;
    output wire [1 : 0]             AXI_13_BRESP ;
    output wire                     AXI_13_BVALID ;
    output wire                     AXI_14_ARREADY ;
    output wire                     AXI_14_AWREADY ;
    output wire [31 : 0]            AXI_14_RDATA_PARITY ;
    output wire [255 : 0]           AXI_14_RDATA ;
    output wire [5 : 0]             AXI_14_RID ;
    output wire                     AXI_14_RLAST ;
    output wire [1 : 0]             AXI_14_RRESP ;
    output wire                     AXI_14_RVALID ;
    output wire                     AXI_14_WREADY ;
    output wire [5 : 0]             AXI_14_BID ;
    output wire [1 : 0]             AXI_14_BRESP ;
    output wire                     AXI_14_BVALID ;
    output wire                     AXI_15_ARREADY ;
    output wire                     AXI_15_AWREADY ;
    output wire [31 : 0]            AXI_15_RDATA_PARITY ;
    output wire [255 : 0]           AXI_15_RDATA ;
    output wire [5 : 0]             AXI_15_RID ;
    output wire                     AXI_15_RLAST ;
    output wire [1 : 0]             AXI_15_RRESP ;
    output wire                     AXI_15_RVALID ;
    output wire                     AXI_15_WREADY ;
    output wire [5 : 0]             AXI_15_BID ;
    output wire [1 : 0]             AXI_15_BRESP ;
    output wire                     AXI_15_BVALID ;
    output wire [31 : 0]            APB_0_PRDATA ;
    (* mark_debug = "true" *)output wire                     APB_0_PREADY ;
    (* mark_debug = "true" *)output wire                     APB_0_PSLVERR ;
    (* mark_debug = "true" *)output wire                     apb_complete_0 ;
    output wire                     DRAM_0_STAT_CATTRIP ;
    output wire [6 : 0]             DRAM_0_STAT_TEMP ;


    ////////////////////////////////////////////////////////////////////////////////
    // Reg declaration
    ////////////////////////////////////////////////////////////////////////////////
    (* keep = "TRUE" *)   wire          AXI_ACLK_IN_0_buf ;
    (* keep = "TRUE" *)   wire          AXI_ACLK_IN_0_iobuf ;
    (* keep = "TRUE" *)   wire          AXI_ACLK0_st0 ;
    (* keep = "TRUE" *)   wire          AXI_ACLK1_st0 ;
    (* keep = "TRUE" *)   wire          AXI_ACLK2_st0 ;
    (* keep = "TRUE" *)   wire          AXI_ACLK3_st0 ;
    (* keep = "TRUE" *)   wire          AXI_ACLK4_st0 ;
    (* keep = "TRUE" *)   wire          AXI_ACLK5_st0 ;
    (* keep = "TRUE" *)   wire          AXI_ACLK6_st0 ;
    (* keep = "TRUE" *)   wire          AXI_ACLK0_st0_buf ;
    (* keep = "TRUE" *)   wire          AXI_ACLK1_st0_buf ;
    (* keep = "TRUE" *)   wire          AXI_ACLK2_st0_buf ;
    (* keep = "TRUE" *)   wire          AXI_ACLK3_st0_buf ;
    (* keep = "TRUE" *)   wire          AXI_ACLK4_st0_buf ;
    (* keep = "TRUE" *)   wire          AXI_ACLK5_st0_buf ;
    (* keep = "TRUE" *)   wire          AXI_ACLK6_st0_buf ;
    (* keep = "TRUE" *)   wire          HBM_REF_CLK_0_buf ;
    (* keep = "TRUE" *)   wire          i_clk_atg_axi_vio_st0 ;
    wire                            MMCM_LOCK_0 ;
    reg  [3:0]                                          cnt_rst_0 ;
    reg           axi_rst_0_r1_n ;
    reg           axi_rst_0_mmcm_n ;
    (* keep = "TRUE" *) reg           axi_rst_st0_n ;
    (* ASYNC_REG = "TRUE" *) reg           axi_rst0_st0_r1_n, axi_rst0_st0_r2_n ;
    (* keep = "TRUE" *) reg           axi_rst0_st0_n ;
    (* ASYNC_REG = "TRUE" *) reg           axi_rst1_st0_r1_n, axi_rst1_st0_r2_n ;
    (* keep = "TRUE" *) reg           axi_rst1_st0_n ;
    (* ASYNC_REG = "TRUE" *) reg           axi_rst2_st0_r1_n, axi_rst2_st0_r2_n ;
    (* keep = "TRUE" *) reg           axi_rst2_st0_n ;
    (* ASYNC_REG = "TRUE" *) reg           axi_rst3_st0_r1_n, axi_rst3_st0_r2_n ;
    (* keep = "TRUE" *) reg           axi_rst3_st0_n ;
    (* ASYNC_REG = "TRUE" *) reg           axi_rst4_st0_r1_n, axi_rst4_st0_r2_n ;
    (* keep = "TRUE" *) reg           axi_rst4_st0_n ;
    (* ASYNC_REG = "TRUE" *) reg           axi_rst5_st0_r1_n, axi_rst5_st0_r2_n ;
    (* keep = "TRUE" *) reg           axi_rst5_st0_n ;
    (* ASYNC_REG = "TRUE" *) reg           axi_rst6_st0_r1_n, axi_rst6_st0_r2_n ;
    (* keep = "TRUE" *) reg           axi_rst6_st0_n ;
    
    reg        [31 : 0]             AXI_00_WDATA_PARITY ;
    reg        [31 : 0]             AXI_01_WDATA_PARITY ;
    reg        [31 : 0]             AXI_02_WDATA_PARITY ;
    reg        [31 : 0]             AXI_03_WDATA_PARITY ;
    reg        [31 : 0]             AXI_04_WDATA_PARITY ;
    reg        [31 : 0]             AXI_05_WDATA_PARITY ;
    reg        [31 : 0]             AXI_06_WDATA_PARITY ;
    reg        [31 : 0]             AXI_07_WDATA_PARITY ;
    reg        [31 : 0]             AXI_08_WDATA_PARITY ;
    reg        [31 : 0]             AXI_09_WDATA_PARITY ;
    reg        [31 : 0]             AXI_10_WDATA_PARITY ;
    reg        [31 : 0]             AXI_11_WDATA_PARITY ;
    reg        [31 : 0]             AXI_12_WDATA_PARITY ;
    reg        [31 : 0]             AXI_13_WDATA_PARITY ;
    reg        [31 : 0]             AXI_14_WDATA_PARITY ;
    reg        [31 : 0]             AXI_15_WDATA_PARITY ;
    
    
    ////////////////////////////////////////////////////////////////////////////////
    // Instantiating BUFG for AXI Clock
    ////////////////////////////////////////////////////////////////////////////////
    /*(* keep = "TRUE" *)*/ wire      APB_0_PCLK_IBUF ;
    /*(* keep = "TRUE" *)*/ wire      APB_0_PCLK_BUF ;
    
    IBUF u_APB_0_PCLK_IBUF  (
      .I (APB_0_PCLK),
      .O (APB_0_PCLK_IBUF)
    ) ;
    
    BUFG u_APB_0_PCLK_BUFG  (
      .I (APB_0_PCLK_IBUF),
      .O (APB_0_PCLK_BUF)
    ) ;
    
    BUFG u_AXI_ACLK_IN_0  (
      .I (AXI_ACLK_IN_0),
      .O (AXI_ACLK_IN_0_buf)
    ) ;
    
    //assign AXI_ACLK = AXI_ACLK_IN_0 ; 
    assign AXI_ACLK = AXI_ACLK0_st0_buf ;    
    assign AXI_ACLK_00 = AXI_ACLK0_st0_buf ; 
    assign AXI_ACLK_01 = AXI_ACLK1_st0_buf ; 
    assign AXI_ACLK_02 = AXI_ACLK2_st0_buf ; 
    assign AXI_ACLK_03 = AXI_ACLK3_st0_buf ; 
    assign AXI_ACLK_04 = AXI_ACLK4_st0_buf ; 
    assign AXI_ACLK_05 = AXI_ACLK5_st0_buf ; 
    assign AXI_ACLK_06 = AXI_ACLK6_st0_buf ; 
    
    ////////////////////////////////////////////////////////////////////////////////
    // Reset logic for AXI_0
    ////////////////////////////////////////////////////////////////////////////////
    always @ (posedge AXI_ACLK_IN_0_buf or negedge AXI_ARESET_N_0) begin
      if (~AXI_ARESET_N_0) begin
        axi_rst_0_r1_n <= 1'b0 ;
      end else begin
        axi_rst_0_r1_n <= 1'b1 ;
      end
    end
    
    always @ (posedge AXI_ACLK_IN_0_buf) begin
      if (~axi_rst_0_r1_n) begin
        cnt_rst_0 <= 4'hA ;
      end else if (cnt_rst_0 != 4'h0) begin
        cnt_rst_0 <= cnt_rst_0 - 1'b1 ;
      end else begin
        cnt_rst_0 <= cnt_rst_0 ;
      end
    end
    
    always @ (posedge AXI_ACLK_IN_0_buf) begin
      if (cnt_rst_0 != 4'h0) begin
        axi_rst_0_mmcm_n <= 1'b0 ;
      end else begin
        axi_rst_0_mmcm_n <= 1'b1 ;
      end
    end
    
    always @ (posedge AXI_ACLK_IN_0_buf) begin
      axi_rst_st0_n <= axi_rst_0_mmcm_n & MMCM_LOCK_0 ;
    end
    
    always @ (posedge AXI_ACLK0_st0_buf) begin
      axi_rst0_st0_r1_n <= axi_rst_st0_n ;
      axi_rst0_st0_r2_n <= axi_rst0_st0_r1_n ;
    end
    
    always @ (posedge AXI_ACLK0_st0_buf or negedge AXI_ARESET_N_0) begin
      if (~AXI_ARESET_N_0) begin
        axi_rst0_st0_n <= 1'b0 ;
      end else begin
        axi_rst0_st0_n <= axi_rst0_st0_r2_n ;
      end
    end
    
    always @ (posedge AXI_ACLK1_st0_buf) begin
      axi_rst1_st0_r1_n <= axi_rst_st0_n ;
      axi_rst1_st0_r2_n <= axi_rst1_st0_r1_n ;
    end
    
    always @ (posedge AXI_ACLK1_st0_buf or negedge AXI_ARESET_N_0) begin
      if (~AXI_ARESET_N_0) begin
        axi_rst1_st0_n <= 1'b0 ;
      end else begin
        axi_rst1_st0_n <= axi_rst1_st0_r2_n ;
      end
    end
    
    always @ (posedge AXI_ACLK2_st0_buf) begin
      axi_rst2_st0_r1_n <= axi_rst_st0_n ;
      axi_rst2_st0_r2_n <= axi_rst2_st0_r1_n ;
    end
    
    always @ (posedge AXI_ACLK2_st0_buf or negedge AXI_ARESET_N_0) begin
      if (~AXI_ARESET_N_0) begin
        axi_rst2_st0_n <= 1'b0 ;
      end else begin
        axi_rst2_st0_n <= axi_rst2_st0_r2_n ;
      end
    end
    
    always @ (posedge AXI_ACLK3_st0_buf) begin
      axi_rst3_st0_r1_n <= axi_rst_st0_n ;
      axi_rst3_st0_r2_n <= axi_rst3_st0_r1_n ;
    end
    
    always @ (posedge AXI_ACLK3_st0_buf or negedge AXI_ARESET_N_0) begin
      if (~AXI_ARESET_N_0) begin
        axi_rst3_st0_n <= 1'b0 ;
      end else begin
        axi_rst3_st0_n <= axi_rst3_st0_r2_n ;
      end
    end
    
    always @ (posedge AXI_ACLK4_st0_buf) begin
      axi_rst4_st0_r1_n <= axi_rst_st0_n ;
      axi_rst4_st0_r2_n <= axi_rst4_st0_r1_n ;
    end
    
    always @ (posedge AXI_ACLK4_st0_buf or negedge AXI_ARESET_N_0) begin
      if (~AXI_ARESET_N_0) begin
        axi_rst4_st0_n <= 1'b0 ;
      end else begin
        axi_rst4_st0_n <= axi_rst4_st0_r2_n ;
      end
    end
    
    always @ (posedge AXI_ACLK5_st0_buf) begin
      axi_rst5_st0_r1_n <= axi_rst_st0_n ;
      axi_rst5_st0_r2_n <= axi_rst5_st0_r1_n ;
    end
    
    always @ (posedge AXI_ACLK5_st0_buf or negedge AXI_ARESET_N_0) begin
      if (~AXI_ARESET_N_0) begin
        axi_rst5_st0_n <= 1'b0 ;
      end else begin
        axi_rst5_st0_n <= axi_rst5_st0_r2_n ;
      end
    end
    
    always @ (posedge AXI_ACLK6_st0_buf) begin
      axi_rst6_st0_r1_n <= axi_rst_st0_n ;
      axi_rst6_st0_r2_n <= axi_rst6_st0_r1_n ;
    end
    
    always @ (posedge AXI_ACLK6_st0_buf or negedge AXI_ARESET_N_0) begin
      if (~AXI_ARESET_N_0) begin
        axi_rst6_st0_n <= 1'b0 ;
      end else begin
        axi_rst6_st0_n <= axi_rst6_st0_r2_n ;
      end
    end
    
    reg  [7:0]    cnt_rst_0_0 ;
    reg           axi_rst_0_mmcm_n_0 ;
    
    always @ (posedge AXI_ACLK_IN_0_buf) begin
      if (~axi_rst_0_r1_n) begin
    	  if( cnt_rst_0_0 >= 8'd100 )
    	  begin
          cnt_rst_0_0 <= cnt_rst_0_0 ;
          axi_rst_0_mmcm_n_0 <= 1'b0 ;
    	  end
    	  else
    	  begin
          cnt_rst_0_0 <= cnt_rst_0_0 + 1 ;
          axi_rst_0_mmcm_n_0 <= axi_rst_0_mmcm_n_0 ;
    	  end
      end else begin
        cnt_rst_0_0 <= 'd0 ;
        axi_rst_0_mmcm_n_0 <= 1'b1 ;
      end
    end
    
    
    ////////////////////////////////////////////////////////////////////////////////
    // Instantiating MMCM for AXI clock generation
    ////////////////////////////////////////////////////////////////////////////////
    MMCME4_ADV
      #(.BANDWIDTH            ("OPTIMIZED"),
        .CLKOUT4_CASCADE      ("FALSE"),
        .COMPENSATION         ("INTERNAL"),
        .STARTUP_WAIT         ("FALSE"),
        .DIVCLK_DIVIDE        (MMCM_DIVCLK_DIVIDE),
        .CLKFBOUT_MULT_F      (MMCM_CLKFBOUT_MULT_F),
        .CLKFBOUT_PHASE       (0.000),
        .CLKFBOUT_USE_FINE_PS ("FALSE"),
        .CLKOUT0_DIVIDE_F     (MMCM_CLKOUT0_DIVIDE_F),
        .CLKOUT0_PHASE        (0.000),
        .CLKOUT0_DUTY_CYCLE   (0.500),
        .CLKOUT0_USE_FINE_PS  ("FALSE"),
        .CLKOUT1_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
        .CLKOUT2_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
        .CLKOUT3_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
        .CLKOUT4_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
        .CLKOUT5_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
        .CLKOUT6_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
        .CLKIN1_PERIOD        (MMCM_CLKIN1_PERIOD),
        .REF_JITTER1          (0.010))
      u_mmcm_0
        // Output clocks
       (
        .CLKFBOUT            (),
        .CLKFBOUTB           (),
        .CLKOUT0             (AXI_ACLK0_st0),
    
        .CLKOUT0B            (),
        .CLKOUT1             (AXI_ACLK1_st0),
        .CLKOUT1B            (),
        .CLKOUT2             (AXI_ACLK2_st0),
        .CLKOUT2B            (),
        .CLKOUT3             (AXI_ACLK3_st0),
        .CLKOUT3B            (),
        .CLKOUT4             (AXI_ACLK4_st0),
        .CLKOUT5             (AXI_ACLK5_st0),
        .CLKOUT6             (AXI_ACLK6_st0),
         // Input clock control
        .CLKFBIN             (), //mmcm_fb
        .CLKIN1              (AXI_ACLK_IN_0_buf),
        .CLKIN2              (1'b0),
        // Other control and status signals
        .LOCKED              (MMCM_LOCK_0),
        .PWRDWN              (1'b0),
        .RST                 (~axi_rst_0_mmcm_n_0),
        //.RST                 (AXI_ARESET_N_0), 
      
        .CDDCDONE            (),
        .CLKFBSTOPPED        (),
        .CLKINSTOPPED        (),
        .DO                  (),
        .DRDY                (),
        .PSDONE              (),
        .CDDCREQ             (1'b0),
        .CLKINSEL            (1'b1),
        .DADDR               (7'b0),
        .DCLK                (1'b0),
        .DEN                 (1'b0),
        .DI                  (16'b0),
        .DWE                 (1'b0),
        .PSCLK               (1'b0),
        .PSEN                (1'b0),
        .PSINCDEC            (1'b0)
      ) ;
    
    BUFG u_AXI_ACLK0_st0  (
      .I (AXI_ACLK0_st0),
      .O (AXI_ACLK0_st0_buf)
    ) ;
    
    BUFG u_AXI_ACLK1_st0  (
      .I (AXI_ACLK1_st0),
      .O (AXI_ACLK1_st0_buf)
    ) ;
    
    BUFG u_AXI_ACLK2_st0  (
      .I (AXI_ACLK2_st0),
      .O (AXI_ACLK2_st0_buf)
    ) ;
    
    BUFG u_AXI_ACLK3_st0  (
      .I (AXI_ACLK3_st0),
      .O (AXI_ACLK3_st0_buf)
    ) ;
    
    BUFG u_AXI_ACLK4_st0  (
      .I (AXI_ACLK4_st0),
      .O (AXI_ACLK4_st0_buf)
    ) ;
    
    BUFG u_AXI_ACLK5_st0  (
      .I (AXI_ACLK5_st0),
      .O (AXI_ACLK5_st0_buf)
    ) ;
    
    BUFG u_AXI_ACLK6_st0  (
      .I (AXI_ACLK6_st0),
      .O (AXI_ACLK6_st0_buf)
    ) ;
    
    BUFG u_HBM_REFCLK_st0  (
      .I (HBM_REF_CLK_0),
      .O (HBM_REF_CLK_0_buf)
    ) ;
    
    BUFGCE_DIV #(
          .BUFGCE_DIVIDE(2)
       )
        u_AXI_vio_CLK_st0  (
      .I (AXI_ACLK0_st0),
      .CE (1'b1),
      .CLR (1'b0),
      .O (i_clk_atg_axi_vio_st0)
    ) ;
    
    
    ////////////////////////////////////////////////////////////////////////////////
    // Calculating Write Data Parity
    ////////////////////////////////////////////////////////////////////////////////
    assign AXI_00_WDATA_PARITY_i = {{^(AXI_00_WDATA[255:248])},{^(AXI_00_WDATA[247:240])},{^(AXI_00_WDATA[239:232])},{^(AXI_00_WDATA[231:224])},
                                  {^(AXI_00_WDATA[223:216])},{^(AXI_00_WDATA[215:208])},{^(AXI_00_WDATA[207:200])},{^(AXI_00_WDATA[199:192])},
                                  {^(AXI_00_WDATA[191:184])},{^(AXI_00_WDATA[183:176])},{^(AXI_00_WDATA[175:168])},{^(AXI_00_WDATA[167:160])},
                                  {^(AXI_00_WDATA[159:152])},{^(AXI_00_WDATA[151:144])},{^(AXI_00_WDATA[143:136])},{^(AXI_00_WDATA[135:128])},
                                  {^(AXI_00_WDATA[127:120])},{^(AXI_00_WDATA[119:112])},{^(AXI_00_WDATA[111:104])},{^(AXI_00_WDATA[103:96])},
                                  {^(AXI_00_WDATA[95:88])},  {^(AXI_00_WDATA[87:80])},  {^(AXI_00_WDATA[79:72])},  {^(AXI_00_WDATA[71:64])},
                                  {^(AXI_00_WDATA[63:56])},  {^(AXI_00_WDATA[55:48])},  {^(AXI_00_WDATA[47:40])},  {^(AXI_00_WDATA[39:32])},
                                  {^(AXI_00_WDATA[31:24])},  {^(AXI_00_WDATA[23:16])},  {^(AXI_00_WDATA[15:8])},   {^(AXI_00_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK0_st0_buf)
      AXI_00_WDATA_PARITY <= AXI_00_WDATA_PARITY_i ;
    
    assign AXI_01_WDATA_PARITY_i = {{^(AXI_01_WDATA[255:248])},{^(AXI_01_WDATA[247:240])},{^(AXI_01_WDATA[239:232])},{^(AXI_01_WDATA[231:224])},
                                  {^(AXI_01_WDATA[223:216])},{^(AXI_01_WDATA[215:208])},{^(AXI_01_WDATA[207:200])},{^(AXI_01_WDATA[199:192])},
                                  {^(AXI_01_WDATA[191:184])},{^(AXI_01_WDATA[183:176])},{^(AXI_01_WDATA[175:168])},{^(AXI_01_WDATA[167:160])},
                                  {^(AXI_01_WDATA[159:152])},{^(AXI_01_WDATA[151:144])},{^(AXI_01_WDATA[143:136])},{^(AXI_01_WDATA[135:128])},
                                  {^(AXI_01_WDATA[127:120])},{^(AXI_01_WDATA[119:112])},{^(AXI_01_WDATA[111:104])},{^(AXI_01_WDATA[103:96])},
                                  {^(AXI_01_WDATA[95:88])},  {^(AXI_01_WDATA[87:80])},  {^(AXI_01_WDATA[79:72])},  {^(AXI_01_WDATA[71:64])},
                                  {^(AXI_01_WDATA[63:56])},  {^(AXI_01_WDATA[55:48])},  {^(AXI_01_WDATA[47:40])},  {^(AXI_01_WDATA[39:32])},
                                  {^(AXI_01_WDATA[31:24])},  {^(AXI_01_WDATA[23:16])},  {^(AXI_01_WDATA[15:8])},   {^(AXI_01_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK0_st0_buf)
      AXI_01_WDATA_PARITY <= AXI_01_WDATA_PARITY_i ;
    assign AXI_02_WDATA_PARITY_i = {{^(AXI_02_WDATA[255:248])},{^(AXI_02_WDATA[247:240])},{^(AXI_02_WDATA[239:232])},{^(AXI_02_WDATA[231:224])},
                                  {^(AXI_02_WDATA[223:216])},{^(AXI_02_WDATA[215:208])},{^(AXI_02_WDATA[207:200])},{^(AXI_02_WDATA[199:192])},
                                  {^(AXI_02_WDATA[191:184])},{^(AXI_02_WDATA[183:176])},{^(AXI_02_WDATA[175:168])},{^(AXI_02_WDATA[167:160])},
                                  {^(AXI_02_WDATA[159:152])},{^(AXI_02_WDATA[151:144])},{^(AXI_02_WDATA[143:136])},{^(AXI_02_WDATA[135:128])},
                                  {^(AXI_02_WDATA[127:120])},{^(AXI_02_WDATA[119:112])},{^(AXI_02_WDATA[111:104])},{^(AXI_02_WDATA[103:96])},
                                  {^(AXI_02_WDATA[95:88])},  {^(AXI_02_WDATA[87:80])},  {^(AXI_02_WDATA[79:72])},  {^(AXI_02_WDATA[71:64])},
                                  {^(AXI_02_WDATA[63:56])},  {^(AXI_02_WDATA[55:48])},  {^(AXI_02_WDATA[47:40])},  {^(AXI_02_WDATA[39:32])},
                                  {^(AXI_02_WDATA[31:24])},  {^(AXI_02_WDATA[23:16])},  {^(AXI_02_WDATA[15:8])},   {^(AXI_02_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK1_st0_buf)
      AXI_02_WDATA_PARITY <= AXI_02_WDATA_PARITY_i ;
    assign AXI_03_WDATA_PARITY_i = {{^(AXI_03_WDATA[255:248])},{^(AXI_03_WDATA[247:240])},{^(AXI_03_WDATA[239:232])},{^(AXI_03_WDATA[231:224])},
                                  {^(AXI_03_WDATA[223:216])},{^(AXI_03_WDATA[215:208])},{^(AXI_03_WDATA[207:200])},{^(AXI_03_WDATA[199:192])},
                                  {^(AXI_03_WDATA[191:184])},{^(AXI_03_WDATA[183:176])},{^(AXI_03_WDATA[175:168])},{^(AXI_03_WDATA[167:160])},
                                  {^(AXI_03_WDATA[159:152])},{^(AXI_03_WDATA[151:144])},{^(AXI_03_WDATA[143:136])},{^(AXI_03_WDATA[135:128])},
                                  {^(AXI_03_WDATA[127:120])},{^(AXI_03_WDATA[119:112])},{^(AXI_03_WDATA[111:104])},{^(AXI_03_WDATA[103:96])},
                                  {^(AXI_03_WDATA[95:88])},  {^(AXI_03_WDATA[87:80])},  {^(AXI_03_WDATA[79:72])},  {^(AXI_03_WDATA[71:64])},
                                  {^(AXI_03_WDATA[63:56])},  {^(AXI_03_WDATA[55:48])},  {^(AXI_03_WDATA[47:40])},  {^(AXI_03_WDATA[39:32])},
                                  {^(AXI_03_WDATA[31:24])},  {^(AXI_03_WDATA[23:16])},  {^(AXI_03_WDATA[15:8])},   {^(AXI_03_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK1_st0_buf)
      AXI_03_WDATA_PARITY <= AXI_03_WDATA_PARITY_i ;
    assign AXI_04_WDATA_PARITY_i = {{^(AXI_04_WDATA[255:248])},{^(AXI_04_WDATA[247:240])},{^(AXI_04_WDATA[239:232])},{^(AXI_04_WDATA[231:224])},
                                  {^(AXI_04_WDATA[223:216])},{^(AXI_04_WDATA[215:208])},{^(AXI_04_WDATA[207:200])},{^(AXI_04_WDATA[199:192])},
                                  {^(AXI_04_WDATA[191:184])},{^(AXI_04_WDATA[183:176])},{^(AXI_04_WDATA[175:168])},{^(AXI_04_WDATA[167:160])},
                                  {^(AXI_04_WDATA[159:152])},{^(AXI_04_WDATA[151:144])},{^(AXI_04_WDATA[143:136])},{^(AXI_04_WDATA[135:128])},
                                  {^(AXI_04_WDATA[127:120])},{^(AXI_04_WDATA[119:112])},{^(AXI_04_WDATA[111:104])},{^(AXI_04_WDATA[103:96])},
                                  {^(AXI_04_WDATA[95:88])},  {^(AXI_04_WDATA[87:80])},  {^(AXI_04_WDATA[79:72])},  {^(AXI_04_WDATA[71:64])},
                                  {^(AXI_04_WDATA[63:56])},  {^(AXI_04_WDATA[55:48])},  {^(AXI_04_WDATA[47:40])},  {^(AXI_04_WDATA[39:32])},
                                  {^(AXI_04_WDATA[31:24])},  {^(AXI_04_WDATA[23:16])},  {^(AXI_04_WDATA[15:8])},   {^(AXI_04_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK2_st0_buf)
      AXI_04_WDATA_PARITY <= AXI_04_WDATA_PARITY_i ;
    assign AXI_05_WDATA_PARITY_i = {{^(AXI_05_WDATA[255:248])},{^(AXI_05_WDATA[247:240])},{^(AXI_05_WDATA[239:232])},{^(AXI_05_WDATA[231:224])},
                                  {^(AXI_05_WDATA[223:216])},{^(AXI_05_WDATA[215:208])},{^(AXI_05_WDATA[207:200])},{^(AXI_05_WDATA[199:192])},
                                  {^(AXI_05_WDATA[191:184])},{^(AXI_05_WDATA[183:176])},{^(AXI_05_WDATA[175:168])},{^(AXI_05_WDATA[167:160])},
                                  {^(AXI_05_WDATA[159:152])},{^(AXI_05_WDATA[151:144])},{^(AXI_05_WDATA[143:136])},{^(AXI_05_WDATA[135:128])},
                                  {^(AXI_05_WDATA[127:120])},{^(AXI_05_WDATA[119:112])},{^(AXI_05_WDATA[111:104])},{^(AXI_05_WDATA[103:96])},
                                  {^(AXI_05_WDATA[95:88])},  {^(AXI_05_WDATA[87:80])},  {^(AXI_05_WDATA[79:72])},  {^(AXI_05_WDATA[71:64])},
                                  {^(AXI_05_WDATA[63:56])},  {^(AXI_05_WDATA[55:48])},  {^(AXI_05_WDATA[47:40])},  {^(AXI_05_WDATA[39:32])},
                                  {^(AXI_05_WDATA[31:24])},  {^(AXI_05_WDATA[23:16])},  {^(AXI_05_WDATA[15:8])},   {^(AXI_05_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK2_st0_buf)
      AXI_05_WDATA_PARITY <= AXI_05_WDATA_PARITY_i ;
    assign AXI_06_WDATA_PARITY_i = {{^(AXI_06_WDATA[255:248])},{^(AXI_06_WDATA[247:240])},{^(AXI_06_WDATA[239:232])},{^(AXI_06_WDATA[231:224])},
                                  {^(AXI_06_WDATA[223:216])},{^(AXI_06_WDATA[215:208])},{^(AXI_06_WDATA[207:200])},{^(AXI_06_WDATA[199:192])},
                                  {^(AXI_06_WDATA[191:184])},{^(AXI_06_WDATA[183:176])},{^(AXI_06_WDATA[175:168])},{^(AXI_06_WDATA[167:160])},
                                  {^(AXI_06_WDATA[159:152])},{^(AXI_06_WDATA[151:144])},{^(AXI_06_WDATA[143:136])},{^(AXI_06_WDATA[135:128])},
                                  {^(AXI_06_WDATA[127:120])},{^(AXI_06_WDATA[119:112])},{^(AXI_06_WDATA[111:104])},{^(AXI_06_WDATA[103:96])},
                                  {^(AXI_06_WDATA[95:88])},  {^(AXI_06_WDATA[87:80])},  {^(AXI_06_WDATA[79:72])},  {^(AXI_06_WDATA[71:64])},
                                  {^(AXI_06_WDATA[63:56])},  {^(AXI_06_WDATA[55:48])},  {^(AXI_06_WDATA[47:40])},  {^(AXI_06_WDATA[39:32])},
                                  {^(AXI_06_WDATA[31:24])},  {^(AXI_06_WDATA[23:16])},  {^(AXI_06_WDATA[15:8])},   {^(AXI_06_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK3_st0_buf)
      AXI_06_WDATA_PARITY <= AXI_06_WDATA_PARITY_i ;
    assign AXI_07_WDATA_PARITY_i = {{^(AXI_07_WDATA[255:248])},{^(AXI_07_WDATA[247:240])},{^(AXI_07_WDATA[239:232])},{^(AXI_07_WDATA[231:224])},
                                  {^(AXI_07_WDATA[223:216])},{^(AXI_07_WDATA[215:208])},{^(AXI_07_WDATA[207:200])},{^(AXI_07_WDATA[199:192])},
                                  {^(AXI_07_WDATA[191:184])},{^(AXI_07_WDATA[183:176])},{^(AXI_07_WDATA[175:168])},{^(AXI_07_WDATA[167:160])},
                                  {^(AXI_07_WDATA[159:152])},{^(AXI_07_WDATA[151:144])},{^(AXI_07_WDATA[143:136])},{^(AXI_07_WDATA[135:128])},
                                  {^(AXI_07_WDATA[127:120])},{^(AXI_07_WDATA[119:112])},{^(AXI_07_WDATA[111:104])},{^(AXI_07_WDATA[103:96])},
                                  {^(AXI_07_WDATA[95:88])},  {^(AXI_07_WDATA[87:80])},  {^(AXI_07_WDATA[79:72])},  {^(AXI_07_WDATA[71:64])},
                                  {^(AXI_07_WDATA[63:56])},  {^(AXI_07_WDATA[55:48])},  {^(AXI_07_WDATA[47:40])},  {^(AXI_07_WDATA[39:32])},
                                  {^(AXI_07_WDATA[31:24])},  {^(AXI_07_WDATA[23:16])},  {^(AXI_07_WDATA[15:8])},   {^(AXI_07_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK3_st0_buf)
      AXI_07_WDATA_PARITY <= AXI_07_WDATA_PARITY_i ;
    assign AXI_08_WDATA_PARITY_i = {{^(AXI_08_WDATA[255:248])},{^(AXI_08_WDATA[247:240])},{^(AXI_08_WDATA[239:232])},{^(AXI_08_WDATA[231:224])},
                                  {^(AXI_08_WDATA[223:216])},{^(AXI_08_WDATA[215:208])},{^(AXI_08_WDATA[207:200])},{^(AXI_08_WDATA[199:192])},
                                  {^(AXI_08_WDATA[191:184])},{^(AXI_08_WDATA[183:176])},{^(AXI_08_WDATA[175:168])},{^(AXI_08_WDATA[167:160])},
                                  {^(AXI_08_WDATA[159:152])},{^(AXI_08_WDATA[151:144])},{^(AXI_08_WDATA[143:136])},{^(AXI_08_WDATA[135:128])},
                                  {^(AXI_08_WDATA[127:120])},{^(AXI_08_WDATA[119:112])},{^(AXI_08_WDATA[111:104])},{^(AXI_08_WDATA[103:96])},
                                  {^(AXI_08_WDATA[95:88])},  {^(AXI_08_WDATA[87:80])},  {^(AXI_08_WDATA[79:72])},  {^(AXI_08_WDATA[71:64])},
                                  {^(AXI_08_WDATA[63:56])},  {^(AXI_08_WDATA[55:48])},  {^(AXI_08_WDATA[47:40])},  {^(AXI_08_WDATA[39:32])},
                                  {^(AXI_08_WDATA[31:24])},  {^(AXI_08_WDATA[23:16])},  {^(AXI_08_WDATA[15:8])},   {^(AXI_08_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK4_st0_buf)
      AXI_08_WDATA_PARITY <= AXI_08_WDATA_PARITY_i ;
    assign AXI_09_WDATA_PARITY_i = {{^(AXI_09_WDATA[255:248])},{^(AXI_09_WDATA[247:240])},{^(AXI_09_WDATA[239:232])},{^(AXI_09_WDATA[231:224])},
                                  {^(AXI_09_WDATA[223:216])},{^(AXI_09_WDATA[215:208])},{^(AXI_09_WDATA[207:200])},{^(AXI_09_WDATA[199:192])},
                                  {^(AXI_09_WDATA[191:184])},{^(AXI_09_WDATA[183:176])},{^(AXI_09_WDATA[175:168])},{^(AXI_09_WDATA[167:160])},
                                  {^(AXI_09_WDATA[159:152])},{^(AXI_09_WDATA[151:144])},{^(AXI_09_WDATA[143:136])},{^(AXI_09_WDATA[135:128])},
                                  {^(AXI_09_WDATA[127:120])},{^(AXI_09_WDATA[119:112])},{^(AXI_09_WDATA[111:104])},{^(AXI_09_WDATA[103:96])},
                                  {^(AXI_09_WDATA[95:88])},  {^(AXI_09_WDATA[87:80])},  {^(AXI_09_WDATA[79:72])},  {^(AXI_09_WDATA[71:64])},
                                  {^(AXI_09_WDATA[63:56])},  {^(AXI_09_WDATA[55:48])},  {^(AXI_09_WDATA[47:40])},  {^(AXI_09_WDATA[39:32])},
                                  {^(AXI_09_WDATA[31:24])},  {^(AXI_09_WDATA[23:16])},  {^(AXI_09_WDATA[15:8])},   {^(AXI_09_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK4_st0_buf)
      AXI_09_WDATA_PARITY <= AXI_09_WDATA_PARITY_i ;
    assign AXI_10_WDATA_PARITY_i = {{^(AXI_10_WDATA[255:248])},{^(AXI_10_WDATA[247:240])},{^(AXI_10_WDATA[239:232])},{^(AXI_10_WDATA[231:224])},
                                  {^(AXI_10_WDATA[223:216])},{^(AXI_10_WDATA[215:208])},{^(AXI_10_WDATA[207:200])},{^(AXI_10_WDATA[199:192])},
                                  {^(AXI_10_WDATA[191:184])},{^(AXI_10_WDATA[183:176])},{^(AXI_10_WDATA[175:168])},{^(AXI_10_WDATA[167:160])},
                                  {^(AXI_10_WDATA[159:152])},{^(AXI_10_WDATA[151:144])},{^(AXI_10_WDATA[143:136])},{^(AXI_10_WDATA[135:128])},
                                  {^(AXI_10_WDATA[127:120])},{^(AXI_10_WDATA[119:112])},{^(AXI_10_WDATA[111:104])},{^(AXI_10_WDATA[103:96])},
                                  {^(AXI_10_WDATA[95:88])},  {^(AXI_10_WDATA[87:80])},  {^(AXI_10_WDATA[79:72])},  {^(AXI_10_WDATA[71:64])},
                                  {^(AXI_10_WDATA[63:56])},  {^(AXI_10_WDATA[55:48])},  {^(AXI_10_WDATA[47:40])},  {^(AXI_10_WDATA[39:32])},
                                  {^(AXI_10_WDATA[31:24])},  {^(AXI_10_WDATA[23:16])},  {^(AXI_10_WDATA[15:8])},   {^(AXI_10_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK5_st0_buf)
      AXI_10_WDATA_PARITY <= AXI_10_WDATA_PARITY_i ;
    assign AXI_11_WDATA_PARITY_i = {{^(AXI_11_WDATA[255:248])},{^(AXI_11_WDATA[247:240])},{^(AXI_11_WDATA[239:232])},{^(AXI_11_WDATA[231:224])},
                                  {^(AXI_11_WDATA[223:216])},{^(AXI_11_WDATA[215:208])},{^(AXI_11_WDATA[207:200])},{^(AXI_11_WDATA[199:192])},
                                  {^(AXI_11_WDATA[191:184])},{^(AXI_11_WDATA[183:176])},{^(AXI_11_WDATA[175:168])},{^(AXI_11_WDATA[167:160])},
                                  {^(AXI_11_WDATA[159:152])},{^(AXI_11_WDATA[151:144])},{^(AXI_11_WDATA[143:136])},{^(AXI_11_WDATA[135:128])},
                                  {^(AXI_11_WDATA[127:120])},{^(AXI_11_WDATA[119:112])},{^(AXI_11_WDATA[111:104])},{^(AXI_11_WDATA[103:96])},
                                  {^(AXI_11_WDATA[95:88])},  {^(AXI_11_WDATA[87:80])},  {^(AXI_11_WDATA[79:72])},  {^(AXI_11_WDATA[71:64])},
                                  {^(AXI_11_WDATA[63:56])},  {^(AXI_11_WDATA[55:48])},  {^(AXI_11_WDATA[47:40])},  {^(AXI_11_WDATA[39:32])},
                                  {^(AXI_11_WDATA[31:24])},  {^(AXI_11_WDATA[23:16])},  {^(AXI_11_WDATA[15:8])},   {^(AXI_11_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK5_st0_buf)
      AXI_11_WDATA_PARITY <= AXI_11_WDATA_PARITY_i ;
    assign AXI_12_WDATA_PARITY_i = {{^(AXI_12_WDATA[255:248])},{^(AXI_12_WDATA[247:240])},{^(AXI_12_WDATA[239:232])},{^(AXI_12_WDATA[231:224])},
                                  {^(AXI_12_WDATA[223:216])},{^(AXI_12_WDATA[215:208])},{^(AXI_12_WDATA[207:200])},{^(AXI_12_WDATA[199:192])},
                                  {^(AXI_12_WDATA[191:184])},{^(AXI_12_WDATA[183:176])},{^(AXI_12_WDATA[175:168])},{^(AXI_12_WDATA[167:160])},
                                  {^(AXI_12_WDATA[159:152])},{^(AXI_12_WDATA[151:144])},{^(AXI_12_WDATA[143:136])},{^(AXI_12_WDATA[135:128])},
                                  {^(AXI_12_WDATA[127:120])},{^(AXI_12_WDATA[119:112])},{^(AXI_12_WDATA[111:104])},{^(AXI_12_WDATA[103:96])},
                                  {^(AXI_12_WDATA[95:88])},  {^(AXI_12_WDATA[87:80])},  {^(AXI_12_WDATA[79:72])},  {^(AXI_12_WDATA[71:64])},
                                  {^(AXI_12_WDATA[63:56])},  {^(AXI_12_WDATA[55:48])},  {^(AXI_12_WDATA[47:40])},  {^(AXI_12_WDATA[39:32])},
                                  {^(AXI_12_WDATA[31:24])},  {^(AXI_12_WDATA[23:16])},  {^(AXI_12_WDATA[15:8])},   {^(AXI_12_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK5_st0_buf)
      AXI_12_WDATA_PARITY <= AXI_12_WDATA_PARITY_i ;
    assign AXI_13_WDATA_PARITY_i = {{^(AXI_13_WDATA[255:248])},{^(AXI_13_WDATA[247:240])},{^(AXI_13_WDATA[239:232])},{^(AXI_13_WDATA[231:224])},
                                  {^(AXI_13_WDATA[223:216])},{^(AXI_13_WDATA[215:208])},{^(AXI_13_WDATA[207:200])},{^(AXI_13_WDATA[199:192])},
                                  {^(AXI_13_WDATA[191:184])},{^(AXI_13_WDATA[183:176])},{^(AXI_13_WDATA[175:168])},{^(AXI_13_WDATA[167:160])},
                                  {^(AXI_13_WDATA[159:152])},{^(AXI_13_WDATA[151:144])},{^(AXI_13_WDATA[143:136])},{^(AXI_13_WDATA[135:128])},
                                  {^(AXI_13_WDATA[127:120])},{^(AXI_13_WDATA[119:112])},{^(AXI_13_WDATA[111:104])},{^(AXI_13_WDATA[103:96])},
                                  {^(AXI_13_WDATA[95:88])},  {^(AXI_13_WDATA[87:80])},  {^(AXI_13_WDATA[79:72])},  {^(AXI_13_WDATA[71:64])},
                                  {^(AXI_13_WDATA[63:56])},  {^(AXI_13_WDATA[55:48])},  {^(AXI_13_WDATA[47:40])},  {^(AXI_13_WDATA[39:32])},
                                  {^(AXI_13_WDATA[31:24])},  {^(AXI_13_WDATA[23:16])},  {^(AXI_13_WDATA[15:8])},   {^(AXI_13_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK6_st0_buf)
      AXI_13_WDATA_PARITY <= AXI_13_WDATA_PARITY_i ;
    assign AXI_14_WDATA_PARITY_i = {{^(AXI_14_WDATA[255:248])},{^(AXI_14_WDATA[247:240])},{^(AXI_14_WDATA[239:232])},{^(AXI_14_WDATA[231:224])},
                                  {^(AXI_14_WDATA[223:216])},{^(AXI_14_WDATA[215:208])},{^(AXI_14_WDATA[207:200])},{^(AXI_14_WDATA[199:192])},
                                  {^(AXI_14_WDATA[191:184])},{^(AXI_14_WDATA[183:176])},{^(AXI_14_WDATA[175:168])},{^(AXI_14_WDATA[167:160])},
                                  {^(AXI_14_WDATA[159:152])},{^(AXI_14_WDATA[151:144])},{^(AXI_14_WDATA[143:136])},{^(AXI_14_WDATA[135:128])},
                                  {^(AXI_14_WDATA[127:120])},{^(AXI_14_WDATA[119:112])},{^(AXI_14_WDATA[111:104])},{^(AXI_14_WDATA[103:96])},
                                  {^(AXI_14_WDATA[95:88])},  {^(AXI_14_WDATA[87:80])},  {^(AXI_14_WDATA[79:72])},  {^(AXI_14_WDATA[71:64])},
                                  {^(AXI_14_WDATA[63:56])},  {^(AXI_14_WDATA[55:48])},  {^(AXI_14_WDATA[47:40])},  {^(AXI_14_WDATA[39:32])},
                                  {^(AXI_14_WDATA[31:24])},  {^(AXI_14_WDATA[23:16])},  {^(AXI_14_WDATA[15:8])},   {^(AXI_14_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK6_st0_buf)
      AXI_14_WDATA_PARITY <= AXI_14_WDATA_PARITY_i ;
    assign AXI_15_WDATA_PARITY_i = {{^(AXI_15_WDATA[255:248])},{^(AXI_15_WDATA[247:240])},{^(AXI_15_WDATA[239:232])},{^(AXI_15_WDATA[231:224])},
                                  {^(AXI_15_WDATA[223:216])},{^(AXI_15_WDATA[215:208])},{^(AXI_15_WDATA[207:200])},{^(AXI_15_WDATA[199:192])},
                                  {^(AXI_15_WDATA[191:184])},{^(AXI_15_WDATA[183:176])},{^(AXI_15_WDATA[175:168])},{^(AXI_15_WDATA[167:160])},
                                  {^(AXI_15_WDATA[159:152])},{^(AXI_15_WDATA[151:144])},{^(AXI_15_WDATA[143:136])},{^(AXI_15_WDATA[135:128])},
                                  {^(AXI_15_WDATA[127:120])},{^(AXI_15_WDATA[119:112])},{^(AXI_15_WDATA[111:104])},{^(AXI_15_WDATA[103:96])},
                                  {^(AXI_15_WDATA[95:88])},  {^(AXI_15_WDATA[87:80])},  {^(AXI_15_WDATA[79:72])},  {^(AXI_15_WDATA[71:64])},
                                  {^(AXI_15_WDATA[63:56])},  {^(AXI_15_WDATA[55:48])},  {^(AXI_15_WDATA[47:40])},  {^(AXI_15_WDATA[39:32])},
                                  {^(AXI_15_WDATA[31:24])},  {^(AXI_15_WDATA[23:16])},  {^(AXI_15_WDATA[15:8])},   {^(AXI_15_WDATA[7:0])}} ;
    
    always @(posedge AXI_ACLK6_st0_buf)
      AXI_15_WDATA_PARITY <= AXI_15_WDATA_PARITY_i ;
    
    ////////////////////////////////////////////////////////////////////////////////
    // Instantiating User Design
    ////////////////////////////////////////////////////////////////////////////////
    hbm_0 u_hbm_0
    (
      .HBM_REF_CLK_0                ( HBM_REF_CLK_0_buf        ), 
      //.HBM_REF_CLK_0                ( HBM_REF_CLK_0        ), 
      
      .AXI_00_ACLK                  ( AXI_ACLK0_st0_buf    ), 
      .AXI_00_ARESET_N              ( axi_rst0_st0_n       ), 
      .AXI_00_ARADDR                ( AXI_00_ARADDR        ), 
      .AXI_00_ARBURST               ( AXI_00_ARBURST       ), 
      .AXI_00_ARID                  ( AXI_00_ARID          ), 
      .AXI_00_ARLEN                 ( AXI_00_ARLEN[3:0]    ), 
      .AXI_00_ARSIZE                ( AXI_00_ARSIZE        ), 
      .AXI_00_ARVALID               ( AXI_00_ARVALID       ), 
      .AXI_00_AWADDR                ( AXI_00_AWADDR        ), 
      .AXI_00_AWBURST               ( AXI_00_AWBURST       ), 
      .AXI_00_AWID                  ( AXI_00_AWID          ), 
      .AXI_00_AWLEN                 ( AXI_00_AWLEN[3:0]    ), 
      .AXI_00_AWSIZE                ( AXI_00_AWSIZE        ), 
      .AXI_00_AWVALID               ( AXI_00_AWVALID       ), 
      .AXI_00_RREADY                ( AXI_00_RREADY        ), 
      .AXI_00_BREADY                ( AXI_00_BREADY        ), 
      .AXI_00_WDATA                 ( AXI_00_WDATA         ), 
      .AXI_00_WLAST                 ( AXI_00_WLAST         ), 
      .AXI_00_WSTRB                 ( AXI_00_WSTRB         ), 
      .AXI_00_WDATA_PARITY          ( AXI_00_WDATA_PARITY  ), 
      .AXI_00_WVALID                ( AXI_00_WVALID        ), 
      
      .AXI_01_ACLK                  ( AXI_ACLK0_st0_buf    ), 
      .AXI_01_ARESET_N              ( axi_rst0_st0_n       ), 
      .AXI_01_ARADDR                ( AXI_01_ARADDR        ), 
      .AXI_01_ARBURST               ( AXI_01_ARBURST       ), 
      .AXI_01_ARID                  ( AXI_01_ARID          ), 
      .AXI_01_ARLEN                 ( AXI_01_ARLEN[3:0]    ), 
      .AXI_01_ARSIZE                ( AXI_01_ARSIZE        ), 
      .AXI_01_ARVALID               ( AXI_01_ARVALID       ), 
      .AXI_01_AWADDR                ( AXI_01_AWADDR        ), 
      .AXI_01_AWBURST               ( AXI_01_AWBURST       ), 
      .AXI_01_AWID                  ( AXI_01_AWID          ), 
      .AXI_01_AWLEN                 ( AXI_01_AWLEN[3:0]    ), 
      .AXI_01_AWSIZE                ( AXI_01_AWSIZE        ), 
      .AXI_01_AWVALID               ( AXI_01_AWVALID       ), 
      .AXI_01_RREADY                ( AXI_01_RREADY        ), 
      .AXI_01_BREADY                ( AXI_01_BREADY        ), 
      .AXI_01_WDATA                 ( AXI_01_WDATA         ), 
      .AXI_01_WLAST                 ( AXI_01_WLAST         ), 
      .AXI_01_WSTRB                 ( AXI_01_WSTRB         ), 
      .AXI_01_WDATA_PARITY          ( AXI_01_WDATA_PARITY  ), 
      .AXI_01_WVALID                ( AXI_01_WVALID        ), 
      
      .AXI_02_ACLK                  ( AXI_ACLK1_st0_buf    ), 
      .AXI_02_ARESET_N              ( axi_rst1_st0_n       ), 
      .AXI_02_ARADDR                ( AXI_02_ARADDR        ), 
      .AXI_02_ARBURST               ( AXI_02_ARBURST       ), 
      .AXI_02_ARID                  ( AXI_02_ARID          ), 
      .AXI_02_ARLEN                 ( AXI_02_ARLEN[3:0]    ), 
      .AXI_02_ARSIZE                ( AXI_02_ARSIZE        ), 
      .AXI_02_ARVALID               ( AXI_02_ARVALID       ), 
      .AXI_02_AWADDR                ( AXI_02_AWADDR        ), 
      .AXI_02_AWBURST               ( AXI_02_AWBURST       ), 
      .AXI_02_AWID                  ( AXI_02_AWID          ), 
      .AXI_02_AWLEN                 ( AXI_02_AWLEN[3:0]    ), 
      .AXI_02_AWSIZE                ( AXI_02_AWSIZE        ), 
      .AXI_02_AWVALID               ( AXI_02_AWVALID       ), 
      .AXI_02_RREADY                ( AXI_02_RREADY        ), 
      .AXI_02_BREADY                ( AXI_02_BREADY        ), 
      .AXI_02_WDATA                 ( AXI_02_WDATA         ), 
      .AXI_02_WLAST                 ( AXI_02_WLAST         ), 
      .AXI_02_WSTRB                 ( AXI_02_WSTRB         ), 
      .AXI_02_WDATA_PARITY          ( AXI_02_WDATA_PARITY  ), 
      .AXI_02_WVALID                ( AXI_02_WVALID        ), 
      .AXI_03_ACLK                  ( AXI_ACLK1_st0_buf    ), 
      .AXI_03_ARESET_N              ( axi_rst1_st0_n       ), 
      .AXI_03_ARADDR                ( AXI_03_ARADDR        ), 
      .AXI_03_ARBURST               ( AXI_03_ARBURST       ), 
      .AXI_03_ARID                  ( AXI_03_ARID          ), 
      .AXI_03_ARLEN                 ( AXI_03_ARLEN[3:0]    ), 
      .AXI_03_ARSIZE                ( AXI_03_ARSIZE        ), 
      .AXI_03_ARVALID               ( AXI_03_ARVALID       ), 
      .AXI_03_AWADDR                ( AXI_03_AWADDR        ), 
      .AXI_03_AWBURST               ( AXI_03_AWBURST       ), 
      .AXI_03_AWID                  ( AXI_03_AWID          ), 
      .AXI_03_AWLEN                 ( AXI_03_AWLEN[3:0]    ), 
      .AXI_03_AWSIZE                ( AXI_03_AWSIZE        ), 
      .AXI_03_AWVALID               ( AXI_03_AWVALID       ), 
      .AXI_03_RREADY                ( AXI_03_RREADY        ), 
      .AXI_03_BREADY                ( AXI_03_BREADY        ), 
      .AXI_03_WDATA                 ( AXI_03_WDATA         ), 
      .AXI_03_WLAST                 ( AXI_03_WLAST         ), 
      .AXI_03_WSTRB                 ( AXI_03_WSTRB         ), 
      .AXI_03_WDATA_PARITY          ( AXI_03_WDATA_PARITY  ), 
      .AXI_03_WVALID                ( AXI_03_WVALID        ), 
      .AXI_04_ACLK                  ( AXI_ACLK2_st0_buf    ), 
      .AXI_04_ARESET_N              ( axi_rst2_st0_n       ), 
      .AXI_04_ARADDR                ( AXI_04_ARADDR        ), 
      .AXI_04_ARBURST               ( AXI_04_ARBURST       ), 
      .AXI_04_ARID                  ( AXI_04_ARID          ), 
      .AXI_04_ARLEN                 ( AXI_04_ARLEN[3:0]    ), 
      .AXI_04_ARSIZE                ( AXI_04_ARSIZE        ), 
      .AXI_04_ARVALID               ( AXI_04_ARVALID       ), 
      .AXI_04_AWADDR                ( AXI_04_AWADDR        ), 
      .AXI_04_AWBURST               ( AXI_04_AWBURST       ), 
      .AXI_04_AWID                  ( AXI_04_AWID          ), 
      .AXI_04_AWLEN                 ( AXI_04_AWLEN[3:0]    ), 
      .AXI_04_AWSIZE                ( AXI_04_AWSIZE        ), 
      .AXI_04_AWVALID               ( AXI_04_AWVALID       ), 
      .AXI_04_RREADY                ( AXI_04_RREADY        ), 
      .AXI_04_BREADY                ( AXI_04_BREADY        ), 
      .AXI_04_WDATA                 ( AXI_04_WDATA         ), 
      .AXI_04_WLAST                 ( AXI_04_WLAST         ), 
      .AXI_04_WSTRB                 ( AXI_04_WSTRB         ), 
      .AXI_04_WDATA_PARITY          ( AXI_04_WDATA_PARITY  ), 
      .AXI_04_WVALID                ( AXI_04_WVALID        ), 
      .AXI_05_ACLK                  ( AXI_ACLK2_st0_buf    ), 
      .AXI_05_ARESET_N              ( axi_rst2_st0_n       ), 
      .AXI_05_ARADDR                ( AXI_05_ARADDR        ), 
      .AXI_05_ARBURST               ( AXI_05_ARBURST       ), 
      .AXI_05_ARID                  ( AXI_05_ARID          ), 
      .AXI_05_ARLEN                 ( AXI_05_ARLEN[3:0]    ), 
      .AXI_05_ARSIZE                ( AXI_05_ARSIZE        ), 
      .AXI_05_ARVALID               ( AXI_05_ARVALID       ), 
      .AXI_05_AWADDR                ( AXI_05_AWADDR        ), 
      .AXI_05_AWBURST               ( AXI_05_AWBURST       ), 
      .AXI_05_AWID                  ( AXI_05_AWID          ), 
      .AXI_05_AWLEN                 ( AXI_05_AWLEN[3:0]    ), 
      .AXI_05_AWSIZE                ( AXI_05_AWSIZE        ), 
      .AXI_05_AWVALID               ( AXI_05_AWVALID       ), 
      .AXI_05_RREADY                ( AXI_05_RREADY        ), 
      .AXI_05_BREADY                ( AXI_05_BREADY        ), 
      .AXI_05_WDATA                 ( AXI_05_WDATA         ), 
      .AXI_05_WLAST                 ( AXI_05_WLAST         ), 
      .AXI_05_WSTRB                 ( AXI_05_WSTRB         ), 
      .AXI_05_WDATA_PARITY          ( AXI_05_WDATA_PARITY  ), 
      .AXI_05_WVALID                ( AXI_05_WVALID        ), 
      .AXI_06_ACLK                  ( AXI_ACLK3_st0_buf    ), 
      .AXI_06_ARESET_N              ( axi_rst3_st0_n       ), 
      .AXI_06_ARADDR                ( AXI_06_ARADDR        ), 
      .AXI_06_ARBURST               ( AXI_06_ARBURST       ), 
      .AXI_06_ARID                  ( AXI_06_ARID          ), 
      .AXI_06_ARLEN                 ( AXI_06_ARLEN[3:0]    ), 
      .AXI_06_ARSIZE                ( AXI_06_ARSIZE        ), 
      .AXI_06_ARVALID               ( AXI_06_ARVALID       ), 
      .AXI_06_AWADDR                ( AXI_06_AWADDR        ), 
      .AXI_06_AWBURST               ( AXI_06_AWBURST       ), 
      .AXI_06_AWID                  ( AXI_06_AWID          ), 
      .AXI_06_AWLEN                 ( AXI_06_AWLEN[3:0]    ), 
      .AXI_06_AWSIZE                ( AXI_06_AWSIZE        ), 
      .AXI_06_AWVALID               ( AXI_06_AWVALID       ), 
      .AXI_06_RREADY                ( AXI_06_RREADY        ), 
      .AXI_06_BREADY                ( AXI_06_BREADY        ), 
      .AXI_06_WDATA                 ( AXI_06_WDATA         ), 
      .AXI_06_WLAST                 ( AXI_06_WLAST         ), 
      .AXI_06_WSTRB                 ( AXI_06_WSTRB         ), 
      .AXI_06_WDATA_PARITY          ( AXI_06_WDATA_PARITY  ), 
      .AXI_06_WVALID                ( AXI_06_WVALID        ), 
      .AXI_07_ACLK                  ( AXI_ACLK3_st0_buf    ), 
      .AXI_07_ARESET_N              ( axi_rst3_st0_n       ), 
      .AXI_07_ARADDR                ( AXI_07_ARADDR        ), 
      .AXI_07_ARBURST               ( AXI_07_ARBURST       ), 
      .AXI_07_ARID                  ( AXI_07_ARID          ), 
      .AXI_07_ARLEN                 ( AXI_07_ARLEN[3:0]    ), 
      .AXI_07_ARSIZE                ( AXI_07_ARSIZE        ), 
      .AXI_07_ARVALID               ( AXI_07_ARVALID       ), 
      .AXI_07_AWADDR                ( AXI_07_AWADDR        ), 
      .AXI_07_AWBURST               ( AXI_07_AWBURST       ), 
      .AXI_07_AWID                  ( AXI_07_AWID          ), 
      .AXI_07_AWLEN                 ( AXI_07_AWLEN[3:0]    ), 
      .AXI_07_AWSIZE                ( AXI_07_AWSIZE        ), 
      .AXI_07_AWVALID               ( AXI_07_AWVALID       ), 
      .AXI_07_RREADY                ( AXI_07_RREADY        ), 
      .AXI_07_BREADY                ( AXI_07_BREADY        ), 
      .AXI_07_WDATA                 ( AXI_07_WDATA         ), 
      .AXI_07_WLAST                 ( AXI_07_WLAST         ), 
      .AXI_07_WSTRB                 ( AXI_07_WSTRB         ), 
      .AXI_07_WDATA_PARITY          ( AXI_07_WDATA_PARITY  ), 
      .AXI_07_WVALID                ( AXI_07_WVALID        ), 
      .AXI_08_ACLK                  ( AXI_ACLK4_st0_buf    ), 
      .AXI_08_ARESET_N              ( axi_rst4_st0_n       ), 
      .AXI_08_ARADDR                ( AXI_08_ARADDR        ), 
      .AXI_08_ARBURST               ( AXI_08_ARBURST       ), 
      .AXI_08_ARID                  ( AXI_08_ARID          ), 
      .AXI_08_ARLEN                 ( AXI_08_ARLEN[3:0]    ), 
      .AXI_08_ARSIZE                ( AXI_08_ARSIZE        ), 
      .AXI_08_ARVALID               ( AXI_08_ARVALID       ), 
      .AXI_08_AWADDR                ( AXI_08_AWADDR        ), 
      .AXI_08_AWBURST               ( AXI_08_AWBURST       ), 
      .AXI_08_AWID                  ( AXI_08_AWID          ), 
      .AXI_08_AWLEN                 ( AXI_08_AWLEN[3:0]    ), 
      .AXI_08_AWSIZE                ( AXI_08_AWSIZE        ), 
      .AXI_08_AWVALID               ( AXI_08_AWVALID       ), 
      .AXI_08_RREADY                ( AXI_08_RREADY        ), 
      .AXI_08_BREADY                ( AXI_08_BREADY        ), 
      .AXI_08_WDATA                 ( AXI_08_WDATA         ), 
      .AXI_08_WLAST                 ( AXI_08_WLAST         ), 
      .AXI_08_WSTRB                 ( AXI_08_WSTRB         ), 
      .AXI_08_WDATA_PARITY          ( AXI_08_WDATA_PARITY  ), 
      .AXI_08_WVALID                ( AXI_08_WVALID        ), 
      .AXI_09_ACLK                  ( AXI_ACLK4_st0_buf    ), 
      .AXI_09_ARESET_N              ( axi_rst4_st0_n       ), 
      .AXI_09_ARADDR                ( AXI_09_ARADDR        ), 
      .AXI_09_ARBURST               ( AXI_09_ARBURST       ), 
      .AXI_09_ARID                  ( AXI_09_ARID          ), 
      .AXI_09_ARLEN                 ( AXI_09_ARLEN[3:0]    ), 
      .AXI_09_ARSIZE                ( AXI_09_ARSIZE        ), 
      .AXI_09_ARVALID               ( AXI_09_ARVALID       ), 
      .AXI_09_AWADDR                ( AXI_09_AWADDR        ), 
      .AXI_09_AWBURST               ( AXI_09_AWBURST       ), 
      .AXI_09_AWID                  ( AXI_09_AWID          ), 
      .AXI_09_AWLEN                 ( AXI_09_AWLEN[3:0]    ), 
      .AXI_09_AWSIZE                ( AXI_09_AWSIZE        ), 
      .AXI_09_AWVALID               ( AXI_09_AWVALID       ), 
      .AXI_09_RREADY                ( AXI_09_RREADY        ), 
      .AXI_09_BREADY                ( AXI_09_BREADY        ), 
      .AXI_09_WDATA                 ( AXI_09_WDATA         ), 
      .AXI_09_WLAST                 ( AXI_09_WLAST         ), 
      .AXI_09_WSTRB                 ( AXI_09_WSTRB         ), 
      .AXI_09_WDATA_PARITY          ( AXI_09_WDATA_PARITY  ), 
      .AXI_09_WVALID                ( AXI_09_WVALID        ), 
      .AXI_10_ACLK                  ( AXI_ACLK5_st0_buf    ), 
      .AXI_10_ARESET_N              ( axi_rst5_st0_n       ), 
      .AXI_10_ARADDR                ( AXI_10_ARADDR        ), 
      .AXI_10_ARBURST               ( AXI_10_ARBURST       ), 
      .AXI_10_ARID                  ( AXI_10_ARID          ), 
      .AXI_10_ARLEN                 ( AXI_10_ARLEN[3:0]    ), 
      .AXI_10_ARSIZE                ( AXI_10_ARSIZE        ), 
      .AXI_10_ARVALID               ( AXI_10_ARVALID       ), 
      .AXI_10_AWADDR                ( AXI_10_AWADDR        ), 
      .AXI_10_AWBURST               ( AXI_10_AWBURST       ), 
      .AXI_10_AWID                  ( AXI_10_AWID          ), 
      .AXI_10_AWLEN                 ( AXI_10_AWLEN[3:0]    ), 
      .AXI_10_AWSIZE                ( AXI_10_AWSIZE        ), 
      .AXI_10_AWVALID               ( AXI_10_AWVALID       ), 
      .AXI_10_RREADY                ( AXI_10_RREADY        ), 
      .AXI_10_BREADY                ( AXI_10_BREADY        ), 
      .AXI_10_WDATA                 ( AXI_10_WDATA         ), 
      .AXI_10_WLAST                 ( AXI_10_WLAST         ), 
      .AXI_10_WSTRB                 ( AXI_10_WSTRB         ), 
      .AXI_10_WDATA_PARITY          ( AXI_10_WDATA_PARITY  ), 
      .AXI_10_WVALID                ( AXI_10_WVALID        ), 
      .AXI_11_ACLK                  ( AXI_ACLK5_st0_buf    ), 
      .AXI_11_ARESET_N              ( axi_rst5_st0_n       ), 
      .AXI_11_ARADDR                ( AXI_11_ARADDR        ), 
      .AXI_11_ARBURST               ( AXI_11_ARBURST       ), 
      .AXI_11_ARID                  ( AXI_11_ARID          ), 
      .AXI_11_ARLEN                 ( AXI_11_ARLEN[3:0]    ), 
      .AXI_11_ARSIZE                ( AXI_11_ARSIZE        ), 
      .AXI_11_ARVALID               ( AXI_11_ARVALID       ), 
      .AXI_11_AWADDR                ( AXI_11_AWADDR        ), 
      .AXI_11_AWBURST               ( AXI_11_AWBURST       ), 
      .AXI_11_AWID                  ( AXI_11_AWID          ), 
      .AXI_11_AWLEN                 ( AXI_11_AWLEN[3:0]    ), 
      .AXI_11_AWSIZE                ( AXI_11_AWSIZE        ), 
      .AXI_11_AWVALID               ( AXI_11_AWVALID       ), 
      .AXI_11_RREADY                ( AXI_11_RREADY        ), 
      .AXI_11_BREADY                ( AXI_11_BREADY        ), 
      .AXI_11_WDATA                 ( AXI_11_WDATA         ), 
      .AXI_11_WLAST                 ( AXI_11_WLAST         ), 
      .AXI_11_WSTRB                 ( AXI_11_WSTRB         ), 
      .AXI_11_WDATA_PARITY          ( AXI_11_WDATA_PARITY  ), 
      .AXI_11_WVALID                ( AXI_11_WVALID        ), 
      .AXI_12_ACLK                  ( AXI_ACLK5_st0_buf    ), 
      .AXI_12_ARESET_N              ( axi_rst5_st0_n       ), 
      .AXI_12_ARADDR                ( AXI_12_ARADDR        ), 
      .AXI_12_ARBURST               ( AXI_12_ARBURST       ), 
      .AXI_12_ARID                  ( AXI_12_ARID          ), 
      .AXI_12_ARLEN                 ( AXI_12_ARLEN[3:0]    ), 
      .AXI_12_ARSIZE                ( AXI_12_ARSIZE        ), 
      .AXI_12_ARVALID               ( AXI_12_ARVALID       ), 
      .AXI_12_AWADDR                ( AXI_12_AWADDR        ), 
      .AXI_12_AWBURST               ( AXI_12_AWBURST       ), 
      .AXI_12_AWID                  ( AXI_12_AWID          ), 
      .AXI_12_AWLEN                 ( AXI_12_AWLEN[3:0]    ), 
      .AXI_12_AWSIZE                ( AXI_12_AWSIZE        ), 
      .AXI_12_AWVALID               ( AXI_12_AWVALID       ), 
      .AXI_12_RREADY                ( AXI_12_RREADY        ), 
      .AXI_12_BREADY                ( AXI_12_BREADY        ), 
      .AXI_12_WDATA                 ( AXI_12_WDATA         ), 
      .AXI_12_WLAST                 ( AXI_12_WLAST         ), 
      .AXI_12_WSTRB                 ( AXI_12_WSTRB         ), 
      .AXI_12_WDATA_PARITY          ( AXI_12_WDATA_PARITY  ), 
      .AXI_12_WVALID                ( AXI_12_WVALID        ), 
      .AXI_13_ACLK                  ( AXI_ACLK6_st0_buf    ), 
      .AXI_13_ARESET_N              ( axi_rst6_st0_n       ), 
      .AXI_13_ARADDR                ( AXI_13_ARADDR        ), 
      .AXI_13_ARBURST               ( AXI_13_ARBURST       ), 
      .AXI_13_ARID                  ( AXI_13_ARID          ), 
      .AXI_13_ARLEN                 ( AXI_13_ARLEN[3:0]    ), 
      .AXI_13_ARSIZE                ( AXI_13_ARSIZE        ), 
      .AXI_13_ARVALID               ( AXI_13_ARVALID       ), 
      .AXI_13_AWADDR                ( AXI_13_AWADDR        ), 
      .AXI_13_AWBURST               ( AXI_13_AWBURST       ), 
      .AXI_13_AWID                  ( AXI_13_AWID          ), 
      .AXI_13_AWLEN                 ( AXI_13_AWLEN[3:0]    ), 
      .AXI_13_AWSIZE                ( AXI_13_AWSIZE        ), 
      .AXI_13_AWVALID               ( AXI_13_AWVALID       ), 
      .AXI_13_RREADY                ( AXI_13_RREADY        ), 
      .AXI_13_BREADY                ( AXI_13_BREADY        ), 
      .AXI_13_WDATA                 ( AXI_13_WDATA         ), 
      .AXI_13_WLAST                 ( AXI_13_WLAST         ), 
      .AXI_13_WSTRB                 ( AXI_13_WSTRB         ), 
      .AXI_13_WDATA_PARITY          ( AXI_13_WDATA_PARITY  ), 
      .AXI_13_WVALID                ( AXI_13_WVALID        ), 
      .AXI_14_ACLK                  ( AXI_ACLK6_st0_buf    ), 
      .AXI_14_ARESET_N              ( axi_rst6_st0_n       ), 
      .AXI_14_ARADDR                ( AXI_14_ARADDR        ), 
      .AXI_14_ARBURST               ( AXI_14_ARBURST       ), 
      .AXI_14_ARID                  ( AXI_14_ARID          ), 
      .AXI_14_ARLEN                 ( AXI_14_ARLEN[3:0]    ), 
      .AXI_14_ARSIZE                ( AXI_14_ARSIZE        ), 
      .AXI_14_ARVALID               ( AXI_14_ARVALID       ), 
      .AXI_14_AWADDR                ( AXI_14_AWADDR        ), 
      .AXI_14_AWBURST               ( AXI_14_AWBURST       ), 
      .AXI_14_AWID                  ( AXI_14_AWID          ), 
      .AXI_14_AWLEN                 ( AXI_14_AWLEN[3:0]    ), 
      .AXI_14_AWSIZE                ( AXI_14_AWSIZE        ), 
      .AXI_14_AWVALID               ( AXI_14_AWVALID       ), 
      .AXI_14_RREADY                ( AXI_14_RREADY        ), 
      .AXI_14_BREADY                ( AXI_14_BREADY        ), 
      .AXI_14_WDATA                 ( AXI_14_WDATA         ), 
      .AXI_14_WLAST                 ( AXI_14_WLAST         ), 
      .AXI_14_WSTRB                 ( AXI_14_WSTRB         ), 
      .AXI_14_WDATA_PARITY          ( AXI_14_WDATA_PARITY  ), 
      .AXI_14_WVALID                ( AXI_14_WVALID        ), 
      .AXI_15_ACLK                  ( AXI_ACLK6_st0_buf    ), 
      .AXI_15_ARESET_N              ( axi_rst6_st0_n       ), 
      .AXI_15_ARADDR                ( AXI_15_ARADDR        ), 
      .AXI_15_ARBURST               ( AXI_15_ARBURST       ), 
      .AXI_15_ARID                  ( AXI_15_ARID          ), 
      .AXI_15_ARLEN                 ( AXI_15_ARLEN[3:0]    ), 
      .AXI_15_ARSIZE                ( AXI_15_ARSIZE        ), 
      .AXI_15_ARVALID               ( AXI_15_ARVALID       ), 
      .AXI_15_AWADDR                ( AXI_15_AWADDR        ), 
      .AXI_15_AWBURST               ( AXI_15_AWBURST       ), 
      .AXI_15_AWID                  ( AXI_15_AWID          ), 
      .AXI_15_AWLEN                 ( AXI_15_AWLEN[3:0]    ), 
      .AXI_15_AWSIZE                ( AXI_15_AWSIZE        ), 
      .AXI_15_AWVALID               ( AXI_15_AWVALID       ), 
      .AXI_15_RREADY                ( AXI_15_RREADY        ), 
      .AXI_15_BREADY                ( AXI_15_BREADY        ), 
      .AXI_15_WDATA                 ( AXI_15_WDATA         ), 
      .AXI_15_WLAST                 ( AXI_15_WLAST         ), 
      .AXI_15_WSTRB                 ( AXI_15_WSTRB         ), 
      .AXI_15_WDATA_PARITY          ( AXI_15_WDATA_PARITY  ), 
      .AXI_15_WVALID                ( AXI_15_WVALID        ), 
      
      .APB_0_PWDATA                 ( APB_0_PWDATA         ), 
      .APB_0_PADDR                  ( APB_0_PADDR          ), 
      .APB_0_PCLK                   ( APB_0_PCLK_BUF       ), 
      .APB_0_PENABLE                ( APB_0_PENABLE        ), 
      .APB_0_PRESET_N               ( APB_0_PRESET_N       ), 
      .APB_0_PSEL                   ( APB_0_PSEL           ), 
      .APB_0_PWRITE                 ( APB_0_PWRITE         ), 
      .AXI_00_ARREADY               ( AXI_00_ARREADY       ), 
      .AXI_00_AWREADY               ( AXI_00_AWREADY       ), 
      .AXI_00_RDATA_PARITY          ( AXI_00_RDATA_PARITY  ), 
      .AXI_00_RDATA                 ( AXI_00_RDATA         ), 
      .AXI_00_RID                   ( AXI_00_RID           ), 
      .AXI_00_RLAST                 ( AXI_00_RLAST         ), 
      .AXI_00_RRESP                 ( AXI_00_RRESP         ), 
      .AXI_00_RVALID                ( AXI_00_RVALID        ), 
      .AXI_00_WREADY                ( AXI_00_WREADY        ), 
      .AXI_00_BID                   ( AXI_00_BID           ), 
      .AXI_00_BRESP                 ( AXI_00_BRESP         ), 
      .AXI_00_BVALID                ( AXI_00_BVALID        ), 
      .AXI_01_ARREADY               ( AXI_01_ARREADY       ), 
      .AXI_01_AWREADY               ( AXI_01_AWREADY       ), 
      .AXI_01_RDATA_PARITY          ( AXI_01_RDATA_PARITY  ), 
      .AXI_01_RDATA                 ( AXI_01_RDATA         ), 
      .AXI_01_RID                   ( AXI_01_RID           ), 
      .AXI_01_RLAST                 ( AXI_01_RLAST         ), 
      .AXI_01_RRESP                 ( AXI_01_RRESP         ), 
      .AXI_01_RVALID                ( AXI_01_RVALID        ), 
      .AXI_01_WREADY                ( AXI_01_WREADY        ), 
      .AXI_01_BID                   ( AXI_01_BID           ), 
      .AXI_01_BRESP                 ( AXI_01_BRESP         ), 
      .AXI_01_BVALID                ( AXI_01_BVALID        ), 
      .AXI_02_ARREADY               ( AXI_02_ARREADY       ), 
      .AXI_02_AWREADY               ( AXI_02_AWREADY       ), 
      .AXI_02_RDATA_PARITY          ( AXI_02_RDATA_PARITY  ), 
      .AXI_02_RDATA                 ( AXI_02_RDATA         ), 
      .AXI_02_RID                   ( AXI_02_RID           ), 
      .AXI_02_RLAST                 ( AXI_02_RLAST         ), 
      .AXI_02_RRESP                 ( AXI_02_RRESP         ), 
      .AXI_02_RVALID                ( AXI_02_RVALID        ), 
      .AXI_02_WREADY                ( AXI_02_WREADY        ), 
      .AXI_02_BID                   ( AXI_02_BID           ), 
      .AXI_02_BRESP                 ( AXI_02_BRESP         ), 
      .AXI_02_BVALID                ( AXI_02_BVALID        ), 
      .AXI_03_ARREADY               ( AXI_03_ARREADY       ), 
      .AXI_03_AWREADY               ( AXI_03_AWREADY       ), 
      .AXI_03_RDATA_PARITY          ( AXI_03_RDATA_PARITY  ), 
      .AXI_03_RDATA                 ( AXI_03_RDATA         ), 
      .AXI_03_RID                   ( AXI_03_RID           ), 
      .AXI_03_RLAST                 ( AXI_03_RLAST         ), 
      .AXI_03_RRESP                 ( AXI_03_RRESP         ), 
      .AXI_03_RVALID                ( AXI_03_RVALID        ), 
      .AXI_03_WREADY                ( AXI_03_WREADY        ), 
      .AXI_03_BID                   ( AXI_03_BID           ), 
      .AXI_03_BRESP                 ( AXI_03_BRESP         ), 
      .AXI_03_BVALID                ( AXI_03_BVALID        ), 
      .AXI_04_ARREADY               ( AXI_04_ARREADY       ), 
      .AXI_04_AWREADY               ( AXI_04_AWREADY       ), 
      .AXI_04_RDATA_PARITY          ( AXI_04_RDATA_PARITY  ), 
      .AXI_04_RDATA                 ( AXI_04_RDATA         ), 
      .AXI_04_RID                   ( AXI_04_RID           ), 
      .AXI_04_RLAST                 ( AXI_04_RLAST         ), 
      .AXI_04_RRESP                 ( AXI_04_RRESP         ), 
      .AXI_04_RVALID                ( AXI_04_RVALID        ), 
      .AXI_04_WREADY                ( AXI_04_WREADY        ), 
      .AXI_04_BID                   ( AXI_04_BID           ), 
      .AXI_04_BRESP                 ( AXI_04_BRESP         ), 
      .AXI_04_BVALID                ( AXI_04_BVALID        ), 
      .AXI_05_ARREADY               ( AXI_05_ARREADY       ), 
      .AXI_05_AWREADY               ( AXI_05_AWREADY       ), 
      .AXI_05_RDATA_PARITY          ( AXI_05_RDATA_PARITY  ), 
      .AXI_05_RDATA                 ( AXI_05_RDATA         ), 
      .AXI_05_RID                   ( AXI_05_RID           ), 
      .AXI_05_RLAST                 ( AXI_05_RLAST         ), 
      .AXI_05_RRESP                 ( AXI_05_RRESP         ), 
      .AXI_05_RVALID                ( AXI_05_RVALID        ), 
      .AXI_05_WREADY                ( AXI_05_WREADY        ), 
      .AXI_05_BID                   ( AXI_05_BID           ), 
      .AXI_05_BRESP                 ( AXI_05_BRESP         ), 
      .AXI_05_BVALID                ( AXI_05_BVALID        ), 
      .AXI_06_ARREADY               ( AXI_06_ARREADY       ), 
      .AXI_06_AWREADY               ( AXI_06_AWREADY       ), 
      .AXI_06_RDATA_PARITY          ( AXI_06_RDATA_PARITY  ), 
      .AXI_06_RDATA                 ( AXI_06_RDATA         ), 
      .AXI_06_RID                   ( AXI_06_RID           ), 
      .AXI_06_RLAST                 ( AXI_06_RLAST         ), 
      .AXI_06_RRESP                 ( AXI_06_RRESP         ), 
      .AXI_06_RVALID                ( AXI_06_RVALID        ), 
      .AXI_06_WREADY                ( AXI_06_WREADY        ), 
      .AXI_06_BID                   ( AXI_06_BID           ), 
      .AXI_06_BRESP                 ( AXI_06_BRESP         ), 
      .AXI_06_BVALID                ( AXI_06_BVALID        ), 
      .AXI_07_ARREADY               ( AXI_07_ARREADY       ), 
      .AXI_07_AWREADY               ( AXI_07_AWREADY       ), 
      .AXI_07_RDATA_PARITY          ( AXI_07_RDATA_PARITY  ), 
      .AXI_07_RDATA                 ( AXI_07_RDATA         ), 
      .AXI_07_RID                   ( AXI_07_RID           ), 
      .AXI_07_RLAST                 ( AXI_07_RLAST         ), 
      .AXI_07_RRESP                 ( AXI_07_RRESP         ), 
      .AXI_07_RVALID                ( AXI_07_RVALID        ), 
      .AXI_07_WREADY                ( AXI_07_WREADY        ), 
      .AXI_07_BID                   ( AXI_07_BID           ), 
      .AXI_07_BRESP                 ( AXI_07_BRESP         ), 
      .AXI_07_BVALID                ( AXI_07_BVALID        ), 
      .AXI_08_ARREADY               ( AXI_08_ARREADY       ), 
      .AXI_08_AWREADY               ( AXI_08_AWREADY       ), 
      .AXI_08_RDATA_PARITY          ( AXI_08_RDATA_PARITY  ), 
      .AXI_08_RDATA                 ( AXI_08_RDATA         ), 
      .AXI_08_RID                   ( AXI_08_RID           ), 
      .AXI_08_RLAST                 ( AXI_08_RLAST         ), 
      .AXI_08_RRESP                 ( AXI_08_RRESP         ), 
      .AXI_08_RVALID                ( AXI_08_RVALID        ), 
      .AXI_08_WREADY                ( AXI_08_WREADY        ), 
      .AXI_08_BID                   ( AXI_08_BID           ), 
      .AXI_08_BRESP                 ( AXI_08_BRESP         ), 
      .AXI_08_BVALID                ( AXI_08_BVALID        ), 
      .AXI_09_ARREADY               ( AXI_09_ARREADY       ), 
      .AXI_09_AWREADY               ( AXI_09_AWREADY       ), 
      .AXI_09_RDATA_PARITY          ( AXI_09_RDATA_PARITY  ), 
      .AXI_09_RDATA                 ( AXI_09_RDATA         ), 
      .AXI_09_RID                   ( AXI_09_RID           ), 
      .AXI_09_RLAST                 ( AXI_09_RLAST         ), 
      .AXI_09_RRESP                 ( AXI_09_RRESP         ), 
      .AXI_09_RVALID                ( AXI_09_RVALID        ), 
      .AXI_09_WREADY                ( AXI_09_WREADY        ), 
      .AXI_09_BID                   ( AXI_09_BID           ), 
      .AXI_09_BRESP                 ( AXI_09_BRESP         ), 
      .AXI_09_BVALID                ( AXI_09_BVALID        ), 
      .AXI_10_ARREADY               ( AXI_10_ARREADY       ), 
      .AXI_10_AWREADY               ( AXI_10_AWREADY       ), 
      .AXI_10_RDATA_PARITY          ( AXI_10_RDATA_PARITY  ), 
      .AXI_10_RDATA                 ( AXI_10_RDATA         ), 
      .AXI_10_RID                   ( AXI_10_RID           ), 
      .AXI_10_RLAST                 ( AXI_10_RLAST         ), 
      .AXI_10_RRESP                 ( AXI_10_RRESP         ), 
      .AXI_10_RVALID                ( AXI_10_RVALID        ), 
      .AXI_10_WREADY                ( AXI_10_WREADY        ), 
      .AXI_10_BID                   ( AXI_10_BID           ), 
      .AXI_10_BRESP                 ( AXI_10_BRESP         ), 
      .AXI_10_BVALID                ( AXI_10_BVALID        ), 
      .AXI_11_ARREADY               ( AXI_11_ARREADY       ), 
      .AXI_11_AWREADY               ( AXI_11_AWREADY       ), 
      .AXI_11_RDATA_PARITY          ( AXI_11_RDATA_PARITY  ), 
      .AXI_11_RDATA                 ( AXI_11_RDATA         ), 
      .AXI_11_RID                   ( AXI_11_RID           ), 
      .AXI_11_RLAST                 ( AXI_11_RLAST         ), 
      .AXI_11_RRESP                 ( AXI_11_RRESP         ), 
      .AXI_11_RVALID                ( AXI_11_RVALID        ), 
      .AXI_11_WREADY                ( AXI_11_WREADY        ), 
      .AXI_11_BID                   ( AXI_11_BID           ), 
      .AXI_11_BRESP                 ( AXI_11_BRESP         ), 
      .AXI_11_BVALID                ( AXI_11_BVALID        ), 
      .AXI_12_ARREADY               ( AXI_12_ARREADY       ), 
      .AXI_12_AWREADY               ( AXI_12_AWREADY       ), 
      .AXI_12_RDATA_PARITY          ( AXI_12_RDATA_PARITY  ), 
      .AXI_12_RDATA                 ( AXI_12_RDATA         ), 
      .AXI_12_RID                   ( AXI_12_RID           ), 
      .AXI_12_RLAST                 ( AXI_12_RLAST         ), 
      .AXI_12_RRESP                 ( AXI_12_RRESP         ), 
      .AXI_12_RVALID                ( AXI_12_RVALID        ), 
      .AXI_12_WREADY                ( AXI_12_WREADY        ), 
      .AXI_12_BID                   ( AXI_12_BID           ), 
      .AXI_12_BRESP                 ( AXI_12_BRESP         ), 
      .AXI_12_BVALID                ( AXI_12_BVALID        ), 
      .AXI_13_ARREADY               ( AXI_13_ARREADY       ), 
      .AXI_13_AWREADY               ( AXI_13_AWREADY       ), 
      .AXI_13_RDATA_PARITY          ( AXI_13_RDATA_PARITY  ), 
      .AXI_13_RDATA                 ( AXI_13_RDATA         ), 
      .AXI_13_RID                   ( AXI_13_RID           ), 
      .AXI_13_RLAST                 ( AXI_13_RLAST         ), 
      .AXI_13_RRESP                 ( AXI_13_RRESP         ), 
      .AXI_13_RVALID                ( AXI_13_RVALID        ), 
      .AXI_13_WREADY                ( AXI_13_WREADY        ), 
      .AXI_13_BID                   ( AXI_13_BID           ), 
      .AXI_13_BRESP                 ( AXI_13_BRESP         ), 
      .AXI_13_BVALID                ( AXI_13_BVALID        ), 
      .AXI_14_ARREADY               ( AXI_14_ARREADY       ), 
      .AXI_14_AWREADY               ( AXI_14_AWREADY       ), 
      .AXI_14_RDATA_PARITY          ( AXI_14_RDATA_PARITY  ), 
      .AXI_14_RDATA                 ( AXI_14_RDATA         ), 
      .AXI_14_RID                   ( AXI_14_RID           ), 
      .AXI_14_RLAST                 ( AXI_14_RLAST         ), 
      .AXI_14_RRESP                 ( AXI_14_RRESP         ), 
      .AXI_14_RVALID                ( AXI_14_RVALID        ), 
      .AXI_14_WREADY                ( AXI_14_WREADY        ), 
      .AXI_14_BID                   ( AXI_14_BID           ), 
      .AXI_14_BRESP                 ( AXI_14_BRESP         ), 
      .AXI_14_BVALID                ( AXI_14_BVALID        ), 
      .AXI_15_ARREADY               ( AXI_15_ARREADY       ), 
      .AXI_15_AWREADY               ( AXI_15_AWREADY       ), 
      .AXI_15_RDATA_PARITY          ( AXI_15_RDATA_PARITY  ), 
      .AXI_15_RDATA                 ( AXI_15_RDATA         ), 
      .AXI_15_RID                   ( AXI_15_RID           ), 
      .AXI_15_RLAST                 ( AXI_15_RLAST         ), 
      .AXI_15_RRESP                 ( AXI_15_RRESP         ), 
      .AXI_15_RVALID                ( AXI_15_RVALID        ), 
      .AXI_15_WREADY                ( AXI_15_WREADY        ), 
      .AXI_15_BID                   ( AXI_15_BID           ), 
      .AXI_15_BRESP                 ( AXI_15_BRESP         ), 
      .AXI_15_BVALID                ( AXI_15_BVALID        ), 
      .apb_complete_0               ( apb_seq_complete_0_s ), 
      .APB_0_PRDATA                 ( APB_0_PRDATA         ), 
      .APB_0_PREADY                 ( APB_0_PREADY         ), 
      .APB_0_PSLVERR                ( APB_0_PSLVERR        ), 
      
      .DRAM_0_STAT_CATTRIP          ( DRAM_0_STAT_CATTRIP  ), 
      .DRAM_0_STAT_TEMP             ( DRAM_0_STAT_TEMP     )  
    ) ;


endmodule

