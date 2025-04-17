source ../set_env.tcl

set techfile "$pdk_dir/tech/milkyway/saed32nm_1p9m_mw.tf"
create_physical_lib saed32nm.ndm   -technology $techfile
import_icc_fram /home/sica/asic_design_scripts/lc_shell/saed32nm/data/LEF/saed32nm_rvt_1p9m.tar.gz
source /home/sica/asic_design_scripts/lc_shell/saed32nm/data/TCL/saed32nm_rvt_1p9m_update_technology.tcl 
write_physical_lib -output saed32nm.ndm
