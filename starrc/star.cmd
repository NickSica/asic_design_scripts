NDM_DATABASE: ../fc_shell/TSMC65_RotaryCircuits.dlib
BLOCK: RTWO_kings_extracted

*NDM_DATABASE: ../lc_shell/rtwo_cells
*BLOCK: OneRing_6GHz 
SKIP_CELLS Seg25um_Horiz Seg25um_Vert Bend90_35um_TR Bend90_35um_BR Bend90_35um_BL Crossover_35um

POWER_NETS: VDD VSS
TCAD_GRD_FILE: /home/tech/TSMC65GP/CCI/CCI_decks/cln65g+_1p09m+alrdl_6x1z1u_typical.nxtgrd
MAPPING_FILE: /home/tech/TSMC65GP/CCI/CCI_decks/starrcxt_mapping
EXTRACTION: RC
REDUCTION: YES
DENSITY_BASED_THICKNESS: YES
EXTRACT_VIA_CAPS: YES

*** Coupling Caps options
COUPLE_TO_GROUND: NO
*COUPLING_ABS_THRESHOLD: 3e-15
*COUPLING_REL_THRESHOLD: 0.03
*COUPLING_REPORT_NUMBER: 1000

*SIMULTANEOUS_MULTI_CORNER: YES
STAR_DIRECTORY: star_work
*CORNERS_FILE: starrc.mapping
*SELECTED_CORNERS: typical rcworst

*NETLIST_FORMAT: OA                  **** obsolete
**** obsolete
*NETLIST_FORMAT: NETNAME
**** Doesn't work required 2 corners
*NETLIST_FORMAT: PARAMETERIZED_SPICE
NETLIST_FORMAT: SPF
NETLIST_PASSIVE_PARAMS: YES
*NETLIST_IDEAL_SPICE_FILE: RTWO_kings_extracted.dpf
*NETLIST_IDEAL_SPICE_HIER: YES
* OA_DEVICE_MAPPING_FILE: /home/tech/TSMC65GP/CCI/CCI_decks/dfii_device_map.txt 
* OA_LAYER_MAPPING_FILE: /home/tech/TSMC65GP/CCI/CCI_decks/dfii_layer_map.txt 

*** For shrink flow
* MAGNIFICATION_FACTOR : 0.9
* MAGNIFY_DEVICE_PARAMS : NO
SKIP_PCELLS : crtmom* crtmom_mx* crtmom_rf* lincap_rf* lincap_rf_25* lowcpad* lowcpad* lowcpad* mimcap_um_rf* mimcap_um_udc_rf* mimcap_woum_rf* mimcap_woum_udc_rf* moscap_rf* moscap_rf18* moscap_rf18_nw* moscap_rf25* moscap_rf25_nw* moscap_rf33* moscap_rf33_nw* moscap_rf_hvt* moscap_rf_hvt_nw* moscap_rf_nw* ndio_hia_rf* nmos_rf* nmos_rf_18* nmos_rf_18_6t* nmos_rf_18_nodnw* nmos_rf_25* nmos_rf_25_6t* nmos_rf_25_nodnw* nmos_rf_25_nodnwod33* nmos_rf_25_nodnwud18* nmos_rf_25od33* nmos_rf_25od33_6t* nmos_rf_25ud18* nmos_rf_25ud18_6t* nmos_rf_33* nmos_rf_33_6t* nmos_rf_33_nodnw* nmos_rf_6t* nmos_rf_hvt* nmos_rf_hvt_6t* nmos_rf_hvt_nodnw* nmos_rf_lvt* nmos_rf_lvt_6t* nmos_rf_lvt_nodnw* nmos_rf_mlvt* nmos_rf_mlvt_6t* nmos_rf_mlvt_nodnw* nmos_rf_nodnw* pdio_hia_rf* pmos_rf* pmos_rf_18* pmos_rf_18_5t* pmos_rf_18_nw* pmos_rf_18_nw_5t* pmos_rf_25* pmos_rf_25_5t* pmos_rf_25_nw* pmos_rf_25_nw_5t* pmos_rf_25_nwod33* pmos_rf_25_nwud18* pmos_rf_25od33* pmos_rf_25od33_5t* pmos_rf_25od33_nw_5t* pmos_rf_25ud18* pmos_rf_25ud18_5t* pmos_rf_25ud18_nw_5t* pmos_rf_33* pmos_rf_33_5t* pmos_rf_33_nw* pmos_rf_33_nw_5t* pmos_rf_5t* pmos_rf_hvt* pmos_rf_hvt_5t* pmos_rf_hvt_nw* pmos_rf_hvt_nw_5t* pmos_rf_lvt* pmos_rf_lvt_5t* pmos_rf_lvt_nw* pmos_rf_lvt_nw_5t* pmos_rf_mlvt* pmos_rf_mlvt_5t* pmos_rf_mlvt_nw* pmos_rf_mlvt_nw_5t* pmos_rf_nw* pmos_rf_nw_5t* pmoscap_rf* pmoscap_rf25* rppoly_rf* rppoly_rf* rppolywo_rf* sbd_rf* sbd_rf_nw* spiral_std_mu_z* spiral_sym_ct_mu_z* spiral_sym_mu_z* spiral_std_mu_a* spiral_sym_ct_mu_a* spiral_sym_mu_a* spiral_std_mza_a* spiral_sym_ct_mza_a* spiral_sym_mza_a*  spiral_std_mz_x* spiral_sym_ct_mz_x* spiral_sym_mz_x* xjvar* xjvar_nw* 
