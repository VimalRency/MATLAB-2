set_param board.repoPaths [get_property LOCAL_ROOT_DIR [xhub::get_xstores xilinx_board_store]]
create_project vivado_prj {} -part xc7z020clg484-1 -force
set_property board_part avnet.com:zedboard:part0:1.4 [current_project]
set_property target_language Verilog [current_project]
set defaultRepoPath {./ipcore}
set_property ip_repo_paths $defaultRepoPath [current_fileset]
update_ip_catalog
set ipList [glob -nocomplain -directory $defaultRepoPath *.zip]
foreach ipCore $ipList {
  set folderList [glob -nocomplain -directory $defaultRepoPath -type d *]
  if {[lsearch -exact $folderList [file rootname $ipCore]] == -1} {
    catch {update_ip_catalog -add_ip $ipCore -repo_path $defaultRepoPath}
  }
}
update_ip_catalog
set HDLVerifierAXI {off}
source vivado_custom_block_design.tcl
# Use global synthesis for this project
set_property synth_checkpoint_mode None [get_files system_top.bd]
# Update output frequency on clock wizard based on target frequency
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.000}] [get_bd_cells core_clkwiz]
save_bd_design
close_project
exit
