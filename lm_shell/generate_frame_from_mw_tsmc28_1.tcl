set __suc -1
set __res 0
redirect -append -file /home/sica/asic_design_scripts/lm_shell/tsmc28_2.log {
  set __pwd [pwd]
  set __suc [catch {
    cd /home/sica/asic_design_scripts/lm_shell
    create_workspace tsmc28 -flow frame   -technology /home/sica/asic_design_scripts/lm_shell/tsmc28/data/TF/tcbn28hpcplusbwp30p140.tf
    import_icc_fram /home/sica/asic_design_scripts/lm_shell/tsmc28/data/LEF/tcbn28hpcplusbwp30p140.tar.gz
    commit_workspace -output tsmc28
    set __res 1
  } __res ]
  cd $__pwd
  set __res
}
if { $__suc == 0 && $__res == 1 } {
  return 1
} else {
  return 0
}
