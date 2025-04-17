add wave -noupdate /frequency_divider/clk_i
add wave -noupdate /frequency_divider/clk_o
add wave -noupdate /frequency_divider/rst_i
add wave -noupdate /frequency_divider/div_i
add wave -noupdate /frequency_divider/pos_count
add wave -noupdate /frequency_divider/neg_count
#add wave -noupdate /frequency_divider/divide_value

update

## signal high low, offset {duty cycle} -r period
force -drive /frequency_divider/clk_i 1 0, 0 {3 ns} -r 6ns
force -drive /frequency_divider/div_i 1'h7 0
force -drive /frequency_divider/rst_i 1'h1 0
force -drive /frequency_divider/rst_i 1'h0 8ns 

run 100ns
