#*****************************************************************************************
# Vivado (TM) v2019.1 (64-bit)
#
# taiga_prj.tcl: Tcl script for re-creating project 'taiga'
#
# Generated by Vivado on Sat Feb 27 09:03:31 -0700 2021
# IP Build 2548770 on Fri May 24 18:01:18 MDT 2019
#
# This file contains the Vivado Tcl commands for re-creating the project to the state*
# when this script was generated. In order to re-create the project, please source this
# file in the Vivado Tcl Shell.
#
# * Note that the runs in the created project will be configured the same way as the
#   original project, however they will not be launched automatically. To regenerate the
#   run results please launch the synthesis/implementation runs as needed.
#
#*****************************************************************************************
# NOTE: In order to use this script for source control purposes, please make sure that the
#       following files are added to the source control system:-
#
# 1. This project restoration tcl script (taiga_prj.tcl) that was generated.
#
# 2. The following source(s) files that were local or imported into the original project.
#    (Please see the '$orig_proj_dir' and '$origin_dir' variable setting below at the start of the script)
#
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/bd/tbd/tbd.bd"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/bd/tbd/hdl/tbd_wrapper.v"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/constrs_1/imports/tmp/test.coe"
#
# 3. The following remote source files that were added to the original project:-
#
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/taiga_config.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/taiga_types.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/alu_unit.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/amo_alu.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/avalon_master.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/axi_master.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/l2_arbiter/l2_config_and_types.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/axi_to_arb.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/barrel_shifter.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/branch_comparator.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/branch_predictor.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/branch_predictor_ram.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/branch_unit.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/byte_en_BRAM.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/clz.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/csr_types.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/csr_regs.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/cycler.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/dbram.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/dcache.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/ddata_bank.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/decode.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_algorithms/div_algorithm.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_algorithms/div_quick_clz.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_algorithms/div_quick_clz_mk2.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_algorithms/div_quick_naive.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_algorithms/div_radix16.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_algorithms/div_radix2.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_algorithms/div_radix2_ET.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_algorithms/div_radix2_ET_full.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_algorithms/div_radix4.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_algorithms/div_radix4_ET.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_algorithms/div_radix8.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_algorithms/div_radix8_ET.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_unit.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/dtag_banks.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/external_interfaces.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/fetch.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/gc_unit.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/ibram.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/icache.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/id_inuse.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/id_tracking.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/intel_byte_enable_ram.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/interfaces.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/itag_banks.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/l1_arbiter.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/l2_arbiter/l2_arbiter.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/l2_arbiter/l2_fifo.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/l2_arbiter/l2_interfaces.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/l2_arbiter/l2_reservation_logic.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/l2_arbiter/l2_round_robin.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/load_store_unit.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/local_memory/local_memory_interface.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/lut_ram.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/mmu.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/msb_naive.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/mul_unit.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/one_hot_occupancy.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/one_hot_to_integer.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/pre_decode.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/ras.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/register_file.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/shift_counter.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/tag_bank.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/taiga.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/taiga_fifo.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/aew_Taiga/examples/ku040/taiga_wrapper.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/tlb_lut_ram.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/wishbone_master.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/write_back.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/xilinx_byte_enable_ram.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/aew_Taiga/examples/ku040/taiga_vhdl.vhd"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/bd/mbb/mbb.bd"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/hdl/mbb_wrapper.vhd"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/new/tma_wrap.vhd"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/new/tmr_wrap.vhd"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/binary_occupancy.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/debug_module/debug_cfg_types.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/debug_module/debug_interfaces.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/debug_module/debug_module.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/div_unit_core_wrapper.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/debug_module/jtag_module.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/debug_module/jtag_register.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/debug_module/jtag_registers.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/local_memory/local_mem.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/msb.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/mstatus_priv_reg.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/Taiga/core/placer_randomizer.sv"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/sources_1/imports/imports/aew_Taiga/core/avalon_master.vhd"
#    "C:/xup/acorn/taiga.xpr/taiga/archive_project_summary.txt"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/constrs_1/new/top.xdc"
#    "C:/xup/acorn/v002/duts/taiga/taiga.srcs/constrs_1/imports/tmp/test.coe"
#
#*****************************************************************************************

if { $argc > 3 } {
    puts "Too many args."
    puts "Please try again."
    break
}

if { $argc < 1 } {
    puts "Setting default processor count 1"
    set proc_count 1
} else {
    puts "Setting processor count "
    puts [lindex $argv 0]
    set proc_count [lindex $argv 0]
}

if { $argc < 2 } {
    puts "Using Devkit2 Target"
    set Target "devkit2"
} else {
    if { [lindex $argv 1] == "devkit2" } {
        puts "Using devkit2 Target"
        set Target "devkit2"
    } elseif { [lindex $argv 1] == "aesku40" } {
        puts "Using aesku40 Target"
        set Target "aesku40"
    } elseif { [lindex $argv 1] == "kupci" } {
        puts "Using kupci Target"
        set Target "kupci"
    } elseif { [lindex $argv 1] == "video" } {
        puts "Using video Target"
        set Target "video"
    } else {
        puts "Unknown Target."
        break
    }
}

if { $argc < 3 } {
    puts "Using UART"
    set output_method "UART"
    set BSCAN false
} else {
    if { [lindex $argv 2] == "BSCAN" } {
        puts "Using BSCAN output"
        set output_method "BSCAN"
        set BSCAN true
    } else {
        puts "Unknown output method."
        break
    }
    
}

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "taiga_prj"

set _xil_proj_name_ [format "%s_%03d_%s_%s" $_xil_proj_name_ $proc_count $Target $output_method]

puts $_xil_proj_name_

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "taiga_prj.tcl"

# Help information for this script
proc print_help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set _xil_proj_name_ [lindex $::argv $i] }
      "--help"         { print_help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/../../../../xup/acorn/v002/duts/taiga"]"

# Create project
set clk_speed 100000000
if {$Target=="devkit2"} {
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xcku060-ffva1517-1-i
} elseif {$Target=="aesku40"} {
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xcku040-fbva676-1-i
} elseif {$Target=="kupci"} {
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xcku060-ffva1156-2-e
} elseif {$Target=="video"} {
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a200tsbg484-1
set clk_speed 66667000
}
# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [current_project]
set_property -name "board_part" -value "" -objects $obj
set_property -name "corecontainer.enable" -value "0" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_optional_runs_sta" -value "0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "generate_ip_upgrade_log" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_interface_inference_priority" -value "" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "legacy_ip_repo_paths" -value "" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "project_type" -value "Default" -objects $obj
set_property -name "pr_flow" -value "0" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "sim.use_ip_compiled_libs" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "source_mgmt_mode" -value "All" -objects $obj
set_property -name "target_language" -value "VHDL" -objects $obj
set_property -name "target_simulator" -value "XSim" -objects $obj
set_property -name "tool_flow" -value "Vivado" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}


# Add local files from the original project (-no_copy_sources specified)
set files [list \
 [file normalize "${origin_dir}/hdl/taiga_wrapper.sv" ]\
 [file normalize "${origin_dir}/hdl/taiga_config.sv" ]\
 [file normalize "${origin_dir}/hdl/taiga_vhdl.vhd" ]\
]
set added_files [add_files -fileset sources_1 $files]

# Set 'sources_1' fileset file properties for local files
set file "hdl/taiga_wrapper.sv"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
set_property -name "is_enabled" -value "1" -objects $file_obj
set_property -name "is_global_include" -value "0" -objects $file_obj
set_property -name "library" -value "xil_defaultlib" -objects $file_obj
set_property -name "path_mode" -value "RelativeFirst" -objects $file_obj
set_property -name "used_in" -value "synthesis implementation simulation" -objects $file_obj
set_property -name "used_in_implementation" -value "1" -objects $file_obj
set_property -name "used_in_simulation" -value "1" -objects $file_obj
set_property -name "used_in_synthesis" -value "1" -objects $file_obj

set file "hdl/taiga_config.sv"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
set_property -name "is_enabled" -value "1" -objects $file_obj
set_property -name "is_global_include" -value "0" -objects $file_obj
set_property -name "library" -value "xil_defaultlib" -objects $file_obj
set_property -name "path_mode" -value "RelativeFirst" -objects $file_obj
set_property -name "used_in" -value "synthesis implementation simulation" -objects $file_obj
set_property -name "used_in_implementation" -value "1" -objects $file_obj
set_property -name "used_in_simulation" -value "1" -objects $file_obj
set_property -name "used_in_synthesis" -value "1" -objects $file_obj

set file "hdl/taiga_vhdl.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "is_enabled" -value "1" -objects $file_obj
set_property -name "is_global_include" -value "0" -objects $file_obj
set_property -name "library" -value "xil_defaultlib" -objects $file_obj
set_property -name "path_mode" -value "RelativeFirst" -objects $file_obj
set_property -name "used_in" -value "synthesis simulation" -objects $file_obj
set_property -name "used_in_simulation" -value "1" -objects $file_obj
set_property -name "used_in_synthesis" -value "1" -objects $file_obj

if {$Target=="video"} {
add_files -norecurse ../hdl_src/${Target}/clk_wiz_0.vhd
import_files -norecurse ../hdl_src/${Target}/clk_wiz_0_inner.xci

} else {
import_files -norecurse ../hdl_src/${Target}/clk_wiz_0.xci
}

update_compile_order -fileset sources_1
set_property  ip_repo_paths  $origin_dir/../ip_repo [current_project]
update_ip_catalog

source ./bd/taiga_bd.tcl
update_compile_order -fileset sources_1


# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "design_mode" -value "RTL" -objects $obj
set_property -name "edif_extra_search_paths" -value "" -objects $obj
set_property -name "elab_link_dcps" -value "1" -objects $obj
set_property -name "elab_load_timing_constraints" -value "1" -objects $obj
set_property -name "generic" -value "" -objects $obj
set_property -name "include_dirs" -value "" -objects $obj
set_property -name "lib_map_file" -value "" -objects $obj
set_property -name "loop_count" -value "1000" -objects $obj
set_property -name "name" -value "sources_1" -objects $obj
set_property -name "top" -value "tma_wrap" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "verilog_define" -value "" -objects $obj
set_property -name "verilog_uppercase" -value "0" -objects $obj
set_property -name "verilog_version" -value "verilog_2001" -objects $obj
set_property -name "vhdl_version" -value "vhdl_2k" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

puts "INFO: Project created:${_xil_proj_name_}"


#add more files???
add_files $origin_dir/Taiga/core/div_algorithms
add_files $origin_dir/Taiga/core/
add_files $origin_dir/Taiga/l2_arbiter/
add_files $origin_dir/Taiga/local_memory/
add_files $origin_dir/../hdl_src
add_files -fileset constrs_1 $origin_dir/../hdl_src/${Target}/${Target}_target.xdc
if {$Target=="video"} {

} else {
add_files -fileset constrs_1 $origin_dir/../hdl_src/generate_bitstream.xdc
}
set_property top design_1_wrapper [current_fileset]

#remove conflicting 
remove_files  $origin_dir/Taiga/core/taiga_config.sv
update_module_reference design_1_taiga_vhdl_0_0
update_compile_order -fileset sources_1

set_property generic "NUM_PROS=$proc_count USE_BSCAN=$BSCAN CLK_RATE=$clk_speed" [current_fileset]
set_property strategy Flow_AlternateRoutability [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY rebuilt [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.RETIMING true [get_runs synth_1]

set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]

launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_run impl_1
open_run impl_1
write_edif ../../tmr/input_edifs/$_xil_proj_name_.edf
write_bitstream -bin_file ../../bins/$_xil_proj_name_.bit

close_project