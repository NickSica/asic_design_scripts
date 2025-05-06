###########################################################################
### Floorplanning
###########################################################################

# -left,bottom,right,top_io2core not supported
#initialize_floorplan
#initialize_floorplan -boundary { {0 0} {400 0} {400 400} {0 400} } -core_offset {10 10 10 10}
initialize_floorplan -core_offset {10 10 10 10} -core_utilization 0.7
#initialize_floorplan -boundary { {0 0} {50 0} {50 50} {0 50} }
#initialize_floorplan -core_utilization 0.60 -core_offset {10 10 10 10}
# too small -row_core_ratio 0.6

#create_grid {grid_1} -type block -x_step 0.005 -y_step 0.005 -x_offset 0.000 -y_offset 0.000
#create_grid {grid_1} -type block -x_step 0.2 -y_step 1.8 -x_offset 0.000 -y_offset 0.000
#create_site_array -site unit

#create_track -layer M3
#create_track -layer M4
#create_track -layer M5
#create_track -layer M6

#place_pins -self
#create_terminals_for_pins

#save_block -as ${lib_name}_fp

