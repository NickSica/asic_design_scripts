source ../set_env.tcl

set_app_options -name lib.setting.milkyway_exec -value /home/tools/synopsys/mw/T-2022.03-SP4/bin/linux64/Milkyway
set_app_options -name lib.setting.icc_shell_exec -value /home/tools/synopsys/icc/T-2022.03-SP4/bin/icc_shell

if { $pdk == "saed32nm" } { 
	#create_workspace -flow exploration -technology /home/tech/SAED32nm/tech/milkyway/saed32nm_1p9m_mw.tf saed32nm_workspace
	#create_workspace -flow physical_only -technology /home/tech/SAED32nm/tech/milkyway/saed32nm_1p9m_mw.tf saed32nm_workspace
	#create_workspace -technology /home/tech/SAED32nm/tech/milkyway/saed32nm_1p9m_mw.tf saed32nm_workspace
	create_workspace -flow frame -technology /home/tech/SAED32nm/tech/milkyway/saed32nm_1p9m_mw.tf saed32nm_workspace
	#read_ndm /home/sica/asic_design_scripts/lc_shell/saed32nm_fusion/saed32nm_rvt_1p9m.ndm
	read_db { /home/tech/SAED32nm/lib/stdcell_rvt/db_ccs/saed32rvt_ss0p95v125c.db /home/tech/SAED32nm/lib/stdcell_rvt/db_ccs/saed32rvt_ss0p95v25c.db /home/tech/SAED32nm/lib/stdcell_rvt/db_ccs/saed32rvt_ss0p95vn40c.db }
	#read_ndm /home/sica/asic_design_scripts/lc_shell/saed32nm.ndm
	#read_lef /home/tech/TSMC65/TSMCHOME/digital/Back_End/lef/saed32nm_rvt_1p9m.lef -merge_action attribute_only
	#read_lef /home/tech/TSMC65/TSMCHOME/digital/Back_End/lef/saed32nm_rvt_1p9m.lef -merge_action attribute_only
	#read_gds -layer_map /home/tech/SAED32nm/tech/milkyway/saed32nm_1p9m_gdsout_mw.map /home/tech/SAED32nm/lib/stdcell_rvt/gds/saed32nm_rvt_oa.gds -layer_map_format icc_default -centerline_boundary
	#read_gds -layer_map /home/tech/SAED32nm/tech/milkyway/saed32nm_1p9m_gdsout_mw.map /home/tech/SAED32nm/lib/stdcell_rvt/gds/saed32nm_rvt_oa.gds 
	#derive_design_level_via_regions
	#derive_via_regions
	#set_pvt_configuration -clear_filter all -add -process_numbers {0.99} -voltages {0.95} -temperatures {-40 25 125}
	#group_libs
	#process_workspaces -force -output saed32nm.ndm

} elseif { $pdk == "tsmc65nm" } {
	create_workspace -technology $techfile ${pdk}_workspace
	read_db $link_library 
	read_lef $pdk_dir/TSMCHOME/digital/Back_End/lef/tcbn65gplus_200a/lef/tcbn65gplus_9lmT2.lef
	read_gds $pdk_dir/TSMCHOME/digital/Back_End/gds/tcbn65gplus_140a/tcbn65gplus.gds
	process_workspaces -force -output ${pdk}.ndm
} elseif { $pdk == "asap7" } {
    set lib asap7sc7p5t_28_R_220121a
	create_physical_lib -scale_factor 4000 -technology $techfile $lib 

    set_app_options -name file.gds.port_type_map -value {{power ${power_net}} {ground ${ground_net}}}

	#set lef_files [glob $pdk_dir/asap7sc7p5t_28/LEF/*.lef]
	#set gds_files [glob $pdk_dir/asap7sc7p5t_28/GDS/*.gds]
	set gds_files $pdk_dir/asap7sc7p5t_28/GDS/$lib.gds
    set lef_files $pdk_dir/asap7sc7p5t_28/LEF/$lib.lef
	#set db_files [glob $pdk_dir/asap7sc7p5t_28/DB/CCS/*.db]
	set db_files [glob ~/asap7_move/asap7sc7p5t_28/DB/CCS/*.db]
    set layermap $pdk_dir/asap7_snps-main/icc/asap07.GDS2A

	read_gds -merge_action update -library $lib -layer_map $layermap $gds_files
	read_lef -merge_action update -library $lib $lef_files
    #read_db $db_files
    start_gui
    ### Need the conversion for big routing blockages
    create_frame -convert_metal_blockage_to_zero_spacing {{M1 0 all}}
    write_physical_lib -force
    exit
 
	#create_workspace ${pdk}_workspace
    #set_app_options -name lib.workspace.keep_all_physical_cells -value true
    #read_ndm $lib.ndm
    ##set db_files [glob $pdk_dir/asap7sc7p5t_28/DB/CCS/*.db]
	#set db_files [glob ~/asap7_move/asap7sc7p5t_28/DB/CCS/*.db]
    ###set lib_files [glob libs/*RVT_TT_ccs_*.lib]
    ##set lib_files libs/asap7sc7p5t_RVT_TT_ccs_211120.lib
    ##read_lib $lib_files
    #read_db $db_files
	#process_workspaces -force -output ${lib}_frame_timing.ndm
} elseif { $pdk == "tsmc28nm" } {
	create_workspace -technology $techfile ${pdk}_workspace
	read_db $link_library 
	read_lef $pdk_dir/TSMCHOME/digital/Back_End/lef/tcbn28hpcplusbwp30p140_110a/lef/tcbn28hpcplusbwp30p140.lef
	read_gds $pdk_dir/TSMCHOME/digital/Back_End/gds/tcbn28hpcplusbwp30p140_110a/tcbn28hpcplusbwp30p140.gds
	process_workspaces -force -output ${pdk}.ndm

    # This leaves out site_name attributes which causes ICC2 to not find inverters or buffers
    #generate_frame_from_mw tsmc28 -mw_lib /home/tech/TSMC28/TSMCHOME/digital/Back_End/milkyway/tcbn28hpcplusbwp30p140_110a/cell_frame_VHV_0d5_0/tcbn28hpcplusbwp30p140
}
