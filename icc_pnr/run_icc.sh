#TOP_LIST="ac97_ctrl aes_core des3_area i2c mem_ctrl pci sasc simple_spi spi ss_pcm systemcaes systemcdes tv80 usb_funct usb_phy wb_dma"
TOP_LIST="i2c"
for design in $TOP_LIST; do
    #SRC_DIRS="../src"
    SRC_DIRS=~/RDF-2020/benchmarks/iwls05_opencores/$design
    
    #TOP_LIST="ROA_InjectionLocking_gen_tb"
    TOP=$(yq eval '.name' <<< cat $SRC_DIRS/rdf_design.yml)
    
    CLK=$(yq eval '.clock_port' <<< cat $SRC_DIRS/rdf_design.yml)
    #INCL_LIBS="../lc_shell/rtwo_cells"
    #INCL_DIRS="../dv/uvm/core_ibex/common/prim ../lowrisc_dv/sv/dv_utils"
    #PKG_FILES=$(find ../lowrisc_ip/ip/prim/rtl -name "*_pkg.sv")
    mkdir -p logs/$design

    PKG_FILES=$PKG_FILES \
    INCL_LIBS=$INCL_LIBS \
    INCL_DIRS=$INCL_DIRS \
    SRC_DIRS=$SRC_DIRS \
    TOP=$TOP \
    CLK=$CLK \
    icc_shell -shared_license -f icc_pnr.tcl | tee logs/$design/icc.log 

done
#sed -i 's/SNPS_ss_pd$primary$power/VDD/g'  output/$TOP_LIST/$TOP_LIST.v
#sed -i 's/SNPS_ss_pd$primary$ground/VSS/g' output/$TOP_LIST/$TOP_LIST.v
#sed -i 's/clk_o, .*/clk_o, VDD, VSS );/g'  output/$TOP_LIST/$TOP_LIST.v
