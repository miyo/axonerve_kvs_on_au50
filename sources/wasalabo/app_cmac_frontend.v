`default_nettype none

`include "param.vh"

module app_cmac_frontend
(
 // 100GbE
 input wire [3 :0]  gt_rxp_in,
 input wire [3 :0]  gt_rxn_in,
 output wire [3 :0] gt_txp_out,
 output wire [3 :0] gt_txn_out,
 input wire 	  gt_ref_clk_p,
 input wire 	  gt_ref_clk_n,

 input wire AXONERVE_IF_CLK,
 input wire AXONERVE_IF_XRST,

 output wire [288-1:0] GEN_KEY,
 output wire [32-1:0]  GEN_VAL,
 output wire [28-1:0]  GEN_ADD,
 output wire [288-1:0] GEN_MSK,
 output wire [7-1:0]   GEN_PRI,
 output wire GEN_IE,
 output wire GEN_WE,
 output wire GEN_RE,
 output wire GEN_SE,
 output wire GEN_XRST,

 input wire OACK,
 input wire OSHIT,
 input wire OMHIT,
 input wire OFIFO_FULL,
 input wire OXMATCH_WAIT,
 input wire [1:0] OENT_ERR,
 input wire [288-1:0] OKEY_DAT,
 input wire [32-1:0] OKEY_VALUE,
 input wire [28-1:0] OSRCH_ENT_ADD,
 input wire [7-1:0]  OKEY_PRI
 );

    wire [11 :0]    gt_loopback_in;

    wire 	  lbus_tx_rx_restart_in;
    wire 	  tx_done_led;
    wire 	  tx_busy_led;
    wire 	  rx_gt_locked_led;
    wire 	  rx_aligned_led;
    wire 	  rx_done_led;
    wire 	  rx_data_fail_led;
    wire 	  rx_busy_led;
    wire 	  stat_reg_compare_out;
    wire	  sys_reset;
    wire 	  pm_tick;
    wire 	  init_clk;

    //// For other GT loopback options please change the value appropriately
    //// For example, for Near End PMA loopback for 4 Lanes update the gt_loopback_in = {4{3'b010}};
    //// For more information and settings on loopback, refer GT Transceivers user guide

    assign gt_loopback_in  = {4{3'b000}};

    wire            gt_ref_clk_out;
    
    wire            s_axi_aclk;
    wire            s_axi_sreset;
    wire [31:0]     s_axi_awaddr;
    wire            s_axi_awvalid;
    wire            s_axi_awready;
    wire [31:0]     s_axi_wdata;
    wire [3:0]      s_axi_wstrb;
    wire            s_axi_wvalid;
    wire            s_axi_wready;
    wire [1:0]      s_axi_bresp;
    wire            s_axi_bvalid;
    wire            s_axi_bready;
    wire [31:0]     s_axi_araddr;
    wire            s_axi_arvalid;
    wire            s_axi_arready;
    wire [31:0]     s_axi_rdata;
    wire [1:0]      s_axi_rresp;
    wire            s_axi_rvalid;
    wire            s_axi_rready;
    wire            usr_rx_reset;
    wire [128-1:0]  rx_dataout0;
    wire            rx_enaout0;
    wire            rx_sopout0;
    wire            rx_eopout0;
    wire            rx_errout0;
    wire [4-1:0]    rx_mtyout0;
    wire [128-1:0]  rx_dataout1;
    wire            rx_enaout1;
    wire            rx_sopout1;
    wire            rx_eopout1;
    wire            rx_errout1;
    wire [4-1:0]    rx_mtyout1;
    wire [128-1:0]  rx_dataout2;
    wire            rx_enaout2;
    wire            rx_sopout2;
    wire            rx_eopout2;
    wire            rx_errout2;
    wire [4-1:0]    rx_mtyout2;
    wire [128-1:0]  rx_dataout3;
    wire            rx_enaout3;
    wire            rx_sopout3;
    wire            rx_eopout3;
    wire            rx_errout3;
    wire [4-1:0]    rx_mtyout3;

    wire            tx_rdyout;
    wire [128-1:0]  tx_datain0;
    wire            tx_enain0;
    wire            tx_sopin0;
    wire            tx_eopin0;
    wire            tx_errin0;
    wire [4-1:0]    tx_mtyin0;
    wire [128-1:0]  tx_datain1;
    wire            tx_enain1;
    wire            tx_sopin1;
    wire            tx_eopin1;
    wire            tx_errin1;
    wire [4-1:0]    tx_mtyin1;
    wire [128-1:0]  tx_datain2;
    wire            tx_enain2;
    wire            tx_sopin2;
    wire            tx_eopin2;
    wire            tx_errin2;
    wire [4-1:0]    tx_mtyin2;
    wire [128-1:0]  tx_datain3;
    wire            tx_enain3;
    wire            tx_sopin3;
    wire            tx_eopin3;
    wire            tx_errin3;
    wire [4-1:0]    tx_mtyin3;
    wire            tx_ovfout;
    wire            tx_unfout;
    wire [55:0]     tx_preamblein;
    wire            usr_tx_reset;
    wire            rxusrclk2;
    wire [8:0]      stat_tx_pause_valid;
    wire            stat_tx_pause;
    wire            stat_tx_user_pause;
    wire [8:0]      ctl_tx_pause_req;
    wire            ctl_tx_resend_pause;
    wire            stat_rx_pause;
    wire [15:0]     stat_rx_pause_quanta0;
    wire [15:0]     stat_rx_pause_quanta1;
    wire [15:0]     stat_rx_pause_quanta2;
    wire [15:0]     stat_rx_pause_quanta3;
    wire [15:0]     stat_rx_pause_quanta4;
    wire [15:0]     stat_rx_pause_quanta5;
    wire [15:0]     stat_rx_pause_quanta6;
    wire [15:0]     stat_rx_pause_quanta7;
    wire [15:0]     stat_rx_pause_quanta8;
    wire [8:0]      stat_rx_pause_req;
    wire [8:0]      stat_rx_pause_valid;
    wire            stat_rx_user_pause;
    wire            stat_rx_aligned;
    wire            stat_rx_aligned_err;
    wire [2:0]      stat_rx_bad_code;
    wire [2:0]      stat_rx_bad_fcs;
    wire            stat_rx_bad_preamble;
    wire            stat_rx_bad_sfd;
    wire            stat_rx_bip_err_0;
    wire            stat_rx_bip_err_1;
    wire            stat_rx_bip_err_10;
    wire            stat_rx_bip_err_11;
    wire            stat_rx_bip_err_12;
    wire            stat_rx_bip_err_13;
    wire            stat_rx_bip_err_14;
    wire            stat_rx_bip_err_15;
    wire            stat_rx_bip_err_16;
    wire            stat_rx_bip_err_17;
    wire            stat_rx_bip_err_18;
    wire            stat_rx_bip_err_19;
    wire            stat_rx_bip_err_2;
    wire            stat_rx_bip_err_3;
    wire            stat_rx_bip_err_4;
    wire            stat_rx_bip_err_5;
    wire            stat_rx_bip_err_6;
    wire            stat_rx_bip_err_7;
    wire            stat_rx_bip_err_8;
    wire            stat_rx_bip_err_9;
    wire [19:0]     stat_rx_block_lock;
    wire            stat_rx_broadcast;
    wire [2:0]      stat_rx_fragment;
    wire [1:0]      stat_rx_framing_err_0;
    wire [1:0]      stat_rx_framing_err_1;
    wire [1:0]      stat_rx_framing_err_10;
    wire [1:0]      stat_rx_framing_err_11;
    wire [1:0]      stat_rx_framing_err_12;
    wire [1:0]      stat_rx_framing_err_13;
    wire [1:0]      stat_rx_framing_err_14;
    wire [1:0]      stat_rx_framing_err_15;
    wire [1:0]      stat_rx_framing_err_16;
    wire [1:0]      stat_rx_framing_err_17;
    wire [1:0]      stat_rx_framing_err_18;
    wire [1:0]      stat_rx_framing_err_19;
    wire [1:0]      stat_rx_framing_err_2;
    wire [1:0]      stat_rx_framing_err_3;
    wire [1:0]      stat_rx_framing_err_4;
    wire [1:0]      stat_rx_framing_err_5;
    wire [1:0]      stat_rx_framing_err_6;
    wire [1:0]      stat_rx_framing_err_7;
    wire [1:0]      stat_rx_framing_err_8;
    wire [1:0]      stat_rx_framing_err_9;
    wire            stat_rx_framing_err_valid_0;
    wire            stat_rx_framing_err_valid_1;
    wire            stat_rx_framing_err_valid_10;
    wire            stat_rx_framing_err_valid_11;
    wire            stat_rx_framing_err_valid_12;
    wire            stat_rx_framing_err_valid_13;
    wire            stat_rx_framing_err_valid_14;
    wire            stat_rx_framing_err_valid_15;
    wire            stat_rx_framing_err_valid_16;
    wire            stat_rx_framing_err_valid_17;
    wire            stat_rx_framing_err_valid_18;
    wire            stat_rx_framing_err_valid_19;
    wire            stat_rx_framing_err_valid_2;
    wire            stat_rx_framing_err_valid_3;
    wire            stat_rx_framing_err_valid_4;
    wire            stat_rx_framing_err_valid_5;
    wire            stat_rx_framing_err_valid_6;
    wire            stat_rx_framing_err_valid_7;
    wire            stat_rx_framing_err_valid_8;
    wire            stat_rx_framing_err_valid_9;
    wire            stat_rx_got_signal_os;
    wire            stat_rx_hi_ber;
    wire            stat_rx_inrangeerr;
    wire            stat_rx_internal_local_fault;
    wire            stat_rx_jabber;
    wire            stat_rx_local_fault;
    wire [19:0]     stat_rx_mf_err;
    wire [19:0]     stat_rx_mf_len_err;
    wire [19:0]     stat_rx_mf_repeat_err;
    wire            stat_rx_misaligned;
    wire            stat_rx_multicast;
    wire            stat_rx_oversize;
    wire            stat_rx_packet_1024_1518_bytes;
    wire            stat_rx_packet_128_255_bytes;
    wire            stat_rx_packet_1519_1522_bytes;
    wire            stat_rx_packet_1523_1548_bytes;
    wire            stat_rx_packet_1549_2047_bytes;
    wire            stat_rx_packet_2048_4095_bytes;
    wire            stat_rx_packet_256_511_bytes;
    wire            stat_rx_packet_4096_8191_bytes;
    wire            stat_rx_packet_512_1023_bytes;
    wire            stat_rx_packet_64_bytes;
    wire            stat_rx_packet_65_127_bytes;
    wire            stat_rx_packet_8192_9215_bytes;
    wire            stat_rx_packet_bad_fcs;
    wire            stat_rx_packet_large;
    wire [2:0]      stat_rx_packet_small;
    wire            stat_rx_received_local_fault;
    wire            stat_rx_remote_fault;
    wire            stat_rx_status;
    wire [2:0]      stat_rx_stomped_fcs;
    wire [19:0]     stat_rx_synced;
    wire [19:0]     stat_rx_synced_err;
    wire [2:0]      stat_rx_test_pattern_mismatch;
    wire            stat_rx_toolong;
    wire [6:0]      stat_rx_total_bytes;
    wire [13:0]     stat_rx_total_good_bytes;
    wire            stat_rx_total_good_packets;
    wire [2:0]      stat_rx_total_packets;
    wire            stat_rx_truncated;
    wire [2:0]      stat_rx_undersize;
    wire            stat_rx_unicast;
    wire            stat_rx_vlan;
    wire [19:0]     stat_rx_pcsl_demuxed;
    wire [4:0]      stat_rx_pcsl_number_0;
    wire [4:0]      stat_rx_pcsl_number_1;
    wire [4:0]      stat_rx_pcsl_number_10;
    wire [4:0]      stat_rx_pcsl_number_11;
    wire [4:0]      stat_rx_pcsl_number_12;
    wire [4:0]      stat_rx_pcsl_number_13;
    wire [4:0]      stat_rx_pcsl_number_14;
    wire [4:0]      stat_rx_pcsl_number_15;
    wire [4:0]      stat_rx_pcsl_number_16;
    wire [4:0]      stat_rx_pcsl_number_17;
    wire [4:0]      stat_rx_pcsl_number_18;
    wire [4:0]      stat_rx_pcsl_number_19;
    wire [4:0]      stat_rx_pcsl_number_2;
    wire [4:0]      stat_rx_pcsl_number_3;
    wire [4:0]      stat_rx_pcsl_number_4;
    wire [4:0]      stat_rx_pcsl_number_5;
    wire [4:0]      stat_rx_pcsl_number_6;
    wire [4:0]      stat_rx_pcsl_number_7;
    wire [4:0]      stat_rx_pcsl_number_8;
    wire [4:0]      stat_rx_pcsl_number_9;
    wire            stat_tx_bad_fcs;
    wire            stat_tx_broadcast;
    wire            stat_tx_frame_error;
    wire            stat_tx_local_fault;
    wire            stat_tx_multicast;
    wire            stat_tx_packet_1024_1518_bytes;
    wire            stat_tx_packet_128_255_bytes;
    wire            stat_tx_packet_1519_1522_bytes;
    wire            stat_tx_packet_1523_1548_bytes;
    wire            stat_tx_packet_1549_2047_bytes;
    wire            stat_tx_packet_2048_4095_bytes;
    wire            stat_tx_packet_256_511_bytes;
    wire            stat_tx_packet_4096_8191_bytes;
    wire            stat_tx_packet_512_1023_bytes;
    wire            stat_tx_packet_64_bytes;
    wire            stat_tx_packet_65_127_bytes;
    wire            stat_tx_packet_8192_9215_bytes;
    wire            stat_tx_packet_large;
    wire            stat_tx_packet_small;
    wire [5:0]      stat_tx_total_bytes;
    wire [13:0]     stat_tx_total_good_bytes;
    wire            stat_tx_total_good_packets;
    wire            stat_tx_total_packets;
    wire            stat_tx_unicast;
    wire            stat_tx_vlan;

    wire [7:0]      rx_otn_bip8_0;
    wire [7:0]      rx_otn_bip8_1;
    wire [7:0]      rx_otn_bip8_2;
    wire [7:0]      rx_otn_bip8_3;
    wire [7:0]      rx_otn_bip8_4;
    wire [65:0]     rx_otn_data_0;
    wire [65:0]     rx_otn_data_1;
    wire [65:0]     rx_otn_data_2;
    wire [65:0]     rx_otn_data_3;
    wire [65:0]     rx_otn_data_4;
    wire            rx_otn_ena;
    wire            rx_otn_lane0;
    wire            rx_otn_vlmarker;
    wire [55:0]     rx_preambleout;


    wire            ctl_tx_send_idle;
    wire            ctl_tx_send_rfi;
    wire            ctl_tx_send_lfi;
    wire            rx_reset;
    wire            tx_reset;
    wire [3 :0]     gt_rxrecclkout;
    wire [3 :0]     gt_powergoodout;
    wire            gtwiz_reset_tx_datapath;
    wire            gtwiz_reset_rx_datapath;
    wire            txusrclk2;

    wire [31:0]     user_reg0;

    assign gtwiz_reset_tx_datapath    = 1'b0;
    assign gtwiz_reset_rx_datapath    = 1'b0;

    wire [511:0]  payload;
    wire	  payload_rd;
    wire [15:0]   lbus_number_pkt_proc = 1'd1;
    wire [13:0]   lbus_pkt_size_proc;
    wire [7:0] 	  debug;

    cmac_usplus_0 DUT
      (
       .gt_rxp_in                            (gt_rxp_in),
       .gt_rxn_in                            (gt_rxn_in),
       .gt_txp_out                           (gt_txp_out),
       .gt_txn_out                           (gt_txn_out),
       .gt_txusrclk2                         (txusrclk2),
       .gt_loopback_in                       (gt_loopback_in),
       .gt_rxrecclkout                       (gt_rxrecclkout),
       .gt_powergoodout                      (gt_powergoodout),
       .gtwiz_reset_tx_datapath              (gtwiz_reset_tx_datapath),
       .gtwiz_reset_rx_datapath              (gtwiz_reset_rx_datapath),
       .s_axi_aclk                           (init_clk),
       .s_axi_sreset                         (sys_reset),
       .pm_tick                              (pm_tick),
       .s_axi_awaddr                         (s_axi_awaddr),
       .s_axi_awvalid                        (s_axi_awvalid),
       .s_axi_awready                        (s_axi_awready),
       .s_axi_wdata                          (s_axi_wdata),
       .s_axi_wstrb                          (s_axi_wstrb),
       .s_axi_wvalid                         (s_axi_wvalid),
       .s_axi_wready                         (s_axi_wready),
       .s_axi_bresp                          (s_axi_bresp),
       .s_axi_bvalid                         (s_axi_bvalid),
       .s_axi_bready                         (s_axi_bready),
       .s_axi_araddr                         (s_axi_araddr),
       .s_axi_arvalid                        (s_axi_arvalid),
       .s_axi_arready                        (s_axi_arready),
       .s_axi_rdata                          (s_axi_rdata),
       .s_axi_rresp                          (s_axi_rresp),
       .s_axi_rvalid                         (s_axi_rvalid),
       .s_axi_rready                         (s_axi_rready),
       .sys_reset                            (sys_reset),
       .gt_ref_clk_p                         (gt_ref_clk_p),
       .gt_ref_clk_n                         (gt_ref_clk_n),
       .init_clk                             (init_clk),
       .gt_ref_clk_out                       (gt_ref_clk_out),

       .rx_dataout0                          (rx_dataout0),
       .rx_dataout1                          (rx_dataout1),
       .rx_dataout2                          (rx_dataout2),
       .rx_dataout3                          (rx_dataout3),
       .rx_enaout0                           (rx_enaout0),
       .rx_enaout1                           (rx_enaout1),
       .rx_enaout2                           (rx_enaout2),
       .rx_enaout3                           (rx_enaout3),
       .rx_eopout0                           (rx_eopout0),
       .rx_eopout1                           (rx_eopout1),
       .rx_eopout2                           (rx_eopout2),
       .rx_eopout3                           (rx_eopout3),
       .rx_errout0                           (rx_errout0),
       .rx_errout1                           (rx_errout1),
       .rx_errout2                           (rx_errout2),
       .rx_errout3                           (rx_errout3),
       .rx_mtyout0                           (rx_mtyout0),
       .rx_mtyout1                           (rx_mtyout1),
       .rx_mtyout2                           (rx_mtyout2),
       .rx_mtyout3                           (rx_mtyout3),
       .rx_sopout0                           (rx_sopout0),
       .rx_sopout1                           (rx_sopout1),
       .rx_sopout2                           (rx_sopout2),
       .rx_sopout3                           (rx_sopout3),
       .rx_otn_bip8_0                        (rx_otn_bip8_0),
       .rx_otn_bip8_1                        (rx_otn_bip8_1),
       .rx_otn_bip8_2                        (rx_otn_bip8_2),
       .rx_otn_bip8_3                        (rx_otn_bip8_3),
       .rx_otn_bip8_4                        (rx_otn_bip8_4),
       .rx_otn_data_0                        (rx_otn_data_0),
       .rx_otn_data_1                        (rx_otn_data_1),
       .rx_otn_data_2                        (rx_otn_data_2),
       .rx_otn_data_3                        (rx_otn_data_3),
       .rx_otn_data_4                        (rx_otn_data_4),
       .rx_otn_ena                           (rx_otn_ena),
       .rx_otn_lane0                         (rx_otn_lane0),
       .rx_otn_vlmarker                      (rx_otn_vlmarker),
       .rx_preambleout                       (rx_preambleout),
       .usr_rx_reset                         (usr_rx_reset),
       .gt_rxusrclk2                         (rxusrclk2),
       .stat_rx_aligned                      (stat_rx_aligned),
       .stat_rx_aligned_err                  (stat_rx_aligned_err),
       .stat_rx_bad_code                     (stat_rx_bad_code),
       .stat_rx_bad_fcs                      (stat_rx_bad_fcs),
       .stat_rx_bad_preamble                 (stat_rx_bad_preamble),
       .stat_rx_bad_sfd                      (stat_rx_bad_sfd),
       .stat_rx_bip_err_0                    (stat_rx_bip_err_0),
       .stat_rx_bip_err_1                    (stat_rx_bip_err_1),
       .stat_rx_bip_err_10                   (stat_rx_bip_err_10),
       .stat_rx_bip_err_11                   (stat_rx_bip_err_11),
       .stat_rx_bip_err_12                   (stat_rx_bip_err_12),
       .stat_rx_bip_err_13                   (stat_rx_bip_err_13),
       .stat_rx_bip_err_14                   (stat_rx_bip_err_14),
       .stat_rx_bip_err_15                   (stat_rx_bip_err_15),
       .stat_rx_bip_err_16                   (stat_rx_bip_err_16),
       .stat_rx_bip_err_17                   (stat_rx_bip_err_17),
       .stat_rx_bip_err_18                   (stat_rx_bip_err_18),
       .stat_rx_bip_err_19                   (stat_rx_bip_err_19),
       .stat_rx_bip_err_2                    (stat_rx_bip_err_2),
       .stat_rx_bip_err_3                    (stat_rx_bip_err_3),
       .stat_rx_bip_err_4                    (stat_rx_bip_err_4),
       .stat_rx_bip_err_5                    (stat_rx_bip_err_5),
       .stat_rx_bip_err_6                    (stat_rx_bip_err_6),
       .stat_rx_bip_err_7                    (stat_rx_bip_err_7),
       .stat_rx_bip_err_8                    (stat_rx_bip_err_8),
       .stat_rx_bip_err_9                    (stat_rx_bip_err_9),
       .stat_rx_block_lock                   (stat_rx_block_lock),
       .stat_rx_broadcast                    (stat_rx_broadcast),
       .stat_rx_fragment                     (stat_rx_fragment),
       .stat_rx_framing_err_0                (stat_rx_framing_err_0),
       .stat_rx_framing_err_1                (stat_rx_framing_err_1),
       .stat_rx_framing_err_10               (stat_rx_framing_err_10),
       .stat_rx_framing_err_11               (stat_rx_framing_err_11),
       .stat_rx_framing_err_12               (stat_rx_framing_err_12),
       .stat_rx_framing_err_13               (stat_rx_framing_err_13),
       .stat_rx_framing_err_14               (stat_rx_framing_err_14),
       .stat_rx_framing_err_15               (stat_rx_framing_err_15),
       .stat_rx_framing_err_16               (stat_rx_framing_err_16),
       .stat_rx_framing_err_17               (stat_rx_framing_err_17),
       .stat_rx_framing_err_18               (stat_rx_framing_err_18),
       .stat_rx_framing_err_19               (stat_rx_framing_err_19),
       .stat_rx_framing_err_2                (stat_rx_framing_err_2),
       .stat_rx_framing_err_3                (stat_rx_framing_err_3),
       .stat_rx_framing_err_4                (stat_rx_framing_err_4),
       .stat_rx_framing_err_5                (stat_rx_framing_err_5),
       .stat_rx_framing_err_6                (stat_rx_framing_err_6),
       .stat_rx_framing_err_7                (stat_rx_framing_err_7),
       .stat_rx_framing_err_8                (stat_rx_framing_err_8),
       .stat_rx_framing_err_9                (stat_rx_framing_err_9),
       .stat_rx_framing_err_valid_0          (stat_rx_framing_err_valid_0),
       .stat_rx_framing_err_valid_1          (stat_rx_framing_err_valid_1),
       .stat_rx_framing_err_valid_10         (stat_rx_framing_err_valid_10),
       .stat_rx_framing_err_valid_11         (stat_rx_framing_err_valid_11),
       .stat_rx_framing_err_valid_12         (stat_rx_framing_err_valid_12),
       .stat_rx_framing_err_valid_13         (stat_rx_framing_err_valid_13),
       .stat_rx_framing_err_valid_14         (stat_rx_framing_err_valid_14),
       .stat_rx_framing_err_valid_15         (stat_rx_framing_err_valid_15),
       .stat_rx_framing_err_valid_16         (stat_rx_framing_err_valid_16),
       .stat_rx_framing_err_valid_17         (stat_rx_framing_err_valid_17),
       .stat_rx_framing_err_valid_18         (stat_rx_framing_err_valid_18),
       .stat_rx_framing_err_valid_19         (stat_rx_framing_err_valid_19),
       .stat_rx_framing_err_valid_2          (stat_rx_framing_err_valid_2),
       .stat_rx_framing_err_valid_3          (stat_rx_framing_err_valid_3),
       .stat_rx_framing_err_valid_4          (stat_rx_framing_err_valid_4),
       .stat_rx_framing_err_valid_5          (stat_rx_framing_err_valid_5),
       .stat_rx_framing_err_valid_6          (stat_rx_framing_err_valid_6),
       .stat_rx_framing_err_valid_7          (stat_rx_framing_err_valid_7),
       .stat_rx_framing_err_valid_8          (stat_rx_framing_err_valid_8),
       .stat_rx_framing_err_valid_9          (stat_rx_framing_err_valid_9),
       .stat_rx_got_signal_os                (stat_rx_got_signal_os),
       .stat_rx_hi_ber                       (stat_rx_hi_ber),
       .stat_rx_inrangeerr                   (stat_rx_inrangeerr),
       .stat_rx_internal_local_fault         (stat_rx_internal_local_fault),
       .stat_rx_jabber                       (stat_rx_jabber),
       .stat_rx_local_fault                  (stat_rx_local_fault),
       .stat_rx_mf_err                       (stat_rx_mf_err),
       .stat_rx_mf_len_err                   (stat_rx_mf_len_err),
       .stat_rx_mf_repeat_err                (stat_rx_mf_repeat_err),
       .stat_rx_misaligned                   (stat_rx_misaligned),
       .stat_rx_multicast                    (stat_rx_multicast),
       .stat_rx_oversize                     (stat_rx_oversize),
       .stat_rx_packet_1024_1518_bytes       (stat_rx_packet_1024_1518_bytes),
       .stat_rx_packet_128_255_bytes         (stat_rx_packet_128_255_bytes),
       .stat_rx_packet_1519_1522_bytes       (stat_rx_packet_1519_1522_bytes),
       .stat_rx_packet_1523_1548_bytes       (stat_rx_packet_1523_1548_bytes),
       .stat_rx_packet_1549_2047_bytes       (stat_rx_packet_1549_2047_bytes),
       .stat_rx_packet_2048_4095_bytes       (stat_rx_packet_2048_4095_bytes),
       .stat_rx_packet_256_511_bytes         (stat_rx_packet_256_511_bytes),
       .stat_rx_packet_4096_8191_bytes       (stat_rx_packet_4096_8191_bytes),
       .stat_rx_packet_512_1023_bytes        (stat_rx_packet_512_1023_bytes),
       .stat_rx_packet_64_bytes              (stat_rx_packet_64_bytes),
       .stat_rx_packet_65_127_bytes          (stat_rx_packet_65_127_bytes),
       .stat_rx_packet_8192_9215_bytes       (stat_rx_packet_8192_9215_bytes),
       .stat_rx_packet_bad_fcs               (stat_rx_packet_bad_fcs),
       .stat_rx_packet_large                 (stat_rx_packet_large),
       .stat_rx_packet_small                 (stat_rx_packet_small),
       .stat_rx_pause                        (stat_rx_pause),
       .stat_rx_pause_quanta0                (stat_rx_pause_quanta0),
       .stat_rx_pause_quanta1                (stat_rx_pause_quanta1),
       .stat_rx_pause_quanta2                (stat_rx_pause_quanta2),
       .stat_rx_pause_quanta3                (stat_rx_pause_quanta3),
       .stat_rx_pause_quanta4                (stat_rx_pause_quanta4),
       .stat_rx_pause_quanta5                (stat_rx_pause_quanta5),
       .stat_rx_pause_quanta6                (stat_rx_pause_quanta6),
       .stat_rx_pause_quanta7                (stat_rx_pause_quanta7),
       .stat_rx_pause_quanta8                (stat_rx_pause_quanta8),
       .stat_rx_pause_req                    (stat_rx_pause_req),
       .stat_rx_pause_valid                  (stat_rx_pause_valid),
       .stat_rx_user_pause                   (stat_rx_user_pause),
       .core_rx_reset                        (1'b0),
       .rx_clk                               (txusrclk2),
       .stat_rx_received_local_fault         (stat_rx_received_local_fault),
       .stat_rx_remote_fault                 (stat_rx_remote_fault),
       .stat_rx_status                       (stat_rx_status),
       .stat_rx_stomped_fcs                  (stat_rx_stomped_fcs),
       .stat_rx_synced                       (stat_rx_synced),
       .stat_rx_synced_err                   (stat_rx_synced_err),
       .stat_rx_test_pattern_mismatch        (stat_rx_test_pattern_mismatch),
       .stat_rx_toolong                      (stat_rx_toolong),
       .stat_rx_total_bytes                  (stat_rx_total_bytes),
       .stat_rx_total_good_bytes             (stat_rx_total_good_bytes),
       .stat_rx_total_good_packets           (stat_rx_total_good_packets),
       .stat_rx_total_packets                (stat_rx_total_packets),
       .stat_rx_truncated                    (stat_rx_truncated),
       .stat_rx_undersize                    (stat_rx_undersize),
       .stat_rx_unicast                      (stat_rx_unicast),
       .stat_rx_vlan                         (stat_rx_vlan),
       .stat_rx_pcsl_demuxed                 (stat_rx_pcsl_demuxed),
       .stat_rx_pcsl_number_0                (stat_rx_pcsl_number_0),
       .stat_rx_pcsl_number_1                (stat_rx_pcsl_number_1),
       .stat_rx_pcsl_number_10               (stat_rx_pcsl_number_10),
       .stat_rx_pcsl_number_11               (stat_rx_pcsl_number_11),
       .stat_rx_pcsl_number_12               (stat_rx_pcsl_number_12),
       .stat_rx_pcsl_number_13               (stat_rx_pcsl_number_13),
       .stat_rx_pcsl_number_14               (stat_rx_pcsl_number_14),
       .stat_rx_pcsl_number_15               (stat_rx_pcsl_number_15),
       .stat_rx_pcsl_number_16               (stat_rx_pcsl_number_16),
       .stat_rx_pcsl_number_17               (stat_rx_pcsl_number_17),
       .stat_rx_pcsl_number_18               (stat_rx_pcsl_number_18),
       .stat_rx_pcsl_number_19               (stat_rx_pcsl_number_19),
       .stat_rx_pcsl_number_2                (stat_rx_pcsl_number_2),
       .stat_rx_pcsl_number_3                (stat_rx_pcsl_number_3),
       .stat_rx_pcsl_number_4                (stat_rx_pcsl_number_4),
       .stat_rx_pcsl_number_5                (stat_rx_pcsl_number_5),
       .stat_rx_pcsl_number_6                (stat_rx_pcsl_number_6),
       .stat_rx_pcsl_number_7                (stat_rx_pcsl_number_7),
       .stat_rx_pcsl_number_8                (stat_rx_pcsl_number_8),
       .stat_rx_pcsl_number_9                (stat_rx_pcsl_number_9),
       .stat_tx_bad_fcs                      (stat_tx_bad_fcs),
       .stat_tx_broadcast                    (stat_tx_broadcast),
       .stat_tx_frame_error                  (stat_tx_frame_error),
       .stat_tx_local_fault                  (stat_tx_local_fault),
       .stat_tx_multicast                    (stat_tx_multicast),
       .stat_tx_packet_1024_1518_bytes       (stat_tx_packet_1024_1518_bytes),
       .stat_tx_packet_128_255_bytes         (stat_tx_packet_128_255_bytes),
       .stat_tx_packet_1519_1522_bytes       (stat_tx_packet_1519_1522_bytes),
       .stat_tx_packet_1523_1548_bytes       (stat_tx_packet_1523_1548_bytes),
       .stat_tx_packet_1549_2047_bytes       (stat_tx_packet_1549_2047_bytes),
       .stat_tx_packet_2048_4095_bytes       (stat_tx_packet_2048_4095_bytes),
       .stat_tx_packet_256_511_bytes         (stat_tx_packet_256_511_bytes),
       .stat_tx_packet_4096_8191_bytes       (stat_tx_packet_4096_8191_bytes),
       .stat_tx_packet_512_1023_bytes        (stat_tx_packet_512_1023_bytes),
       .stat_tx_packet_64_bytes              (stat_tx_packet_64_bytes),
       .stat_tx_packet_65_127_bytes          (stat_tx_packet_65_127_bytes),
       .stat_tx_packet_8192_9215_bytes       (stat_tx_packet_8192_9215_bytes),
       .stat_tx_packet_large                 (stat_tx_packet_large),
       .stat_tx_packet_small                 (stat_tx_packet_small),
       .stat_tx_total_bytes                  (stat_tx_total_bytes),
       .stat_tx_total_good_bytes             (stat_tx_total_good_bytes),
       .stat_tx_total_good_packets           (stat_tx_total_good_packets),
       .stat_tx_total_packets                (stat_tx_total_packets),
       .stat_tx_unicast                      (stat_tx_unicast),
       .stat_tx_vlan                         (stat_tx_vlan),


       .ctl_tx_send_idle                     (ctl_tx_send_idle),
       .ctl_tx_send_rfi                      (ctl_tx_send_rfi),
       .ctl_tx_send_lfi                      (ctl_tx_send_lfi),
       .core_tx_reset                        (1'b0),
       .stat_tx_pause_valid                  (stat_tx_pause_valid),
       .stat_tx_pause                        (stat_tx_pause),
       .stat_tx_user_pause                   (stat_tx_user_pause),
       .ctl_tx_pause_req                     (ctl_tx_pause_req),
       .ctl_tx_resend_pause                  (ctl_tx_resend_pause),
       .tx_rdyout                            (tx_rdyout),
       .tx_datain0                           (tx_datain0),
       .tx_datain1                           (tx_datain1),
       .tx_datain2                           (tx_datain2),
       .tx_datain3                           (tx_datain3),
       .tx_enain0                            (tx_enain0),
       .tx_enain1                            (tx_enain1),
       .tx_enain2                            (tx_enain2),
       .tx_enain3                            (tx_enain3),
       .tx_eopin0                            (tx_eopin0),
       .tx_eopin1                            (tx_eopin1),
       .tx_eopin2                            (tx_eopin2),
       .tx_eopin3                            (tx_eopin3),
       .tx_errin0                            (tx_errin0),
       .tx_errin1                            (tx_errin1),
       .tx_errin2                            (tx_errin2),
       .tx_errin3                            (tx_errin3),
       .tx_mtyin0                            (tx_mtyin0),
       .tx_mtyin1                            (tx_mtyin1),
       .tx_mtyin2                            (tx_mtyin2),
       .tx_mtyin3                            (tx_mtyin3),
       .tx_sopin0                            (tx_sopin0),
       .tx_sopin1                            (tx_sopin1),
       .tx_sopin2                            (tx_sopin2),
       .tx_sopin3                            (tx_sopin3),
       .tx_ovfout                            (tx_ovfout),
       .tx_unfout                            (tx_unfout),
       .tx_preamblein                        (tx_preamblein),
       .usr_tx_reset                         (usr_tx_reset),

       .user_reg0                            (user_reg0),

       .core_drp_reset                       (1'b0),
       .drp_clk                              (1'b0),
       .drp_addr                             (10'b0),
       .drp_di                               (16'b0),
       .drp_en                               (1'b0),
       .drp_do                               (),
       .drp_rdy                              (),
       .drp_we                               (1'b0)
       );

    cmac_usplus_0_pkt_gen_mon
      #(
	.PKT_NUM                              (1000), // unused
	.PKT_SIZE                             (512) // unused
	) i_cmac_usplus_0_pkt_gen_mon  
	(
	 .gen_mon_clk                          (txusrclk2),
	 .usr_tx_reset                         (usr_tx_reset),
	 .usr_rx_reset                         (usr_rx_reset),
	 .sys_reset                            (sys_reset),
	 .send_continuous_pkts                 (1'b0),
	 .lbus_tx_rx_restart_in                (lbus_tx_rx_restart_in),
	 .s_axi_aclk                           (init_clk),
	 .s_axi_sreset                         (sys_reset),
	 .pm_tick                              (pm_tick),
	 .s_axi_awaddr                         (s_axi_awaddr),
	 .s_axi_awvalid                        (s_axi_awvalid),
	 .s_axi_awready                        (s_axi_awready),
	 .s_axi_wdata                          (s_axi_wdata),
	 .s_axi_wstrb                          (s_axi_wstrb),
	 .s_axi_wvalid                         (s_axi_wvalid),
	 .s_axi_wready                         (s_axi_wready),
	 .s_axi_bresp                          (s_axi_bresp),
	 .s_axi_bvalid                         (s_axi_bvalid),
	 .s_axi_bready                         (s_axi_bready),
	 .s_axi_araddr                         (s_axi_araddr),
	 .s_axi_arvalid                        (s_axi_arvalid),
	 .s_axi_arready                        (s_axi_arready),
	 .s_axi_rdata                          (s_axi_rdata),
	 .s_axi_rresp                          (s_axi_rresp),
	 .s_axi_rvalid                         (s_axi_rvalid),
	 .s_axi_rready                         (s_axi_rready),
	 .tx_rdyout                            (tx_rdyout),
	 .tx_datain0                           (tx_datain0),
	 .tx_enain0                            (tx_enain0),
	 .tx_sopin0                            (tx_sopin0),
	 .tx_eopin0                            (tx_eopin0),
	 .tx_errin0                            (tx_errin0),
	 .tx_mtyin0                            (tx_mtyin0),
	 .tx_datain1                           (tx_datain1),
	 .tx_enain1                            (tx_enain1),
	 .tx_sopin1                            (tx_sopin1),
	 .tx_eopin1                            (tx_eopin1),
	 .tx_errin1                            (tx_errin1),
	 .tx_mtyin1                            (tx_mtyin1),
	 .tx_datain2                           (tx_datain2),
	 .tx_enain2                            (tx_enain2),
	 .tx_sopin2                            (tx_sopin2),
	 .tx_eopin2                            (tx_eopin2),
	 .tx_errin2                            (tx_errin2),
	 .tx_mtyin2                            (tx_mtyin2),
	 .tx_datain3                           (tx_datain3),
	 .tx_enain3                            (tx_enain3),
	 .tx_sopin3                            (tx_sopin3),
	 .tx_eopin3                            (tx_eopin3),
	 .tx_errin3                            (tx_errin3),
	 .tx_mtyin3                            (tx_mtyin3),
	 .rx_dataout0                          (rx_dataout0),
	 .rx_enaout0                           (rx_enaout0),
	 .rx_sopout0                           (rx_sopout0),
	 .rx_eopout0                           (rx_eopout0),
	 .rx_errout0                           (rx_errout0),
	 .rx_mtyout0                           (rx_mtyout0),
	 .rx_dataout1                          (rx_dataout1),
	 .rx_enaout1                           (rx_enaout1),
	 .rx_sopout1                           (rx_sopout1),
	 .rx_eopout1                           (rx_eopout1),
	 .rx_errout1                           (rx_errout1),
	 .rx_mtyout1                           (rx_mtyout1),
	 .rx_dataout2                          (rx_dataout2),
	 .rx_enaout2                           (rx_enaout2),
	 .rx_sopout2                           (rx_sopout2),
	 .rx_eopout2                           (rx_eopout2),
	 .rx_errout2                           (rx_errout2),
	 .rx_mtyout2                           (rx_mtyout2),
	 .rx_dataout3                          (rx_dataout3),
	 .rx_enaout3                           (rx_enaout3),
	 .rx_sopout3                           (rx_sopout3),
	 .rx_eopout3                           (rx_eopout3),
	 .rx_errout3                           (rx_errout3),
	 .rx_mtyout3                           (rx_mtyout3),
	 .tx_ovfout                            (tx_ovfout),
	 .tx_unfout                            (tx_unfout),
	 .tx_preamblein                        (tx_preamblein),
	 .rx_preambleout                       (rx_preambleout),
	 .stat_tx_pause_valid                  (stat_tx_pause_valid),
	 .stat_tx_pause                        (stat_tx_pause),
	 .stat_tx_user_pause                   (stat_tx_user_pause),
	 .ctl_tx_pause_req                     (ctl_tx_pause_req),
	 .ctl_tx_resend_pause                  (ctl_tx_resend_pause),
	 .stat_rx_pause                        (stat_rx_pause),
	 .stat_rx_pause_quanta0                (stat_rx_pause_quanta0),
	 .stat_rx_pause_quanta1                (stat_rx_pause_quanta1),
	 .stat_rx_pause_quanta2                (stat_rx_pause_quanta2),
	 .stat_rx_pause_quanta3                (stat_rx_pause_quanta3),
	 .stat_rx_pause_quanta4                (stat_rx_pause_quanta4),
	 .stat_rx_pause_quanta5                (stat_rx_pause_quanta5),
	 .stat_rx_pause_quanta6                (stat_rx_pause_quanta6),
	 .stat_rx_pause_quanta7                (stat_rx_pause_quanta7),
	 .stat_rx_pause_quanta8                (stat_rx_pause_quanta8),
	 .stat_rx_pause_req                    (stat_rx_pause_req),
	 .stat_rx_pause_valid                  (stat_rx_pause_valid),
	 .stat_rx_user_pause                   (stat_rx_user_pause),
	 .stat_rx_aligned_err                  (stat_rx_aligned_err),
	 .stat_rx_bad_code                     (stat_rx_bad_code),
	 .stat_rx_bad_fcs                      (stat_rx_bad_fcs),
	 .stat_rx_bad_preamble                 (stat_rx_bad_preamble),
	 .stat_rx_bad_sfd                      (stat_rx_bad_sfd),
	 .stat_rx_bip_err_0                    (stat_rx_bip_err_0),
	 .stat_rx_bip_err_1                    (stat_rx_bip_err_1),
	 .stat_rx_bip_err_10                   (stat_rx_bip_err_10),
	 .stat_rx_bip_err_11                   (stat_rx_bip_err_11),
	 .stat_rx_bip_err_12                   (stat_rx_bip_err_12),
	 .stat_rx_bip_err_13                   (stat_rx_bip_err_13),
	 .stat_rx_bip_err_14                   (stat_rx_bip_err_14),
	 .stat_rx_bip_err_15                   (stat_rx_bip_err_15),
	 .stat_rx_bip_err_16                   (stat_rx_bip_err_16),
	 .stat_rx_bip_err_17                   (stat_rx_bip_err_17),
	 .stat_rx_bip_err_18                   (stat_rx_bip_err_18),
	 .stat_rx_bip_err_19                   (stat_rx_bip_err_19),
	 .stat_rx_bip_err_2                    (stat_rx_bip_err_2),
	 .stat_rx_bip_err_3                    (stat_rx_bip_err_3),
	 .stat_rx_bip_err_4                    (stat_rx_bip_err_4),
	 .stat_rx_bip_err_5                    (stat_rx_bip_err_5),
	 .stat_rx_bip_err_6                    (stat_rx_bip_err_6),
	 .stat_rx_bip_err_7                    (stat_rx_bip_err_7),
	 .stat_rx_bip_err_8                    (stat_rx_bip_err_8),
	 .stat_rx_bip_err_9                    (stat_rx_bip_err_9),
	 .stat_rx_block_lock                   (stat_rx_block_lock),
	 .stat_rx_broadcast                    (stat_rx_broadcast),
	 .stat_rx_fragment                     (stat_rx_fragment),
	 .stat_rx_framing_err_0                (stat_rx_framing_err_0),
	 .stat_rx_framing_err_1                (stat_rx_framing_err_1),
	 .stat_rx_framing_err_10               (stat_rx_framing_err_10),
	 .stat_rx_framing_err_11               (stat_rx_framing_err_11),
	 .stat_rx_framing_err_12               (stat_rx_framing_err_12),
	 .stat_rx_framing_err_13               (stat_rx_framing_err_13),
	 .stat_rx_framing_err_14               (stat_rx_framing_err_14),
	 .stat_rx_framing_err_15               (stat_rx_framing_err_15),
	 .stat_rx_framing_err_16               (stat_rx_framing_err_16),
	 .stat_rx_framing_err_17               (stat_rx_framing_err_17),
	 .stat_rx_framing_err_18               (stat_rx_framing_err_18),
	 .stat_rx_framing_err_19               (stat_rx_framing_err_19),
	 .stat_rx_framing_err_2                (stat_rx_framing_err_2),
	 .stat_rx_framing_err_3                (stat_rx_framing_err_3),
	 .stat_rx_framing_err_4                (stat_rx_framing_err_4),
	 .stat_rx_framing_err_5                (stat_rx_framing_err_5),
	 .stat_rx_framing_err_6                (stat_rx_framing_err_6),
	 .stat_rx_framing_err_7                (stat_rx_framing_err_7),
	 .stat_rx_framing_err_8                (stat_rx_framing_err_8),
	 .stat_rx_framing_err_9                (stat_rx_framing_err_9),
	 .stat_rx_framing_err_valid_0          (stat_rx_framing_err_valid_0),
	 .stat_rx_framing_err_valid_1          (stat_rx_framing_err_valid_1),
	 .stat_rx_framing_err_valid_10         (stat_rx_framing_err_valid_10),
	 .stat_rx_framing_err_valid_11         (stat_rx_framing_err_valid_11),
	 .stat_rx_framing_err_valid_12         (stat_rx_framing_err_valid_12),
	 .stat_rx_framing_err_valid_13         (stat_rx_framing_err_valid_13),
	 .stat_rx_framing_err_valid_14         (stat_rx_framing_err_valid_14),
	 .stat_rx_framing_err_valid_15         (stat_rx_framing_err_valid_15),
	 .stat_rx_framing_err_valid_16         (stat_rx_framing_err_valid_16),
	 .stat_rx_framing_err_valid_17         (stat_rx_framing_err_valid_17),
	 .stat_rx_framing_err_valid_18         (stat_rx_framing_err_valid_18),
	 .stat_rx_framing_err_valid_19         (stat_rx_framing_err_valid_19),
	 .stat_rx_framing_err_valid_2          (stat_rx_framing_err_valid_2),
	 .stat_rx_framing_err_valid_3          (stat_rx_framing_err_valid_3),
	 .stat_rx_framing_err_valid_4          (stat_rx_framing_err_valid_4),
	 .stat_rx_framing_err_valid_5          (stat_rx_framing_err_valid_5),
	 .stat_rx_framing_err_valid_6          (stat_rx_framing_err_valid_6),
	 .stat_rx_framing_err_valid_7          (stat_rx_framing_err_valid_7),
	 .stat_rx_framing_err_valid_8          (stat_rx_framing_err_valid_8),
	 .stat_rx_framing_err_valid_9          (stat_rx_framing_err_valid_9),
	 .stat_rx_got_signal_os                (stat_rx_got_signal_os),
	 .stat_rx_hi_ber                       (stat_rx_hi_ber),
	 .stat_rx_inrangeerr                   (stat_rx_inrangeerr),
	 .stat_rx_internal_local_fault         (stat_rx_internal_local_fault),
	 .stat_rx_jabber                       (stat_rx_jabber),
	 .stat_rx_local_fault                  (stat_rx_local_fault),
	 .stat_rx_mf_err                       (stat_rx_mf_err),
	 .stat_rx_mf_len_err                   (stat_rx_mf_len_err),
	 .stat_rx_mf_repeat_err                (stat_rx_mf_repeat_err),
	 .stat_rx_misaligned                   (stat_rx_misaligned),
	 .stat_rx_multicast                    (stat_rx_multicast),
	 .stat_rx_oversize                     (stat_rx_oversize),
	 .stat_rx_packet_1024_1518_bytes       (stat_rx_packet_1024_1518_bytes),
	 .stat_rx_packet_128_255_bytes         (stat_rx_packet_128_255_bytes),
	 .stat_rx_packet_1519_1522_bytes       (stat_rx_packet_1519_1522_bytes),
	 .stat_rx_packet_1523_1548_bytes       (stat_rx_packet_1523_1548_bytes),
	 .stat_rx_packet_1549_2047_bytes       (stat_rx_packet_1549_2047_bytes),
	 .stat_rx_packet_2048_4095_bytes       (stat_rx_packet_2048_4095_bytes),
	 .stat_rx_packet_256_511_bytes         (stat_rx_packet_256_511_bytes),
	 .stat_rx_packet_4096_8191_bytes       (stat_rx_packet_4096_8191_bytes),
	 .stat_rx_packet_512_1023_bytes        (stat_rx_packet_512_1023_bytes),
	 .stat_rx_packet_64_bytes              (stat_rx_packet_64_bytes),
	 .stat_rx_packet_65_127_bytes          (stat_rx_packet_65_127_bytes),
	 .stat_rx_packet_8192_9215_bytes       (stat_rx_packet_8192_9215_bytes),
	 .stat_rx_packet_bad_fcs               (stat_rx_packet_bad_fcs),
	 .stat_rx_packet_large                 (stat_rx_packet_large),
	 .stat_rx_packet_small                 (stat_rx_packet_small),
	 .stat_rx_received_local_fault         (stat_rx_received_local_fault),
	 .stat_rx_remote_fault                 (stat_rx_remote_fault),
	 .stat_rx_status                       (stat_rx_status),
	 .stat_rx_stomped_fcs                  (stat_rx_stomped_fcs),
	 .stat_rx_synced                       (stat_rx_synced),
	 .stat_rx_synced_err                   (stat_rx_synced_err),
	 .stat_rx_test_pattern_mismatch        (stat_rx_test_pattern_mismatch),
	 .stat_rx_toolong                      (stat_rx_toolong),
	 .stat_rx_total_bytes                  (stat_rx_total_bytes),
	 .stat_rx_total_good_bytes             (stat_rx_total_good_bytes),
	 .stat_rx_total_good_packets           (stat_rx_total_good_packets),
	 .stat_rx_total_packets                (stat_rx_total_packets),
	 .stat_rx_truncated                    (stat_rx_truncated),
	 .stat_rx_undersize                    (stat_rx_undersize),
	 .stat_rx_unicast                      (stat_rx_unicast),
	 .stat_rx_vlan                         (stat_rx_vlan),
	 .stat_rx_pcsl_demuxed                 (stat_rx_pcsl_demuxed),
	 .stat_rx_pcsl_number_0                (stat_rx_pcsl_number_0),
	 .stat_rx_pcsl_number_1                (stat_rx_pcsl_number_1),
	 .stat_rx_pcsl_number_10               (stat_rx_pcsl_number_10),
	 .stat_rx_pcsl_number_11               (stat_rx_pcsl_number_11),
	 .stat_rx_pcsl_number_12               (stat_rx_pcsl_number_12),
	 .stat_rx_pcsl_number_13               (stat_rx_pcsl_number_13),
	 .stat_rx_pcsl_number_14               (stat_rx_pcsl_number_14),
	 .stat_rx_pcsl_number_15               (stat_rx_pcsl_number_15),
	 .stat_rx_pcsl_number_16               (stat_rx_pcsl_number_16),
	 .stat_rx_pcsl_number_17               (stat_rx_pcsl_number_17),
	 .stat_rx_pcsl_number_18               (stat_rx_pcsl_number_18),
	 .stat_rx_pcsl_number_19               (stat_rx_pcsl_number_19),
	 .stat_rx_pcsl_number_2                (stat_rx_pcsl_number_2),
	 .stat_rx_pcsl_number_3                (stat_rx_pcsl_number_3),
	 .stat_rx_pcsl_number_4                (stat_rx_pcsl_number_4),
	 .stat_rx_pcsl_number_5                (stat_rx_pcsl_number_5),
	 .stat_rx_pcsl_number_6                (stat_rx_pcsl_number_6),
	 .stat_rx_pcsl_number_7                (stat_rx_pcsl_number_7),
	 .stat_rx_pcsl_number_8                (stat_rx_pcsl_number_8),
	 .stat_rx_pcsl_number_9                (stat_rx_pcsl_number_9),
	 .stat_tx_bad_fcs                      (stat_tx_bad_fcs),
	 .stat_rx_aligned                      (stat_rx_aligned),
	 .stat_tx_broadcast                    (stat_tx_broadcast),
	 .stat_tx_frame_error                  (stat_tx_frame_error),
	 .stat_tx_local_fault                  (stat_tx_local_fault),
	 .stat_tx_multicast                    (stat_tx_multicast),
	 .stat_tx_packet_1024_1518_bytes       (stat_tx_packet_1024_1518_bytes),
	 .stat_tx_packet_128_255_bytes         (stat_tx_packet_128_255_bytes),
	 .stat_tx_packet_1519_1522_bytes       (stat_tx_packet_1519_1522_bytes),
	 .stat_tx_packet_1523_1548_bytes       (stat_tx_packet_1523_1548_bytes),
	 .stat_tx_packet_1549_2047_bytes       (stat_tx_packet_1549_2047_bytes),
	 .stat_tx_packet_2048_4095_bytes       (stat_tx_packet_2048_4095_bytes),
	 .stat_tx_packet_256_511_bytes         (stat_tx_packet_256_511_bytes),
	 .stat_tx_packet_4096_8191_bytes       (stat_tx_packet_4096_8191_bytes),
	 .stat_tx_packet_512_1023_bytes        (stat_tx_packet_512_1023_bytes),
	 .stat_tx_packet_64_bytes              (stat_tx_packet_64_bytes),
	 .stat_tx_packet_65_127_bytes          (stat_tx_packet_65_127_bytes),
	 .stat_tx_packet_8192_9215_bytes       (stat_tx_packet_8192_9215_bytes),
	 .stat_tx_packet_large                 (stat_tx_packet_large),
	 .stat_tx_packet_small                 (stat_tx_packet_small),
	 .stat_tx_total_bytes                  (stat_tx_total_bytes),
	 .stat_tx_total_good_bytes             (stat_tx_total_good_bytes),
	 .stat_tx_total_good_packets           (stat_tx_total_good_packets),
	 .stat_tx_total_packets                (stat_tx_total_packets),
	 .stat_tx_unicast                      (stat_tx_unicast),
	 .stat_tx_vlan                         (stat_tx_vlan),
	 .ctl_tx_send_idle                     (ctl_tx_send_idle),
	 .ctl_tx_send_rfi                      (ctl_tx_send_rfi),
	 .ctl_tx_send_lfi                      (ctl_tx_send_lfi),
	 .rx_reset                             (rx_reset),
	 .tx_reset                             (tx_reset),
	 .gt_rxrecclkout                       (gt_rxrecclkout),
	 .tx_done_led                          (tx_done_led),
	 .tx_busy_led                          (tx_busy_led),
	 .stat_reg_compare_out                 (stat_reg_compare_out),
	 .rx_gt_locked_led                     (rx_gt_locked_led),
	 .rx_aligned_led                       (rx_aligned_led),
	 .rx_done_led                          (rx_done_led),
	 .rx_data_fail_led                     (rx_data_fail_led),
	 .rx_busy_led                          (rx_busy_led),
	 .payload_rd                           (payload_rd),
	 .payload                              (payload),
	 .lbus_number_pkt_proc                 (lbus_number_pkt_proc),
	 .lbus_pkt_size_proc                   (lbus_pkt_size_proc),
	 .debug(debug)
	 );

    assign init_clk = gt_ref_clk_out;
    
    reg [31:0] counter = 32'd0;
    reg [7:0]  reset_counter = 8'd0;
    always @(posedge init_clk) begin
	counter <= counter + 1;
    end

    wire txusrclk2_reset;
    resetgen#(.RESET_COUNT(100)) resetgen_i_0(.clk(init_clk), .reset_in(1'b0), .reset_out(sys_reset));
    resetgen#(.RESET_COUNT(100)) resetgen_i_1(.clk(txusrclk2), .reset_in(1'b0), .reset_out(txusrclk2_reset));

    wire [511:0] fifo_d;
    wire [511:0] fifo_q;
    wire 	fifo_wr;
    wire 	fifo_rd;
    wire 	fifo_full, fifo_empty;
    
    fifo_512_256_ft fifo_512_256_ft_i(.wr_clk(txusrclk2),
				      .rd_clk(txusrclk2),
				      .rst(sys_reset), // async
				      .din(fifo_d),
				      .wr_en(fifo_wr),
				      .full(fifo_full),
				      .dout(fifo_q),
				      .empty(fifo_empty),
				      .rd_en(fifo_rd),
				      .wr_rst_busy(),
				      .rd_rst_busy(),
				      .valid(),
				      .wr_data_count(),
				      .rd_data_count()
				      );
    wire fifo_full_keep;
    keep_flag fifo_full_keep_i(txusrclk2, txusrclk2_reset, fifo_full, fifo_full_keep);

    assign payload = fifo_q;
    assign fifo_rd = payload_rd;

    wire [7:0] recv_mty = rx_eopout3 == 1'b1 ? rx_mtyout3
	       : rx_eopout2 == 1'b1 ? rx_mtyout2 + 8'd16
	       : rx_eopout1 == 1'b1 ? rx_mtyout1 + 8'd32
	       : rx_eopout0 == 1'b1 ? rx_mtyout0 + 8'd48
               : 8'd0;
    
    wire [111:0] ether_header_data;
    wire         ether_header_valid;
    wire [511:0] ether_data_data;
    wire         ether_data_valid;
    wire         ether_data_sop;
    wire         ether_data_eop;
    wire [7:0]   ether_data_mty;
    ether_rx#(.APP_KEY(16'h3434)) ether_rx_i
      (
       .clk(txusrclk2),
       .reset(1'b0),
       .recv_data({rx_dataout0, rx_dataout1, rx_dataout2, rx_dataout3}),
       .recv_valid(rx_enaout0),
       .recv_sop(rx_sopout0),
       .recv_eop(rx_eopout0 || rx_eopout1 || rx_eopout2 || rx_eopout3),
       .recv_mty(recv_mty),
       .ether_header_data(ether_header_data),
       .ether_header_valid(ether_header_valid),
       .ether_data_data(ether_data_data),
       .ether_data_valid(ether_data_valid),
       .ether_data_sop(ether_data_sop),
       .ether_data_eop(ether_data_eop),
       .ether_data_mty(ether_data_mty)
       );

    reg ether_header_rd = 1'b0;
    wire[111:0] ether_header_q;
    wire ether_header_full;
    wire ether_header_valid_rising;

    reg ether_header_valid_r;
    always @(posedge txusrclk2)
      ether_header_valid_r <= ether_header_valid;
    assign ether_header_valid_rising = ether_header_valid_r == 1'b0 && ether_header_valid == 1'b1;

    fifo_112_16_ft ether_header_fifo(
				     .clk(txusrclk2),
				     .srst(txusrclk2_reset),
				     .din(ether_header_data),
				     .wr_en(ether_header_valid_rising),
				     .rd_en(ether_header_rd),
				     .dout(ether_header_q),
				     .full(ether_header_full),
				     .overflow(),
				     .empty(),
				     .valid(),
				     .underflow(),
				     .data_count(),
				     .wr_rst_busy(),
				     .rd_rst_busy());
    wire ether_header_full_keep;
    keep_flag ether_header_full_keep_i(txusrclk2, txusrclk2_reset, ether_header_full, ether_header_full_keep);

    reg app_command_fifo_rd;
    wire [31:0] app_command_fifo_q;
    wire app_command_fifo_valid;
    wire app_command_fifo_full;

    fifo_32_256_ft app_command_fifo(
				    .clk(txusrclk2),
				    .srst(txusrclk2_reset),
				    .din(ether_data_data[511:480]),
				    .wr_en(ether_data_sop && ether_data_valid),
				    .rd_en(app_command_fifo_rd),
				    .dout(app_command_fifo_q),
				    .full(app_command_fifo_full),
				    .overflow(),
				    .empty(),
				    .valid(app_command_fifo_valid),
				    .underflow(),
				    .data_count(),
				    .wr_rst_busy(),
				    .rd_rst_busy());
    wire app_command_fifo_full_keep;
    keep_flag app_command_fifo_full_keep_i(txusrclk2, txusrclk2_reset, app_command_fifo_full, app_command_fifo_full_keep);

    wire send_valid, send_sop, send_eop;
    wire [7:0] send_mty;
    wire [511:0] send_data;

    reg [111:0] ether_tx_header_data;
    reg         ether_tx_header_valid;
    reg [511:0] ether_tx_data_data;
    reg ether_tx_data_valid;
    reg ether_tx_data_sop;
    reg ether_tx_data_eop;
    reg [13:0] ether_tx_data_mty;

    ether_tx ether_tx_i
      (
       .clk(txusrclk2),
       .reset(1'b0),
       .ether_header_data(ether_tx_header_data),
       .ether_header_valid(ether_tx_header_valid),
       .ether_data_data(ether_tx_data_data),
       .ether_data_valid(ether_tx_data_valid),
       .ether_data_sop(ether_tx_data_sop),
       .ether_data_eop(ether_tx_data_eop),
       .ether_data_mty(ether_tx_data_mty),
       .send_data(send_data),
       .send_valid(send_valid),
       .send_sop(send_sop),
       .send_eop(send_eop),
       .send_mty(send_mty)
       );

    cmac_usplus_emitter cmac_usplus_emitter_i
      (
       .clk(txusrclk2),
       .reset(1'b0),

       .din_data(send_data),
       .din_valid(send_valid),
       .din_sop(send_sop),
       .din_eop(send_eop),
       .din_mty(send_mty),

       .dout_data(fifo_d),
       .dout_valid(fifo_wr),
       .dout_kick(lbus_tx_rx_restart_in),
       .dout_bytes(lbus_pkt_size_proc),
       .cmac_busy(tx_busy_led),
       .cmac_done(tx_done_led),
       .cmac_tx_rdy(tx_rdyout)
       );

    wire w_iclkdiv2 = AXONERVE_IF_CLK;
    wire w_ixrst = AXONERVE_IF_XRST;

    wire fifo_ether2axonerve_full;
    wire fifo_ether2axonerve_empty;
    wire fifo_ether2axonerve_rd;
    wire fifo_ether2axonerve_wr;
    wire fifo_ether2axonerve_valid;
    wire [511:0] fifo_ether2axonerve_dout;
    fifo_512_256_ft fifo_ether2axonerve(.wr_clk(txusrclk2),
					.rd_clk(w_iclkdiv2),
					.rst(~w_ixrst), // async
					.din(ether_data_data),
					.wr_en(fifo_ether2axonerve_wr),
					.full(fifo_ether2axonerve_full),
					.dout(fifo_ether2axonerve_dout),
					.empty(fifo_ether2axonerve_empty),
					.rd_en(fifo_ether2axonerve_rd),
					.wr_rst_busy(),
					.rd_rst_busy(),
					.valid(fifo_ether2axonerve_valid),
					.wr_data_count(),
					.rd_data_count()
					);
    wire fifo_ether2axonerve_full_keep;
    keep_flag fifo_ether2axonerve_full_keep_i
      (txusrclk2, txusrclk2_reset, fifo_ether2axonerve_full, fifo_ether2axonerve_full_keep);

    assign fifo_ether2axonerve_wr = ether_data_valid && (ether_data_mty == 0);

    wire[31:0] user_cmd;
    wire user_reset_trig;
    assign fifo_ether2axonerve_rd = fifo_ether2axonerve_valid && ~OFIFO_FULL;
    assign user_cmd = fifo_ether2axonerve_dout[511:480];
    assign GEN_KEY = fifo_ether2axonerve_dout[479:192];
    assign GEN_VAL = fifo_ether2axonerve_dout[191:160];
    assign GEN_ADD = fifo_ether2axonerve_dout[159:128];
    //assign w_gen_msk = fifo_ether2axonerve_dout[127:64];
    assign GEN_MSK = 288'd0;
    // fifo_ether2axonerve_dout[63:39]; reserved
    assign GEN_PRI = fifo_ether2axonerve_dout[38:32];
    assign GEN_IE = fifo_ether2axonerve_dout[0] && fifo_ether2axonerve_valid && ~OFIFO_FULL;
    assign GEN_WE = fifo_ether2axonerve_dout[1] && fifo_ether2axonerve_valid && ~OFIFO_FULL;
    assign GEN_RE = fifo_ether2axonerve_dout[2] && fifo_ether2axonerve_valid && ~OFIFO_FULL;
    assign GEN_SE = fifo_ether2axonerve_dout[3] && fifo_ether2axonerve_valid && ~OFIFO_FULL;
    assign user_reset_trig = fifo_ether2axonerve_dout[4] && fifo_ether2axonerve_valid && ~OFIFO_FULL;

    reg user_reset_reg = 1'b0;
    reg user_reset_done = 1'b0;
    assign GEN_XRST = ~user_reset_reg;
    reg [2:0] user_reset_state = 3'd0;
    always @(posedge w_iclkdiv2) begin
	case(user_reset_state)
	    3'd0: begin
		if(user_reset_trig == 1'b1) begin
		    user_reset_reg <= 1'b1;
		    user_reset_state <= user_reset_state + 1;
		end else begin
		    user_reset_reg <= 1'b0;
		end
		user_reset_done <= 1'b0;
	    end
	    3'd1: begin
		user_reset_reg <= 1'b0;
		if(OXMATCH_WAIT == 1'b0) begin // begin reset sequence
		    user_reset_state <= user_reset_state + 1;
		end
	    end
	    3'd2: begin
		if(OXMATCH_WAIT == 1'b1) begin // end reset sequence
		    user_reset_state <= 3'd0; // wait for next reset_trig
		    user_reset_reg <= 1'b0;
		    user_reset_done <= 1'b1;
		end
	    end
	    default: begin
		user_reset_state <= 3'd0;
		user_reset_reg <= 1'b0;
		user_reset_done <= 1'b0;
	    end
	endcase
    end

    wire fifo_axonerve2ether_full;
    reg fifo_axonerve2ether_wr = 1'b0;
    reg [511:0] fifo_axonerve2ether_din = 1'b0;

    wire fifo_axonerve2ether_empty;
    reg fifo_axonerve2ether_rd = 1'b0;
    wire fifo_axonerve2ether_valid;
    wire [511:0] fifo_axonerve2ether_dout;
    wire [12:0] fifo_axonerve2ether_rd_count;
    fifo_512_256_ft fifo_axonerve2ether(.wr_clk(w_iclkdiv2),
					.rd_clk(txusrclk2),
					.rst(~w_ixrst), // async
					.din(fifo_axonerve2ether_din),
					.wr_en(fifo_axonerve2ether_wr),
					.full(fifo_axonerve2ether_full),
					.dout(fifo_axonerve2ether_dout),
					.empty(fifo_axonerve2ether_empty),
					.rd_en(fifo_axonerve2ether_rd),
					.wr_rst_busy(),
					.rd_rst_busy(),
					.valid(fifo_axonerve2ether_valid),
					.wr_data_count(),
					.rd_data_count(fifo_axonerve2ether_rd_count)
					);
    wire fifo_axonerve2ether_full_keep;
    keep_flag fifo_axonerve2ether_full_keep_i
      (w_iclkdiv2, ~w_ixrst, fifo_axonerve2ether_full, fifo_axonerve2ether_full_keep);

    always @(posedge w_iclkdiv2) begin
	if(OACK == 1'b1) begin
	    fifo_axonerve2ether_wr <= 1'b1;
	    fifo_axonerve2ether_din[511:480] <= user_cmd;
	    fifo_axonerve2ether_din[479:192] <= OKEY_DAT;
	    fifo_axonerve2ether_din[191:160] <= OKEY_VALUE;
	    fifo_axonerve2ether_din[159:128] <= OSRCH_ENT_ADD;
	    fifo_axonerve2ether_din[127:64] <= 64'h0; // reserved for mask
	    fifo_axonerve2ether_din[63:39]  <= 25'h0; // reserved
	    fifo_axonerve2ether_din[38:32]  <= OKEY_PRI;
	    fifo_axonerve2ether_din[0]   <= OSHIT;
	    fifo_axonerve2ether_din[1]   <= OMHIT;
	    fifo_axonerve2ether_din[3:2] <= OENT_ERR;
	end else if(user_reset_done == 1'b1) begin
	    fifo_axonerve2ether_wr <= 1'b1;
	    fifo_axonerve2ether_din <= 512'd0;
	end else begin
	    fifo_axonerve2ether_wr <= 1'b0;
	end
    end

    reg[7:0] state = 8'd0;
    reg[8:0] data_counter = 9'd0;
    always @(posedge txusrclk2) begin
	if(txusrclk2_reset == 1) begin
	    fifo_axonerve2ether_rd <= 1'b0;
	    ether_tx_header_valid <= 1'b0;
	    ether_tx_data_valid <= 1'b0;
	    ether_tx_data_sop <= 1'b0;
	    ether_tx_data_eop <= 1'b0;
	    ether_tx_data_mty <= 14'd0;
	    ether_tx_data_data <= 512'd0;
	    data_counter <= 9'd0;
	    state <= 8'd0;
	    ether_header_rd <= 1'b0;
	    app_command_fifo_rd <= 1'b0;
	end else begin
	    case(state)
		8'd0: begin // wait for response data
		    if(app_command_fifo_q[23:16] == fifo_axonerve2ether_rd_count[7:0] && app_command_fifo_valid == 1'b1) begin
			state <= 1;
			fifo_axonerve2ether_rd <= 1'b1;
			app_command_fifo_rd <= 1'b1;
		    end else begin
			fifo_axonerve2ether_rd <= 1'b0;
			app_command_fifo_rd <= 1'b0;
		    end
		    data_counter[7:0] <= app_command_fifo_q[23:16];
		    ether_tx_header_valid <= 1'b0;
		    ether_tx_data_valid <= 1'b0;
		    ether_tx_data_sop <= 1'b0;
		    ether_tx_data_eop <= 1'b0;
		    ether_tx_data_mty <= 14'd0;
		    ether_tx_data_data <= 512'd0;
		    ether_header_rd <= 1'b0;
		end
		8'd1: begin
		    app_command_fifo_rd <= 1'b0;
		    if(data_counter == 1) begin
			fifo_axonerve2ether_rd <= 1'b0;
			ether_tx_data_eop <= 1'b1;
			state <= 0;
		    end else begin
			fifo_axonerve2ether_rd <= 1'b1;
			ether_tx_data_eop <= 1'b0;
			state <= 2;
		    end
		    ether_tx_header_valid <= 1'b1;
		    ether_tx_header_data <= {ether_header_q[63:16], ether_header_q[111:64], ether_header_q[15:0]}; // loopback
		    ether_header_rd <= 1'b1;
		    ether_tx_data_sop <= 1'b1;
		    ether_tx_data_valid <= 1'b1;
		    ether_tx_data_data <= fifo_axonerve2ether_dout;
		    data_counter <= data_counter - 1;
		end
		8'd2: begin
		    if(data_counter == 1) begin
			fifo_axonerve2ether_rd <= 1'b0;
			ether_tx_data_eop <= 1'b1;
			state <= 0;
		    end else begin
			fifo_axonerve2ether_rd <= 1'b1;
			ether_tx_data_eop <= 1'b0;
			state <= 2;
		    end
		    ether_tx_header_valid <= 1'b0;
		    ether_tx_header_data <= 112'd0;
		    ether_header_rd <= 1'b0;
		    ether_tx_data_sop <= 1'b0;
		    ether_tx_data_valid <= 1'b1;
		    ether_tx_data_data <= fifo_axonerve2ether_dout;
		    data_counter <= data_counter - 1;
		end
		default: begin
		    state <= 0;
		    fifo_axonerve2ether_rd <= 1'b0;
		    ether_tx_header_valid <= 1'b0;
		    ether_tx_data_valid <= 1'b0;
		    ether_tx_data_sop <= 1'b0;
		    ether_tx_data_eop <= 1'b0;
		    ether_tx_data_data <= 512'd0;
		    ether_header_rd <= 1'b0;
		    app_command_fifo_rd <= 1'b0;
		end
	    endcase // case (state)
	end // else: !if(txusrclk2_reset == 1)
    end // always @ (posedge txusrclk2)

    vio_0 vio_0_i(.clk(txusrclk2),
		  .probe_in0(tx_done_led),
		  .probe_in1(tx_busy_led),
		  .probe_in2(rx_gt_locked_led),
		  .probe_in3(rx_aligned_led),
		  .probe_in4(rx_done_led),
		  .probe_in5(rx_data_fail_led),
		  .probe_in6(rx_busy_led),
		  .probe_in7(stat_reg_compare_out),
		  .probe_out0(pm_tick)
		  );
    
    ila_0 ila_0_i(.clk(init_clk),
		  .probe0(counter)
		  );

    ila_1 ila_1_i(.clk(txusrclk2),
		  .probe0({rx_mtyout0, rx_enaout0, rx_eopout0, rx_sopout0, rx_dataout0}),
		  .probe1({rx_mtyout1, rx_enaout1, rx_eopout1, rx_sopout1, rx_dataout1}),
		  .probe2({rx_mtyout2, rx_enaout2, rx_eopout2, rx_sopout2, rx_dataout2}),
		  .probe3({rx_mtyout3, rx_enaout3, rx_eopout3, rx_sopout3, rx_dataout3}),
		  .probe4(debug),
		  .probe5({lbus_pkt_size_proc, ether_data_mty, send_mty}),
		  .probe6(lbus_tx_rx_restart_in),
		  .probe7({fifo_rd, fifo_q}),
		  .probe8({fifo_wr, fifo_d}),
		  .probe9(tx_rdyout),
		  .probe10({fifo_axonerve2ether_rd_count, fifo_axonerve2ether_empty, fifo_axonerve2ether_valid}),
		  .probe11({fifo_axonerve2ether_rd, ether_tx_data_sop, ether_tx_data_eop, ether_tx_data_valid, ether_tx_header_valid}),
		  .probe12({data_counter, state}),
		  .probe13({ether_data_sop, ether_data_valid, ether_data_eop, ether_data_data}),
		  .probe14(fifo_axonerve2ether_dout),
		  .probe15({fifo_ether2axonerve_full_keep, app_command_fifo_full_keep, ether_header_full_keep, fifo_full_keep})
		  );

    ila_2 ila_2_i(.clk(w_iclkdiv2),
		  .probe0({fifo_axonerve2ether_wr, fifo_axonerve2ether_din}),
		  .probe1({OXMATCH_WAIT, user_reset_reg, user_reset_done, user_reset_state}),
		  .probe2(fifo_axonerve2ether_full_keep)
		  );

    

endmodule // app_cmac_frontend

module keep_flag(
		 input wire clk,
		 input wire reset,
		 input wire flag_in,
		 output reg flag_q);
    always @(posedge clk) begin
	if(reset == 1'b1)
	  flag_q <= 1'b0;
	else if(flag_in == 1'b1)
	  flag_q <= 1'b1;
    end
endmodule // keep_flag

`default_nettype wire
