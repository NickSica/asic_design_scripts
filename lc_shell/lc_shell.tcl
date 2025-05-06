source -echo ../set_env.tcl

set new_lib asap7

    set ref_path ../lm_shell/tsmc65nm.ndm
    set layermap "$pdk_dir/TSMCHOME/6x1z1u_icc_icc2_tech_files/PRTF_ICC_65nm_001_Syn_V24a/PR_tech/Synopsys/GdsOutMap/PRTF_ICC_N65_gdsout_6X1Z1U.24a.map"

create_physical_lib -technology $techfile $new_lib
set_app_options {file.gds.port_type_map {{power ${power_net}} {ground ${ground_net}}}}
set_ref_libs -ref_libs $ref_path 
#derive_via_regions
#read_gds -layer_map $layermap $root_dir/src/OneRing_24GHz.gds
#read_gds -layer_map $layermap $root_dir/src/nch.gds
#read_gds -layer_map $layermap $root_dir/src/pass.gds
read_lef $root_dir/src/sites.lef
read_lef -merge_action update $root_dir/src/OneRing_24GHz.lef
read_lef -preserve_lef_cell_site -merge_action update $root_dir/src/nch.lef
read_lef -preserve_lef_cell_site -merge_action update $root_dir/src/pass.lef
read_oasis -merge_action update -layer_map $layermap $root_dir/src/OneRing_24GHz.oasis
read_oasis -merge_action update -layer_map $layermap $root_dir/src/nch.oasis
read_oasis -merge_action update -layer_map $layermap $root_dir/src/pass.oasis

#read_def $root_dir/src/*.def
create_frame
#check_library
write_physical_lib -output $new_lib
#write_lib $new_lib -output $new_lib
#start_gui
