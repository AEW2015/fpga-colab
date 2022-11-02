namespace eval jcm_lite {
	variable pkg_index_location [file normalize [info script]]
	variable pkg_location [file dirname $pkg_index_location]
}

package ifneeded jcm_lite 1.0.0 {
	source [file join $jcm_lite::pkg_location jcm_lite.tcl]
}