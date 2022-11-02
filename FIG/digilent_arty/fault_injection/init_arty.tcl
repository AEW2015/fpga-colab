connect
cd tcl_server
source ./pkgIndex.tcl
package require tcl_server
cd ..
cd arty
source ./pkgIndex.tcl
package require jcm_lite
source ./jcm_lite.tcl
tcl_server::start_server

jcm_lite::set_ir_length 6
jtag target 2



