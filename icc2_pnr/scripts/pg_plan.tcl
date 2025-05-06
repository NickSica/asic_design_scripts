###########################################################################
### Power Grid Planning
###########################################################################
create_net -power VDD
create_net -ground VSS 

set_attribute -objects [get_nets VDD] -name net_type -value power
set_attribute -objects [get_nets VSS] -name net_type -value ground

connect_pg_net -net VDD [get_pins -physical_context *VDD]
connect_pg_net -net VSS [get_pins -physical_context *VSS]
#connect_pg_net -net ${ground_net} [get_pins -physical_context */${power_net}]
#connect_pg_net -net ${ground_net} [get_pins -physical_context */${ground_net}]
#connect_pg_net -net ${power_net}  [get_terminals -hier -include_lib_cell */${power_net}*]
#connect_pg_net -net ${ground_net} [get_terminals -hier -include_lib_cell */${ground_net}*]

connect_pg_net -automatic

create_placement -floorplan

# Create VDD/VSS Ring
#{side_offset: {{side: 1 2 3 4}{offset: 3.5}}}
create_pg_ring_pattern pg_ring -nets {VSS VDD} \
    -horizontal_layer M7 -vertical_layer M8 \
    -vertical_spacing 0.5 \
    -horizontal_spacing 0.5 \
    -corner_bridge true \
    -via_rule { \
         {{layers: M7} {layers: M8} {via_master: default}} \
         {{intersection: undefined} {via_master: NIL}} \
    }
set_pg_strategy ring_strat -core \
    -pattern { \
          {name: pg_ring} \
          {nets: {VSS VDD}} \
          {offset: {1 1}} \
    } \
    -extension { \
            {{side: 1 2 3 4}{direction: T L B R}{stop: design_boundary_and_generate_pin}} \
    }
#{{side: 2 4}{direction: L R}{stop: design_boundary_and_generate_pin}} \
#{width: 1.5} {pitch: 15}
compile_pg -strategies {ring_strat} -ignore_drc

## M7 doesn't extend to rings correctly so remove for now
#{{horizontal_layer: M7} {width: minimum} {pitch: 5} {spacing: interleaving}}

create_pg_mesh_pattern pg_mesh \
    -layers {
        {{horizontal_layer: M7} {width: minimum} {pitch: 5} {spacing: interleaving}}
        {{vertical_layer: M6} {width: minimum} {pitch: 5} {spacing: interleaving}}
    } \
    -via_rule {
         {{layers: M6} {layers: M7} {via_master: default}}
         {{intersection: undefined} {via_master: NIL}}
    }

set_pg_strategy mesh_strat -core \
    -pattern { \
        {pattern: pg_mesh} \
        {nets: {VDD VSS}} \
    } \
    -extension { \
        {{side: 1 2 3 4} \
         {direction: T L B R} \
         {stop: outermost_ring} \
        }
    }

create_pg_std_cell_conn_pattern std_pattern -layers {M1}
set_pg_strategy std_rails -core \
    -pattern { \
        {name: std_pattern} \
        {nets: {VDD VSS}} \
    } \
    -extension { \
        {{side: 1 2 3 4} \
         {direction: T L B R} \
         {stop: outermost_ring} \
        }
    }
    #-extension { {{stop: outermost_ring}} }

###### Weird quirk- {strategies: ring_strat} doesn't work don't know why
#set_pg_strategy_via_rule rail_via_rule \
#    -via_rule { 
#        { {{strategies: std_rails} {layers: M1}}  
#          {{strategies: mesh_strat} {layers: M6}}  
#          {via_master: {VIA12 VIA23 VIA34 VIA45 VIA56}} }
#        { {{strategies: mesh_strat} {layers: M6}}
#          {{existing: ring} {layers: M7}}
#          {via_master: VIA67} }
#        { {{strategies: mesh_strat} {layers: M7}} 
#          {{existing: ring} {layers: M8}}
#          {via_master: default} }
#    }
set_pg_strategy_via_rule rail_via_rule \
    -via_rule { 
        { {{strategies: std_rails} {layers: M1}}  
          {{existing: ring} {layers: M8}}  
          {via_master: {VIA12 VIA23 VIA34 VIA45 VIA56 VIA67 VIA78}} }
    }

set_app_options -name plan.pgroute.disable_floating_removal -value true
#compile_pg -strategies {mesh_strat std_rails} -via_rule rail_via_rule
compile_pg -strategies {std_rails} -via_rule rail_via_rule


#trim_pg_mesh

### Create Pins
# can be constrained using set_block_pin_constraints and create_pin_constraint
place_pins -self
get_ports -filter physical_status==unplaced *


### Save the design
#
save_block -as ${lib_name}_pg
