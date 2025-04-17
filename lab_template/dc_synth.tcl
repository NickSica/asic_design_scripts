
###### DC Synthesis Script #######

## Give the path to the verilog files and define the WORK directory

lappend search_path ./src/
define_design_lib WORK -path "work"

## Define the library location
set link_library [ list /mnt/class_data/ecec574-w2019/PDKs/SAED32nm/lib/stdcell_rvt/db_ccs/saed32rvt_ss0p95v125c.db /mnt/class_data/ecec574-w2019/PDKs/SAED32nm/lib/stdcell_rvt/db_ccs/saed32rvt_ss0p95v25c.db /mnt/class_data/ecec574-w2019/PDKs/SAED32nm/lib/stdcell_rvt/db_ccs/saed32rvt_ss0p95vn40c.db]

set target_library [ list /mnt/class_data/ecec574-w2019/PDKs/SAED32nm/lib/stdcell_rvt/db_ccs/saed32rvt_ss0p95v25c.db ]

## read the verilog files
#analyze -library WORK -format verilog [list dff.v s386.v]
analyze -library WORK -format verilog s386.v

elaborate   -architecture verilog -library WORK s386

## Check if design is consistent
check_design  > reports/synth_check_design.rpt

## Create Constraints 
create_clock CK -name ideal_clock1 -period 5
set_input_delay 2.0 [ remove_from_collection [all_inputs] CK ] -clock ideal_clock1
set_output_delay 2.0 [all_outputs ] -clock ideal_clock1
set_max_area 0 
set_load 0.3 [ all_outputs ]


## Compilation 
## you can change medium to either low or high 
compile -area_effort medium -map_effort medium


## Below commands report area , cell, qor, resources, and timing information needed to analyze the design. 

  report_area > reports/synth_area.rpt
  report_cell > reports/synth_cells.rpt
  report_qor  > reports/synth_qor.rpt
  report_resources > reports/synth_resources.rpt
  report_timing -max_paths 10 > reports/synth_timing.rpt

## Dump out the constraints in an SDC file

  write_sdc  const/dff.sdc

## Dump out the synthesized database and gate-level-netlist
  write -f ddc -hierarchy -output output/dff.ddc

  write -hierarchy -format verilog -output  output/dff.v

