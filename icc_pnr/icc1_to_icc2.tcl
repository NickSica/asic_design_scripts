source ../set_env.tcl

set libdir "$pdk_dir/tech/star_rcxt"
set tlupmax "$libdir/saed32nm_1p9m_Cmax.tluplus"
set tlunom "$libdir/saed32nm_1p9m_nominal.tluplus"
set tlupmin "$libdir/saed32nm_1p9m_Cmin.tluplus"
set tech2itf "$libdir/saed32nm_tf_itf_tluplus.map"

#set libdir "$pdk_dir/Technology_Kit/rules/starrcxt"
#set tlupmax "$libdir/tluplus/saed90nm_1p9m_1t_Cmax.tluplus"
#set tlunom "$libdir/tluplus/saed90nm_1p9m_1t_nominal.tluplus"
#set tlupmin "$libdir/tluplus/saed90nm_1p9m_1t_Cmin.tluplus"
#set tech2itf "$libdir/tech2itf.map"

#set techfile "../ref/tech/saed32nm_1p9m.tf"
#set techfile $pdk_dir/Technology_Kit/techfile/saed90nm_1p9m.tf
#set ref_lib $pdk_dir/Digital_Standard_Cell_Library/synopsys/plib/
#set techfile $pdk_dir/Technology_Kit/techfile/saed90nm_1p9m.tf
#set ref_lib $pdk_dir/Digital_Standard_Cell_Library/lef/saed90nm.lef

set techfile "$pdk_dir/tech/milkyway/saed32nm_1p9m_mw.tf"
set ref_lib "$pdk_dir/lib/stdcell_rvt/milkyway/saed32nm_rvt_1p9m"

set lib_name "fifo"

source -echo scripts/init_design.tcl
source -echo scripts/floorplan_icc.tcl
source -echo scripts/place_icc.tcl
source -echo scripts/cts_icc.tcl
#source -echo scripts/route_icc.tcl
#source -echo scripts/extract_icc.tcl
#start_gui

change_names -rules verilog -hier
write_verilog -pg icc1_to_icc2/from_icc1.v
write_floorplan -format icc2 icc1_to_icc2/from_icc1_fp.tcl
write_script -format icc2 -output icc1_to_icc2/from_icc1_cstr.tcl
write_timing_context -format icc2 -output icc1_to_icc2/from_icc1_tim_context
write_def -all_vias -via_style_as_generated -version 5.8 -output icc1_to_icc2/from_icc1.def
save_upf icc1_to_icc2/from_icc1.upf
