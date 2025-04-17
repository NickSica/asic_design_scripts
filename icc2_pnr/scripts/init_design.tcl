if { $app_name == "icc2_shell" } {
    if { ![file exists ${lib_name}.dlib] } {
    	create_lib ${lib_name}.dlib \
    		-technology $techfile \
    		-ref_libs ${icc2_lib}
    }
    open_lib ${lib_name}.dlib
}

#set design_data ../dc_synth/output/fifo.ddc
set cell_name $top
#import_designs $design_data -format ddc -top $cell_name

set logic0_net $ground_net 
set logic1_net $power_net

if { $app_name == "icc2_shell" } {
    read_verilog -top $cell_name $vlog_files
    
    #uniquify_fp_mw_cel
    
    link_block
    
    read_sdc $sdc_files
    
    read_parasitic_tech -tlup $tlupnom -layermap $tech2itf -name tlup_nom
    set_parasitic_parameters -early_spec tlup_nom -late_spec tlup_nom
    # -corners { default } 
    
    save_block -as ${lib_name}_initial
}
