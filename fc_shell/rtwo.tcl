###### Fusion Compiler Script ###### 
set is_test 0 
if { $is_test == 1 } {
    source -echo ../set_env.tcl
    set block OneRing_24GHz
    set ref_libs [ list $root_dir/lc_shell/rtwo_cells $ref_libs ]
    set lib_name RTWO_Blocks
    
    if { ![file exists ${lib_name}.dlib] } {
        create_lib -ref_libs $ref_libs -technology $techfile ${lib_name}.dlib 
    }
    open_lib ${lib_name}.dlib 
} else {
    set block $::block
    set ref_libs [ list $root_dir/lc_shell/rtwo_cells $ref_libs ]
    set rtwo_lib RTWO_Blocks
    
    if { ![file exists ${rtwo_lib}.dlib] } {
        create_lib -ref_libs $ref_libs -technology $techfile ${rtwo_lib}.dlib 
    }
    open_lib ${rtwo_lib}.dlib 

}

#### Change these settings
set b2b_length 9.65
set seg_length 25
set num_sides 4

if { $is_test == 1 } {
    ## 6 GHz
    #set num_segs 16
    #set pre_segs 3
    #set post_segs 4
    
    ## 24 GHz
    set num_segs 4
    set pre_segs 0
    set post_segs 2
} else {
    set num_segs $::num_segs 
    set pre_segs $::pre_segs 
    set post_segs $::post_segs 
}

set unused_segs [expr $num_segs - $post_segs - $pre_segs]
set rem_segs [expr $unused_segs % 2]
if {$rem_segs != 0} {
    echo "Not an even amount of segments in-between, decreasing amount of segments"
    set num_segs [expr $num_segs - $rem_segs]
    set unused_segs [expr $unused_segs - $rem_segs]
}
set skip_segs [expr $unused_segs / 2]

#### Calculate cell dimensions
set length [expr $num_segs * 25 + 46]
set len_list [list $length $length]
#-dimensions $len_list 
# Does not like macro design_type and module design_type has errors
# black_box as recommended when set to macro has errors
#create_block $block -design_type module -force -boundary [list {0 0} $len_list]
#create_block $block -design_type lib_cell -force -boundary [list {0 0} $len_list]
create_block $block -design_type macro -force -boundary [list {0 0} $len_list]

#### FLOORPLAN RESIZES ITSELF RANDOMLY????\
## The following didn't work
#create_voltage_area_shape -voltage_area DEFAULT_VA -region [list {0 0} $len_list]
#set_floorplan_area_rules -object_types core_area -min [expr $length * $length] -max [expr $length * $length] -name core_area_rule

## Worth a try 
#set_floorplan_enclosure_rules
#set_floorplan_length_rules

initialize_floorplan -keep_boundary -side_length $len_list -boundary [list {0 0} $len_list] -core_offset 0
#initialize_floorplan -boundary [list {0 0} $len_list] -core_offset 0

## Doesn't work, still only 144.0
#set_attribute [current_block] boundary [list {0.0 0.0} {145.0 145.0}]

#resize_objects -bbox {{0 0} {145 145}} [get_core_area]

#link_block
start_gui

proc place_instance {cell inst_num target_corner anchor_corner} {
    create_cell "U$inst_num" $cell
    set prev_inst [expr $inst_num - 1]
    set_macro_relative_location -offset {0 0} -target_object [get_cells "U$inst_num"] -target_orientation R0 -target_corner $target_corner -anchor_object [get_cells "U$prev_inst"] -anchor_corner $anchor_corner
}

proc place_ports {inst_num pin_name port_name port_dims} {
    set port_x [lindex $port_dims 0]
    set port_y [lindex $port_dims 1]
    create_port -direction inout -port_type signal $port_name
    create_pin_guide -name ${port_name}_guide -exclusive [get_port $port_name] -boundary [get_pin "U$inst_num/$pin_name"]
    #set pin_loc [get_attribute -objects [get_pins "U$inst_num/$pin_name"] -name boundary]
    set pin_loc [lindex [get_attribute -objects [get_pin_guides ${port_name}_guide] -name boundary] 0]
    set pin_loc [list [expr [lindex $pin_loc 0] + $port_x / 2] [expr [lindex $pin_loc 1] + $port_y / 2]]
    set_individual_pin_constraints -ports $port_name -allowed_layers [get_layers M7] -location $pin_loc -off_edge
}

set corners { "Bend90_35um_TR" "Bend90_35um_BR" "Bend90_35um_BL" "Crossover_35um" }
set port_suffix { "_1" "" "_2" } 

set_edit_setting -keep_pin_on_edge false
#move_objects -to {34.000 7.050} -force [get_port inner1]
#set_attribute -objects [get_ports inner1] -name physical_status -value placed
#get_attribute -objects [get_pins U2/B2B_1] -name bbox

set inst_num 2
set b2b_num 1
create_cell "U1" rtwo_cells/Crossover_35um
set_macro_relative_location -offset {0 0} -target_object [get_cells U1] -target_orientation R0 -target_corner tl -anchor_corner tl 

for {set i 0} {$i < $num_sides} {incr i} {
    if {$i == 0} {
        set seg_cell rtwo_cells/Seg25um_Horiz
        set target_corner tl
        set anchor_corner tr 
    } elseif {$i == 1} {
        set seg_cell rtwo_cells/Seg25um_Vert
        set target_corner tr
        set anchor_corner br 
    } elseif {$i == 2} {
        set seg_cell rtwo_cells/Seg25um_Horiz
        set target_corner br
        set anchor_corner bl 
    } elseif {$i == 3} {
        set seg_cell rtwo_cells/Seg25um_Vert
        set target_corner bl
        set anchor_corner tl
    }

    set start $inst_num
    set suffix_num 0
    while { $inst_num < $num_segs + $start } {
        place_instance $seg_cell $inst_num $target_corner $anchor_corner

        #create_cell "I$b2b_num" rtwo_cells/InverterPair
        #set offset [list [expr 25 / 2 - $b2b_length / 2 ] 1]
        #set_macro_relative_location -offset $offset -target_object [get_cell "I$b2b_num"] -target_orientation R0 -target_corner tl -anchor_object [get_cell "U$inst_num"] -anchor_corner tl

        #incr b2b_num
        incr inst_num
    }

    if {$i != 3} {
        set cell rtwo_cells/[lindex $corners $i]
        place_instance $cell $inst_num $target_corner $anchor_corner
        incr inst_num
    }
}

#create_shape -shape_type rect -layer M1 -boundary {{40 40} {55 55}}
#create_pin_guide -name inner1_guide -exclusive [get_port inner1] -boundary {{45 45} {50 50}}

#set_attribute  -objects [current_block] -name edge_number -value 4 -quiet 
#set_attribute  -objects [] -name edge_number -value 4 -quiet 

create_placement -floorplan
set_fixed_objects [get_flat_cells -filter is_hard_macro==true]
create_placement


### Port and B2B placement

place_ports 1 "outer" "Outer4" {3.65 3.65}
place_ports 1 "inner" "Inner4" {3.65 3.65}
set inst_num 2
for {set i 0} {$i < $num_sides} {incr i} {
    set side_num [expr $i + 1]

    set suffix_num 0
    set start $inst_num
    set stop [expr $num_segs + $start]
    set skip_count 1
    set next_port [expr $start + $pre_segs]
    while { $inst_num < $stop } {
        #if {$inst_num > $start + $pre_segs - 1 && $inst_num < $stop - $post_segs} {}
        if {$inst_num == $next_port} {
            place_ports $inst_num "B2B_1" "Outern$side_num[lindex $port_suffix $suffix_num]" {2 2}
            place_ports $inst_num "B2B_2" "Innern$side_num[lindex $port_suffix $suffix_num]" {2 2}
            incr suffix_num
            if {$inst_num < $stop - $post_segs} {
                set next_port [expr $inst_num + $skip_segs]
            }
        }

        # Doesn't work with library cells
        #align_objects -anchor_side center -anchor [get_pins -design [current_block] {U1/outer}] [get_pin I1/ZN]

        # Only works for macros not standard cells
        #set_macro_relative_location -offset {0 0} -target_object [get_cells "I$b2b_num"] -target_orientation R0 -target_corner $target_corner -anchor_object [get_cells "U$inst_num"] -anchor_corner $anchor_corner

        if {$i % 2 == 0} {
            set cell InverterPair_Horiz
            set offset [list [expr ($seg_length + 0.5) / 2 - $b2b_length / 2] [expr 2]]
        } else {
            set cell InverterPair_Vert
            set offset [list [expr 2] [expr ($seg_length + 0.5) / 2 - $b2b_length / 2]]
        }
        create_cell "I$b2b_num" rtwo_cells/$cell
        set origin [get_attribute -objects [get_cell "U$inst_num"] -name origin]
        ### the 26 isn't quite right it shouldn't need the extra 0.5, but it's misaligned otherwise
        set offset [list [expr [lindex $origin 0] + [lindex $offset 0]] [expr [lindex $origin 1] + [lindex $offset 1]]]
        set_attribute -objects [get_cell "I$b2b_num"] -name origin -value $offset 

        incr b2b_num
        incr inst_num
    }

    if {$i != 3} {
        place_ports $inst_num "outer" "Outer$side_num" {3.65 3.65}
        place_ports $inst_num "inner" "Inner$side_num" {3.65 3.65}
                
        #connect_pins 
        incr inst_num
    }
}

### Create power/ground and pop-up terminals
create_port -port_type power VDD
create_port -port_type ground VSS
connect_pg_net -automatic
pop_up_objects [get_terminals -include_lib_cell -hier */VDD*]
pop_up_objects [get_terminals -include_lib_cell -hier */VSS*]

#### TODO: Remove if we figure out why layout resizes itself
remove_objects [get_placement_blockages]
place_pins -self

create_frame
#commit_block $block 
save_block
if { $is_test == 1 } {
    start_gui
} else {
    close_blocks
    close_lib
}
