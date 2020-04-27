set_operating_conditions -design_power_budget 63

set_property IOSTANDARD LVDS [get_ports SYSCLK3_N]
set_property PACKAGE_PIN BB18 [get_ports SYSCLK3_P]
set_property PACKAGE_PIN BC18 [get_ports SYSCLK3_N]
set_property IOSTANDARD LVDS [get_ports SYSCLK3_P]
set_property DQS_BIAS TRUE [get_ports SYSCLK3_P]

create_clock -period 10.000 -name sysclk3 [get_ports SYSCLK3_P]

set_false_path -from [get_clocks sysclk3] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]]

set_false_path -from [get_clocks -of_objects [get_pins {app_cmac_frontend_i/DUT/inst/cmac_usplus_0_gt_i/inst/gen_gtwizard_gtye4_top.cmac_usplus_0_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[7].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -to [get_clocks gt_ref_clk_p]
set_false_path -from [get_clocks gt_ref_clk_p] -to [get_clocks -of_objects [get_pins {app_cmac_frontend_i/DUT/inst/cmac_usplus_0_gt_i/inst/gen_gtwizard_gtye4_top.cmac_usplus_0_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[7].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]]

set_false_path -from [get_clocks sysclk3] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]] -to [get_clocks sysclk3]

set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]] -to [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]]

set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]] -to [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT1]] -to [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT2]] -to [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT3]] -to [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT4]] -to [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT5]] -to [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT6]] -to [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]]

set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]]

set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT1]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT2]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT3]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT4]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT5]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT6]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]]

set_false_path -from [get_clocks sysclk3] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT1]]
set_false_path -from [get_clocks sysclk3] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT2]]
set_false_path -from [get_clocks sysclk3] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT3]]
set_false_path -from [get_clocks sysclk3] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT4]]
set_false_path -from [get_clocks sysclk3] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT5]]
set_false_path -from [get_clocks sysclk3] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT6]]

set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT2]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT3]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT4]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT5]]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT0]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT6]]

set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT2]]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT3]]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT4]]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT5]]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT6]]

set_false_path -from [get_clocks sysclk3] -to [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks sysclk3]

set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT5]] -to [get_clocks sysclk3]
set_false_path -from [get_clocks -of_objects [get_pins HBM_CONTROLLER/u_mmcm_0/CLKOUT6]] -to [get_clocks sysclk3]

set_false_path -from [get_clocks -of_objects [get_pins {app_cmac_frontend_i/DUT/inst/cmac_usplus_0_gt_i/inst/gen_gtwizard_gtye4_top.cmac_usplus_0_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[7].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -to [get_clocks sysclk3]
set_false_path -from [get_clocks sysclk3] -to [get_clocks -of_objects [get_pins {app_cmac_frontend_i/DUT/inst/cmac_usplus_0_gt_i/inst/gen_gtwizard_gtye4_top.cmac_usplus_0_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[7].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list HBM_CONTROLLER/AXI_ACLK0_st0_buf]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list HBM_CONTROLLER/n_0_0]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list HBM_CONTROLLER/n_0_1]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list HBM_CONTROLLER/n_0_2]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list HBM_CONTROLLER/n_0_3]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list HBM_CONTROLLER/n_0_4]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list HBM_CONTROLLER/u_hbm_0_n_4992]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list HBM_CONTROLLER/u_hbm_0_n_4993]]
set_property C_CLK_INPUT_FREQ_HZ 100000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets SYSCLK3]
