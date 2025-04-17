#set designs {s1238 s15850 s35932 s386 s9234}
if { [info exists ::env(TOP)] } {
	set top $::env(TOP) 
} else {
	set top RTWO_kings
}

if { [info exists ::env(SRC_DIRS)] } {
    set src_dirs $::env(SRC_DIRS)
} else {
	set src_dirs ""
}

if { [info exists ::env(SDC_DIRS)] } {
    set sdc_dirs $::env(SDC_DIRS)
} else {
	set sdc_dirs ""
}

if { [info exists ::env(PKG_DIRS)] } {
    set pkg_files [glob "$::env(INCL_DIRS)/*_pkg.sv"]
} else {
	set pkg_files ""
}

if { [info exists ::env(INCL_DIRS)] } {
    set incl_dirs $::env(INCL_DIRS)
} else {
    set incl_dirs ""
}

if { [info exists ::env(INCL_LIBS)] } {
    set incl_libs $::env(INCL_LIBS)
} else {
    set incl_libs ""
}

if { [info exists ::env(CLK)] } {
	set clk $::env(CLK) 
} else {
	set clk clk_i
}

if { ![info exists is_cc] } {
    set app_name [get_app_var synopsys_program_name]
}
set svlog_files [glob -nocomplain $src_dirs/*.sv]
set vlog_files  [glob -nocomplain $src_dirs/*.v]
set vhdl_files  [glob -nocomplain $src_dirs/*.vhd]
set sdc_files   [glob -nocomplain $sdc_dirs/*.sdc]

if {[info exists root_dir] == 0} {
    set root_dir [file dirname [info script]]
}
set pdk saed32nm

set power_net VDD
set ground_net VSS

#set_app_var command_log_file ./logs/command.log
#set_app_var view_command_log_file ./logs/view_command.log
#set_app_var sh_command_log_file ./logs/command.log
#set_app_var sh_output_log_file ./logs/output.log

## Define the library location
if { $pdk == "saed14nm" } {
	set pdk_dir /home/tech/SAED14nm
	set link_library [ list * \
		$pdk_dir/stdcell_rvt/db_ccs/saed14rvt_ss0p72v125c.db \
		$pdk_dir/stdcell_rvt/db_ccs/saed14rvt_ss0p72v25c.db \
		$pdk_dir/stdcell_rvt/db_ccs/saed14rvt_ss0p72vm40c.db \
	]
	
	set target_library [ list \
		$pdk_dir/stdcell_rvt/db_ccs/saed14rvt_ss0p72v25c.db \
	]

    set libdir "$pdk_dir/tech/star_rc"
	set tlupmax "$libdir/max/saed14nm_1p9m_Cmax.tluplus"
	set tlupnom "$libdir/nominal/saed14nm_1p9m_nominal.tluplus"
	set tlupmin "$libdir/min/saed14nm_1p9m_Cmin.tluplus"
	set tech2itf "$libdir/saed14nm_tf_itf_tluplus.map"
	
	set techfile "$pdk_dir/tech/milkyway/saed14nm_1p9m_mw.tf"
	set icc_lib "$pdk_dir/stdcell_rvt/milkyway/saed14nm_rvt_1p9m"
	set icc2_lib "$pdk_dir/stdcell_rvt/ndm/saed14rvt_frame_timing_ccs.ndm"
} elseif { $pdk == "saed32nm" } {
	set pdk_dir /home/tech/SAED32nm
    set search_path "$search_path $pdk_dir/lib/stdcell_rvt/db_ccs"
    set target_library "saed32rvt_ss0p95v25c.db"
    set link_library "* $target_library"
	#set link_library [ list * \
	#	$pdk_dir/lib/stdcell_rvt/db_ccs/saed32rvt_ss0p95v125c.db \
	#	$pdk_dir/lib/stdcell_rvt/db_ccs/saed32rvt_ss0p95v25c.db \
	#	$pdk_dir/lib/stdcell_rvt/db_ccs/saed32rvt_ss0p95vn40c.db \
	#]
	#
	#set target_library [ list \
	#	$pdk_dir/lib/stdcell_rvt/db_ccs/saed32rvt_ss0p95v25c.db \
	#]

    set libdir "$pdk_dir/tech/star_rcxt"
	set tlupmax "$libdir/saed32nm_1p9m_Cmax.tluplus"
	set tlupnom "$libdir/saed32nm_1p9m_nominal.tluplus"
	set tlupmin "$libdir/saed32nm_1p9m_Cmin.tluplus"
	set tech2itf "$libdir/saed32nm_tf_itf_tluplus.map"
	
	set icc_techfile "$pdk_dir/tech/milkyway/saed32nm_1p9m_mw.tf"
	set icc2_techfile "$pdk_dir/lib/stdcell_rvt/ndm/tf/saed32nm_1p9m_mw.tf"
	#set ref_lib "$pdk_dir/lib/stdcell_rvt/ndm/saed32rvt_frame_only.ndm"
	set icc_lib "$pdk_dir/lib/stdcell_rvt/milkyway/saed32nm_rvt_1p9m"
	set icc2_lib "$pdk_dir/lib/stdcell_rvt/ndm/saed32rvt_frame_timing_ccs.ndm"
} elseif { $pdk == "saed90nm" } {
	set pdk_dir /home/tech/SAED90nm_lib/SAED_EDK90nm
	set link_library [ list * \
		$pdk_dir/Digital_Standard_cell_Library/synopsys/models/saed90nm_max.db \
		$pdk_dir/Digital_Standard_cell_Library/synopsys/models/saed90nm_typ.db \
		$pdk_dir/Digital_Standard_cell_Library/synopsys/models/saed90nm_min.db \
	]
	
	set target_library [ list \
		$pdk_dir/Digital_Standard_cell_Library/synopsys/models/saed90nm_typ.db \
	]

    set libdir "$pdk_dir/Technology_Kit/process/star_rcxt"
	set tlupmax "$libdir/tluplus/saed90nm_1p9m_1t_Cmax.tluplus"
	set tlupnom "$libdir/tluplus/saed90nm_1p9m_1t_nominal.tluplus"
	set tlupmin "$libdir/tluplus/saed90nm_1p9m_1t_Cmin.tluplus"
	set tech2itf "$libdir/saed90nm.map"

	set techfile $pdk_dir/Technology_Kit/techfile/saed90nm_1p9m.tf
	set icc_lib $pdk_dir/Digital_Standard_Cell_Library/synopsys/plib/
} elseif { $pdk == "tsmc65nm" } {
    set vdd_voltage 1
    set gnd_voltage 0
    set vdd_port VDD
    set gnd_port VSS

	set pdk_dir /home/tech/TSMC65GP
	set db_dir $pdk_dir/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn65gplus_200a
	set link_library [ list * \
		$db_dir/tcbn65gplustc_ccs.db \
		$db_dir/tcbn65gpluswc_ccs.db \
		$db_dir/tcbn65gplusbc_ccs.db \
	]

	set target_library [ list \
		$db_dir/tcbn65gplustc_ccs.db \
	]

    set libdir "$pdk_dir/TSMCHOME/6x1z1u_icc_files/RC_TLUplus_crn65lp_1p9m_6x1z1u_alrdl_5corners_1.0a"
	set tlupnom "$libdir/RC_TLUplus_crn65lp_1p09m+alrdl_6x1z1u_typical/crn65lp_1p09m+alrdl_6x1z1u_typical.tluplus"
	set tlupmin "$libdir/RC_TLUplus_crn65lp_1p09m+alrdl_6x1z1u_cworst/crn65lp_1p09m+alrdl_6x1z1u_cworst.tluplus"
	set tlupmax "$libdir/RC_TLUplus_crn65lp_1p09m+alrdl_6x1z1u_cbest/crn65lp_1p09m+alrdl_6x1z1u_cbest.tluplus"
	set tech2itf "$pdk_dir/TSMCHOME/digital/Back_End/milkyway/tcbn65gplus_200a/techfiles/tluplus/star.map_9M"

    set layermap "$pdk_dir/TSMCHOME/6x1z1u_icc_icc2_tech_files/PRTF_ICC_65nm_001_Syn_V24a/PR_tech/Synopsys/GdsOutMap/PRTF_ICC_N65_gdsout_6X1Z1U.24a.map"
	set techfile $pdk_dir/TSMCHOME/6x1z1u_icc_icc2_tech_files/PRTF_ICC_65nm_001_Syn_V24a/PR_tech/Synopsys/TechFile/VHV/PRTF_ICC_N65_9M_6X1Z1U_RDL.24a.tf
	#set ref_lib ../lc_shell/tsmc65nm.ndm
	set icc_lib $pdk_dir/TSMCHOME/digital/Back_End/milkyway/tcbn65gplus_200a/cell_frame/tcbn65gplus
	set icc2_lib $pdk_dir/TSMCHOME/digital/Back_End/milkyway/tsmc65nm.ndm
	#set icc2_lib [list [file join $root_dir lm_shell/tsmc65nm.ndm] $incl_libs]
	#set icc2_lib [list [file join $root_dir lm_shell/tsmc65nm.ndm] ]
    #set cdsDefTechLib $CDSHOME/tools/dfII/etc/cdsDefTechLib
    #set basicLib $CDSHOME/tools/dfII/etc/cdslib/basic
    #set analogLib $CDSHOME/tools/dfII/etc/cdslib/artist/analogLib
    set tsmcN65 $pdk_dir/tsmcN65
    set TSMC65_RotaryCircuits $root_dir/TSMC65_RotaryCircuits
    set tcbn65gplus $root_dir/tcbn65gplus
    set TSMC65_HFSS_Interconnects $root_dir/TSMC65_HFSS_Interconnects
} elseif { $pdk == "tsmc28nm" } {
    set vdd_voltage 0.9
    set gnd_voltage 0
    set vdd_port VDD
    set gnd_port VSS

	set pdk_dir /home/tech/TSMC28
	set db_dir $pdk_dir/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn28hpcplusbwp30p140_180a
    set mem_dir $pdk_dir/TSMCHOME/sram/Compiler/tsn28hpcpd127spsram_20120200_180a/tsn28hpcpd127spsram_20120200_180a
	set link_library [ list \
		$db_dir/tcbn28hpcplusbwp30p140tt0p9v25c_ccs.db \
		$db_dir/tcbn28hpcplusbwp30p140ssg0p9v0c_ccs.db \
		$db_dir/tcbn28hpcplusbwp30p140ffg0p99v0c_ccs.db \
	]
        #$mem_dir/ts1n28hpcphvtb256x78m4s_tt0p9v25c.db \
    

	set target_library [ list \
		$db_dir/tcbn28hpcplusbwp30p140tt0p9v25c_ccs.db \
	]

    set libdir "$pdk_dir/APR_Tech/Synopsys/RC_TLUplus_crn28hpc+_1p9m_6x1z1u_ut-alrdl_9corners_1.3p1a"
	set tlupnom "$libdir/RC_TLUplus_crn28hpc+_1p09m+ut-alrdl_6x1z1u_typical/crn28hpc+_1p09m+ut-alrdl_6x1z1u_typical.tluplus"
	set tlupmin "$libdir/RC_TLUplus_crn28hpc+_1p09m+ut-alrdl_6x1z1u_rcworst/crn28hpc+_1p09m+ut-alrdl_6x1z1u_rcworst.tluplus"
	set tlupmax "$libdir/RC_TLUplus_crn28hpc+_1p09m+ut-alrdl_6x1z1u_rcbest/crn28hpc+_1p09m+ut-alrdl_6x1z1u_rcbest.tluplus"
	set tech2itf "$pdk_dir/PDK/TSMC_iPDK/CCI/CCI_decks/starrcxt_mapping"


    set layermap "$pdk_dir/APR_Tech/Synopsys/tn28clpr002s1_1_9_1a/PRTF_ICC_28nm_Syn_V19_1a/PR_tech/Synopsys/GdsOutMap/gdsout_6X1Z1U.map"
	set techfile "$pdk_dir/APR_Tech/Synopsys/tn28clpr002s1_1_9_1a/PRTF_ICC_28nm_Syn_V19_1a/tsmcn28_9lm6X1Z1UUTRDL.tf"
	set icc_lib $pdk_dir/TSMCHOME/digital/Back_End/milkyway/tcbn28hpcplusbwp30p140_110a/cell_frame_VHV_0d5_0/tcbn28hpcplusbwp30p140
    #set icc2_lib ../icc_pnr/icc2_frame/ndm/ibex_top.mw_frame_only.ndm
    set ndm_dir [file join $pdk_dir/TSMCHOME/digital/Back_End/milkyway/tsmc28/ndm ]
	set icc2_lib [glob $ndm_dir/*.ndm]
	#set icc2_lib [list $ndm $mem_dir/ts1n28hpcphvtb256x78m4s_c.ndm]
}
