set project_dir    "./prj"
set project_name   "axonerve_etherif"
set top_module     "AXONERVE_HBM_TOP"
set project_target "xcu50-fsvh2104-2-e"
set project_board "xilinx.com:au50:part0:1.0"

set source_files { \
			./axonerve/param.vh \
			./sources/defines_h.vh \
			./axonerve/AXONERVE_A01_HBM_all.vp \
			./sources/HBM_CONTROLLER.v \
			./sources/AXONERVE_HBM_TOP.v \
			./sources/app_cmac_frontend.v \
			./alveo_u50_misc/cmac_usplus_0_ex/sources/cmac_usplus_0_axi4_lite_user_if.v \
			./alveo_u50_misc/cmac_usplus_0_ex/sources/cmac_usplus_0_lbus_pkt_gen.v \
			./alveo_u50_misc/cmac_usplus_0_ex/sources/cmac_usplus_0_lbus_pkt_mon.v \
			./alveo_u50_misc/cmac_usplus_0_ex/sources/cmac_usplus_0_pkt_gen_mon.v \
			./alveo_u50_misc/cmac_usplus_0_ex/sources/resetgen.v \
			./alveo_u50_misc/cmac_usplus_0_ex/sources/cmac_usplus_emitter.sv \
			./alveo_u50_misc/cmac_usplus_0_ex/sources/ether_rx.sv \
			./alveo_u50_misc/cmac_usplus_0_ex/sources/ether_tx.sv \
		   }

set constraint_files { \
			./sources/AXONERVE_HBM.xdc \
		       }

set simulation_files { \
		       }

create_project -force $project_name $project_dir -part $project_target
set_property BOARD_PART $project_board [current_project] 
add_files -norecurse $source_files

set_property is_global_include true [get_files ./axonerve/param.vh]
set_property is_global_include true [get_files ./sources/defines_h.vh]

add_files -fileset constrs_1 -norecurse $constraint_files

update_ip_catalog

import_ip -files ./ip/cmac_usplus_0.xci
import_ip -files ./ip/hbm_0.xci
import_ip -files ./ip/fifo_112_16_ft.xci
import_ip -files ./ip/fifo_16_1024_ft.xci
import_ip -files ./ip/fifo_32_256_ft.xci
import_ip -files ./ip/fifo_512_256_ft.xci
import_ip -files ./ip/clk_wiz_0.xci
import_ip -files ./ip/ila_axonerve.xci
import_ip -files ./ip/ila_0.xci
import_ip -files ./ip/ila_1.xci
import_ip -files ./ip/ila_2.xci
import_ip -files ./ip/vio_0.xci

set_property top $top_module [current_fileset]
set_property target_constrs_file ./sources/AXONERVE_HBM.xdc [current_fileset -constrset]

update_compile_order -fileset sources_1

#add_files -fileset sim_1 -norecurse $simulation_files

update_compile_order -fileset sim_1

set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
#set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
#set_property strategy Flow_RuntimeOptimized [get_runs synth_1]
#set_property strategy Performance_ExplorePostRoutePhysOpt [get_runs impl_1]

reset_project

launch_runs synth_1 -jobs 6
wait_on_run synth_1
 
launch_runs impl_1 -jobs 6
wait_on_run impl_1
open_run impl_1
report_utilization -file [file join $project_dir "project.rpt"]
report_timing -file [file join $project_dir "project.rpt"] -append
 
launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_run impl_1
close_project

quit
