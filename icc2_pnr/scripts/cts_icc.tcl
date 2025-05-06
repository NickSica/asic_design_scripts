###########################################################################
### Clock Tree Synthesis
###########################################################################

if {$is_fc == 1} {
    set_early_data_check_policy -policy lenient -checks cts.constraint.ao_libcells
    set_clock_routing_rules -clocks ideal_clock1 -default_rule -min_routing_layer M3 -max_routing_layer M6
}

set_app_options -name route.common.number_of_secondary_pg_pin_connections -value 2
set_app_options -name route.common.separate_tie_off_from_secondary_pg     -value true

#if {[get_routing_rules -quiet VDDwide] != ""} {remove_routing_rules VDDwide }
#create_routing_rule VDDwide -widths {M1 0.1 M2 0.1 M3 0.1} -taper_distance 0.2
#set_routing_rule -rule VDDwide -min_routing_layer M2 -min_layer_mode allow_pin_connection -max_routing_layer M3 [get_nets VDD]
#
set_routing_rule -min_routing_layer M2 -min_layer_mode allow_pin_connection -max_routing_layer M3 [get_nets VDD]
set_routing_rule -min_routing_layer M2 -min_layer_mode allow_pin_connection -max_routing_layer M3 [get_nets VSS]
route_group -nets {VDD VSS}

##In the Layout window, click on "Clock ", you will see various options, you can set any of the options to run CTS. If you click on Clock ' Core CTS and Optimization
clock_opt

##Save the Cell and report timing

save_block -as ${lib_name}_cts
#report_placement_utilization > reports/${lib_name}_cts_util.rpt NOT A COMMAND
#report_qor_snapshot > reports/${lib_name}_cts_qor_snapshot.rpt DOESNT WORK
report_qor > $reports_dir/${lib_name}_cts_qor.rpt
report_timing -max_paths 20 -delay max > $reports_dir/${lib_name}_cts.setup.rpt
report_timing -max_paths 20 -delay min > $reports_dir/${lib_name}_cts.hold.rpt

