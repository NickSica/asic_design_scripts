source ../set_env.tcl

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
	create_workspace -technology $pdk_dir/TSMCHOME/6x1z1u_icc_icc2_tech_files/PRTF_ICC_65nm_001_Syn_V24a/PR_tech/Synopsys/TechFile/VHV/PRTF_ICC_N65_9M_6X1Z1U_RDL.24a.tf ${pdk}_workspace
	read_db $link_library 
	read_lef /home/tech/TSMC65/TSMCHOME/digital/Back_End/lef/tcbn65gplus_200a/lef/tcbn65gplus_9lmT2.lef
	read_gds /home/tech/TSMC65/TSMCHOME/digital/Back_End/gds/tcbn65gplus_140a/tcbn65gplus.gds
	process_workspaces -force -output ${pdk}.ndm
}

