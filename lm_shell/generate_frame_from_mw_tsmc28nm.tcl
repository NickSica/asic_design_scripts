set __suc -1
set __res 0
redirect -append -file /home/sica/ECEC575/lm_shell/tsmc28nm.log {
  set __pwd [pwd]
  set __suc [catch {
    cd /home/sica/ECEC575/lm_shell
    create_physical_lib tsmc28nm.ndm   -technology /home/sica/ECEC575/lm_shell/tsmc28nm/data/TF/tcbn28hpcplusbwp30p140.tf
    import_icc_fram /home/sica/ECEC575/lm_shell/tsmc28nm/data/LEF/tcbn28hpcplusbwp30p140.tar.gz
    write_physical_lib -output tsmc28nm.ndm
  } __res ]
  catch { close_physical_lib }
  cd $__pwd
  set __res
}
if { $__suc == 0 && $__res == 1 } {
  return 1
} else {
  return 0
}
