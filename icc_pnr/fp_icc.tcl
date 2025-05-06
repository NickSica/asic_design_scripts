###################################################################

# Created by write_floorplan on Wed Feb 22 13:13:56 2023

###################################################################
set_app_options -name shell.undo.enabled -value false
set_app_options -name shell.undo.max_levels -value 100
set_app_options -name shell.undo.max_memory -value 1000000000

set flag [set sh_continue_on_error]
if {!$flag} {
    set sh_continue_on_error true
}

set_attribute [current_block] boundary {} 

set_attribute [current_block] \
    boundary {    {0.000 0.000} {35.456 0.000} {35.456 35.200} {0.000 35.200} {0.000 0.000}} 
set oldSnapState [gui_get_snap_setting -enabled]
gui_set_snap_setting -enabled false

#*****************
#  Keepout Margin
#*****************

if {[sizeof_collection [get_keepout_margins -quiet]]} {
    remove_keepout_margins [get_keepout_margins -quiet]
}


gui_set_snap_setting -enabled $oldSnapState
set_app_options -name shell.undo.enabled -value true
set_app_options -name shell.undo.max_levels -value 100
set_app_options -name shell.undo.max_memory -value 1000000000

if {!$flag} {
    set sh_continue_on_error false
}
