proc par_tmr_design {name target part} {
    puts $name
    create_project $name $name -part $part
    set_property design_mode GateLvl [current_fileset]
    add_files -norecurse ./output_edifs/$name.edf
    
    add_files -fileset constrs_1 -norecurse tmr_src/tmr_clk.xdc
    add_files -fileset constrs_1 -norecurse tmr_src/${target}_target.xdc
    if {$target!="video"} {
        add_files -fileset constrs_1 -norecurse tmr_src/generate_bitstream.xdc
    }

    set_property top_file $name.edf [current_fileset]
	set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]
    set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]

    launch_runs impl_1 -to_step write_bitstream -jobs 4
    wait_on_run impl_1
    open_run impl_1
    write_bitstream -bin_file ../bins/$name.bit

    close_project
}


set tmr_edifs [glob -directory ./output_edifs/ *.edf]
foreach x $tmr_edifs {
    puts $x
    set name [lindex [file split [file rootname $x]] end]
    puts $name
    set s_devkit2 "devkit2"
    set s_aesku40 "aesku40"
    set s_kupci "kupci"
    set s_video "video"
    set target $s_devkit2
    set part xcku060-ffva1517-1-i
    if {[string first $s_devkit2 $name] != -1} {
        puts "\"$s_devkit2\" found in \"$name\""
        set target $s_devkit2
        set part xcku060-ffva1517-1-i
    } elseif {[string first $s_aesku40 $name] != -1} {
        puts "\"$s_aesku40\" found in \"$name\""
        set target $s_aesku40
        set part xcku040-fbva676-1-i
    } elseif {[string first $s_kupci $name] != -1} {
        puts "\"$s_kupci\" found in \"$name\""
        set target $s_kupci
        set part xcku060-ffva1156-2-e
    } elseif {[string first $s_video $name] != -1} {
        puts "\"$s_video\" found in \"$name\""
        set target $s_video
        set part xc7a200tsbg484-1
    }
    if {[file exist $name]} {
        # check that it's a directory
        puts "Project already exsists."
    } else {
        par_tmr_design $name $target $part
    }
}



