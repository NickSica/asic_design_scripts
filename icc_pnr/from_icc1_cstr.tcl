
##################################################################

# Created by write_script -format icc2 on Wed Feb 22 13:44:37 2023

##################################################################

##################################################################
# Set application variables for app 
##################################################################
set_app_var search_path "$search_path .                                        \
/home/tools/synopsys/icc/T-2022.03-SP4/libraries/syn                           \
/home/tools/synopsys/icc/T-2022.03-SP4/dw/syn_ver                              \
/home/tools/synopsys/icc/T-2022.03-SP4/dw/sim_ver "

##################################################################
# Set application variables for design 
##################################################################
set_app_options -name design.bus_delimiters -value {[]}

##################################################################
# Set application variables for mv 
##################################################################
set_app_options -name mv.cells.no_main_power_violations -value true 

##################################################################
# Set application variables for power 
##################################################################
set_app_options -name power.default_static_probability -value 0.5 
set_app_options -name power.default_toggle_rate -value 0.1 
set_app_options -name power.default_toggle_rate_reference_clock -value fastest
set_app_options -name mv.upf.enable_golden_upf -value false 

##################################################################
# Set application variables for time 
##################################################################
set_app_options -name time.enable_clock_to_data_analysis -value false 
set_app_options -name time.high_fanout_net_pin_capacitance -value 1.000000pF
set_app_options -name time.high_fanout_net_threshold -value 1000 
set_app_options -name time.use_special_default_path_groups -value false 
set_app_options -name time.remove_clock_reconvergence_pessimism -value false 
set_app_options -name time.gclock_source_network_num_master_registers -value   \
10000000 
set_app_options -name time.disable_cond_default_arcs -value false 
set_app_options -name time.crpr_remove_clock_to_data_crp -value false 
set_app_options -name time.clock_reconvergence_pessimism -value normal 
set_app_options -name time.case_analysis_sequential_propagation -value never 

##################################################################
# Commands 
##################################################################
current_design FIFO

##################################################################
# Set attributes 
##################################################################

##################################################################
# Commands 
##################################################################

current_design FIFO

##################################################################
