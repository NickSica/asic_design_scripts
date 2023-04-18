#source ../set_env.tcl

generate_frame_from_mw saed32nm.ndm -mw_lib /home/tech/SAED32nm/lib/stdcell_rvt/milkyway/saed32nm_rvt_1p9m/saed32nm_rvt_1p9m -overwrite
#generate_frame_from_mw tsmc65nm.ndm -mw_lib /home/tech/TSMC65/TSMCHOME/digital/Back_End/milkyway/tcbn65gplus_200a/cell_frame/tcbn65gplus -overwrite
#create_fusion_lib -mw_lib /home/tech/SAED32nm/lib/stdcell_rvt/milkyway/saed32nm_rvt_1p9m -technology /home/tech/SAED32nm/tech/milkyway/saed32nm_1p9m_mw.tf saed32nm_new

#create_physical_lib  -technology /home/tech/SAED32nm/tech/milkyway/saed32nm_1p9m_mw.tf saed32nm_new
#read_lef /home/tech/SAED32nm/lib/stdcell_rvt/lef/saed32nm_rvt_1p9m.lef
#read_gds -layer_map /home/tech/SAED32nm/tech/milkyway/saed32nm_1p9m_gdsout_mw.map /home/tech/SAED32nm/lib/stdcell_rvt/gds/saed32nm_rvt_oa.gds

#create_frame

#write_physical_lib -force -output saednm_new.ndm
#write_fusion_lib -force -output saednm_fusion.ndm
