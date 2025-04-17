cp ~/ocean_scripts/frequency_divider.sv ../src/
SRC_DIRS="../src/"
TOP_LIST="frequency_divider"
SVLOG_FILES=$(find ../src -name "*.sv")
#INCL_LIBS="../lc_shell/rtwo_cells"
#INCL_DIRS="../lowrisc_ip/ip/prim/rtl ../lowrisc_ip/ip/prim_generic/rtl ../dv/uvm/core_ibex/common/prim ../lowrisc_dv/sv/dv_utils"
#PKG_FILES=$(find ../lowrisc_ip/ip/prim/rtl -name "*_pkg.sv")
for top in $TOP_LIST; do
	#PKG_FILES=$PKG_FILES INCL_LIBS=$INCL_LIBS INCL_DIRS=$INCL_DIRS SVLOG_FILES=$SVLOG_FILES SRC_DIRS=$SRC_DIRS TOP=$top dc_shell -f dc_synth.tcl | tee logs/dc.log 

    PKG_FILES=$PKG_FILES \
    INCL_LIBS=$INCL_LIBS \
    INCL_DIRS=$INCL_DIRS \
    SVLOG_FILES=$SVLOG_FILES \
    SRC_DIRS=$SRC_DIRS \
    TOP=$top \
    dc_shell -f dc_synth.tcl | tee logs/dc.log 

done

sed -i 's/SNPS_ss_pd$primary$power/VDD/g' output/frequency_divider/frequency_divider.v
sed -i 's/SNPS_ss_pd$primary$ground/VSS/g' output/frequency_divider/frequency_divider.v
sed -i 's/clk_o, .*/clk_o, VDD, VSS );/g' output/frequency_divider/frequency_divider.v
cp output/frequency_divider/frequency_divider.v ~/ocean_scripts
