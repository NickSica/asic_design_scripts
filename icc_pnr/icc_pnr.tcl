source -echo ../set_env.tcl

# const dir only used for dc_synth folder no need to create
set const_dir const/$top 

set output_dir $pdk/output/$top
set reports_dir $pdk/reports/$top
set snapshot_dir $pdk/snapshot/$top
set lib_dir $pdk/lib
lappend search_path ../dc_synth/$output_dir

set_host_options -max_cores 24

file mkdir $output_dir
file mkdir $reports_dir
file mkdir $snapshot_dir
file mkdir $lib_dir

set ref_lib $icc_lib

set mw_logic0_net VSS
set mw_logic0_net VDD

set icc_snapshot_storage_location $snapshot_dir

start_gui
#open_mw_lib lib/ibex_top.mw
#open_mw_cel place
source -echo scripts/init_design.tcl
source -echo scripts/floorplan_icc.tcl
source -echo scripts/place_icc.tcl
source -echo scripts/cts_icc.tcl
source -echo scripts/route_icc.tcl
source -echo scripts/extract_icc.tcl
#exit
