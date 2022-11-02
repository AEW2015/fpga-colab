namespace eval tcl_server {
	variable pkg_index_location [file normalize [info script]]
	variable pkg_location [file dirname $pkg_index_location]
}



package ifneeded tcl_server 0.1.0 {
	source [file join $tcl_server::pkg_location tcl_server.tcl]
}