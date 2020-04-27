`default_nettype none
`timescale 1ns / 1ps

`include "defines_h.vh"
`include "param.vh"

module AXONERVE_HBM_TOP(/*AUTOARG*/
    // Outputs

    // Inputs
    //CPU_RESET 
    input wire SYSCLK3_P,
    input wire SYSCLK3_N,

    input wire [3 :0]  gt_rxp_in,
    input wire [3 :0]  gt_rxn_in,
    output wire [3 :0] gt_txp_out,
    output wire [3 :0] gt_txn_out,
    input wire 	  gt_ref_clk_p,
    input wire 	  gt_ref_clk_n
    );

   //====================================================================
   // Declaration of Parameter                                           
   //====================================================================
    parameter            P_CAM_Group           = `CAM_Group       ;         // CAM group number
    parameter            P_Key_Width           = `Key_Width       ;         // Key data width
    parameter            P_Entry_AdSize        = `Entry_AdSize    ;         // Entry address size
    parameter            P_Srch_RAM_Width      = `Entry_AdSize+1  ;         // data width(for search)
    parameter            P_Srch_RAM_AdSize     = `Srch_RAM_AdSize ;         // memory address size(for search)
    parameter            P_Srch_RAM_Num        = `Srch_RAM_Num    ;         // Number of Search SRAMs
    parameter            P_Pri_Size            = `Pri_Size        ;         // Priority width
    parameter            P_VALUE_Width         = `VALUE_Width     ; 
   //====================================================================
   // Declaration of Local Parameter                                     
   //====================================================================
    localparam           P_Total_Key_Width     = P_Key_Width;
   //====================================================================
   // Declaration of Asynchronus reset                                   
   //====================================================================
   //input                              CPU_RESET ;          // Reset
   //====================================================================
   // Declaration of Control port                                        
   //====================================================================
    
    //===================================================================
    (* mark_debug = "true" *)wire   [P_Entry_AdSize-1:0]        OSRCH_ENT_ADD ; 
    (* mark_debug = "true" *)wire   [P_Key_Width-1:0]           OKEY_DAT ; 
    wire   [P_Key_Width-1:0]           OKEY_MSK ; 
    wire   [P_Pri_Size-1:0]            OKEY_PRI ; 
    (* mark_debug = "true" *)wire   [P_VALUE_Width-1:0]         OKEY_VALUE ; 
    //===================================================================

    wire                               CPU_RESET_buf ; 
    //
    wire                               w_iclk ; 
    wire                               w_iclkdiv2 ;
    wire                               w_ixrst ; 
    wire                               w_AXICLK ; 
    wire                               w_HBMREFCLK ; 

    (* mark_debug = "true" *)wire  [P_Key_Width-1:0]            w_gen_key ; 
    wire  [P_Key_Width-1:0]            w_gen_msk ; 
    wire  [P_Pri_Size-1:0]             w_gen_pri ; 
    (* mark_debug = "true" *)wire  [P_VALUE_Width-1:0]          w_gen_val ; 
    (* mark_debug = "true" *)wire  [P_Entry_AdSize-1:0]         w_gen_add ; 
    (* mark_debug = "true" *)wire                               w_ie ; 
    (* mark_debug = "true" *)wire                               w_we ; 
    (* mark_debug = "true" *)wire                               w_re ; 
    (* mark_debug = "true" *)wire                               w_se ; 

    wire                               w_AXI_ACLK_00 ;
    wire                               w_AXI_ACLK_01 ;
    wire                               w_AXI_ACLK_02 ;
    wire                               w_AXI_ACLK_03 ;
    wire                               w_AXI_ACLK_04 ;
    wire                               w_AXI_ACLK_05 ;
    wire                               w_AXI_ACLK_06 ;

    // HBM wire 
    wire [ 31:0]                       APB_0_PWDATA ;
    wire [ 21:0]                       APB_0_PADDR  ;
    wire                               APB_0_PENABLE = 1'b0;
    wire                               APB_0_PSEL    = 1'b0;
    wire                               APB_0_PWRITE  = 1'b0;
    wire [ 31:0]                       APB_0_PRDATA ;
    wire                               APB_0_PREADY ;
    wire                               APB_0_PSLVERR ;

    wire [ 27:0]                       AXI_00_ARADDR ;
    wire [  1:0]                       AXI_00_ARBURST ;
    wire [  8:0]                       AXI_00_ARID ;
    wire [  7:0]                       AXI_00_ARLEN ;
    wire [  2:0]                       AXI_00_ARSIZE ;
    wire                               AXI_00_ARVALID ;
    wire [ 27:0]                       AXI_00_AWADDR ;
    wire [  1:0]                       AXI_00_AWBURST ;
    wire [  8:0]                       AXI_00_AWID ;
    wire [  7:0]                       AXI_00_AWLEN ;
    wire [  2:0]                       AXI_00_AWSIZE ;
    wire                               AXI_00_AWVALID ;
    wire                               AXI_00_RREADY ;
    wire                               AXI_00_BREADY ;
    wire [255:0]                       AXI_00_WDATA ;
    wire                               AXI_00_WLAST ;
    wire [ 31:0]                       AXI_00_WSTRB ;
    wire                               AXI_00_WVALID ;
    wire [3:0]                         AXI_00_ARCACHE ;
    wire [3:0]                         AXI_00_AWCACHE ;
    wire [2:0]                         AXI_00_AWPROT ;
    wire [ 27:0]                       AXI_01_ARADDR ;
    wire [  1:0]                       AXI_01_ARBURST ;
    wire [  8:0]                       AXI_01_ARID ;
    wire [  7:0]                       AXI_01_ARLEN ;
    wire [  2:0]                       AXI_01_ARSIZE ;
    wire                               AXI_01_ARVALID  ;
    wire [ 27:0]                       AXI_01_AWADDR ;
    wire [  1:0]                       AXI_01_AWBURST ;
    wire [  8:0]                       AXI_01_AWID ;
    wire [  7:0]                       AXI_01_AWLEN ;
    wire [  2:0]                       AXI_01_AWSIZE ;
    wire                               AXI_01_AWVALID ;
    wire                               AXI_01_RREADY ;
    wire                               AXI_01_BREADY ;
    wire [255:0]                       AXI_01_WDATA ;
    wire                               AXI_01_WLAST ;
    wire [ 31:0]                       AXI_01_WSTRB ;
    wire                               AXI_01_WVALID ;
    wire [3:0]                         AXI_01_ARCACHE ;
    wire [3:0]                         AXI_01_AWCACHE ;
    wire [2:0]                         AXI_01_AWPROT ;
    wire [ 27:0]                       AXI_02_ARADDR ;
    wire [  1:0]                       AXI_02_ARBURST ;
    wire [  8:0]                       AXI_02_ARID ;
    wire [  7:0]                       AXI_02_ARLEN ;
    wire [  2:0]                       AXI_02_ARSIZE ;
    wire                               AXI_02_ARVALID ;
    wire [ 27:0]                       AXI_02_AWADDR ;
    wire [  1:0]                       AXI_02_AWBURST ;
    wire [  8:0]                       AXI_02_AWID ;
    wire [  7:0]                       AXI_02_AWLEN ;
    wire [  2:0]                       AXI_02_AWSIZE ;
    wire                               AXI_02_AWVALID ;
    wire                               AXI_02_RREADY ;
    wire                               AXI_02_BREADY ;
    wire [255:0]                       AXI_02_WDATA ;
    wire                               AXI_02_WLAST ;
    wire [ 31:0]                       AXI_02_WSTRB ;
    wire                               AXI_02_WVALID ;
    wire [3:0]                         AXI_02_ARCACHE ;
    wire [3:0]                         AXI_02_AWCACHE ;
    wire [2:0]                         AXI_02_AWPROT ;
    wire [ 27:0]                       AXI_03_ARADDR ;
    wire [  1:0]                       AXI_03_ARBURST ;
    wire [  8:0]                       AXI_03_ARID ;
    wire [  7:0]                       AXI_03_ARLEN ;
    wire [  2:0]                       AXI_03_ARSIZE ;
    wire                               AXI_03_ARVALID ;
    wire [ 27:0]                       AXI_03_AWADDR ;
    wire [  1:0]                       AXI_03_AWBURST ;
    wire [  8:0]                       AXI_03_AWID ;
    wire [  7:0]                       AXI_03_AWLEN ;
    wire [  2:0]                       AXI_03_AWSIZE ;
    wire                               AXI_03_AWVALID ;
    wire                               AXI_03_RREADY ;
    wire                               AXI_03_BREADY ;
    wire [255:0]                       AXI_03_WDATA ;
    wire                               AXI_03_WLAST ;
    wire [ 31:0]                       AXI_03_WSTRB ;
    wire                               AXI_03_WVALID ;
    wire [3:0]                         AXI_03_ARCACHE ;
    wire [3:0]                         AXI_03_AWCACHE ;
    wire [2:0]                         AXI_03_AWPROT ;
    wire [ 27:0]                       AXI_04_ARADDR ;
    wire [  1:0]                       AXI_04_ARBURST ;
    wire [  8:0]                       AXI_04_ARID ;
    wire [  7:0]                       AXI_04_ARLEN ;
    wire [  2:0]                       AXI_04_ARSIZE ;
    wire                               AXI_04_ARVALID ;
    wire [ 27:0]                       AXI_04_AWADDR ;
    wire [  1:0]                       AXI_04_AWBURST ;
    wire [  8:0]                       AXI_04_AWID ;
    wire [  7:0]                       AXI_04_AWLEN ;
    wire [  2:0]                       AXI_04_AWSIZE ;
    wire                               AXI_04_AWVALID ;
    wire                               AXI_04_RREADY ;
    wire                               AXI_04_BREADY ;
    wire [255:0]                       AXI_04_WDATA ;
    wire                               AXI_04_WLAST ;
    wire [ 31:0]                       AXI_04_WSTRB ;
    wire                               AXI_04_WVALID ;
    wire [3:0]                         AXI_04_ARCACHE ;
    wire [3:0]                         AXI_04_AWCACHE ;
    wire [2:0]                         AXI_04_AWPROT ;
    wire [ 27:0]                       AXI_05_ARADDR ;
    wire [  1:0]                       AXI_05_ARBURST ;
    wire [  8:0]                       AXI_05_ARID ;
    wire [  7:0]                       AXI_05_ARLEN ;
    wire [  2:0]                       AXI_05_ARSIZE ;
    wire                               AXI_05_ARVALID ;
    wire [ 27:0]                       AXI_05_AWADDR ;
    wire [  1:0]                       AXI_05_AWBURST ;
    wire [  8:0]                       AXI_05_AWID ;
    wire [  7:0]                       AXI_05_AWLEN ;
    wire [  2:0]                       AXI_05_AWSIZE ;
    wire                               AXI_05_AWVALID ;
    wire                               AXI_05_RREADY ;
    wire                               AXI_05_BREADY ;
    wire [255:0]                       AXI_05_WDATA ;
    wire                               AXI_05_WLAST ;
    wire [ 31:0]                       AXI_05_WSTRB ;
    wire                               AXI_05_WVALID ;
    wire [3:0]                         AXI_05_ARCACHE ;
    wire [3:0]                         AXI_05_AWCACHE ;
    wire [2:0]                         AXI_05_AWPROT ;
    wire [ 27:0]                       AXI_06_ARADDR ;
    wire [  1:0]                       AXI_06_ARBURST ;
    wire [  8:0]                       AXI_06_ARID ;
    wire [  7:0]                       AXI_06_ARLEN ;
    wire [  2:0]                       AXI_06_ARSIZE ;
    wire                               AXI_06_ARVALID ;
    wire [ 27:0]                       AXI_06_AWADDR ;
    wire [  1:0]                       AXI_06_AWBURST ;
    wire [  8:0]                       AXI_06_AWID ;
    wire [  7:0]                       AXI_06_AWLEN ;
    wire [  2:0]                       AXI_06_AWSIZE ;
    wire                               AXI_06_AWVALID ;
    wire                               AXI_06_RREADY ;
    wire                               AXI_06_BREADY ;
    wire [255:0]                       AXI_06_WDATA ;
    wire                               AXI_06_WLAST ;
    wire [ 31:0]                       AXI_06_WSTRB ;
    wire                               AXI_06_WVALID ;
    wire [3:0]                         AXI_06_ARCACHE ;
    wire [3:0]                         AXI_06_AWCACHE ;
    wire [2:0]                         AXI_06_AWPROT ;
    wire [ 27:0]                       AXI_07_ARADDR ;
    wire [  1:0]                       AXI_07_ARBURST ;
    wire [  8:0]                       AXI_07_ARID ;
    wire [  7:0]                       AXI_07_ARLEN ;
    wire [  2:0]                       AXI_07_ARSIZE ;
    wire                               AXI_07_ARVALID ;
    wire [ 27:0]                       AXI_07_AWADDR ;
    wire [  1:0]                       AXI_07_AWBURST ;
    wire [  8:0]                       AXI_07_AWID ;
    wire [  7:0]                       AXI_07_AWLEN ;
    wire [  2:0]                       AXI_07_AWSIZE ;
    wire                               AXI_07_AWVALID ;
    wire                               AXI_07_RREADY ;
    wire                               AXI_07_BREADY ;
    wire [255:0]                       AXI_07_WDATA ;
    wire                               AXI_07_WLAST ;
    wire [ 31:0]                       AXI_07_WSTRB ;
    wire                               AXI_07_WVALID ;
    wire [3:0]                         AXI_07_ARCACHE ;
    wire [3:0]                         AXI_07_AWCACHE ;
    wire [2:0]                         AXI_07_AWPROT ;
    wire [ 27:0]                       AXI_08_ARADDR ;
    wire [  1:0]                       AXI_08_ARBURST ;
    wire [  8:0]                       AXI_08_ARID ;
    wire [  7:0]                       AXI_08_ARLEN ;
    wire [  2:0]                       AXI_08_ARSIZE ;
    wire                               AXI_08_ARVALID ;
    wire [ 27:0]                       AXI_08_AWADDR ;
    wire [  1:0]                       AXI_08_AWBURST ;
    wire [  8:0]                       AXI_08_AWID ;
    wire [  7:0]                       AXI_08_AWLEN ;
    wire [  2:0]                       AXI_08_AWSIZE ;
    wire                               AXI_08_AWVALID ;
    wire                               AXI_08_RREADY ;
    wire                               AXI_08_BREADY ;
    wire [255:0]                       AXI_08_WDATA ;
    wire                               AXI_08_WLAST ;
    wire [ 31:0]                       AXI_08_WSTRB ;
    wire                               AXI_08_WVALID ;
    wire [3:0]                         AXI_08_ARCACHE ;
    wire [3:0]                         AXI_08_AWCACHE ;
    wire [2:0]                         AXI_08_AWPROT ;
    wire [ 27:0]                       AXI_09_ARADDR ;
    wire [  1:0]                       AXI_09_ARBURST ;
    wire [  8:0]                       AXI_09_ARID ;
    wire [  7:0]                       AXI_09_ARLEN ;
    wire [  2:0]                       AXI_09_ARSIZE ;
    wire                               AXI_09_ARVALID ;
    wire [ 27:0]                       AXI_09_AWADDR ;
    wire [  1:0]                       AXI_09_AWBURST ;
    wire [  8:0]                       AXI_09_AWID ;
    wire [  7:0]                       AXI_09_AWLEN ;
    wire [  2:0]                       AXI_09_AWSIZE ;
    wire                               AXI_09_AWVALID ;
    wire                               AXI_09_RREADY ;
    wire                               AXI_09_BREADY ;
    wire [255:0]                       AXI_09_WDATA ;
    wire                               AXI_09_WLAST ;
    wire [ 31:0]                       AXI_09_WSTRB ;
    wire                               AXI_09_WVALID ;
    wire [3:0]                         AXI_09_ARCACHE ;
    wire [3:0]                         AXI_09_AWCACHE ;
    wire [2:0]                         AXI_09_AWPROT ;
    wire [ 27:0]                       AXI_10_ARADDR ;
    wire [  1:0]                       AXI_10_ARBURST ;
    wire [  8:0]                       AXI_10_ARID ;
    wire [  7:0]                       AXI_10_ARLEN ;
    wire [  2:0]                       AXI_10_ARSIZE ;
    wire                               AXI_10_ARVALID ;
    wire [ 27:0]                       AXI_10_AWADDR ;
    wire [  1:0]                       AXI_10_AWBURST ;
    wire [  8:0]                       AXI_10_AWID ;
    wire [  7:0]                       AXI_10_AWLEN ;
    wire [  2:0]                       AXI_10_AWSIZE ;
    wire                               AXI_10_AWVALID ;
    wire                               AXI_10_RREADY ;
    wire                               AXI_10_BREADY ;
    wire [255:0]                       AXI_10_WDATA ;
    wire                               AXI_10_WLAST ;
    wire [ 31:0]                       AXI_10_WSTRB ;
    wire                               AXI_10_WVALID ;
    wire [3:0]                         AXI_10_ARCACHE ;
    wire [3:0]                         AXI_10_AWCACHE ;
    wire [2:0]                         AXI_10_AWPROT ;
    wire [ 27:0]                       AXI_11_ARADDR ;
    wire [  1:0]                       AXI_11_ARBURST ;
    wire [  8:0]                       AXI_11_ARID ;
    wire [  7:0]                       AXI_11_ARLEN ;
    wire [  2:0]                       AXI_11_ARSIZE ;
    wire                               AXI_11_ARVALID ;
    wire [ 27:0]                       AXI_11_AWADDR ;
    wire [  1:0]                       AXI_11_AWBURST ;
    wire [  8:0]                       AXI_11_AWID ;
    wire [  7:0]                       AXI_11_AWLEN ;
    wire [  2:0]                       AXI_11_AWSIZE ;
    wire                               AXI_11_AWVALID ;
    wire                               AXI_11_RREADY ;
    wire                               AXI_11_BREADY ;
    wire [255:0]                       AXI_11_WDATA ;
    wire                               AXI_11_WLAST ;
    wire [ 31:0]                       AXI_11_WSTRB ;
    wire                               AXI_11_WVALID ;
    wire [3:0]                         AXI_11_ARCACHE ;
    wire [3:0]                         AXI_11_AWCACHE ;
    wire [2:0]                         AXI_11_AWPROT ;
    wire [ 27:0]                       AXI_12_ARADDR ;
    wire [  1:0]                       AXI_12_ARBURST ;
    wire [  8:0]                       AXI_12_ARID ;
    wire [  7:0]                       AXI_12_ARLEN ;
    wire [  2:0]                       AXI_12_ARSIZE ;
    wire                               AXI_12_ARVALID ;
    wire [ 27:0]                       AXI_12_AWADDR ;
    wire [  1:0]                       AXI_12_AWBURST ;
    wire [  8:0]                       AXI_12_AWID ;
    wire [  7:0]                       AXI_12_AWLEN ;
    wire [  2:0]                       AXI_12_AWSIZE ;
    wire                               AXI_12_AWVALID ;
    wire                               AXI_12_RREADY ;
    wire                               AXI_12_BREADY ;
    wire [255:0]                       AXI_12_WDATA ;
    wire                               AXI_12_WLAST ;
    wire [ 31:0]                       AXI_12_WSTRB ;
    wire                               AXI_12_WVALID ;
    wire [3:0]                         AXI_12_ARCACHE ;
    wire [3:0]                         AXI_12_AWCACHE ;
    wire [2:0]                         AXI_12_AWPROT ;
    wire [ 27:0]                       AXI_13_ARADDR ;
    wire [  1:0]                       AXI_13_ARBURST ;
    wire [  8:0]                       AXI_13_ARID ;
    wire [  7:0]                       AXI_13_ARLEN ;
    wire [  2:0]                       AXI_13_ARSIZE ;
    wire                               AXI_13_ARVALID ;
    wire [ 27:0]                       AXI_13_AWADDR ;
    wire [  1:0]                       AXI_13_AWBURST ;
    wire [  8:0]                       AXI_13_AWID ;
    wire [  7:0]                       AXI_13_AWLEN ;
    wire [  2:0]                       AXI_13_AWSIZE ;
    wire                               AXI_13_AWVALID ;
    wire                               AXI_13_RREADY ;
    wire                               AXI_13_BREADY ;
    wire [255:0]                       AXI_13_WDATA ;
    wire                               AXI_13_WLAST ;
    wire [ 31:0]                       AXI_13_WSTRB ;
    wire                               AXI_13_WVALID ;
    wire [3:0]                         AXI_13_ARCACHE ;
    wire [3:0]                         AXI_13_AWCACHE ;
    wire [2:0]                         AXI_13_AWPROT ;
    wire [ 27:0]                       AXI_14_ARADDR ;
    wire [  1:0]                       AXI_14_ARBURST ;
    wire [  8:0]                       AXI_14_ARID ;
    wire [  7:0]                       AXI_14_ARLEN ;
    wire [  2:0]                       AXI_14_ARSIZE ;
    wire                               AXI_14_ARVALID ;
    wire [ 27:0]                       AXI_14_AWADDR ;
    wire [  1:0]                       AXI_14_AWBURST ;
    wire [  8:0]                       AXI_14_AWID ;
    wire [  7:0]                       AXI_14_AWLEN ;
    wire [  2:0]                       AXI_14_AWSIZE ;
    wire                               AXI_14_AWVALID ;
    wire                               AXI_14_RREADY ;
    wire                               AXI_14_BREADY ;
    wire [255:0]                       AXI_14_WDATA ;
    wire                               AXI_14_WLAST ;
    wire [ 31:0]                       AXI_14_WSTRB ;
    wire                               AXI_14_WVALID ;
    wire [3:0]                         AXI_14_ARCACHE ;
    wire [3:0]                         AXI_14_AWCACHE ;
    wire [2:0]                         AXI_14_AWPROT ;
    wire [ 27:0]                       AXI_15_ARADDR ;
    wire [  1:0]                       AXI_15_ARBURST ;
    wire [  8:0]                       AXI_15_ARID ;
    wire [  7:0]                       AXI_15_ARLEN ;
    wire [  2:0]                       AXI_15_ARSIZE ;
    wire                               AXI_15_ARVALID ;
    wire [ 27:0]                       AXI_15_AWADDR ;
    wire [  1:0]                       AXI_15_AWBURST ;
    wire [  8:0]                       AXI_15_AWID ;
    wire [  7:0]                       AXI_15_AWLEN ;
    wire [  2:0]                       AXI_15_AWSIZE ;
    wire                               AXI_15_AWVALID ;
    wire                               AXI_15_RREADY ;
    wire                               AXI_15_BREADY ;
    wire [255:0]                       AXI_15_WDATA ;
    wire                               AXI_15_WLAST ;
    wire [ 31:0]                       AXI_15_WSTRB ;
    wire                               AXI_15_WVALID ;
    wire [3:0]                         AXI_15_ARCACHE ;
    wire [3:0]                         AXI_15_AWCACHE ;
    wire [2:0]                         AXI_15_AWPROT ;
    wire                               AXI_00_ARREADY ;
    wire                               AXI_00_AWREADY ;
    wire [ 31:0]                       AXI_00_RDATA_PARITY ;
    wire [255:0]                       AXI_00_RDATA ;
    wire [  5:0]                       AXI_00_RID ;
    wire                               AXI_00_RLAST ;
    wire [  1:0]                       AXI_00_RRESP ;
    wire                               AXI_00_RVALID ;
    wire                               AXI_00_WREADY ;
    wire [  5:0]                       AXI_00_BID ;
    wire [  1:0]                       AXI_00_BRESP ;
    wire                               AXI_00_BVALID ;
    wire                               AXI_01_ARREADY ;
    wire                               AXI_01_AWREADY ;
    wire [ 31:0]                       AXI_01_RDATA_PARITY ;
    wire [255:0]                       AXI_01_RDATA ;
    wire [  5:0]                       AXI_01_RID ;
    wire                               AXI_01_RLAST ;
    wire [  1:0]                       AXI_01_RRESP ;
    wire                               AXI_01_RVALID ;
    wire                               AXI_01_WREADY ;
    wire [  5:0]                       AXI_01_BID ;
    wire [  1:0]                       AXI_01_BRESP ;
    wire                               AXI_01_BVALID ;
    wire                               AXI_02_ARREADY ;
    wire                               AXI_02_AWREADY ;
    wire [ 31:0]                       AXI_02_RDATA_PARITY ;
    wire [255:0]                       AXI_02_RDATA ;
    wire [  5:0]                       AXI_02_RID ;
    wire                               AXI_02_RLAST ;
    wire [  1:0]                       AXI_02_RRESP ;
    wire                               AXI_02_RVALID ;
    wire                               AXI_02_WREADY ;
    wire [  5:0]                       AXI_02_BID ;
    wire [  1:0]                       AXI_02_BRESP ;
    wire                               AXI_02_BVALID ;
    wire                               AXI_03_ARREADY ;
    wire                               AXI_03_AWREADY ;
    wire [ 31:0]                       AXI_03_RDATA_PARITY ;
    wire [255:0]                       AXI_03_RDATA ;
    wire [  5:0]                       AXI_03_RID ;
    wire                               AXI_03_RLAST ;
    wire [  1:0]                       AXI_03_RRESP ;
    wire                               AXI_03_RVALID ;
    wire                               AXI_03_WREADY ;
    wire [  5:0]                       AXI_03_BID ;
    wire [  1:0]                       AXI_03_BRESP ;
    wire                               AXI_03_BVALID ;
    wire                               AXI_04_ARREADY ;
    wire                               AXI_04_AWREADY ;
    wire [ 31:0]                       AXI_04_RDATA_PARITY ;
    wire [255:0]                       AXI_04_RDATA ;
    wire [  5:0]                       AXI_04_RID ;
    wire                               AXI_04_RLAST ;
    wire [  1:0]                       AXI_04_RRESP ;
    wire                               AXI_04_RVALID ;
    wire                               AXI_04_WREADY ;
    wire [  5:0]                       AXI_04_BID ;
    wire [  1:0]                       AXI_04_BRESP ;
    wire                               AXI_04_BVALID ;
    wire                               AXI_05_ARREADY ;
    wire                               AXI_05_AWREADY ;
    wire [ 31:0]                       AXI_05_RDATA_PARITY ;
    wire [255:0]                       AXI_05_RDATA ;
    wire [  5:0]                       AXI_05_RID ;
    wire                               AXI_05_RLAST ;
    wire [  1:0]                       AXI_05_RRESP ;
    wire                               AXI_05_RVALID ;
    wire                               AXI_05_WREADY ;
    wire [  5:0]                       AXI_05_BID ;
    wire [  1:0]                       AXI_05_BRESP ;
    wire                               AXI_05_BVALID ;
    wire                               AXI_06_ARREADY ;
    wire                               AXI_06_AWREADY ;
    wire [ 31:0]                       AXI_06_RDATA_PARITY ;
    wire [255:0]                       AXI_06_RDATA ;
    wire [  5:0]                       AXI_06_RID ;
    wire                               AXI_06_RLAST ;
    wire [  1:0]                       AXI_06_RRESP ;
    wire                               AXI_06_RVALID ;
    wire                               AXI_06_WREADY ;
    wire [  5:0]                       AXI_06_BID ;
    wire [  1:0]                       AXI_06_BRESP ;
    wire                               AXI_06_BVALID ;
    wire                               AXI_07_ARREADY ;
    wire                               AXI_07_AWREADY ;
    wire [ 31:0]                       AXI_07_RDATA_PARITY ;
    wire [255:0]                       AXI_07_RDATA ;
    wire [  5:0]                       AXI_07_RID ;
    wire                               AXI_07_RLAST ;
    wire [  1:0]                       AXI_07_RRESP ;
    wire                               AXI_07_RVALID ;
    wire                               AXI_07_WREADY ;
    wire [  5:0]                       AXI_07_BID ;
    wire [  1:0]                       AXI_07_BRESP ;
    wire                               AXI_07_BVALID ;
    wire                               AXI_08_ARREADY ;
    wire                               AXI_08_AWREADY ;
    wire [ 31:0]                       AXI_08_RDATA_PARITY ;
    wire [255:0]                       AXI_08_RDATA ;
    wire [  5:0]                       AXI_08_RID ;
    wire                               AXI_08_RLAST ;
    wire [  1:0]                       AXI_08_RRESP ;
    wire                               AXI_08_RVALID ;
    wire                               AXI_08_WREADY ;
    wire [  5:0]                       AXI_08_BID ;
    wire [  1:0]                       AXI_08_BRESP ;
    wire                               AXI_08_BVALID ;
    wire                               AXI_09_ARREADY ;
    wire                               AXI_09_AWREADY ;
    wire [ 31:0]                       AXI_09_RDATA_PARITY ;
    wire [255:0]                       AXI_09_RDATA ;
    wire [  5:0]                       AXI_09_RID ;
    wire                               AXI_09_RLAST ;
    wire [  1:0]                       AXI_09_RRESP ;
    wire                               AXI_09_RVALID ;
    wire                               AXI_09_WREADY ;
    wire [  5:0]                       AXI_09_BID ;
    wire [  1:0]                       AXI_09_BRESP ;
    wire                               AXI_09_BVALID ;
    wire                               AXI_10_ARREADY ;
    wire                               AXI_10_AWREADY ;
    wire [ 31:0]                       AXI_10_RDATA_PARITY ;
    wire [255:0]                       AXI_10_RDATA ;
    wire [  5:0]                       AXI_10_RID ;
    wire                               AXI_10_RLAST ;
    wire [  1:0]                       AXI_10_RRESP ;
    wire                               AXI_10_RVALID ;
    wire                               AXI_10_WREADY ;
    wire [  5:0]                       AXI_10_BID ;
    wire [  1:0]                       AXI_10_BRESP ;
    wire                               AXI_10_BVALID ;
    wire                               AXI_11_ARREADY ;
    wire                               AXI_11_AWREADY ;
    wire [ 31:0]                       AXI_11_RDATA_PARITY ;
    wire [255:0]                       AXI_11_RDATA ;
    wire [  5:0]                       AXI_11_RID ;
    wire                               AXI_11_RLAST ;
    wire [  1:0]                       AXI_11_RRESP ;
    wire                               AXI_11_RVALID ;
    wire                               AXI_11_WREADY ;
    wire [  5:0]                       AXI_11_BID ;
    wire [  1:0]                       AXI_11_BRESP ;
    wire                               AXI_11_BVALID ;
    wire                               AXI_12_ARREADY ;
    wire                               AXI_12_AWREADY ;
    wire [ 31:0]                       AXI_12_RDATA_PARITY ;
    wire [255:0]                       AXI_12_RDATA ;
    wire [  5:0]                       AXI_12_RID ;
    wire                               AXI_12_RLAST ;
    wire [  1:0]                       AXI_12_RRESP ;
    wire                               AXI_12_RVALID ;
    wire                               AXI_12_WREADY ;
    wire [  5:0]                       AXI_12_BID ;
    wire [  1:0]                       AXI_12_BRESP ;
    wire                               AXI_12_BVALID ;
    wire                               AXI_13_ARREADY ;
    wire                               AXI_13_AWREADY ;
    wire [ 31:0]                       AXI_13_RDATA_PARITY ;
    wire [255:0]                       AXI_13_RDATA ;
    wire [  5:0]                       AXI_13_RID ;
    wire                               AXI_13_RLAST ;
    wire [  1:0]                       AXI_13_RRESP ;
    wire                               AXI_13_RVALID ;
    wire                               AXI_13_WREADY ;
    wire [  5:0]                       AXI_13_BID ;
    wire [  1:0]                       AXI_13_BRESP ;
    wire                               AXI_13_BVALID ;
    wire                               AXI_14_ARREADY ;
    wire                               AXI_14_AWREADY ;
    wire [ 31:0]                       AXI_14_RDATA_PARITY ;
    wire [255:0]                       AXI_14_RDATA ;
    wire [  5:0]                       AXI_14_RID ;
    wire                               AXI_14_RLAST ;
    wire [  1:0]                       AXI_14_RRESP ;
    wire                               AXI_14_RVALID ;
    wire                               AXI_14_WREADY ;
    wire [  5:0]                       AXI_14_BID ;
    wire [  1:0]                       AXI_14_BRESP ;
    wire                               AXI_14_BVALID ;
    wire                               AXI_15_ARREADY ;
    wire                               AXI_15_AWREADY ;
    wire [ 31:0]                       AXI_15_RDATA_PARITY ;
    wire [255:0]                       AXI_15_RDATA ;
    wire [  5:0]                       AXI_15_RID ;
    wire                               AXI_15_RLAST ;
    wire [  1:0]                       AXI_15_RRESP ;
    wire                               AXI_15_RVALID ;
    wire                               AXI_15_WREADY ;
    wire [  5:0]                       AXI_15_BID ;
    wire [  1:0]                       AXI_15_BRESP ;
    wire                               AXI_15_BVALID ;
    
    wire                               DRAM_0_STAT_CATTRIP ;
    wire [  6:0]                       DRAM_0_STAT_TEMP ;

    wire [  3:0]                       w_cmd ;   
    (* mark_debug = "true" *)wire                               OACK ; 
    (* mark_debug = "true" *)wire                               OSHIT ; 


    //-----------------------------------
    // SRAM CAM Core Instanse
    //-----------------------------------

    wire SYSCLK3;
    IBUFDS IBUFDS (
        .O(SYSCLK3), // Clock buffer output
        .I(SYSCLK3_P), // Diff_p clock buffer input (connect directly to top-level port)
        .IB(SYSCLK3_N) // Diff_n clock buffer input (connect directly to top-level port)
    );
 
    wire [1:0] OENT_ERR;
    wire OMHIT;
    wire OXMATCH_WAIT;
    wire OFIFO_FULL;
    wire IREG_DBG;
    wire IREG_CLUS_SEL;
    wire IREG_SERC_MEM_SEL;
    wire IREG_SERC_MEM_ADR;
    wire IREG_SERC_MEM_XRW;
    wire IREG_SERC_MEM_DON;
    wire IREG_SERC_MEM_WDT;
    wire OREG_SERC_MEM_RDT;
    wire AXI_ACLK;
    wire sw_xrst;

    AXONERVE_A01_HBM #(
        .P_CAM_Group          ( P_CAM_Group       ), // CAM group number
        .P_Key_Width          ( P_Key_Width       ), // Key data width
        .P_Entry_AdSize       ( P_Entry_AdSize    ), // Entry address size
        .P_Srch_RAM_Width     ( P_Srch_RAM_Width  ), // data width(for search)
        .P_Srch_RAM_AdSize    ( P_Srch_RAM_AdSize ), // memory address size(for search)
        .P_Srch_RAM_Num       ( P_Srch_RAM_Num    ), // Number of Search SRAMs
        .P_Pri_Size           ( P_Pri_Size        ), // Priority width
        .P_VALUE_Width        ( P_VALUE_Width     )  // Value Width 
    )
    AXONERVE_A01_HBM_I0(
        // Axonerve 
        .IXRST                ( w_ixrst && sw_xrst), //-- input                            Reset
        .ICLK                 ( w_iclkdiv2        ), //-- input                            System Clock 
        .ICLKX2               ( 1'b0              ), //-- input                            System Clock
        .ICAM_IE              ( w_ie              ), //-- input                            CAM Initial Enable
        .ICAM_WE              ( w_we              ), //-- input                            CAM Write Enable
        .ICAM_RE              ( w_re              ), //-- input                            CAM Read Enable
        .ICAM_SE              ( w_se              ), //-- input                            CAM Search Enable
        .IENT_ADD             ( w_gen_add         ), //-- input  [P_Entry_AdSize-1:0]      Access Entry Address
        .ICODE_MODE           ( 1'b0              ), //-- input                            encode mode
        .OACK                 ( OACK              ), //-- output                           Access Completion Indicator
        .OENT_ERR             ( OENT_ERR          ), //-- output                           Entry Error Indicator
        .OSHIT                ( OSHIT             ), //-- output                           Single Hit Indicator
        .OMHIT                ( OMHIT             ), //-- output                           Multi Hit Indicator
        .OSRCH_ENT_ADD        ( OSRCH_ENT_ADD     ), //-- output [P_Entry_AdSize-1:0]      Search Result Entry Address
        .OXMATCH_WAIT         ( OXMATCH_WAIT      ), //-- output                           Match Wait Indicator
        .OFIFO_FULL           ( OFIFO_FULL        ), 
        .IKEY_DAT             ( w_gen_key         ), //-- input  [P_Total_Key_Width-1:0]   Access Key Data
        .OKEY_DAT             ( OKEY_DAT          ), //-- output [P_Total_Key_Width-1:0]   Read Key Data 
        .IEKEY_MSK            ( w_gen_msk         ), //-- input  [P_Total_Key_Width-1:0]   Entry Key Data Mask
        .OEKEY_MSK            ( OKEY_MSK          ), //-- output [P_Total_Key_Width-1:0]   Read Entry Key Data Mask
        .IKEY_PRI             ( w_gen_pri         ), //-- input  [P_Pri_Size-1:0]          Entry Key Data Priority
        .OKEY_PRI             ( OKEY_PRI          ), //-- output [P_Pri_Size-1:0]          Read Key Data Priority
        .IKEY_VALUE           ( w_gen_val         ), //-- input  [P_VALUE_Width-1:0]       Entry Value Data
        .OKEY_VALUE           ( OKEY_VALUE        ), //-- output [P_VALUE_Width-1:0]       Read Value Data
        .IREG_DBG             ( IREG_DBG          ), //-- input                            Debug:Search Mem Debug Mode
        .IREG_CLUS_SEL        ( IREG_CLUS_SEL     ), //-- input [ 2:0]                     Debug:Selected Cluster
        .IREG_SERC_MEM_SEL    ( IREG_SERC_MEM_SEL ), //-- input [ 4:0]                     Debug:Selected Search Mem
        .IREG_SERC_MEM_ADR    ( IREG_SERC_MEM_ADR ), //-- input [P_Entry_AdSize-1:0]       Debug:Search Mem Address
        .IREG_SERC_MEM_XRW    ( IREG_SERC_MEM_XRW ), //-- input                            Debug:Access Indicate(0:Read,1:Write)
        .IREG_SERC_MEM_DON    ( IREG_SERC_MEM_DON ), //-- input                            Debug:Access Indicate(1Shot Pulse)
        .IREG_SERC_MEM_WDT    ( IREG_SERC_MEM_WDT ), //-- input [P_Srch_RAM_Width-1:0]     Debug:Write Data
        .OREG_SERC_MEM_RDT    ( OREG_SERC_MEM_RDT ), //-- output[P_Srch_RAM_Width-1:0]     Debug:Read Data
        // HBM
        .AXI_CLK              ( AXI_ACLK          ),  //-- input
        .AXI_ACLK0            ( w_AXI_ACLK_00     ),  // tam add  
        .AXI_ACLK1            ( w_AXI_ACLK_01     ),  // tam add 
        .AXI_ACLK2            ( w_AXI_ACLK_02     ),  // tam add 
        .AXI_ACLK3            ( w_AXI_ACLK_03     ),  // tam add 
        .AXI_ACLK4            ( w_AXI_ACLK_04     ),  // tam add 
        .AXI_ACLK5            ( w_AXI_ACLK_05     ),  // tam add 
        .AXI_ACLK6            ( w_AXI_ACLK_06     ),  // tam add 
        //.AXI_CLK              ( w_AXICLK          ),  //-- input
        .AXI_0_0_0_AWID       ( AXI_00_AWID       ),  //-- output 
        .AXI_0_0_0_AWADDR     ( AXI_00_AWADDR     ),  //-- output 
        .AXI_0_0_0_AWLEN      ( AXI_00_AWLEN[3:0] ),  //-- output 
        .AXI_0_0_0_AWSIZE     ( AXI_00_AWSIZE     ),  //-- output 
        .AXI_0_0_0_AWBURST    ( AXI_00_AWBURST    ),  //-- output 
        .AXI_0_0_0_AWPROT     (                   ),  //-- output 
        .AXI_0_0_0_AWQOS      (                   ),  //-- output 
        .AXI_0_0_0_AWUSER     (                   ),  //-- output 
        .AXI_0_0_0_AWVALID    ( AXI_00_AWVALID    ),  //-- output 
        .AXI_0_0_0_AWREADY    ( AXI_00_AWREADY    ),  //-- input  
        .AXI_0_0_0_WDATA      ( AXI_00_WDATA      ),  //-- output 
        .AXI_0_0_0_WSTRB      ( AXI_00_WSTRB      ),  //-- output 
        .AXI_0_0_0_WLAST      ( AXI_00_WLAST      ),  //-- output 
        .AXI_0_0_0_WVALID     ( AXI_00_WVALID     ),  //-- output 
        .AXI_0_0_0_WREADY     ( AXI_00_WREADY     ),  //-- input  
        .AXI_0_0_0_BID        ( { 3'b000, AXI_00_BID }        ),  //-- input  
        .AXI_0_0_0_BRESP      ( AXI_00_BRESP      ),  //-- input  
        .AXI_0_0_0_BVALID     ( AXI_00_BVALID     ),  //-- input  
        .AXI_0_0_0_BREADY     ( AXI_00_BREADY     ),  //-- output 
        .AXI_0_0_0_ARID       ( AXI_00_ARID       ),  //-- output 
        .AXI_0_0_0_ARADDR     ( AXI_00_ARADDR     ),  //-- output 
        .AXI_0_0_0_ARLEN      ( AXI_00_ARLEN[3:0] ),  //-- output 
        .AXI_0_0_0_ARSIZE     ( AXI_00_ARSIZE     ),  //-- output 
        .AXI_0_0_0_ARBURST    ( AXI_00_ARBURST    ),  //-- output 
        .AXI_0_0_0_ARPROT     (                   ),  //-- output 
        .AXI_0_0_0_ARQOS      (                   ),  //-- output 
        .AXI_0_0_0_ARUSER     (                   ),  //-- output 
        .AXI_0_0_0_ARVALID    ( AXI_00_ARVALID    ),  //-- output 
        .AXI_0_0_0_ARREADY    ( AXI_00_ARREADY    ),  //-- input  
        .AXI_0_0_0_RID        ( { 3'b000, AXI_00_RID }       ),  //-- input  
        .AXI_0_0_0_RDATA      ( AXI_00_RDATA      ),  //-- input  
        .AXI_0_0_0_RRESP      ( AXI_00_RRESP      ),  //-- input  
        .AXI_0_0_0_RLAST      ( AXI_00_RLAST      ),  //-- input  
        .AXI_0_0_0_RVALID     ( AXI_00_RVALID     ),  //-- input  
        .AXI_0_0_0_RREADY     ( AXI_00_RREADY     ),  //-- output 
        .AXI_0_0_1_AWID       ( AXI_01_AWID       ),  //-- output  
        .AXI_0_0_1_AWADDR     ( AXI_01_AWADDR     ),  //-- output  
        .AXI_0_0_1_AWLEN      ( AXI_01_AWLEN[3:0] ),  //-- output  
        .AXI_0_0_1_AWSIZE     ( AXI_01_AWSIZE     ),  //-- output  
        .AXI_0_0_1_AWBURST    ( AXI_01_AWBURST    ),  //-- output  
        .AXI_0_0_1_AWPROT     (                   ),  //-- output  
        .AXI_0_0_1_AWQOS      (                   ),  //-- output  
        .AXI_0_0_1_AWUSER     (                   ),  //-- output  
        .AXI_0_0_1_AWVALID    ( AXI_01_AWVALID    ),  //-- output  
        .AXI_0_0_1_AWREADY    ( AXI_01_AWREADY    ),  //-- input   
        .AXI_0_0_1_WDATA      ( AXI_01_WDATA      ),  //-- output  
        .AXI_0_0_1_WSTRB      ( AXI_01_WSTRB      ),  //-- output  
        .AXI_0_0_1_WLAST      ( AXI_01_WLAST      ),  //-- output  
        .AXI_0_0_1_WVALID     ( AXI_01_WVALID     ),  //-- output  
        .AXI_0_0_1_WREADY     ( AXI_01_WREADY     ),  //-- input   
        .AXI_0_0_1_BID        ( {3'b000, AXI_01_BID }       ),  //-- input   
        .AXI_0_0_1_BRESP      ( AXI_01_BRESP      ),  //-- input   
        .AXI_0_0_1_BVALID     ( AXI_01_BVALID     ),  //-- input   
        .AXI_0_0_1_BREADY     ( AXI_01_BREADY     ),  //-- output  
        .AXI_0_0_1_ARID       ( AXI_01_ARID       ),  //-- output  
        .AXI_0_0_1_ARADDR     ( AXI_01_ARADDR     ),  //-- output  
        .AXI_0_0_1_ARLEN      ( AXI_01_ARLEN[3:0] ),  //-- output  
        .AXI_0_0_1_ARSIZE     ( AXI_01_ARSIZE     ),  //-- output  
        .AXI_0_0_1_ARBURST    ( AXI_01_ARBURST    ),  //-- output  
        .AXI_0_0_1_ARPROT     (                   ),  //-- output  
        .AXI_0_0_1_ARQOS      (                   ),  //-- output  
        .AXI_0_0_1_ARUSER     (                   ),  //-- output  
        .AXI_0_0_1_ARVALID    ( AXI_01_ARVALID    ),  //-- output  
        .AXI_0_0_1_ARREADY    ( AXI_01_ARREADY    ),  //-- input   
        .AXI_0_0_1_RID        ( { 3'b000, AXI_01_RID }       ),  //-- input   
        .AXI_0_0_1_RDATA      ( AXI_01_RDATA      ),  //-- input   
        .AXI_0_0_1_RRESP      ( AXI_01_RRESP      ),  //-- input   
        .AXI_0_0_1_RLAST      ( AXI_01_RLAST      ),  //-- input   
        .AXI_0_0_1_RVALID     ( AXI_01_RVALID     ),  //-- input   
        .AXI_0_0_1_RREADY     ( AXI_01_RREADY     ),  //-- output  
        .AXI_0_1_0_AWID       ( AXI_02_AWID       ),  //-- output  
        .AXI_0_1_0_AWADDR     ( AXI_02_AWADDR     ),  //-- output  
        .AXI_0_1_0_AWLEN      ( AXI_02_AWLEN[3:0] ),  //-- output  
        .AXI_0_1_0_AWSIZE     ( AXI_02_AWSIZE     ),  //-- output  
        .AXI_0_1_0_AWBURST    ( AXI_02_AWBURST    ),  //-- output  
        .AXI_0_1_0_AWPROT     (                   ),  //-- output  
        .AXI_0_1_0_AWQOS      (                   ),  //-- output  
        .AXI_0_1_0_AWUSER     (                   ),  //-- output  
        .AXI_0_1_0_AWVALID    ( AXI_02_AWVALID    ),  //-- output  
        .AXI_0_1_0_AWREADY    ( AXI_02_AWREADY    ),  //-- input   
        .AXI_0_1_0_WDATA      ( AXI_02_WDATA      ),  //-- output  
        .AXI_0_1_0_WSTRB      ( AXI_02_WSTRB      ),  //-- output  
        .AXI_0_1_0_WLAST      ( AXI_02_WLAST      ),  //-- output  
        .AXI_0_1_0_WVALID     ( AXI_02_WVALID     ),  //-- output  
        .AXI_0_1_0_WREADY     ( AXI_02_WREADY     ),  //-- input   
        .AXI_0_1_0_BID        ( {3'b000, AXI_02_BID }       ),  //-- input   
        .AXI_0_1_0_BRESP      ( AXI_02_BRESP      ),  //-- input   
        .AXI_0_1_0_BVALID     ( AXI_02_BVALID     ),  //-- input   
        .AXI_0_1_0_BREADY     ( AXI_02_BREADY     ),  //-- output  
        .AXI_0_1_0_ARID       ( AXI_02_ARID       ),  //-- output  
        .AXI_0_1_0_ARADDR     ( AXI_02_ARADDR     ),  //-- output  
        .AXI_0_1_0_ARLEN      ( AXI_02_ARLEN[3:0] ),  //-- output  
        .AXI_0_1_0_ARSIZE     ( AXI_02_ARSIZE     ),  //-- output  
        .AXI_0_1_0_ARBURST    ( AXI_02_ARBURST    ),  //-- output  
        .AXI_0_1_0_ARPROT     (                   ),  //-- output  
        .AXI_0_1_0_ARQOS      (                   ),  //-- output  
        .AXI_0_1_0_ARUSER     (                   ),  //-- output  
        .AXI_0_1_0_ARVALID    ( AXI_02_ARVALID    ),  //-- output  
        .AXI_0_1_0_ARREADY    ( AXI_02_ARREADY    ),  //-- input   
        .AXI_0_1_0_RID        ( { 3'b000, AXI_02_RID }       ),  //-- input   
        .AXI_0_1_0_RDATA      ( AXI_02_RDATA      ),  //-- input   
        .AXI_0_1_0_RRESP      ( AXI_02_RRESP      ),  //-- input   
        .AXI_0_1_0_RLAST      ( AXI_02_RLAST      ),  //-- input   
        .AXI_0_1_0_RVALID     ( AXI_02_RVALID     ),  //-- input   
        .AXI_0_1_0_RREADY     ( AXI_02_RREADY     ),  //-- output  
        .AXI_0_1_1_AWID       ( AXI_03_AWID       ),  //-- output  
        .AXI_0_1_1_AWADDR     ( AXI_03_AWADDR     ),  //-- output  
        .AXI_0_1_1_AWLEN      ( AXI_03_AWLEN[3:0] ),  //-- output  
        .AXI_0_1_1_AWSIZE     ( AXI_03_AWSIZE     ),  //-- output  
        .AXI_0_1_1_AWBURST    ( AXI_03_AWBURST    ),  //-- output  
        .AXI_0_1_1_AWPROT     (                   ),  //-- output  
        .AXI_0_1_1_AWQOS      (                   ),  //-- output  
        .AXI_0_1_1_AWUSER     (                   ),  //-- output  
        .AXI_0_1_1_AWVALID    ( AXI_03_AWVALID    ),  //-- output  
        .AXI_0_1_1_AWREADY    ( AXI_03_AWREADY    ),  //-- input   
        .AXI_0_1_1_WDATA      ( AXI_03_WDATA      ),  //-- output  
        .AXI_0_1_1_WSTRB      ( AXI_03_WSTRB      ),  //-- output  
        .AXI_0_1_1_WLAST      ( AXI_03_WLAST      ),  //-- output  
        .AXI_0_1_1_WVALID     ( AXI_03_WVALID     ),  //-- output  
        .AXI_0_1_1_WREADY     ( AXI_03_WREADY     ),  //-- input   
        .AXI_0_1_1_BID        ( {3'b000, AXI_03_BID }       ),  //-- input   
        .AXI_0_1_1_BRESP      ( AXI_03_BRESP      ),  //-- input   
        .AXI_0_1_1_BVALID     ( AXI_03_BVALID     ),  //-- input   
        .AXI_0_1_1_BREADY     ( AXI_03_BREADY     ),  //-- output  
        .AXI_0_1_1_ARID       ( AXI_03_ARID       ),  //-- output  
        .AXI_0_1_1_ARADDR     ( AXI_03_ARADDR     ),  //-- output  
        .AXI_0_1_1_ARLEN      ( AXI_03_ARLEN[3:0] ),  //-- output  
        .AXI_0_1_1_ARSIZE     ( AXI_03_ARSIZE     ),  //-- output  
        .AXI_0_1_1_ARBURST    ( AXI_03_ARBURST    ),  //-- output  
        .AXI_0_1_1_ARPROT     (                   ),  //-- output  
        .AXI_0_1_1_ARQOS      (                   ),  //-- output  
        .AXI_0_1_1_ARUSER     (                   ),  //-- output  
        .AXI_0_1_1_ARVALID    ( AXI_03_ARVALID    ),  //-- output  
        .AXI_0_1_1_ARREADY    ( AXI_03_ARREADY    ),  //-- input   
        .AXI_0_1_1_RID        ( { 3'b000, AXI_03_RID }       ),  //-- input   
        .AXI_0_1_1_RDATA      ( AXI_03_RDATA      ),  //-- input   
        .AXI_0_1_1_RRESP      ( AXI_03_RRESP      ),  //-- input   
        .AXI_0_1_1_RLAST      ( AXI_03_RLAST      ),  //-- input   
        .AXI_0_1_1_RVALID     ( AXI_03_RVALID     ),  //-- input   
        .AXI_0_1_1_RREADY     ( AXI_03_RREADY     ),  //-- output  
        .AXI_0_2_0_AWID       ( AXI_04_AWID       ),  //-- output  
        .AXI_0_2_0_AWADDR     ( AXI_04_AWADDR     ),  //-- output  
        .AXI_0_2_0_AWLEN      ( AXI_04_AWLEN[3:0] ),  //-- output  
        .AXI_0_2_0_AWSIZE     ( AXI_04_AWSIZE     ),  //-- output  
        .AXI_0_2_0_AWBURST    ( AXI_04_AWBURST    ),  //-- output  
        .AXI_0_2_0_AWPROT     (                   ),  //-- output  
        .AXI_0_2_0_AWQOS      (                   ),  //-- output  
        .AXI_0_2_0_AWUSER     (                   ),  //-- output  
        .AXI_0_2_0_AWVALID    ( AXI_04_AWVALID    ),  //-- output  
        .AXI_0_2_0_AWREADY    ( AXI_04_AWREADY    ),  //-- input   
        .AXI_0_2_0_WDATA      ( AXI_04_WDATA      ),  //-- output  
        .AXI_0_2_0_WSTRB      ( AXI_04_WSTRB      ),  //-- output  
        .AXI_0_2_0_WLAST      ( AXI_04_WLAST      ),  //-- output  
        .AXI_0_2_0_WVALID     ( AXI_04_WVALID     ),  //-- output  
        .AXI_0_2_0_WREADY     ( AXI_04_WREADY     ),  //-- input   
        .AXI_0_2_0_BID        ( {3'b000, AXI_04_BID }       ),  //-- input   
        .AXI_0_2_0_BRESP      ( AXI_04_BRESP      ),  //-- input   
        .AXI_0_2_0_BVALID     ( AXI_04_BVALID     ),  //-- input   
        .AXI_0_2_0_BREADY     ( AXI_04_BREADY     ),  //-- output  
        .AXI_0_2_0_ARID       ( AXI_04_ARID       ),  //-- output  
        .AXI_0_2_0_ARADDR     ( AXI_04_ARADDR     ),  //-- output  
        .AXI_0_2_0_ARLEN      ( AXI_04_ARLEN[3:0] ),  //-- output  
        .AXI_0_2_0_ARSIZE     ( AXI_04_ARSIZE     ),  //-- output  
        .AXI_0_2_0_ARBURST    ( AXI_04_ARBURST    ),  //-- output  
        .AXI_0_2_0_ARPROT     (                   ),  //-- output  
        .AXI_0_2_0_ARQOS      (                   ),  //-- output  
        .AXI_0_2_0_ARUSER     (                   ),  //-- output  
        .AXI_0_2_0_ARVALID    ( AXI_04_ARVALID    ),  //-- output  
        .AXI_0_2_0_ARREADY    ( AXI_04_ARREADY    ),  //-- input   
        .AXI_0_2_0_RID        ( { 3'b000, AXI_04_RID }       ),  //-- input   
        .AXI_0_2_0_RDATA      ( AXI_04_RDATA      ),  //-- input   
        .AXI_0_2_0_RRESP      ( AXI_04_RRESP      ),  //-- input   
        .AXI_0_2_0_RLAST      ( AXI_04_RLAST      ),  //-- input   
        .AXI_0_2_0_RVALID     ( AXI_04_RVALID     ),  //-- input   
        .AXI_0_2_0_RREADY     ( AXI_04_RREADY     ),  //-- output  
        .AXI_0_2_1_AWID       ( AXI_05_AWID       ),  //-- output  
        .AXI_0_2_1_AWADDR     ( AXI_05_AWADDR     ),  //-- output  
        .AXI_0_2_1_AWLEN      ( AXI_05_AWLEN[3:0] ),  //-- output  
        .AXI_0_2_1_AWSIZE     ( AXI_05_AWSIZE     ),  //-- output  
        .AXI_0_2_1_AWBURST    ( AXI_05_AWBURST    ),  //-- output  
        .AXI_0_2_1_AWPROT     (                   ),  //-- output  
        .AXI_0_2_1_AWQOS      (                   ),  //-- output  
        .AXI_0_2_1_AWUSER     (                   ),  //-- output  
        .AXI_0_2_1_AWVALID    ( AXI_05_AWVALID    ),  //-- output  
        .AXI_0_2_1_AWREADY    ( AXI_05_AWREADY    ),  //-- input   
        .AXI_0_2_1_WDATA      ( AXI_05_WDATA      ),  //-- output  
        .AXI_0_2_1_WSTRB      ( AXI_05_WSTRB      ),  //-- output  
        .AXI_0_2_1_WLAST      ( AXI_05_WLAST      ),  //-- output  
        .AXI_0_2_1_WVALID     ( AXI_05_WVALID     ),  //-- output  
        .AXI_0_2_1_WREADY     ( AXI_05_WREADY     ),  //-- input   
        .AXI_0_2_1_BID        ( {3'b000, AXI_05_BID }       ),  //-- input   
        .AXI_0_2_1_BRESP      ( AXI_05_BRESP      ),  //-- input   
        .AXI_0_2_1_BVALID     ( AXI_05_BVALID     ),  //-- input   
        .AXI_0_2_1_BREADY     ( AXI_05_BREADY     ),  //-- output  
        .AXI_0_2_1_ARID       ( AXI_05_ARID       ),  //-- output  
        .AXI_0_2_1_ARADDR     ( AXI_05_ARADDR     ),  //-- output  
        .AXI_0_2_1_ARLEN      ( AXI_05_ARLEN[3:0] ),  //-- output  
        .AXI_0_2_1_ARSIZE     ( AXI_05_ARSIZE     ),  //-- output  
        .AXI_0_2_1_ARBURST    ( AXI_05_ARBURST    ),  //-- output  
        .AXI_0_2_1_ARPROT     (                   ),  //-- output  
        .AXI_0_2_1_ARQOS      (                   ),  //-- output  
        .AXI_0_2_1_ARUSER     (                   ),  //-- output  
        .AXI_0_2_1_ARVALID    ( AXI_05_ARVALID    ),  //-- output  
        .AXI_0_2_1_ARREADY    ( AXI_05_ARREADY    ),  //-- input   
        .AXI_0_2_1_RID        ( { 3'b000, AXI_05_RID }       ),  //-- input   
        .AXI_0_2_1_RDATA      ( AXI_05_RDATA      ),  //-- input   
        .AXI_0_2_1_RRESP      ( AXI_05_RRESP      ),  //-- input   
        .AXI_0_2_1_RLAST      ( AXI_05_RLAST      ),  //-- input   
        .AXI_0_2_1_RVALID     ( AXI_05_RVALID     ),  //-- input   
        .AXI_0_2_1_RREADY     ( AXI_05_RREADY     ),  //-- output  
        .AXI_0_3_0_AWID       ( AXI_06_AWID       ),  //-- output  
        .AXI_0_3_0_AWADDR     ( AXI_06_AWADDR     ),  //-- output  
        .AXI_0_3_0_AWLEN      ( AXI_06_AWLEN[3:0] ),  //-- output  
        .AXI_0_3_0_AWSIZE     ( AXI_06_AWSIZE     ),  //-- output  
        .AXI_0_3_0_AWBURST    ( AXI_06_AWBURST    ),  //-- output  
        .AXI_0_3_0_AWPROT     (                   ),  //-- output  
        .AXI_0_3_0_AWQOS      (                   ),  //-- output  
        .AXI_0_3_0_AWUSER     (                   ),  //-- output  
        .AXI_0_3_0_AWVALID    ( AXI_06_AWVALID    ),  //-- output  
        .AXI_0_3_0_AWREADY    ( AXI_06_AWREADY    ),  //-- input   
        .AXI_0_3_0_WDATA      ( AXI_06_WDATA      ),  //-- output  
        .AXI_0_3_0_WSTRB      ( AXI_06_WSTRB      ),  //-- output  
        .AXI_0_3_0_WLAST      ( AXI_06_WLAST      ),  //-- output  
        .AXI_0_3_0_WVALID     ( AXI_06_WVALID     ),  //-- output  
        .AXI_0_3_0_WREADY     ( AXI_06_WREADY     ),  //-- input   
        .AXI_0_3_0_BID        ( {3'b000, AXI_06_BID }       ),  //-- input   
        .AXI_0_3_0_BRESP      ( AXI_06_BRESP      ),  //-- input   
        .AXI_0_3_0_BVALID     ( AXI_06_BVALID     ),  //-- input   
        .AXI_0_3_0_BREADY     ( AXI_06_BREADY     ),  //-- output  
        .AXI_0_3_0_ARID       ( AXI_06_ARID       ),  //-- output  
        .AXI_0_3_0_ARADDR     ( AXI_06_ARADDR     ),  //-- output  
        .AXI_0_3_0_ARLEN      ( AXI_06_ARLEN[3:0] ),  //-- output  
        .AXI_0_3_0_ARSIZE     ( AXI_06_ARSIZE     ),  //-- output  
        .AXI_0_3_0_ARBURST    ( AXI_06_ARBURST    ),  //-- output  
        .AXI_0_3_0_ARPROT     (                   ),  //-- output  
        .AXI_0_3_0_ARQOS      (                   ),  //-- output  
        .AXI_0_3_0_ARUSER     (                   ),  //-- output  
        .AXI_0_3_0_ARVALID    ( AXI_06_ARVALID    ),  //-- output  
        .AXI_0_3_0_ARREADY    ( AXI_06_ARREADY    ),  //-- input   
        .AXI_0_3_0_RID        ( { 3'b000, AXI_06_RID }       ),  //-- input   
        .AXI_0_3_0_RDATA      ( AXI_06_RDATA      ),  //-- input   
        .AXI_0_3_0_RRESP      ( AXI_06_RRESP      ),  //-- input   
        .AXI_0_3_0_RLAST      ( AXI_06_RLAST      ),  //-- input   
        .AXI_0_3_0_RVALID     ( AXI_06_RVALID     ),  //-- input   
        .AXI_0_3_0_RREADY     ( AXI_06_RREADY     ),  //-- output  
        .AXI_0_3_1_AWID       ( AXI_07_AWID       ),  //-- output  
        .AXI_0_3_1_AWADDR     ( AXI_07_AWADDR     ),  //-- output  
        .AXI_0_3_1_AWLEN      ( AXI_07_AWLEN[3:0] ),  //-- output  
        .AXI_0_3_1_AWSIZE     ( AXI_07_AWSIZE     ),  //-- output  
        .AXI_0_3_1_AWBURST    ( AXI_07_AWBURST    ),  //-- output  
        .AXI_0_3_1_AWPROT     (                   ),  //-- output  
        .AXI_0_3_1_AWQOS      (                   ),  //-- output  
        .AXI_0_3_1_AWUSER     (                   ),  //-- output  
        .AXI_0_3_1_AWVALID    ( AXI_07_AWVALID    ),  //-- output  
        .AXI_0_3_1_AWREADY    ( AXI_07_AWREADY    ),  //-- input   
        .AXI_0_3_1_WDATA      ( AXI_07_WDATA      ),  //-- output  
        .AXI_0_3_1_WSTRB      ( AXI_07_WSTRB      ),  //-- output  
        .AXI_0_3_1_WLAST      ( AXI_07_WLAST      ),  //-- output  
        .AXI_0_3_1_WVALID     ( AXI_07_WVALID     ),  //-- output  
        .AXI_0_3_1_WREADY     ( AXI_07_WREADY     ),  //-- input   
        .AXI_0_3_1_BID        ( {3'b000, AXI_07_BID }       ),  //-- input   
        .AXI_0_3_1_BRESP      ( AXI_07_BRESP      ),  //-- input   
        .AXI_0_3_1_BVALID     ( AXI_07_BVALID     ),  //-- input   
        .AXI_0_3_1_BREADY     ( AXI_07_BREADY     ),  //-- output  
        .AXI_0_3_1_ARID       ( AXI_07_ARID       ),  //-- output  
        .AXI_0_3_1_ARADDR     ( AXI_07_ARADDR     ),  //-- output  
        .AXI_0_3_1_ARLEN      ( AXI_07_ARLEN[3:0] ),  //-- output  
        .AXI_0_3_1_ARSIZE     ( AXI_07_ARSIZE     ),  //-- output  
        .AXI_0_3_1_ARBURST    ( AXI_07_ARBURST    ),  //-- output  
        .AXI_0_3_1_ARPROT     (                   ),  //-- output  
        .AXI_0_3_1_ARQOS      (                   ),  //-- output  
        .AXI_0_3_1_ARUSER     (                   ),  //-- output  
        .AXI_0_3_1_ARVALID    ( AXI_07_ARVALID    ),  //-- output  
        .AXI_0_3_1_ARREADY    ( AXI_07_ARREADY    ),  //-- input   
        .AXI_0_3_1_RID        ( { 3'b000, AXI_07_RID }       ),  //-- input   
        .AXI_0_3_1_RDATA      ( AXI_07_RDATA      ),  //-- input   
        .AXI_0_3_1_RRESP      ( AXI_07_RRESP      ),  //-- input   
        .AXI_0_3_1_RLAST      ( AXI_07_RLAST      ),  //-- input   
        .AXI_0_3_1_RVALID     ( AXI_07_RVALID     ),  //-- input   
        .AXI_0_3_1_RREADY     ( AXI_07_RREADY     ),  //-- output  
        .AXI_0_4_0_AWID       ( AXI_08_AWID       ),  //-- output  
        .AXI_0_4_0_AWADDR     ( AXI_08_AWADDR     ),  //-- output  
        .AXI_0_4_0_AWLEN      ( AXI_08_AWLEN[3:0] ),  //-- output  
        .AXI_0_4_0_AWSIZE     ( AXI_08_AWSIZE     ),  //-- output  
        .AXI_0_4_0_AWBURST    ( AXI_08_AWBURST    ),  //-- output  
        .AXI_0_4_0_AWPROT     (                   ),  //-- output  
        .AXI_0_4_0_AWQOS      (                   ),  //-- output  
        .AXI_0_4_0_AWUSER     (                   ),  //-- output  
        .AXI_0_4_0_AWVALID    ( AXI_08_AWVALID    ),  //-- output  
        .AXI_0_4_0_AWREADY    ( AXI_08_AWREADY    ),  //-- input   
        .AXI_0_4_0_WDATA      ( AXI_08_WDATA      ),  //-- output  
        .AXI_0_4_0_WSTRB      ( AXI_08_WSTRB      ),  //-- output  
        .AXI_0_4_0_WLAST      ( AXI_08_WLAST      ),  //-- output  
        .AXI_0_4_0_WVALID     ( AXI_08_WVALID     ),  //-- output  
        .AXI_0_4_0_WREADY     ( AXI_08_WREADY     ),  //-- input   
        .AXI_0_4_0_BID        ( {3'b000, AXI_08_BID }       ),  //-- input   
        .AXI_0_4_0_BRESP      ( AXI_08_BRESP      ),  //-- input   
        .AXI_0_4_0_BVALID     ( AXI_08_BVALID     ),  //-- input   
        .AXI_0_4_0_BREADY     ( AXI_08_BREADY     ),  //-- output  
        .AXI_0_4_0_ARID       ( AXI_08_ARID       ),  //-- output  
        .AXI_0_4_0_ARADDR     ( AXI_08_ARADDR     ),  //-- output  
        .AXI_0_4_0_ARLEN      ( AXI_08_ARLEN[3:0] ),  //-- output  
        .AXI_0_4_0_ARSIZE     ( AXI_08_ARSIZE     ),  //-- output  
        .AXI_0_4_0_ARBURST    ( AXI_08_ARBURST    ),  //-- output  
        .AXI_0_4_0_ARPROT     (                   ),  //-- output  
        .AXI_0_4_0_ARQOS      (                   ),  //-- output  
        .AXI_0_4_0_ARUSER     (                   ),  //-- output  
        .AXI_0_4_0_ARVALID    ( AXI_08_ARVALID    ),  //-- output  
        .AXI_0_4_0_ARREADY    ( AXI_08_ARREADY    ),  //-- input   
        .AXI_0_4_0_RID        ( { 3'b000, AXI_08_RID }       ),  //-- input   
        .AXI_0_4_0_RDATA      ( AXI_08_RDATA      ),  //-- input   
        .AXI_0_4_0_RRESP      ( AXI_08_RRESP      ),  //-- input   
        .AXI_0_4_0_RLAST      ( AXI_08_RLAST      ),  //-- input   
        .AXI_0_4_0_RVALID     ( AXI_08_RVALID     ),  //-- input   
        .AXI_0_4_0_RREADY     ( AXI_08_RREADY     ),  //-- output  
        .AXI_0_4_1_AWID       ( AXI_09_AWID       ),  //-- output  
        .AXI_0_4_1_AWADDR     ( AXI_09_AWADDR     ),  //-- output  
        .AXI_0_4_1_AWLEN      ( AXI_09_AWLEN[3:0] ),  //-- output  
        .AXI_0_4_1_AWSIZE     ( AXI_09_AWSIZE     ),  //-- output  
        .AXI_0_4_1_AWBURST    ( AXI_09_AWBURST    ),  //-- output  
        .AXI_0_4_1_AWPROT     (                   ),  //-- output  
        .AXI_0_4_1_AWQOS      (                   ),  //-- output  
        .AXI_0_4_1_AWUSER     (                   ),  //-- output  
        .AXI_0_4_1_AWVALID    ( AXI_09_AWVALID    ),  //-- output  
        .AXI_0_4_1_AWREADY    ( AXI_09_AWREADY    ),  //-- input   
        .AXI_0_4_1_WDATA      ( AXI_09_WDATA      ),  //-- output  
        .AXI_0_4_1_WSTRB      ( AXI_09_WSTRB      ),  //-- output  
        .AXI_0_4_1_WLAST      ( AXI_09_WLAST      ),  //-- output  
        .AXI_0_4_1_WVALID     ( AXI_09_WVALID     ),  //-- output  
        .AXI_0_4_1_WREADY     ( AXI_09_WREADY     ),  //-- input   
        .AXI_0_4_1_BID        ( {3'b000, AXI_09_BID }       ),  //-- input   
        .AXI_0_4_1_BRESP      ( AXI_09_BRESP      ),  //-- input   
        .AXI_0_4_1_BVALID     ( AXI_09_BVALID     ),  //-- input   
        .AXI_0_4_1_BREADY     ( AXI_09_BREADY     ),  //-- output  
        .AXI_0_4_1_ARID       ( AXI_09_ARID       ),  //-- output  
        .AXI_0_4_1_ARADDR     ( AXI_09_ARADDR     ),  //-- output  
        .AXI_0_4_1_ARLEN      ( AXI_09_ARLEN[3:0] ),  //-- output  
        .AXI_0_4_1_ARSIZE     ( AXI_09_ARSIZE     ),  //-- output  
        .AXI_0_4_1_ARBURST    ( AXI_09_ARBURST    ),  //-- output  
        .AXI_0_4_1_ARPROT     (                   ),  //-- output  
        .AXI_0_4_1_ARQOS      (                   ),  //-- output  
        .AXI_0_4_1_ARUSER     (                   ),  //-- output  
        .AXI_0_4_1_ARVALID    ( AXI_09_ARVALID    ),  //-- output  
        .AXI_0_4_1_ARREADY    ( AXI_09_ARREADY    ),  //-- input   
        .AXI_0_4_1_RID        ( { 3'b000, AXI_09_RID }       ),  //-- input   
        .AXI_0_4_1_RDATA      ( AXI_09_RDATA      ),  //-- input   
        .AXI_0_4_1_RRESP      ( AXI_09_RRESP      ),  //-- input   
        .AXI_0_4_1_RLAST      ( AXI_09_RLAST      ),  //-- input   
        .AXI_0_4_1_RVALID     ( AXI_09_RVALID     ),  //-- input   
        .AXI_0_4_1_RREADY     ( AXI_09_RREADY     ),  //-- output  
        .AXI_0_5_0_AWID       ( AXI_10_AWID       ),  //-- output  
        .AXI_0_5_0_AWADDR     ( AXI_10_AWADDR     ),  //-- output  
        .AXI_0_5_0_AWLEN      ( AXI_10_AWLEN[3:0] ),  //-- output  
        .AXI_0_5_0_AWSIZE     ( AXI_10_AWSIZE     ),  //-- output  
        .AXI_0_5_0_AWBURST    ( AXI_10_AWBURST    ),  //-- output  
        .AXI_0_5_0_AWPROT     (                   ),  //-- output  
        .AXI_0_5_0_AWQOS      (                   ),  //-- output  
        .AXI_0_5_0_AWUSER     (                   ),  //-- output  
        .AXI_0_5_0_AWVALID    ( AXI_10_AWVALID    ),  //-- output  
        .AXI_0_5_0_AWREADY    ( AXI_10_AWREADY    ),  //-- input   
        .AXI_0_5_0_WDATA      ( AXI_10_WDATA      ),  //-- output  
        .AXI_0_5_0_WSTRB      ( AXI_10_WSTRB      ),  //-- output  
        .AXI_0_5_0_WLAST      ( AXI_10_WLAST      ),  //-- output  
        .AXI_0_5_0_WVALID     ( AXI_10_WVALID     ),  //-- output  
        .AXI_0_5_0_WREADY     ( AXI_10_WREADY     ),  //-- input   
        .AXI_0_5_0_BID        ( {3'b000, AXI_10_BID }       ),  //-- input   
        .AXI_0_5_0_BRESP      ( AXI_10_BRESP      ),  //-- input   
        .AXI_0_5_0_BVALID     ( AXI_10_BVALID     ),  //-- input   
        .AXI_0_5_0_BREADY     ( AXI_10_BREADY     ),  //-- output  
        .AXI_0_5_0_ARID       ( AXI_10_ARID       ),  //-- output  
        .AXI_0_5_0_ARADDR     ( AXI_10_ARADDR     ),  //-- output  
        .AXI_0_5_0_ARLEN      ( AXI_10_ARLEN[3:0] ),  //-- output  
        .AXI_0_5_0_ARSIZE     ( AXI_10_ARSIZE     ),  //-- output  
        .AXI_0_5_0_ARBURST    ( AXI_10_ARBURST    ),  //-- output  
        .AXI_0_5_0_ARPROT     (                   ),  //-- output  
        .AXI_0_5_0_ARQOS      (                   ),  //-- output  
        .AXI_0_5_0_ARUSER     (                   ),  //-- output  
        .AXI_0_5_0_ARVALID    ( AXI_10_ARVALID    ),  //-- output  
        .AXI_0_5_0_ARREADY    ( AXI_10_ARREADY    ),  //-- input   
        .AXI_0_5_0_RID        ( { 3'b000, AXI_10_RID }       ),  //-- input   
        .AXI_0_5_0_RDATA      ( AXI_10_RDATA      ),  //-- input   
        .AXI_0_5_0_RRESP      ( AXI_10_RRESP      ),  //-- input   
        .AXI_0_5_0_RLAST      ( AXI_10_RLAST      ),  //-- input   
        .AXI_0_5_0_RVALID     ( AXI_10_RVALID     ),  //-- input   
        .AXI_0_5_0_RREADY     ( AXI_10_RREADY     ),  //-- output  
        .AXI_0_5_1_AWID       ( AXI_11_AWID       ),  //-- output  
        .AXI_0_5_1_AWADDR     ( AXI_11_AWADDR     ),  //-- output  
        .AXI_0_5_1_AWLEN      ( AXI_11_AWLEN[3:0] ),  //-- output  
        .AXI_0_5_1_AWSIZE     ( AXI_11_AWSIZE     ),  //-- output  
        .AXI_0_5_1_AWBURST    ( AXI_11_AWBURST    ),  //-- output  
        .AXI_0_5_1_AWPROT     (                   ),  //-- output  
        .AXI_0_5_1_AWQOS      (                   ),  //-- output  
        .AXI_0_5_1_AWUSER     (                   ),  //-- output  
        .AXI_0_5_1_AWVALID    ( AXI_11_AWVALID    ),  //-- output  
        .AXI_0_5_1_AWREADY    ( AXI_11_AWREADY    ),  //-- input   
        .AXI_0_5_1_WDATA      ( AXI_11_WDATA      ),  //-- output  
        .AXI_0_5_1_WSTRB      ( AXI_11_WSTRB      ),  //-- output  
        .AXI_0_5_1_WLAST      ( AXI_11_WLAST      ),  //-- output  
        .AXI_0_5_1_WVALID     ( AXI_11_WVALID     ),  //-- output  
        .AXI_0_5_1_WREADY     ( AXI_11_WREADY     ),  //-- input   
        .AXI_0_5_1_BID        ( {3'b000, AXI_11_BID }       ),  //-- input   
        .AXI_0_5_1_BRESP      ( AXI_11_BRESP      ),  //-- input   
        .AXI_0_5_1_BVALID     ( AXI_11_BVALID     ),  //-- input   
        .AXI_0_5_1_BREADY     ( AXI_11_BREADY     ),  //-- output  
        .AXI_0_5_1_ARID       ( AXI_11_ARID       ),  //-- output  
        .AXI_0_5_1_ARADDR     ( AXI_11_ARADDR     ),  //-- output  
        .AXI_0_5_1_ARLEN      ( AXI_11_ARLEN[3:0] ),  //-- output  
        .AXI_0_5_1_ARSIZE     ( AXI_11_ARSIZE     ),  //-- output  
        .AXI_0_5_1_ARBURST    ( AXI_11_ARBURST    ),  //-- output  
        .AXI_0_5_1_ARPROT     (                   ),  //-- output  
        .AXI_0_5_1_ARQOS      (                   ),  //-- output  
        .AXI_0_5_1_ARUSER     (                   ),  //-- output  
        .AXI_0_5_1_ARVALID    ( AXI_11_ARVALID    ),  //-- output  
        .AXI_0_5_1_ARREADY    ( AXI_11_ARREADY    ),  //-- input   
        .AXI_0_5_1_RID        ( { 3'b000, AXI_11_RID }       ),  //-- input   
        .AXI_0_5_1_RDATA      ( AXI_11_RDATA      ),  //-- input   
        .AXI_0_5_1_RRESP      ( AXI_11_RRESP      ),  //-- input   
        .AXI_0_5_1_RLAST      ( AXI_11_RLAST      ),  //-- input   
        .AXI_0_5_1_RVALID     ( AXI_11_RVALID     ),  //-- input   
        .AXI_0_5_1_RREADY     ( AXI_11_RREADY     ),  //-- output  
        .AXI_0_6_0_AWID       ( AXI_12_AWID       ),  //-- output  
        .AXI_0_6_0_AWADDR     ( AXI_12_AWADDR     ),  //-- output  
        .AXI_0_6_0_AWLEN      ( AXI_12_AWLEN[3:0] ),  //-- output  
        .AXI_0_6_0_AWSIZE     ( AXI_12_AWSIZE     ),  //-- output  
        .AXI_0_6_0_AWBURST    ( AXI_12_AWBURST    ),  //-- output  
        .AXI_0_6_0_AWPROT     (                   ),  //-- output  
        .AXI_0_6_0_AWQOS      (                   ),  //-- output  
        .AXI_0_6_0_AWUSER     (                   ),  //-- output  
        .AXI_0_6_0_AWVALID    ( AXI_12_AWVALID    ),  //-- output  
        .AXI_0_6_0_AWREADY    ( AXI_12_AWREADY    ),  //-- input   
        .AXI_0_6_0_WDATA      ( AXI_12_WDATA      ),  //-- output  
        .AXI_0_6_0_WSTRB      ( AXI_12_WSTRB      ),  //-- output  
        .AXI_0_6_0_WLAST      ( AXI_12_WLAST      ),  //-- output  
        .AXI_0_6_0_WVALID     ( AXI_12_WVALID     ),  //-- output  
        .AXI_0_6_0_WREADY     ( AXI_12_WREADY     ),  //-- input   
        .AXI_0_6_0_BID        ( {3'b000, AXI_12_BID }       ),  //-- input   
        .AXI_0_6_0_BRESP      ( AXI_12_BRESP      ),  //-- input   
        .AXI_0_6_0_BVALID     ( AXI_12_BVALID     ),  //-- input   
        .AXI_0_6_0_BREADY     ( AXI_12_BREADY     ),  //-- output  
        .AXI_0_6_0_ARID       ( AXI_12_ARID       ),  //-- output  
        .AXI_0_6_0_ARADDR     ( AXI_12_ARADDR     ),  //-- output  
        .AXI_0_6_0_ARLEN      ( AXI_12_ARLEN[3:0] ),  //-- output  
        .AXI_0_6_0_ARSIZE     ( AXI_12_ARSIZE     ),  //-- output  
        .AXI_0_6_0_ARBURST    ( AXI_12_ARBURST    ),  //-- output  
        .AXI_0_6_0_ARPROT     (                   ),  //-- output  
        .AXI_0_6_0_ARQOS      (                   ),  //-- output  
        .AXI_0_6_0_ARUSER     (                   ),  //-- output  
        .AXI_0_6_0_ARVALID    ( AXI_12_ARVALID    ),  //-- output  
        .AXI_0_6_0_ARREADY    ( AXI_12_ARREADY    ),  //-- input   
        .AXI_0_6_0_RID        ( { 3'b000, AXI_12_RID }       ),  //-- input   
        .AXI_0_6_0_RDATA      ( AXI_12_RDATA      ),  //-- input   
        .AXI_0_6_0_RRESP      ( AXI_12_RRESP      ),  //-- input   
        .AXI_0_6_0_RLAST      ( AXI_12_RLAST      ),  //-- input   
        .AXI_0_6_0_RVALID     ( AXI_12_RVALID     ),  //-- input   
        .AXI_0_6_0_RREADY     ( AXI_12_RREADY     ),  //-- output  
        .AXI_0_6_1_AWID       ( AXI_13_AWID       ),  //-- output  
        .AXI_0_6_1_AWADDR     ( AXI_13_AWADDR     ),  //-- output  
        .AXI_0_6_1_AWLEN      ( AXI_13_AWLEN[3:0] ),  //-- output  
        .AXI_0_6_1_AWSIZE     ( AXI_13_AWSIZE     ),  //-- output  
        .AXI_0_6_1_AWBURST    ( AXI_13_AWBURST    ),  //-- output  
        .AXI_0_6_1_AWPROT     (                   ),  //-- output  
        .AXI_0_6_1_AWQOS      (                   ),  //-- output  
        .AXI_0_6_1_AWUSER     (                   ),  //-- output  
        .AXI_0_6_1_AWVALID    ( AXI_13_AWVALID    ),  //-- output  
        .AXI_0_6_1_AWREADY    ( AXI_13_AWREADY    ),  //-- input   
        .AXI_0_6_1_WDATA      ( AXI_13_WDATA      ),  //-- output  
        .AXI_0_6_1_WSTRB      ( AXI_13_WSTRB      ),  //-- output  
        .AXI_0_6_1_WLAST      ( AXI_13_WLAST      ),  //-- output  
        .AXI_0_6_1_WVALID     ( AXI_13_WVALID     ),  //-- output  
        .AXI_0_6_1_WREADY     ( AXI_13_WREADY     ),  //-- input   
        .AXI_0_6_1_BID        ( {3'b000, AXI_13_BID }       ),  //-- input   
        .AXI_0_6_1_BRESP      ( AXI_13_BRESP      ),  //-- input   
        .AXI_0_6_1_BVALID     ( AXI_13_BVALID     ),  //-- input   
        .AXI_0_6_1_BREADY     ( AXI_13_BREADY     ),  //-- output  
        .AXI_0_6_1_ARID       ( AXI_13_ARID       ),  //-- output  
        .AXI_0_6_1_ARADDR     ( AXI_13_ARADDR     ),  //-- output  
        .AXI_0_6_1_ARLEN      ( AXI_13_ARLEN[3:0] ),  //-- output  
        .AXI_0_6_1_ARSIZE     ( AXI_13_ARSIZE     ),  //-- output  
        .AXI_0_6_1_ARBURST    ( AXI_13_ARBURST    ),  //-- output  
        .AXI_0_6_1_ARPROT     (                   ),  //-- output  
        .AXI_0_6_1_ARQOS      (                   ),  //-- output  
        .AXI_0_6_1_ARUSER     (                   ),  //-- output  
        .AXI_0_6_1_ARVALID    ( AXI_13_ARVALID    ),  //-- output  
        .AXI_0_6_1_ARREADY    ( AXI_13_ARREADY    ),  //-- input   
        .AXI_0_6_1_RID        ( { 3'b000, AXI_13_RID }       ),  //-- input   
        .AXI_0_6_1_RDATA      ( AXI_13_RDATA      ),  //-- input   
        .AXI_0_6_1_RRESP      ( AXI_13_RRESP      ),  //-- input   
        .AXI_0_6_1_RLAST      ( AXI_13_RLAST      ),  //-- input   
        .AXI_0_6_1_RVALID     ( AXI_13_RVALID     ),  //-- input   
        .AXI_0_6_1_RREADY     ( AXI_13_RREADY     ),  //-- output  
        .AXI_0_7_0_AWID       ( AXI_14_AWID       ),  //-- output  
        .AXI_0_7_0_AWADDR     ( AXI_14_AWADDR     ),  //-- output  
        .AXI_0_7_0_AWLEN      ( AXI_14_AWLEN[3:0] ),  //-- output  
        .AXI_0_7_0_AWSIZE     ( AXI_14_AWSIZE     ),  //-- output  
        .AXI_0_7_0_AWBURST    ( AXI_14_AWBURST    ),  //-- output  
        .AXI_0_7_0_AWPROT     (                   ),  //-- output  
        .AXI_0_7_0_AWQOS      (                   ),  //-- output  
        .AXI_0_7_0_AWUSER     (                   ),  //-- output  
        .AXI_0_7_0_AWVALID    ( AXI_14_AWVALID    ),  //-- output  
        .AXI_0_7_0_AWREADY    ( AXI_14_AWREADY    ),  //-- input   
        .AXI_0_7_0_WDATA      ( AXI_14_WDATA      ),  //-- output  
        .AXI_0_7_0_WSTRB      ( AXI_14_WSTRB      ),  //-- output  
        .AXI_0_7_0_WLAST      ( AXI_14_WLAST      ),  //-- output  
        .AXI_0_7_0_WVALID     ( AXI_14_WVALID     ),  //-- output  
        .AXI_0_7_0_WREADY     ( AXI_14_WREADY     ),  //-- input   
        .AXI_0_7_0_BID        ( {3'b000, AXI_14_BID }       ),  //-- input   
        .AXI_0_7_0_BRESP      ( AXI_14_BRESP      ),  //-- input   
        .AXI_0_7_0_BVALID     ( AXI_14_BVALID     ),  //-- input   
        .AXI_0_7_0_BREADY     ( AXI_14_BREADY     ),  //-- output  
        .AXI_0_7_0_ARID       ( AXI_14_ARID       ),  //-- output  
        .AXI_0_7_0_ARADDR     ( AXI_14_ARADDR     ),  //-- output  
        .AXI_0_7_0_ARLEN      ( AXI_14_ARLEN[3:0] ),  //-- output  
        .AXI_0_7_0_ARSIZE     ( AXI_14_ARSIZE     ),  //-- output  
        .AXI_0_7_0_ARBURST    ( AXI_14_ARBURST    ),  //-- output  
        .AXI_0_7_0_ARPROT     (                   ),  //-- output  
        .AXI_0_7_0_ARQOS      (                   ),  //-- output  
        .AXI_0_7_0_ARUSER     (                   ),  //-- output  
        .AXI_0_7_0_ARVALID    ( AXI_14_ARVALID    ),  //-- output  
        .AXI_0_7_0_ARREADY    ( AXI_14_ARREADY    ),  //-- input   
        .AXI_0_7_0_RID        ( { 3'b000, AXI_14_RID }       ),  //-- input   
        .AXI_0_7_0_RDATA      ( AXI_14_RDATA      ),  //-- input   
        .AXI_0_7_0_RRESP      ( AXI_14_RRESP      ),  //-- input   
        .AXI_0_7_0_RLAST      ( AXI_14_RLAST      ),  //-- input   
        .AXI_0_7_0_RVALID     ( AXI_14_RVALID     ),  //-- input   
        .AXI_0_7_0_RREADY     ( AXI_14_RREADY     ),  //-- output  
        .AXI_0_7_1_AWID       ( AXI_15_AWID       ),  //-- output  
        .AXI_0_7_1_AWADDR     ( AXI_15_AWADDR     ),  //-- output  
        .AXI_0_7_1_AWLEN      ( AXI_15_AWLEN[3:0] ),  //-- output  
        .AXI_0_7_1_AWSIZE     ( AXI_15_AWSIZE     ),  //-- output  
        .AXI_0_7_1_AWBURST    ( AXI_15_AWBURST    ),  //-- output  
        .AXI_0_7_1_AWPROT     (                   ),  //-- output  
        .AXI_0_7_1_AWQOS      (                   ),  //-- output  
        .AXI_0_7_1_AWUSER     (                   ),  //-- output  
        .AXI_0_7_1_AWVALID    ( AXI_15_AWVALID    ),  //-- output  
        .AXI_0_7_1_AWREADY    ( AXI_15_AWREADY    ),  //-- input   
        .AXI_0_7_1_WDATA      ( AXI_15_WDATA      ),  //-- output  
        .AXI_0_7_1_WSTRB      ( AXI_15_WSTRB      ),  //-- output  
        .AXI_0_7_1_WLAST      ( AXI_15_WLAST      ),  //-- output  
        .AXI_0_7_1_WVALID     ( AXI_15_WVALID     ),  //-- output  
        .AXI_0_7_1_WREADY     ( AXI_15_WREADY     ),  //-- input   
        .AXI_0_7_1_BID        ( {3'b000, AXI_15_BID }       ),  //-- input   
        .AXI_0_7_1_BRESP      ( AXI_15_BRESP      ),  //-- input   
        .AXI_0_7_1_BVALID     ( AXI_15_BVALID     ),  //-- input   
        .AXI_0_7_1_BREADY     ( AXI_15_BREADY     ),  //-- output  
        .AXI_0_7_1_ARID       ( AXI_15_ARID       ),  //-- output  
        .AXI_0_7_1_ARADDR     ( AXI_15_ARADDR     ),  //-- output  
        .AXI_0_7_1_ARLEN      ( AXI_15_ARLEN[3:0] ),  //-- output  
        .AXI_0_7_1_ARSIZE     ( AXI_15_ARSIZE     ),  //-- output  
        .AXI_0_7_1_ARBURST    ( AXI_15_ARBURST    ),  //-- output  
        .AXI_0_7_1_ARPROT     (                   ),  //-- output  
        .AXI_0_7_1_ARQOS      (                   ),  //-- output  
        .AXI_0_7_1_ARUSER     (                   ),  //-- output  
        .AXI_0_7_1_ARVALID    ( AXI_15_ARVALID    ),  //-- output  
        .AXI_0_7_1_ARREADY    ( AXI_15_ARREADY    ),  //-- input   
        .AXI_0_7_1_RID        ( { 3'b000, AXI_15_RID }       ),  //-- input   
        .AXI_0_7_1_RDATA      ( AXI_15_RDATA      ),  //-- input   
        .AXI_0_7_1_RRESP      ( AXI_15_RRESP      ),  //-- input   
        .AXI_0_7_1_RLAST      ( AXI_15_RLAST      ),  //-- input   
        .AXI_0_7_1_RVALID     ( AXI_15_RVALID     ),  //-- input   
        .AXI_0_7_1_RREADY     ( AXI_15_RREADY     )   //-- output  
    );

    wire [31:0] OVERSION = 32'h00080002;

    wire clk_wiz_0_locked;
    clk_wiz_0 clk_wiz_0_i (
    			   .clk_out1(w_iclk),     // 400MHz
    			   .clk_out2(w_iclkdiv2), // 200MHz
    			   .reset(1'b0),
    			   .locked(clk_wiz_0_locked),
    			   .clk_in1(AXI_ACLK) // 400MHz
    			   );
    assign w_ixrst = 1'b1;
    
    wire OEND;

    HBM_CONTROLLER #( 
        .APP_DATA_WIDTH               ( 256                ), 
        .APP_ADDR_WIDTH               ( 33                 ) 
    ) 
    HBM_CONTROLLER ( 
        .APB_0_PCLK                   ( SYSCLK3            ), 
        .APB_0_PRESET_N               ( w_ixrst            ), 
        .AXI_ACLK_IN_0                ( SYSCLK3            ), 
        .AXI_ARESET_N_0               ( w_ixrst            ), 
        .HBM_REF_CLK_0                ( SYSCLK3            ), 
        .AXI_ACLK                     ( AXI_ACLK           ), 
        .AXI_ACLK_00                  ( w_AXI_ACLK_00      ),
        .AXI_ACLK_01                  ( w_AXI_ACLK_01      ),
        .AXI_ACLK_02                  ( w_AXI_ACLK_02      ),
        .AXI_ACLK_03                  ( w_AXI_ACLK_03      ),
        .AXI_ACLK_04                  ( w_AXI_ACLK_04      ),
        .AXI_ACLK_05                  ( w_AXI_ACLK_05      ),
        .AXI_ACLK_06                  ( w_AXI_ACLK_06      ),
        .AXI_00_ARADDR                ( { 5'h00, AXI_00_ARADDR } ), 
        .AXI_00_ARBURST               ( AXI_00_ARBURST     ), 
        .AXI_00_ARID                  ( AXI_00_ARID        ), 
        .AXI_00_ARLEN                 ( AXI_00_ARLEN[3:0]  ), 
        .AXI_00_ARSIZE                ( AXI_00_ARSIZE      ), 
        .AXI_00_ARVALID               ( AXI_00_ARVALID     ), 
        .AXI_00_AWADDR                ( { 5'h00, AXI_00_AWADDR } ), 
        .AXI_00_AWBURST               ( AXI_00_AWBURST     ), 
        .AXI_00_AWID                  ( AXI_00_AWID        ), 
        .AXI_00_AWLEN                 ( AXI_00_AWLEN[3:0]  ), 
        .AXI_00_AWSIZE                ( AXI_00_AWSIZE      ), 
        .AXI_00_AWVALID               ( AXI_00_AWVALID     ), 
        .AXI_00_RREADY                ( AXI_00_RREADY      ), 
        .AXI_00_BREADY                ( AXI_00_BREADY      ), 
        .AXI_00_WDATA                 ( AXI_00_WDATA       ), 
        .AXI_00_WLAST                 ( AXI_00_WLAST       ), 
        .AXI_00_WSTRB                 ( AXI_00_WSTRB       ), 
        //.AXI_00_WDATA_PARITY          ( AXI_00_WDATA_PARITY), 
        .AXI_00_WVALID                ( AXI_00_WVALID      ), 
        .AXI_01_ARADDR                ( { 5'h01, AXI_01_ARADDR } ), 
        .AXI_01_ARBURST               ( AXI_01_ARBURST     ), 
        .AXI_01_ARID                  ( AXI_01_ARID        ), 
        .AXI_01_ARLEN                 ( AXI_01_ARLEN[3:0]  ), 
        .AXI_01_ARSIZE                ( AXI_01_ARSIZE      ), 
        .AXI_01_ARVALID               ( AXI_01_ARVALID     ), 
        .AXI_01_AWADDR                ( { 5'h01, AXI_01_AWADDR } ), 
        .AXI_01_AWBURST               ( AXI_01_AWBURST     ), 
        .AXI_01_AWID                  ( AXI_01_AWID        ), 
        .AXI_01_AWLEN                 ( AXI_01_AWLEN[3:0]  ), 
        .AXI_01_AWSIZE                ( AXI_01_AWSIZE      ), 
        .AXI_01_AWVALID               ( AXI_01_AWVALID     ), 
        .AXI_01_RREADY                ( AXI_01_RREADY      ), 
        .AXI_01_BREADY                ( AXI_01_BREADY      ), 
        .AXI_01_WDATA                 ( AXI_01_WDATA       ), 
        .AXI_01_WLAST                 ( AXI_01_WLAST       ), 
        .AXI_01_WSTRB                 ( AXI_01_WSTRB       ), 
        //.AXI_01_WDATA_PARITY          ( AXI_01_WDATA_PARITY), 
        .AXI_01_WVALID                ( AXI_01_WVALID      ), 
        .AXI_02_ARADDR                ( { 5'h02, AXI_02_ARADDR } ), 
        .AXI_02_ARBURST               ( AXI_02_ARBURST     ), 
        .AXI_02_ARID                  ( AXI_02_ARID        ), 
        .AXI_02_ARLEN                 ( AXI_02_ARLEN[3:0]  ), 
        .AXI_02_ARSIZE                ( AXI_02_ARSIZE      ), 
        .AXI_02_ARVALID               ( AXI_02_ARVALID     ), 
        .AXI_02_AWADDR                (  { 5'h02, AXI_02_AWADDR } ), 
        .AXI_02_AWBURST               ( AXI_02_AWBURST     ), 
        .AXI_02_AWID                  ( AXI_02_AWID        ), 
        .AXI_02_AWLEN                 ( AXI_02_AWLEN[3:0]  ), 
        .AXI_02_AWSIZE                ( AXI_02_AWSIZE      ), 
        .AXI_02_AWVALID               ( AXI_02_AWVALID     ), 
        .AXI_02_RREADY                ( AXI_02_RREADY      ), 
        .AXI_02_BREADY                ( AXI_02_BREADY      ), 
        .AXI_02_WDATA                 ( AXI_02_WDATA       ), 
        .AXI_02_WLAST                 ( AXI_02_WLAST       ), 
        .AXI_02_WSTRB                 ( AXI_02_WSTRB       ), 
        //.AXI_02_WDATA_PARITY          ( AXI_02_WDATA_PARITY), 
        .AXI_02_WVALID                ( AXI_02_WVALID      ), 
        .AXI_03_ARADDR                (  { 5'h03, AXI_03_ARADDR } ), 
        .AXI_03_ARBURST               ( AXI_03_ARBURST     ), 
        .AXI_03_ARID                  ( AXI_03_ARID        ), 
        .AXI_03_ARLEN                 ( AXI_03_ARLEN[3:0]  ), 
        .AXI_03_ARSIZE                ( AXI_03_ARSIZE      ), 
        .AXI_03_ARVALID               ( AXI_03_ARVALID     ), 
        .AXI_03_AWADDR                (  { 5'h03, AXI_03_AWADDR } ), 
        .AXI_03_AWBURST               ( AXI_03_AWBURST     ), 
        .AXI_03_AWID                  ( AXI_03_AWID        ), 
        .AXI_03_AWLEN                 ( AXI_03_AWLEN[3:0]  ), 
        .AXI_03_AWSIZE                ( AXI_03_AWSIZE      ), 
        .AXI_03_AWVALID               ( AXI_03_AWVALID     ), 
        .AXI_03_RREADY                ( AXI_03_RREADY      ), 
        .AXI_03_BREADY                ( AXI_03_BREADY      ), 
        .AXI_03_WDATA                 ( AXI_03_WDATA       ), 
        .AXI_03_WLAST                 ( AXI_03_WLAST       ), 
        .AXI_03_WSTRB                 ( AXI_03_WSTRB       ), 
        //.AXI_03_WDATA_PARITY          ( AXI_03_WDATA_PARITY), 
        .AXI_03_WVALID                ( AXI_03_WVALID      ), 
        .AXI_04_ARADDR                (  { 5'h04, AXI_04_ARADDR } ), 
        .AXI_04_ARBURST               ( AXI_04_ARBURST     ), 
        .AXI_04_ARID                  ( AXI_04_ARID        ), 
        .AXI_04_ARLEN                 ( AXI_04_ARLEN[3:0]  ), 
        .AXI_04_ARSIZE                ( AXI_04_ARSIZE      ), 
        .AXI_04_ARVALID               ( AXI_04_ARVALID     ), 
        .AXI_04_AWADDR                (  { 5'h04, AXI_04_AWADDR } ), 
        .AXI_04_AWBURST               ( AXI_04_AWBURST     ), 
        .AXI_04_AWID                  ( AXI_04_AWID        ), 
        .AXI_04_AWLEN                 ( AXI_04_AWLEN[3:0]  ), 
        .AXI_04_AWSIZE                ( AXI_04_AWSIZE      ), 
        .AXI_04_AWVALID               ( AXI_04_AWVALID     ), 
        .AXI_04_RREADY                ( AXI_04_RREADY      ), 
        .AXI_04_BREADY                ( AXI_04_BREADY      ), 
        .AXI_04_WDATA                 ( AXI_04_WDATA       ), 
        .AXI_04_WLAST                 ( AXI_04_WLAST       ), 
        .AXI_04_WSTRB                 ( AXI_04_WSTRB       ), 
        //.AXI_04_WDATA_PARITY          ( AXI_04_WDATA_PARITY), 
        .AXI_04_WVALID                ( AXI_04_WVALID      ), 
        .AXI_05_ARADDR                (  { 5'h05, AXI_05_ARADDR } ), 
        .AXI_05_ARBURST               ( AXI_05_ARBURST     ), 
        .AXI_05_ARID                  ( AXI_05_ARID        ), 
        .AXI_05_ARLEN                 ( AXI_05_ARLEN[3:0]  ), 
        .AXI_05_ARSIZE                ( AXI_05_ARSIZE      ), 
        .AXI_05_ARVALID               ( AXI_05_ARVALID     ), 
        .AXI_05_AWADDR                (  { 5'h05, AXI_05_AWADDR } ), 
        .AXI_05_AWBURST               ( AXI_05_AWBURST     ), 
        .AXI_05_AWID                  ( AXI_05_AWID        ), 
        .AXI_05_AWLEN                 ( AXI_05_AWLEN[3:0]  ), 
        .AXI_05_AWSIZE                ( AXI_05_AWSIZE      ), 
        .AXI_05_AWVALID               ( AXI_05_AWVALID     ), 
        .AXI_05_RREADY                ( AXI_05_RREADY      ), 
        .AXI_05_BREADY                ( AXI_05_BREADY      ), 
        .AXI_05_WDATA                 ( AXI_05_WDATA       ), 
        .AXI_05_WLAST                 ( AXI_05_WLAST       ), 
        .AXI_05_WSTRB                 ( AXI_05_WSTRB       ), 
        //.AXI_05_WDATA_PARITY          ( AXI_05_WDATA_PARITY), 
        .AXI_05_WVALID                ( AXI_05_WVALID      ), 
        .AXI_06_ARADDR                (  { 5'h06, AXI_06_ARADDR } ), 
        .AXI_06_ARBURST               ( AXI_06_ARBURST     ), 
        .AXI_06_ARID                  ( AXI_06_ARID        ), 
        .AXI_06_ARLEN                 ( AXI_06_ARLEN[3:0]  ), 
        .AXI_06_ARSIZE                ( AXI_06_ARSIZE      ), 
        .AXI_06_ARVALID               ( AXI_06_ARVALID     ), 
        .AXI_06_AWADDR                (  { 5'h06, AXI_06_AWADDR } ), 
        .AXI_06_AWBURST               ( AXI_06_AWBURST     ), 
        .AXI_06_AWID                  ( AXI_06_AWID        ), 
        .AXI_06_AWLEN                 ( AXI_06_AWLEN[3:0]  ), 
        .AXI_06_AWSIZE                ( AXI_06_AWSIZE      ), 
        .AXI_06_AWVALID               ( AXI_06_AWVALID     ), 
        .AXI_06_RREADY                ( AXI_06_RREADY      ), 
        .AXI_06_BREADY                ( AXI_06_BREADY      ), 
        .AXI_06_WDATA                 ( AXI_06_WDATA       ), 
        .AXI_06_WLAST                 ( AXI_06_WLAST       ), 
        .AXI_06_WSTRB                 ( AXI_06_WSTRB       ), 
        //.AXI_06_WDATA_PARITY          ( AXI_06_WDATA_PARITY), 
        .AXI_06_WVALID                ( AXI_06_WVALID      ), 
        .AXI_07_ARADDR                (  { 5'h07, AXI_07_ARADDR } ), 
        .AXI_07_ARBURST               ( AXI_07_ARBURST     ), 
        .AXI_07_ARID                  ( AXI_07_ARID        ), 
        .AXI_07_ARLEN                 ( AXI_07_ARLEN[3:0]  ), 
        .AXI_07_ARSIZE                ( AXI_07_ARSIZE      ), 
        .AXI_07_ARVALID               ( AXI_07_ARVALID     ), 
        .AXI_07_AWADDR                (  { 5'h07, AXI_07_AWADDR } ), 
        .AXI_07_AWBURST               ( AXI_07_AWBURST     ), 
        .AXI_07_AWID                  ( AXI_07_AWID        ), 
        .AXI_07_AWLEN                 ( AXI_07_AWLEN[3:0]  ), 
        .AXI_07_AWSIZE                ( AXI_07_AWSIZE      ), 
        .AXI_07_AWVALID               ( AXI_07_AWVALID     ), 
        .AXI_07_RREADY                ( AXI_07_RREADY      ), 
        .AXI_07_BREADY                ( AXI_07_BREADY      ), 
        .AXI_07_WDATA                 ( AXI_07_WDATA       ), 
        .AXI_07_WLAST                 ( AXI_07_WLAST       ), 
        .AXI_07_WSTRB                 ( AXI_07_WSTRB       ), 
        //.AXI_07_WDATA_PARITY          ( AXI_07_WDATA_PARITY), 
        .AXI_07_WVALID                ( AXI_07_WVALID      ), 
        .AXI_08_ARADDR                (  { 5'h08, AXI_08_ARADDR } ), 
        .AXI_08_ARBURST               ( AXI_08_ARBURST     ), 
        .AXI_08_ARID                  ( AXI_08_ARID        ), 
        .AXI_08_ARLEN                 ( AXI_08_ARLEN[3:0]  ), 
        .AXI_08_ARSIZE                ( AXI_08_ARSIZE      ), 
        .AXI_08_ARVALID               ( AXI_08_ARVALID     ), 
        .AXI_08_AWADDR                (  { 5'h08, AXI_08_AWADDR } ), 
        .AXI_08_AWBURST               ( AXI_08_AWBURST     ), 
        .AXI_08_AWID                  ( AXI_08_AWID        ), 
        .AXI_08_AWLEN                 ( AXI_08_AWLEN[3:0]  ), 
        .AXI_08_AWSIZE                ( AXI_08_AWSIZE      ), 
        .AXI_08_AWVALID               ( AXI_08_AWVALID     ), 
        .AXI_08_RREADY                ( AXI_08_RREADY      ), 
        .AXI_08_BREADY                ( AXI_08_BREADY      ), 
        .AXI_08_WDATA                 ( AXI_08_WDATA       ), 
        .AXI_08_WLAST                 ( AXI_08_WLAST       ), 
        .AXI_08_WSTRB                 ( AXI_08_WSTRB       ), 
        //.AXI_08_WDATA_PARITY          ( AXI_08_WDATA_PARITY), 
        .AXI_08_WVALID                ( AXI_08_WVALID      ), 
        .AXI_09_ARADDR                (  { 5'h09, AXI_09_ARADDR } ), 
        .AXI_09_ARBURST               ( AXI_09_ARBURST     ), 
        .AXI_09_ARID                  ( AXI_09_ARID        ), 
        .AXI_09_ARLEN                 ( AXI_09_ARLEN[3:0]  ), 
        .AXI_09_ARSIZE                ( AXI_09_ARSIZE      ), 
        .AXI_09_ARVALID               ( AXI_09_ARVALID     ), 
        .AXI_09_AWADDR                (  { 5'h09, AXI_09_AWADDR } ), 
        .AXI_09_AWBURST               ( AXI_09_AWBURST     ), 
        .AXI_09_AWID                  ( AXI_09_AWID        ), 
        .AXI_09_AWLEN                 ( AXI_09_AWLEN[3:0]  ), 
        .AXI_09_AWSIZE                ( AXI_09_AWSIZE      ), 
        .AXI_09_AWVALID               ( AXI_09_AWVALID     ), 
        .AXI_09_RREADY                ( AXI_09_RREADY      ), 
        .AXI_09_BREADY                ( AXI_09_BREADY      ), 
        .AXI_09_WDATA                 ( AXI_09_WDATA       ), 
        .AXI_09_WLAST                 ( AXI_09_WLAST       ), 
        .AXI_09_WSTRB                 ( AXI_09_WSTRB       ), 
        //.AXI_09_WDATA_PARITY          ( AXI_09_WDATA_PARITY), 
        .AXI_09_WVALID                ( AXI_09_WVALID      ),
        .AXI_10_ARADDR                (  { 5'h0A, AXI_10_ARADDR } ), 
        .AXI_10_ARBURST               ( AXI_10_ARBURST     ), 
        .AXI_10_ARID                  ( AXI_10_ARID        ), 
        .AXI_10_ARLEN                 ( AXI_10_ARLEN[3:0]  ), 
        .AXI_10_ARSIZE                ( AXI_10_ARSIZE      ), 
        .AXI_10_ARVALID               ( AXI_10_ARVALID     ), 
        .AXI_10_AWADDR                (  { 5'h0A, AXI_10_AWADDR } ), 
        .AXI_10_AWBURST               ( AXI_10_AWBURST     ), 
        .AXI_10_AWID                  ( AXI_10_AWID        ), 
        .AXI_10_AWLEN                 ( AXI_10_AWLEN[3:0]  ), 
        .AXI_10_AWSIZE                ( AXI_10_AWSIZE      ), 
        .AXI_10_AWVALID               ( AXI_10_AWVALID     ), 
        .AXI_10_RREADY                ( AXI_10_RREADY      ), 
        .AXI_10_BREADY                ( AXI_10_BREADY      ), 
        .AXI_10_WDATA                 ( AXI_10_WDATA       ), 
        .AXI_10_WLAST                 ( AXI_10_WLAST       ), 
        .AXI_10_WSTRB                 ( AXI_10_WSTRB       ), 
        //.AXI_10_WDATA_PARITY          ( AXI_10_WDATA_PARITY), 
        .AXI_10_WVALID                ( AXI_10_WVALID      ), 
        .AXI_11_ARADDR                (  { 5'h0B, AXI_11_ARADDR } ), 
        .AXI_11_ARBURST               ( AXI_11_ARBURST     ), 
        .AXI_11_ARID                  ( AXI_11_ARID        ), 
        .AXI_11_ARLEN                 ( AXI_11_ARLEN[3:0]  ), 
        .AXI_11_ARSIZE                ( AXI_11_ARSIZE      ), 
        .AXI_11_ARVALID               ( AXI_11_ARVALID     ), 
        .AXI_11_AWADDR                (  { 5'h0B, AXI_11_AWADDR } ), 
        .AXI_11_AWBURST               ( AXI_11_AWBURST     ), 
        .AXI_11_AWID                  ( AXI_11_AWID        ), 
        .AXI_11_AWLEN                 ( AXI_11_AWLEN[3:0]  ), 
        .AXI_11_AWSIZE                ( AXI_11_AWSIZE      ), 
        .AXI_11_AWVALID               ( AXI_11_AWVALID     ), 
        .AXI_11_RREADY                ( AXI_11_RREADY      ), 
        .AXI_11_BREADY                ( AXI_11_BREADY      ), 
        .AXI_11_WDATA                 ( AXI_11_WDATA       ), 
        .AXI_11_WLAST                 ( AXI_11_WLAST       ), 
        .AXI_11_WSTRB                 ( AXI_11_WSTRB       ), 
        //.AXI_11_WDATA_PARITY          ( AXI_11_WDATA_PARITY), 
        .AXI_11_WVALID                ( AXI_11_WVALID      ), 
        .AXI_12_ARADDR                (  { 5'h0C, AXI_12_ARADDR } ), 
        .AXI_12_ARBURST               ( AXI_12_ARBURST     ), 
        .AXI_12_ARID                  ( AXI_12_ARID        ), 
        .AXI_12_ARLEN                 ( AXI_12_ARLEN[3:0]  ), 
        .AXI_12_ARSIZE                ( AXI_12_ARSIZE      ), 
        .AXI_12_ARVALID               ( AXI_12_ARVALID     ), 
        .AXI_12_AWADDR                (  { 5'h0C, AXI_12_AWADDR } ), 
        .AXI_12_AWBURST               ( AXI_12_AWBURST     ), 
        .AXI_12_AWID                  ( AXI_12_AWID        ), 
        .AXI_12_AWLEN                 ( AXI_12_AWLEN[3:0]  ), 
        .AXI_12_AWSIZE                ( AXI_12_AWSIZE      ), 
        .AXI_12_AWVALID               ( AXI_12_AWVALID     ), 
        .AXI_12_RREADY                ( AXI_12_RREADY      ), 
        .AXI_12_BREADY                ( AXI_12_BREADY      ), 
        .AXI_12_WDATA                 ( AXI_12_WDATA       ), 
        .AXI_12_WLAST                 ( AXI_12_WLAST       ), 
        .AXI_12_WSTRB                 ( AXI_12_WSTRB       ), 
        //.AXI_12_WDATA_PARITY          ( AXI_12_WDATA_PARITY), 
        .AXI_12_WVALID                ( AXI_12_WVALID      ), 
        .AXI_13_ARADDR                (  { 5'h0D, AXI_13_ARADDR } ), 
        .AXI_13_ARBURST               ( AXI_13_ARBURST     ), 
        .AXI_13_ARID                  ( AXI_13_ARID        ), 
        .AXI_13_ARLEN                 ( AXI_13_ARLEN[3:0]  ), 
        .AXI_13_ARSIZE                ( AXI_13_ARSIZE      ), 
        .AXI_13_ARVALID               ( AXI_13_ARVALID     ), 
        .AXI_13_AWADDR                (  { 5'h0D, AXI_13_AWADDR } ), 
        .AXI_13_AWBURST               ( AXI_13_AWBURST     ), 
        .AXI_13_AWID                  ( AXI_13_AWID        ), 
        .AXI_13_AWLEN                 ( AXI_13_AWLEN[3:0]  ), 
        .AXI_13_AWSIZE                ( AXI_13_AWSIZE      ), 
        .AXI_13_AWVALID               ( AXI_13_AWVALID     ), 
        .AXI_13_RREADY                ( AXI_13_RREADY      ), 
        .AXI_13_BREADY                ( AXI_13_BREADY      ), 
        .AXI_13_WDATA                 ( AXI_13_WDATA       ), 
        .AXI_13_WLAST                 ( AXI_13_WLAST       ), 
        .AXI_13_WSTRB                 ( AXI_13_WSTRB       ), 
        //.AXI_13_WDATA_PARITY          ( AXI_13_WDATA_PARITY), 
        .AXI_13_WVALID                ( AXI_13_WVALID      ), 
        .AXI_14_ARADDR                (  { 5'h0E, AXI_14_ARADDR } ), 
        .AXI_14_ARBURST               ( AXI_14_ARBURST     ), 
        .AXI_14_ARID                  ( AXI_14_ARID        ), 
        .AXI_14_ARLEN                 ( AXI_14_ARLEN[3:0]  ), 
        .AXI_14_ARSIZE                ( AXI_14_ARSIZE      ), 
        .AXI_14_ARVALID               ( AXI_14_ARVALID     ), 
        .AXI_14_AWADDR                (  { 5'h0E, AXI_14_AWADDR } ), 
        .AXI_14_AWBURST               ( AXI_14_AWBURST     ), 
        .AXI_14_AWID                  ( AXI_14_AWID        ), 
        .AXI_14_AWLEN                 ( AXI_14_AWLEN[3:0]  ), 
        .AXI_14_AWSIZE                ( AXI_14_AWSIZE      ), 
        .AXI_14_AWVALID               ( AXI_14_AWVALID     ), 
        .AXI_14_RREADY                ( AXI_14_RREADY      ), 
        .AXI_14_BREADY                ( AXI_14_BREADY      ), 
        .AXI_14_WDATA                 ( AXI_14_WDATA       ), 
        .AXI_14_WLAST                 ( AXI_14_WLAST       ), 
        .AXI_14_WSTRB                 ( AXI_14_WSTRB       ), 
        //.AXI_14_WDATA_PARITY          ( AXI_14_WDATA_PARITY), 
        .AXI_14_WVALID                ( AXI_14_WVALID      ), 
        .AXI_15_ARADDR                (  { 5'h0F, AXI_15_ARADDR } ), 
        .AXI_15_ARBURST               ( AXI_15_ARBURST       ), 
        .AXI_15_ARID                  ( AXI_15_ARID          ), 
        .AXI_15_ARLEN                 ( AXI_15_ARLEN[3:0]    ), 
        .AXI_15_ARSIZE                ( AXI_15_ARSIZE        ), 
        .AXI_15_ARVALID               ( AXI_15_ARVALID       ), 
        .AXI_15_AWADDR                (  { 5'h0F, AXI_15_AWADDR } ), 
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
        //.AXI_15_WDATA_PARITY          ( AXI_15_WDATA_PARITY  ), 
        .AXI_15_WVALID                ( AXI_15_WVALID        ), 
        
        .APB_0_PWDATA                 ( APB_0_PWDATA         ), 
        .APB_0_PADDR                  ( APB_0_PADDR          ), 
        .APB_0_PSEL                   ( APB_0_PSEL           ),
        .APB_0_PWRITE                 ( APB_0_PWRITE         ),
        .APB_0_PENABLE                ( APB_0_PENABLE        ),

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


        .APB_0_PRDATA                 ( APB_0_PRDATA         ), 
        .APB_0_PREADY                 ( APB_0_PREADY         ), 
        .APB_0_PSLVERR                ( APB_0_PSLVERR        ), 
        
        .DRAM_0_STAT_CATTRIP          ( DRAM_0_STAT_CATTRIP  ), 
        .DRAM_0_STAT_TEMP             ( DRAM_0_STAT_TEMP     )  
) ;

    app_cmac_frontend app_cmac_frontend_i (
					   // 100GbE
					   .gt_rxp_in(gt_rxp_in),
					   .gt_rxn_in(gt_rxn_in),
					   .gt_txp_out(gt_txp_out),
					   .gt_txn_out(gt_txn_out),
					   .gt_ref_clk_p(gt_ref_clk_p),
					   .gt_ref_clk_n(gt_ref_clk_n),

					   .AXONERVE_IF_CLK(w_iclkdiv2),
					   .AXONERVE_IF_XRST(w_ixrst),

					   .GEN_KEY(w_gen_key),
					   .GEN_VAL(w_gen_val),
					   .GEN_ADD(w_gen_add),
					   .GEN_MSK(w_gen_msk),
					   .GEN_PRI(w_gen_pri),
					   .GEN_IE(w_ie),
					   .GEN_WE(w_we),
					   .GEN_RE(w_re),
					   .GEN_SE(w_se),
					   .GEN_XRST(sw_xrst),

					   .OACK(OACK),
					   .OSHIT(OSHIT),
					   .OMHIT(OMHIT),
					   .OFIFO_FULL(OFIFO_FULL),
					   .OXMATCH_WAIT(OXMATCH_WAIT),
					   .OENT_ERR(OENT_ERR),
					   .OKEY_DAT(OKEY_DAT),
					   .OKEY_VALUE(OKEY_VALUE),
					   .OSRCH_ENT_ADD(OSRCH_ENT_ADD),
					   .OKEY_PRI(OKEY_PRI)
					   );

    ila_axonerve ila_axonerve_i(.clk(w_iclkdiv2),
				.probe0(OKEY_DAT),                 // 288
				.probe1(OKEY_VALUE),               // 32
				.probe2(OSRCH_ENT_ADD),            // 28
				.probe3(w_gen_add),                // 28
				.probe4(w_gen_key),                // 288
				.probe5(w_gen_val),                // 32
				.probe6({OACK, OSHIT, OXMATCH_WAIT}), // 3
				.probe7({w_ie, w_re, w_se, w_we})     // 4
				);

endmodule // AXONERVE_HBM_TOP

`default_nettype wire
