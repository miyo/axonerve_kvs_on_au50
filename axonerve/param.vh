//                              -*- Mode: Verilog -*-
// Filename        : param.vh
// Description     : Parameter header file 
// Author          : Kuniaki Tamiya 
// Created On      : Thu Feb 14 14:21:26 JST 2019
// Last Modified By: $Author$
// Last Modified On: $Date$
// Update Count    : $Revision$
// Status          : $Id$
// Version         : AXONERVE_A01_OffChip_8MEntry_BCAM_20190214_01
// Version-Reg     : 0x00100000
//
//                   2019 by NAGASE & CO., LTD.

    `define     VENDOR   Altera 
    `define     Family   Stratix10 
    `define     BRAM       // BRAM / BRAMX2 / 
    `define     General    // General / Network  
//    `define     DIV36    // DIV24  / DIV36  
    `define     TIME       // TIME or none
//    `define     Narrow   // Narrow or none 
    `define     BCAM       // if CAM_Group 1 


    `define     CAM_Group           1   // CAM group number
    `define     Key_Width         288   // Key data width
    `define     Entry_AdSize       28   // Entry address size
    `define     Srch_RAM_AdSize    28   // memory address size(for search)
    `define     Srch_RAM_Num       16   // Number of Search SRAMs
    `define     Pri_Size            7   // Priority width
    `define     VALUE_Width        32   // Priority width

