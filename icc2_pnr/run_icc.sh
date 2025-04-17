SRC_DIRS="/home/yilmaz/oscillators_verilog/dc/output"
SDC_DIRS="/home/yilmaz/oscillators_verilog/dc/output"
SRC_DIRS="../dc_synth/output/coupled_roscs"
SDC_DIRS="../dc_synth/consts/coupled_roscs"
TOP_LIST="coupled_roscs"
#INCL_LIBS="../lc_shell/rtwo_cells"
#INCL_DIRS="../lowrisc_ip/ip/prim/rtl ../lowrisc_ip/ip/prim_generic/rtl ../dv/uvm/core_ibex/common/prim ../lowrisc_dv/sv/dv_utils"
#PKG_FILES=$(find ../lowrisc_ip/ip/prim/rtl -name "*_pkg.sv")
for top in $TOP_LIST; do
	#PKG_FILES=$PKG_FILES INCL_LIBS=$INCL_LIBS INCL_DIRS=$INCL_DIRS SVLOG_FILES=$SVLOG_FILES SRC_DIRS=$SRC_DIRS TOP=$top dc_shell -f dc_synth.tcl | tee logs/dc.log 

    PKG_FILES=$PKG_FILES \
    INCL_LIBS=$INCL_LIBS \
    INCL_DIRS=$INCL_DIRS \
    SRC_DIRS=$SRC_DIRS \
    SDC_DIRS=$SDC_DIRS \
    TOP=$top \
    icc2_shell -f icc_pnr.tcl | tee logs/fc.log 

done

#SRC_DIRS="../src/"
#TOP_LIST="RTWO_kings"
#SVLOG_FILES=$(find ../src -name "*.sv")
#INCL_LIBS="../lc_shell/rtwo_cells"
##INCL_DIRS="../lowrisc_ip/ip/prim/rtl ../lowrisc_ip/ip/prim_generic/rtl ../dv/uvm/core_ibex/common/prim ../lowrisc_dv/sv/dv_utils"
##PKG_FILES=$(find ../lowrisc_ip/ip/prim/rtl -name "*_pkg.sv")
#for top in $TOP_LIST; do
#	#PKG_FILES=$PKG_FILES INCL_LIBS=$INCL_LIBS INCL_DIRS=$INCL_DIRS SVLOG_FILES=$SVLOG_FILES SRC_DIRS=$SRC_DIRS TOP=$top dc_shell -f dc_synth.tcl | tee logs/dc.log 
#
#    PKG_FILES=$PKG_FILES \
#    INCL_LIBS=$INCL_LIBS \
#    INCL_DIRS=$INCL_DIRS \
#    SVLOG_FILES=$SVLOG_FILES \
#    SRC_DIRS=$SRC_DIRS \
#    TOP=$top \
#    icc2_shell -f icc_pnr.tcl | tee logs/fc.log 
#
#done
