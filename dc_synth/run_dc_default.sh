#SRC_DIRS="../src"
SRC_DIRS=~/RDF-2020/benchmarks/iwls05_opencores/i2c

#TOP_LIST="ROA_InjectionLocking_gen_tb"
TOP_LIST=$(yq eval '.name' <<< cat $SRC_DIRS/rdf_design.yml)

CLK=$(yq eval '.clock_port' <<< cat $SRC_DIRS/rdf_design.yml)
#INCL_LIBS="../lc_shell/rtwo_cells"
#INCL_DIRS="../lowrisc_ip/ip/prim/rtl ../lowrisc_ip/ip/prim_generic/rtl ../dv/uvm/core_ibex/common/prim ../lowrisc_dv/sv/dv_utils"
#PKG_FILES=$(find ../lowrisc_ip/ip/prim/rtl -name "*_pkg.sv")
for top in $TOP_LIST; do
	#PKG_FILES=$PKG_FILES INCL_LIBS=$INCL_LIBS INCL_DIRS=$INCL_DIRS SVLOG_FILES=$SVLOG_FILES SRC_DIRS=$SRC_DIRS TOP=$top dc_shell -f dc_synth.tcl | tee logs/dc.log 

    PKG_FILES=$PKG_FILES \
    INCL_LIBS=$INCL_LIBS \
    INCL_DIRS=$INCL_DIRS \
    SRC_DIRS=$SRC_DIRS \
    TOP=$top \
    CLK=$CLK \
    dc_shell -f dc_synth.tcl | tee logs/dc.log 

done
sed -i 's/SNPS_ss_pd$primary$power/VDD/g'  output/$TOP_LIST/$TOP_LIST.v
sed -i 's/SNPS_ss_pd$primary$ground/VSS/g' output/$TOP_LIST/$TOP_LIST.v
sed -i 's/clk_o, .*/clk_o, VDD, VSS );/g'  output/$TOP_LIST/$TOP_LIST.v
