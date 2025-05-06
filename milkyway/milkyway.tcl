#set lib_name NanGate45
#set techlef ~/NanGate45-Synopsys-Enablement/NanGate45/NangateOpenCellLibrary.tech.lef
#set techfile ~/NanGate45-Synopsys-Enablement/NanGate45/tf/NangateOpenCellLibrary.tf
#set tluplus ~/NanGate45-Synopsys-Enablement/NanGate45/tlup/NangateOpenCellLibrary.tlup
#set lef_folder ~/NanGate45-Synopsys-Enablement/NanGate45/lef

set lib_name asap7

set pdk_dir /home/tech/asap7/asap7_snps-main
set tluplus $pdk_dir/starrc/asap07.tluplus
set techfile $pdk_dir/icc/asap07_icc.tf

set pdk_dir /home/tech/asap7/asap7sc7p5t_28
set techlef $pdk_dir/techlef_misc/asap7_tech_1x_201209.lef 
set lef_folder $pdk_dir/LEF
set gds_folder $pdk_dir/GDS

#create_mw_lib -technology $techfile -open $lib_name
#replace_tlu_plus_file $tluplus 

#set lef_files [glob $lef_folder/*.lef]
set lef_files [glob $lef_folder/asap7sc7p5t_28_R_220121a.lef]
foreach lef_file $lef_files {
    set base [file rootname [file tail $lef_file]]
    create_mw_lib -technology $techfile -open $lib_name/$base
    replace_tlu_plus_file $tluplus 

    #read_lef -tech_lef_files $techlef -cell_lef_files $lef_file 
    read_lef -cell_lef_files $lef_file 
    #close_mw_lib -save
}

#set gds_files [glob $gds_folder/*.gds]
set gds_files [glob $gds_folder/asap7sc7p5t_28_R_220121a.gds]
foreach gds_file $gds_files {
    #set base [file rootname [file tail $gds_file]]
    #create_mw_lib -technology $techfile -open $lib_name/$base
    #replace_tlu_plus_file $tluplus 

    read_gds -layer_mapping /home/tech/asap7/asap7_snps-main/icc/asap07_layer.txt -cell_type /home/tech/asap7/asap7_snps-main/icc/asap07.GDS2A $gds_file 
    #close_mw_lib -save

}

set base [file rootname [file tail $lef_folder/asap7sc7p5t_28_R_220121a.lef]]
flatten_cell -library $lib_name/$base
# I guess do this manually? It doesn't exist
#extract_blockage_pin_via
auExtractBlockagePinVia
setFormField extract_blockage library_name $lib_name/$base
setToggleField extract_blockage generate_boundary left 1
setToggleField extract_blockage generate_boundary right 1
setToggleField extract_blockage generate_boundary top 1
setToggleField extract_blockage generate_boundary bottom 1
formOK extract_blockage

auSetPRBdry
setFormField set_pr_boundary library_name $lib_name/$base
setFormField set_pr_boundary width auto
setFormField set_pr_boundary left_boundary specify 
setFormField set_pr_boundary left_from "BPV Via Solutions" 
setFormField set_pr_boundary height auto
setFormField set_pr_boundary adjacent_rows "shared P/G (double-back)" 
setFormField set_pr_boundary multiple_(2x,_3x) "all cells are single-height" 
formOK set_pr_boundary

#cmSetMultiHeightProperty
#setFormField set_multiple_height_pr_boundary library_name $lib_name/$base
#formOK set_multiple_height_pr_boundary

close_mw_lib -save
exit

#read_lef -tech_lef_files $techlef -cell_lef_files [glob $lef_folder/*.lef]
