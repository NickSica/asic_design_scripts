source -echo ../set_app.tcl
if { $app_name == "icc2_shell" } {
    source -echo ../set_env.tcl
    # const dir only used for dc_synth folder no need to create
    #set const_dir       const/${top}_no_sram
    #set output_dir     output/${top}_no_sram
    #set reports_dir   reports/${top}_no_sram
    #set snapshot_dir snapshot/${top}_no_sram
    #set lib_name              ${top}_no_sram

    set const_dir       const/${top}
    set output_dir     output/${top}
    set reports_dir   reports/${top}
    set snapshot_dir snapshot/${top}
    set lib_dir lib

    file mkdir $output_dir
    file mkdir $reports_dir
    file mkdir $snapshot_dir
    file mkdir $lib_dir
}

set lib_name              ${top}

lappend search_path ../fc_shell/$output_dir
set_app_options -name lib.configuration.icc_shell_exec -value "/home/tools/synopsys/icc/Q-2019.12-SP1/bin/icc_shell"

set_host_options -max_cores 32

set ref_lib $icc2_lib

set_svf -off
#open_lib $lib_name.dlib
#open_block ${lib_name}_extracted
#if { ![info exists top_script] } {
set icc2_dir [file join $root_dir icc2_pnr]
	source -echo $icc2_dir/scripts/init_design.tcl
	source -echo $icc2_dir/scripts/floorplan_icc.tcl
	source -echo $icc2_dir/scripts/pg_plan.tcl
	source -echo $icc2_dir/scripts/place_icc.tcl
	#source -echo $icc2_dir/scripts/cts_icc.tcl
	source -echo $icc2_dir/scripts/route_icc.tcl
	source -echo $icc2_dir/scripts/extract_icc.tcl
#}
start_gui
