source ../set_env.tcl

set new_lib rtwo_cells

if { $pdk == "tsmc65nm" } {
    set ref_path $pdk_dir/TSMCHOME/digital/Back_End/milkyway/tsmc65nm.ndm
    set layermap "$pdk_dir/TSMCHOME/6x1z1u_icc_icc2_tech_files/PRTF_ICC_65nm_001_Syn_V24a/PR_tech/Synopsys/GdsOutMap/PRTF_ICC_N65_gdsout_6X1Z1U.24a.map"
} elseif { $pdk == "tsmc28nm" } {
    set ndm_dir [file join $pdk_dir/TSMCHOME/digital/Back_End/milkyway/tsmc28/ndm ]
    set ref_path [glob $ndm_dir/*.ndm]
    #set techfile "$pdk_dir/APR Tech/Synopsys/tn28clpr002s1_1_5a/N28_PRTF_Syn_v1d5a/PR_tech/Synopsys/TechFile/VHV/tsmcn28_9lm6X1Z1UUTRDL.tf"

} elseif { $pdk == "tsmc28nm" } {
	create_workspace -technology $techfile ${pdk}_workspace
	read_db $link_library 
	read_lef ../icc_pnr/test.lef
	#read_lef $pdk_dir/TSMCHOME/digital/Back_End/lef/tcbn28hpcplusbwp30p140_110a/lef/tcbn28hpcplusbwp30p140.lef
	#read_gds /home/sica/TSMC28/std_cells.gds
	#read_gds $pdk_dir/TSMCHOME/digital/Back_End/gds/tcbn28hpcplusbwp30p140_110a/tcbn28hpcplusbwp30p140.gds
	process_workspaces -force -output ${pdk}.ndm
}

create_workspace -flow physical_only -technology $techfile ${new_lib}_${pdk}_workspace
set_ref_libs -ref_libs $ref_path 

set_app_options -name file.oasis.port_type_map -value {{power ${power_net}} {ground ${ground_net}}}
set_app_options -name file.oasis.text_layer_map -value {"M1 TEXT1"}
set_app_options -name file.gds.port_type_map -value {{power ${power_net}} {ground ${ground_net}}}
set_app_options -name file.gds.text_layer_map -value {"M1 TEXT1"}


#### Core SITE definition- height of 1.8, width of 0.2
#read_oasis -layer_map_format icc_default -library $new_lib -layer_map $layermap $root_dir/src/OneRing_24GHz.oasis
#read_oasis -layer_map_format icc_default -library $new_lib -layer_map $layermap $root_dir/src/OneRing_6GHz.oasis
#read_oasis -layer_map_format icc_default -library $new_lib -layer_map $layermap $root_dir/src/nch.oasis
#read_oasis -layer_map_format icc_default -library $new_lib -layer_map $layermap $root_dir/src/pass.oasis

read_gds -layer_map_format icc_default -library $new_lib -layer_map $layermap $root_dir/src/nch_cust.gds
read_gds -layer_map_format icc_default -library $new_lib -layer_map $layermap $root_dir/src/pass_cust.gds

read_oasis -top_design_type macro -layer_map_format icc_default -library $new_lib \
    -layer_map $layermap $root_dir/src/Bend90_35um_TR.oasis
read_oasis -top_design_type macro -layer_map_format icc_default -library $new_lib \
    -layer_map $layermap $root_dir/src/Bend90_35um_BR.oasis
read_oasis -top_design_type macro -layer_map_format icc_default -library $new_lib \
    -layer_map $layermap $root_dir/src/Bend90_35um_BL.oasis
read_oasis -top_design_type macro -layer_map_format icc_default -library $new_lib \
    -layer_map $layermap $root_dir/src/Crossover_35um.oasis
read_oasis -top_design_type macro -layer_map_format icc_default -library $new_lib \
    -layer_map $layermap $root_dir/src/Seg25um_Horiz.oasis
read_oasis -top_design_type macro -layer_map_format icc_default -library $new_lib \
    -layer_map $layermap $root_dir/src/Seg25um_Vert.oasis
read_oasis -top_design_type macro -layer_map_format icc_default -library $new_lib \
    -layer_map $layermap $root_dir/src/InverterPair_Horiz.oasis
read_oasis -top_design_type macro -layer_map_format icc_default -library $new_lib \
    -layer_map $layermap $root_dir/src/InverterPair_Vert.oasis
read_oasis -top_design_type macro -layer_map_format icc_default -library $new_lib \
    -layer_map $layermap $root_dir/src/stacked_INVD8.oasis

read_lef -library $new_lib -merge_action update $root_dir/src/bend_crossover.lef
read_lef -library $new_lib -merge_action update $root_dir/src/straight.lef
read_lef -library $new_lib -merge_action update $root_dir/src/nch_cust.lef
read_lef -library $new_lib -merge_action update $root_dir/src/pass_cust.lef
read_lef -library $new_lib -merge_action update $root_dir/src/InverterPair.lef
read_lef -library $new_lib -merge_action update $root_dir/src/stacked_INVD8.lef

#read_gds -top_design_type macro -layer_map_format icc_default \
#         -library $new_lib -layer_map $layermap $root_dir/src/OneRing_24GHz.gds
#read_gds -top_design_type macro -layer_map_format icc_default \
#         -library $new_lib -layer_map $layermap $root_dir/src/OneRing_6GHz.gds
#read_lef -library $new_lib -merge_action update $root_dir/src/OneRing_24GHz.lef
#read_lef -library $new_lib -merge_action update $root_dir/src/OneRing_6GHz.lef
#current_block rtwo_cells:OneRing_24GHz.design
##set_app_options -name lib.physical_model.derive_pattern_must_join -value true
##set_app_options -name lib.physical_model.include_routing_pg_ports -value {VDD VSS}
#set_attribute -objects [get_port VDD] -name port_type -value power
#set_attribute -objects [get_port VSS] -name port_type -value ground
##set_attribute -objects [get_terminals -of_objects {VDD}] -name must_join_group -value vdd_group
##set_attribute -objects [get_terminals -of_objects {VSS}] -name must_join_group -value vss_group
#current_block rtwo_cells:OneRing_6GHz.design
##set_app_options -name lib.physical_model.derive_pattern_must_join -value true
##set_app_options -name lib.physical_model.include_routing_pg_ports -value {VDD VSS}
#set_attribute -objects [get_port VDD] -name port_type -value power
#set_attribute -objects [get_port VSS] -name port_type -value ground
##set_attribute -objects [get_terminals -of_objects {VDD}] -name must_join_group -value vdd_group
##set_attribute -objects [get_terminals -of_objects {VSS}] -name must_join_group -value vss_group

current_block rtwo_cells:InverterPair_Horiz.design
set_attribute -objects [get_port VDD] -name port_type -value power
set_attribute -objects [get_port VSS] -name port_type -value ground
#create_net -power VDD
#create_port -direction inout -port_type power VDD
#connect_net -net VDD -port_name VDD [get_pins */VDD]
#create_net -power VSS
#create_port -direction inout -port_type ground VSS
#connect_net -net VSS -port_name VSS [get_pins */VSS]

current_block rtwo_cells:InverterPair_Vert.design
set_attribute -objects [get_port VDD] -name port_type -value power
set_attribute -objects [get_port VSS] -name port_type -value ground
#create_net -power VDD
#create_port -direction inout -port_type power VDD
#connect_net -net VDD -port_name VDD [get_pins */VDD]
#create_net -power VSS
#create_port -direction inout -port_type ground VSS
#connect_net -net VSS -port_name VSS [get_pins */VSS]

set write 1 
if {$write == 1} {
  process_workspaces -force -output ${new_lib}
  ##read_def $root_dir/src/*.def
} else {
  start_gui
}

create_workspace -flow edit ${new_lib}
set_attribute [get_lib_cells rtwo_cells/OneRing_24GHz/frame] design_type macro
set_attribute [get_lib_cells rtwo_cells/OneRing_6GHz/frame] design_type macro
set_attribute [get_lib_cells rtwo_cells/InverterPair_Horiz/frame] design_type macro
set_attribute [get_lib_cells rtwo_cells/InverterPair_Vert/frame] design_type macro
set_attribute [get_lib_cells rtwo_cells/Seg25um_Horiz/frame] design_type macro
set_attribute [get_lib_cells rtwo_cells/Seg25um_Vert/frame] design_type macro
set_attribute [get_lib_cells rtwo_cells/Bend90_35um_TR/frame] design_type macro
set_attribute [get_lib_cells rtwo_cells/Bend90_35um_BR/frame] design_type macro
set_attribute [get_lib_cells rtwo_cells/Bend90_35um_BL/frame] design_type macro
set_attribute [get_lib_cells rtwo_cells/Crossover_35um/frame] design_type macro
set_attribute [get_lib_cells rtwo_cells/nch_cust/frame] design_type macro
set_attribute [get_lib_cells rtwo_cells/pass_cust/frame] design_type macro

if {$write == 1} {
  process_workspaces -force -output ${new_lib}
  exit
}
