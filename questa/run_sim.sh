#!/bin/bash
vlib work

## VHDL
#vcom -work work ~/ocean_scripts/frequency_divider.sv
vlog +acc -sv -work work ~/ocean_scripts/frequency_divider.sv

## Show mapping
## vmap -c creates a default ini for use
#vmap


vsim -do vsim.do work.frequency_divider
