###### Fusion Compiler Script ###### 
set_app_var sh_continue_on_error false
set_app_options -name file.verilog.keep_unconnected_nets -value false
source -echo ../set_env.tcl
set is_fc 1
set ref_libs $icc2_lib
set lib_name $top
if { ![file exists ${lib_name}.dlib] } {
    create_lib -ref_libs $ref_libs -technology $techfile ${lib_name}.dlib 
}
open_lib ${lib_name}.dlib 
#create_block $top -dimensions {100 100}
#link_block
#

#set ::block OneRing_6GHz
#set ::num_segs 16
#set ::tap_locs {2 3 4}
#set ::pre_segs 3
#set ::post_segs 4
#source rtwo.tcl

#set ::block OneRing_24GHz
#set ::block gen_ring
#set ::num_segs 4
#set ::pre_segs 0
#set ::post_segs 2
#source rtwo.tcl
#set ref_libs [ list $root_dir/lc_shell/rtwo_cells $pdk_dir/TSMCHOME/digital/Back_End/milkyway/tsmc65nm.ndm $root_dir/fc_shell/RTWO_Blocks.dlib ]

open_lib ${lib_name}.dlib 
set ref_libs $icc2_lib
set_ref_libs -clear
set_ref_libs -ref_libs $ref_libs

lappend search_path ${incl_dirs}
set const_dir    ${pdk}/const/${top}
set reports_dir  ${pdk}/reports/${top}
set output_dir   ${pdk}/output/${top}
set const_dir    ${pdk}/const/${top}
set work_dir     ${pdk}/HDL_WORK/${top}
set snapshot_dir ${pdk}/snapshot/${top} 
set lib_dir      ${pdk}/lib 

###### DC Synth Start #######
define_hdl_library HDL_WORK -path $work_dir

analyze -hdl_library HDL_WORK -autoread -recursive -top $top $src_dirs
elaborate -hdl_library HDL_WORK $top

#create_site_def -name unit -width 0.2 -height 1.8  
#create_site_def -name gaunit -width 0.8 -height 1.8  
# TODO: FIXME?
#rename_module [current_design] $top
#rename_design [current_design] $top
#current_design $top
set_top_module $top

#link

# TODO: FIXME?
#check_design

file mkdir $reports_dir
file mkdir $output_dir
file mkdir $const_dir
file mkdir $snapshot_dir
file mkdir $lib_dir

set is_clk 1 

if { $is_clk == 1 } {
    #set clk clk_i
    
    create_clock $clk -name ideal_clock1 -period 5
    set_clock_latency 0.4 $clk -clock ideal_clock1
    set_clock_transition 0.1 ideal_clock1
    
    set_input_delay 0.4 [ remove_from_collection [all_inputs] $clk ] -clock ideal_clock1 
    set_output_delay 0.4 [ all_outputs ] -clock ideal_clock1
    set_clock_uncertainty 0.05 ideal_clock1
}

#set design_ports [ get_ports * ]
#set no_connect_port ""
#set one_connect_port ""
#foreach_in_collection port $design_ports {
#    if { [get_object_name $port] == "clk_i" } {
#        continue
#    }
#    set connected_net [get_nets [all_connected $port]]
#    if { [sizeof_collection $connected_net] == 0 } {
#        lappend no_connect_port [get_object_name $port]
#    } else {
#        set connect_point [all_connected $connected_net]
#        if { [sizeof_collection $connect_point] == 1 } {
#            lappend one_connect_port [get_object_name $port]
#        }
#    }
#}
#
#if { [llength $no_connect_port] != 0 } {
#    echo "The following ports are connected to nothing --> $no_connect_port\n"
#    remove_port $no_connect_port
#}
#
#if { [llength $one_connect_port] != 0 } {
#    echo "The following ports are connected to a net going nowhere --> $one_connect_port\n"
#    remove_port $one_connect_port
#}

# Not a thing in FC
#set_max_area 0
set_load 0.3 [ all_outputs ]

#create_power_domain pd
#create_supply_net VDD
#connect_supply_net VDD -ports VDD
#set_voltage 1 -object_list VDD

# TODO: FIXME?   
#check_design > $reports_dir/synth_check_design.rpt
check_timing > $reports_dir/synth_check_timing.rpt

uniquify > $reports_dir/synth_uniquify.rpt

read_parasitic_tech -tlup $tlupmin -layermap $tech2itf -name tlup_min
read_parasitic_tech -tlup $tlupmax -layermap $tech2itf -name tlup_max
set_parasitic_parameters -early_spec tlup_min -late_spec tlup_max

#&& pin_direction!=output
#set ports [get_ports -hierarchical -filter \
#    { is_hierarchical==false && pin_direction!=internal}]                                
#set floating_ports [remove_from_collection $ports \                                      
#    [get_ports -leaf -of [get_nets -top_net_of_hierarchical_group -segments -of $ports]]]

compile_fusion -check_only
compile_fusion -from initial_map -to logic_opto

report_area > $reports_dir/synth_area.rpt
report_power > $reports_dir/synth_power.rpt
report_qor > $reports_dir/synth_qor.rpt
report_cell > $reports_dir/synth_cells.rpt
report_resource > $reports_dir/synth_resources.rpt
report_timing > $reports_dir/timing_overview.rpt

## Analysis reports

# TODO: FIXME?
#report_timing -from [all_inputs] -max_paths 20 -to [all_registers -data_pins] > $reports_dir/timing.rpt
#report_timing -from [all_register -clock_pins] -max_paths 20 -to [all_registers -data_pins]  >> $reports_dir/timing.rpt
#report_timing -from [all_registers -clock_pins] -max_paths 20 -to [all_outputs] >> $reports_dir/timing.rpt
#report_timing -from [all_inputs] -to [all_outputs] -max_paths 20 >> $reports_dir/timing.rpt
#report_timing -from [all_registers -clock_pins] -to [all_registers -data_pins] -delay_type max  >> $reports_dir/timing.rpt
#report_timing -from [all_registers -clock_pins] -to [all_registers -data_pins] -delay_type min  >> $reports_dir/timing.rpt
#
#report_timing -transition_time -capacitance -nets -input_pins -from [all_registers -clock_pins] -to [all_registers -data_pins]  > $reports_dir/timing.tran.cap.rpt

#change_names -rules verilog

write_verilog -hier design $output_dir/$top.v

###### Doesn't exist?
#write_ddc -hier design -output $output_dir/$top.ddc

write_sdc -output $const_dir/$top.sdc

###### DC Synth End #######

#start_gui

### Need to set due to the RTWOs being macros
set_early_data_check_policy -policy strict
set_early_data_check_policy -checks hier.block.instance_with_design_type_macro -policy tolerate
set_early_data_check_policy -checks place.coarse.unfixed_macros -policy lenient
set_early_data_check_policy -checks place.coarse.incomplete_timing_data -policy lenient

source -echo $root_dir/icc2_pnr/icc_pnr.tcl
