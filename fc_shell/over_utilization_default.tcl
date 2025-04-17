namespace eval default {
  proc show_available_area {} {

    # available area
    set show_available_area true
    set ad "availabe area for default plane"; # description
    set ac "green"; # color
    set ap "DiagCrossPattern"; # pattern
    set aw 1; # width

    # partially blocked area (is included in available area)
    set show_partially_blocked_area true
    set pd "partially blocked area for default plane"; # description
    set pc "lightgreen"; # color
    set pp "DiagCrossPattern"; # pattern
    set pw 1; # width

    if { $show_available_area } {
      set available_rects {
        {{0 0} {800 799.2}}
      }
      foreach rect $available_rects {
        gui_add_annotation -type rectangle $rect -color $ac -width $aw -pattern $ap -info_tip "$ad"
      }
    }
    if { $show_partially_blocked_area } {
      set partially_blocked_rects {
      }
      foreach blocked_rect $partially_blocked_rects {
        set rect [lindex $blocked_rect 0]
        set blocked [lindex $blocked_rect 1]
        gui_add_annotation -type rectangle $rect -color $pc -width $pw -pattern $pp -info_tip "$blocked $pd"
      }
    }
  }
}

default::show_available_area
