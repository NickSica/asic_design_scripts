if {![info exists ::env(CALIBRE_HOME)] && [info exists ::env(MGC_HOME)]} {
    puts "Environment variable CALIBRE_HOME not set, using MGC_HOME"
    set ::env(CALIBRE_HOME) $::env(MGC_HOME)
}
if {![info exists ::env(CALIBRE_HOME)]} {
    puts "ERROR, environment variable CALIBRE_HOME or MGC_HOME not set"
    puts "Calibre interface not loaded"
} else {
    source [file join $::env(CALIBRE_HOME) lib icc_calibre.tcl]
}
