###### DC Synth Script #######
#
source -echo ../set_env.tcl

lappend search_path ${incl_dirs}
set const_dir     const/${top}
set reports_dir reports/${top}
set output_dir   output/${top}
set const_dir     const/${top}
set work_dir       work/${top}

## read the verilog files
define_design_lib WORK -path $work_dir
#analyze -library WORK -format verilog $mem_dir/ts1n28hpcphvtb256x78m4s_180a_tt0p9v25c.v
#analyze -library WORK -format sverilog ${pkg_files}
read_file -library WORK ../src/simple.v

link

check_design

file mkdir $reports_dir
file mkdir $output_dir
file mkdir $const_dir

set is_clk 0

if{is_clk == 1} {
    set clk clk_i
    
    create_clock $clk -name ideal_clock1 -period 0.1
    set_clock_latency 0.4 $clk -clock ideal_clock1
    set_clock_transition 0.1 ideal_clock1
    
    set_input_delay 0.4 [ remove_from_collection [all_inputs] $clk ] -clock ideal_clock1 
    set_output_delay 0.4 [ all_outputs ] -clock ideal_clock1
    set_clock_uncertainty 0.05 ideal_clock1
}

set_max_area 0
set_load 0.3 [ all_outputs ]

create_power_domain pd
create_supply_net VDD
create_supply_net VSS
set_voltage $vdd_voltage -object_list pd.primary.power 
set_voltage $gnd_voltage -object_list pd.primary.ground 
create_supply_port $vdd_port
create_supply_port $gnd_port
connect_supply_net $vdd_port -ports $vdd_port
connect_supply_net $gnd_port -ports $gnd_port
#connect_supply_net pd.primary.power  -ports $vdd_port
#connect_supply_net pd.primary.ground -ports $gnd_port
set_domain_supply_net -primary_power_net $vdd_port -primary_ground_net $gnd_port pd

#connect_supply_net VDD -ports VDD
#set_voltage 1 -object_list VDD
#connect_supply_net VSS -ports VSS
#set_voltage 0 -object_list VSS


check_design > $reports_dir/synth_check_design.rpt
check_timing > $reports_dir/synth_check_timing.rpt

uniquify > $reports_dir/synth_uniquify.rpt

compile_ultra

write -pg -hier -f verilog -output test_fifo.v

read_file -library WORK test_fifo.v

link

check_design

file mkdir $reports_dir
file mkdir $output_dir
file mkdir $const_dir

set is_clk 0

if{is_clk == 1} {
    set clk clk_i
    
    create_clock $clk -name ideal_clock1 -period 0.1
    set_clock_latency 0.4 $clk -clock ideal_clock1
    set_clock_transition 0.1 ideal_clock1
    
    set_input_delay 0.4 [ remove_from_collection [all_inputs] $clk ] -clock ideal_clock1 
    set_output_delay 0.4 [ all_outputs ] -clock ideal_clock1
    set_clock_uncertainty 0.05 ideal_clock1
}

set_max_area 0
set_load 0.3 [ all_outputs ]

create_power_domain pd
create_supply_net VDD
create_supply_net VSS
set_voltage $vdd_voltage -object_list pd.primary.power 
set_voltage $gnd_voltage -object_list pd.primary.ground 
create_supply_port $vdd_port
create_supply_port $gnd_port
connect_supply_net $vdd_port -ports $vdd_port
connect_supply_net $gnd_port -ports $gnd_port
#connect_supply_net pd.primary.power  -ports $vdd_port
#connect_supply_net pd.primary.ground -ports $gnd_port
set_domain_supply_net -primary_power_net $vdd_port -primary_ground_net $gnd_port pd

#connect_supply_net VDD -ports VDD
#set_voltage 1 -object_list VDD
#connect_supply_net VSS -ports VSS
#set_voltage 0 -object_list VSS


check_design > $reports_dir/synth_check_design.rpt
check_timing > $reports_dir/synth_check_timing.rpt

uniquify > $reports_dir/synth_uniquify.rpt

compile_ultra

write -pg -hier -f verilog -output test2_fifo.v

