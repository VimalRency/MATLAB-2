set_property SRC_FILE_INFO {cfile:c:/projects/dvfs_zed/dvfs_zed_project/dvfs_zed_project.gen/sources_1/bd/dvfs_bd/ip/dvfs_bd_dvfs_core_ip_0_0/constraint/dvfs_core_ip_src_dvfs_core_hdl_interface_constraints.xdc rfile:../../../dvfs_zed_project.gen/sources_1/bd/dvfs_bd/ip/dvfs_bd_dvfs_core_ip_0_0/constraint/dvfs_core_ip_src_dvfs_core_hdl_interface_constraints.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:9 export:INPUT save:INPUT read:READ} [current_design]
set clk_period_axitoip [get_property PERIOD [get_clocks -of_objects [get_cells inst/u_dvfs_core_ip_axi_lite_inst/u_dvfs_core_ip_axi_lite_module_inst/u_dvfs_core_ip_write_data_sync_inst/u_dvfs_core_ip_write_sync_receive_clk_inst/s_level_2FlopSync_2_reg]]]
set_property src_info {type:SCOPED_XDC file:1 line:10 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay -from $startreglist_axitoip -to $endreglist_axitoip -datapath_only $clk_period_axitoip -quiet
set_property src_info {type:SCOPED_XDC file:1 line:15 export:INPUT save:INPUT read:READ} [current_design]
set clk_period_iptoaxi [get_property PERIOD [get_clocks -of_objects [get_cells inst/u_dvfs_core_ip_axi_lite_inst/u_dvfs_core_ip_axi_lite_module_inst/u_dvfs_core_ip_write_data_sync_inst/s_level_2FlopSync_2_reg]]]
set_property src_info {type:SCOPED_XDC file:1 line:16 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay -from $startreglist_iptoaxi -to $endreglist_iptoaxi -datapath_only $clk_period_iptoaxi -quiet
