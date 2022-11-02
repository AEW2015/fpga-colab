# Register the package
package provide jcm_lite 1.0.0
package require Tcl 8.5
package require xsdb 0.1

# Create the namespace
namespace eval ::jcm_lite {
	# Export commands
	namespace export targets read_id_code read_bscan write_bscan_hex read_frame read_bit issue_gcapture inject_fault inject_random_fault test_valid_frame
	
	# Command for read
	variable CMD_BSCAN
	array set CMD_BSCAN { 1  000010
	                      2  000011
	                      3  100010
	                      4  100011
	}
	variable CMD_IDCODE  001001
	variable CMD_CFG_IN  000101
	variable CMD_CFG_OUT 000100
	
	variable FRADS_FILES
	array set FRADS_FILES [list \
		0362d093 [file join $pkg_location frads xc7a35t.txt] \
	]
	
	 #xc7a200t_frads.txt
	
	variable VALID_CRAM_FRAMES [list]
	
	
	# Sequences adapted from pg. 134 in the 7 series configuration guide
	# Configuration Memory Read Procedure (1149.1 JTAG)
	variable DUMMY_WORD                      FFFFFFFF
	variable SYNC_WORD                       AA995566
	variable TYPE_1_NOOP_WORD_0              20000000
	variable TYPE_1_WRITE_1_WORD_TO_CMD      30008001
	variable RCFG_CMD                        00000004
	variable GCAPTURE_CMD                    0000000C
	variable TYPE_1_WRITE_1_WORD_TO_FAR	     30002001											 
	
	variable WRITE_TO_FAR_SEQ             [join [list                 \
	                                      $DUMMY_WORD                 \
	                                      $SYNC_WORD                  \
										  $TYPE_1_NOOP_WORD_0         \
										  $TYPE_1_WRITE_1_WORD_TO_CMD \
										  $RCFG_CMD                   \
										  $TYPE_1_NOOP_WORD_0         \
										  $TYPE_1_NOOP_WORD_0         \
										  $TYPE_1_WRITE_1_WORD_TO_FAR ] ""]	
										  
	variable ISSUE_GCAPTURE_SEQ           [join [list                 \
	                                      $DUMMY_WORD                 \
	                                      $SYNC_WORD                  \
										  $TYPE_1_NOOP_WORD_0         \
										  $TYPE_1_WRITE_1_WORD_TO_CMD \
										  $GCAPTURE_CMD               \
										  $TYPE_1_NOOP_WORD_0         \
										  $TYPE_1_NOOP_WORD_0         ] ""]

	variable TYPE_1_READ_0_WORDS_FROM_FDRO   28006000
	variable TYPE_2_READ_202_WORDS_FROM_FDRO 480000CA

	
	variable READ_FDRO_SEQ    [join [list $TYPE_1_READ_0_WORDS_FROM_FDRO   \
	                                      $TYPE_2_READ_202_WORDS_FROM_FDRO \
										  $DUMMY_WORD                      \
										  $DUMMY_WORD                      ] ""]
	
	variable RCRC_CMD                        00000007
	variable TYPE_1_WRITE_1_WORD_TO_IDCODE   30018001

	variable WRITE_TO_IDCODE_SEQ          [join [list                    \
	                                      $DUMMY_WORD                    \
	                                      $SYNC_WORD                     \
										  $TYPE_1_NOOP_WORD_0            \
										  $TYPE_1_WRITE_1_WORD_TO_CMD    \
										  $RCRC_CMD                      \
										  $TYPE_1_WRITE_1_WORD_TO_IDCODE ] ""]
										  
	variable UNKNOWN_CMD					 00000001
											
	variable WRITE_TO_FAR_WO_DUMMY_SEQ    [join [list                 \
										  $TYPE_1_WRITE_1_WORD_TO_CMD \
										  $UNKNOWN_CMD                \
										  $TYPE_1_NOOP_WORD_0         \
										  $TYPE_1_WRITE_1_WORD_TO_FAR ] ""]
	
	variable TYPE_1_READ_0_WORDS_FROM_FDRI   30004000
	variable TYPE_2_READ_202_WORDS_FROM_FDRI 500000CA
	
	variable READ_FDRI_SEQ                [join [list                      \
	                                      $TYPE_1_NOOP_WORD_0              \
										  $TYPE_1_READ_0_WORDS_FROM_FDRI   \
										  $TYPE_2_READ_202_WORDS_FROM_FDRI ] ""]
	
	variable id_code
	variable ir_length
	variable WORDS_PER_FRAME 101
	variable BITS_PER_WORD   32
	variable pblock_coordinates "None"
	variable lut_sefi_scrubbing_enabled false
	variable golden_frame_data_hex
	
	variable ir_seq
	variable dr_seq
	
	variable dr_write
    variable dr_read

	# initialize device if active device is selected
	proc initialize {} {
		xsdb::connect
		update_active_device
	}

	proc targets {args} {
		xsdb::connect
		if {[llength $args] == 0} {
			puts [jtag targets]
		} else {
			jtag targets {*}$args
			update_active_device
		}
	}
	
	proc update_active_device {} {
		set jtag_targets [jtag targets]
		if {[regexp {\d+\* [^ ]+ \(idcode ([0-9a-fA-F]{8}) irlen (\d+) fpga\)} $jtag_targets match idcode irlength]} {
			set_id_code $idcode
			set_ir_length $irlength
			parse_frads_list_into_memory
		}
	}
	
	proc set_id_code {idcode} {
		variable id_code $idcode
	}
	
	proc set_ir_length {irlength} {
		variable ir_length $irlength
	}
	
	proc parse_frads_list_into_memory {} {
		variable VALID_CRAM_FRAMES [list]
		
		variable FRADS_FILES
		set frads_file [open $FRADS_FILES([get_id_code])]
		set frads_data [read $frads_file]
		foreach line [split $frads_data "\n"] {
			if {[regexp {[0-9A-Fa-f]{8}} $line hex_frad]} {
				if {$hex_frad != "FF000000"} {
					if {[is_configuration_frame_type_0 $hex_frad]} {
						lappend VALID_CRAM_FRAMES $hex_frad
					}
				}
			}
		}
	}


		
	proc is_configuration_frame_type_0 {hex_frad} {
		set bin_frad [hex_to_bin $hex_frad]
		return [expr [string range $bin_frad [expr 31 - 25] [expr 31 - 23]] == "000"]
	}
	
	proc read_id_code {} {
		variable CMD_IDCODE
		
		set_ir_seq     $CMD_IDCODE
		set_dr_seq_hex 00000000 0
		return [run_seq_lsb]
	}

	proc read_bscan {index words} {
		variable BITS_PER_WORD
		variable CMD_BSCAN
		
		set_ir_seq $CMD_BSCAN($index)
		set_dr_seq [join [lrepeat [expr $words*$BITS_PER_WORD] 0] ""] 0
		set hex_response [run_seq_msb]
		return $hex_response
	}
	
	proc write_bscan_hex {index data} {
		variable CMD_BSCAN
		
		set_ir_seq     $CMD_BSCAN($index)
		set_dr_seq_hex $data 0
		set hex_response [run_seq_msb]
		return $hex_response
	}

	proc set_ir_seq {value {reverse 1}} {
		if {$reverse} {
			set value [string reverse $value]
		}
		variable ir_seq $value
	}

	proc set_dr_seq_hex {hex_value {reverse 1}} {
		set bin_value [hex_to_bin $hex_value]
		set_dr_seq $bin_value $reverse
	}
	
	proc set_dr_seq {bin_value {reverse 1}} {
		if {$reverse} {
			set bin_value [string reverse $bin_value]
		}
		variable dr_seq $bin_value
	}
	
	proc run_seq_lsb {} {
		set result [run_seq_lsb_raw_response]
		return [bin_reverse_to_hex $result]
	}

	proc run_seq_msb {} {
		set result [run_seq_lsb_raw_response]
		return [bin_to_hex $result]
	}

	proc run_seq_lsb_raw_response {} {
		variable ir_seq
		variable dr_seq
		
		set seqname [jtag sequence]
		$seqname irshift -state IDLE -bits [get_ir_length] $ir_seq
		
		$seqname drshift -state IDLE -capture -bits [string length $dr_seq] $dr_seq

		set result [$seqname run -bits]

		$seqname delete

		return $result
	}

	proc read_frame {frame} {
		variable WORDS_PER_FRAME
		
		set raw_frame_data [read_raw_frame_data_hex $frame]
		set flag 0
		for {set i 0} {$i < $WORDS_PER_FRAME} {incr i} {
			set info $i
			set data_word 661
			if {$data_word != "00000000"} {
			set flag 1
			 if {$i < 10} {
				append info " "
			 }
			 append info ": " $data_word
			 puts $info
			}
		
		}
		
		return $flag
	}

	proc read_bit {frame word bit} {
		variable BITS_PER_WORD
		set raw_frame_data [read_raw_frame_data_bin $frame]
		set index [expr $word*$BITS_PER_WORD + ($BITS_PER_WORD - $bit - 1)]
		return [string range $raw_frame_data $index $index]
	}
	
	proc issue_gcapture {} {
	variable ISSUE_GCAPTURE_SEQ
		set_dr_write $ISSUE_GCAPTURE_SEQ
		set_dr_read 00000000
		run_config_seq_bin
	}
	
	proc inject_random_fault {{channel ""}} {
		variable VALID_CRAM_FRAMES
		variable WORDS_PER_FRAME
		variable BITS_PER_WORD
		
		set random_frame [lindex $VALID_CRAM_FRAMES [expr round(rand()*([llength $VALID_CRAM_FRAMES] - 1))]]
		set random_word [expr round(rand()*($WORDS_PER_FRAME - 1))]
		set random_bit [expr round(rand()*($BITS_PER_WORD - 1))]
		
		set result [inject_fault_internal $random_frame $random_word $random_bit $channel]
		return [list $random_frame $random_word $random_bit $result]
	}

	proc inject_fault {frame word bit} {
		return [inject_fault_internal $frame $word $bit stdout]
	}
	
	proc inject_fault_internal {frame word bit {channel ""}} {
		variable BITS_PER_WORD
		
		set data_raw_bin [read_raw_frame_data_bin $frame]
		set data_raw_hex [bin_to_hex $data_raw_bin]
			
		set data_inject_bin [flip_bit $data_raw_bin [expr $BITS_PER_WORD*$word + ($BITS_PER_WORD - $bit - 1)]]
		set data_inject_hex [bin_to_hex $data_inject_bin]

		write_frame_hex $frame $data_inject_hex
		
		after 100

		set data_new_hex [read_raw_frame_data_hex $frame]

		set flag 0
		if {$channel != ""} {
			puts $channel "    Data_Old \t Data_new"
		}
		for {set i 0} {$i <= 100} {incr i} {
			set info $i
			set data_word_old [string range $data_raw_hex [expr $i*8] [expr ($i+1)*8-1]]
			set data_word_new [string range $data_new_hex [expr $i*8] [expr ($i+1)*8-1]]
			if {($data_word_old != "00000000")||($data_word_new != "00000000")} {
			 if {$i < 10} {
				append info " "
			 }
			 if {$data_word_old == $data_word_new} {
			 append info ": " $data_word_old " \t " $data_word_new
			 } else {
			 set flag 1
			 append info ": " $data_word_old " ->\t " $data_word_new
			 }
			 if {$channel != ""} {
				puts $channel $info
			 }
			}
		
		}
		if {$flag == 0} {
			if {$channel != ""} {
				puts $channel "Write Failed (Unwritable Bit?)"
			}
			return 0
		}

		if {$channel != ""} {		
			puts $channel "done"
		}
		return 1
	
	}
	
	proc flip_bit { input bit } {
		set bit_value [string range $input $bit $bit]
		return [string replace $input $bit $bit [expr {[string equal $bit_value 0] ? 1 : 0}]]
	}

	
	proc read_raw_frame_data_hex {frame} {
		set data_bin [read_raw_frame_data_bin $frame]
		set data_hex [bin_to_hex $data_bin]
		return $data_hex
	}

	proc read_raw_frame_data_bin {frame} {
		variable WRITE_TO_FAR_SEQ
		variable READ_FDRO_SEQ
		variable WORDS_PER_FRAME
		variable BITS_PER_WORD

		set command $WRITE_TO_FAR_SEQ
		append command $frame $READ_FDRO_SEQ
		set_dr_write $command

		set_dr_read [join [lrepeat [expr 2*$WORDS_PER_FRAME*$BITS_PER_WORD/4] 0] ""]
		
		set result [run_config_seq_bin]
		
		set data_raw [string range $result [expr $WORDS_PER_FRAME*$BITS_PER_WORD] \
										   [expr 2*$WORDS_PER_FRAME*$BITS_PER_WORD - 1]]
	   
		return $data_raw
	}

	proc set_dr_write {value} {
		variable dr_write $value
	}

	proc set_dr_read {value} {
		variable dr_read $value
	}
	
	proc write_frame_hex {frame data_hex} {
		variable WRITE_TO_IDCODE_SEQ
		variable WRITE_TO_FAR_WO_DUMMY_SEQ
		variable READ_FDRI_SEQ
		variable WORDS_PER_FRAME
		variable BITS_PER_WORD
		
		set command_write $WRITE_TO_IDCODE_SEQ
		append command_write [get_id_code] $WRITE_TO_FAR_WO_DUMMY_SEQ
		append command_write $frame $READ_FDRI_SEQ
		set data_end [join [lrepeat [expr (1+$WORDS_PER_FRAME)*$BITS_PER_WORD/4] 0] ""]    
		append command_write $data_hex $data_end
		
		set_dr_write $command_write

		set_dr_read $data_end
		
		run_config_seq_bin

	}

	proc get_id_code {} {
		variable id_code
		return $id_code
	}

	proc run_config_seq_bin {} {
		variable CMD_CFG_IN
		variable CMD_CFG_OUT
		variable ir_seq
		
		set seqname [jtag sequence]
		$seqname state RESET
		
		set_ir_seq $CMD_CFG_IN
		$seqname irshift -state IDLE -bits [get_ir_length] $ir_seq

		set dr_cmd [hex_to_bin [get_dr_write] ]
		$seqname drshift -state IDLE -bits [string length $dr_cmd] $dr_cmd
		
		set_ir_seq $CMD_CFG_OUT
		$seqname irshift -state IDLE -bits [get_ir_length] $ir_seq
		
		set dr_cmd [hex_to_bin [get_dr_read] ]
		$seqname drshift -state IDLE -capture -bits [string length $dr_cmd] $dr_cmd

		set result [$seqname run -bits]
		
		$seqname delete
		
		return $result

	}

	proc get_ir_length {} {
		variable ir_length
		return  $ir_length
	}

	proc get_dr_write {} {
		variable dr_write
		return $dr_write
	}

	proc get_dr_read {} {
		variable dr_read
		return $dr_read
	}

	proc hex_to_bin {hex_value} {
		binary scan [binary format H* $hex_value] B* bit_value
		return $bit_value
	}

	proc dec_to_bin32 {dec_value} {
		binary scan [binary format I* $dec_value] B* bit_value
		return $bit_value
	}

	proc bin_reverse_to_hex {sequence} {
		set bin_reverse [string reverse $sequence]
		return [bin_to_hex $bin_reverse]
	}

	proc bin_to_hex {bin_value} {
		binary scan [binary format B* $bin_value] H* hex_value
		return $hex_value
	}
	

	
	proc idcode_c {} {

    set_dr_write AA99556620000000280180012000000020000000

    set_dr_read 00000000
    return [bin_to_hex [run_config_seq_bin]]

    }
	proc ctl0 {} {

    set_dr_write AA995566200000002800A0012000000020000000

    set_dr_read 00000000
    return [bin_to_hex [run_config_seq_bin]]

    }
	
    proc ctl0_nmask {} {

    set_dr_write AA995566200000003000C001000005013000A001000004012000000020000000

    set_dr_read 00000000
    return [bin_to_hex [run_config_seq_bin]]

    }
    
    proc test_valid_frames {start_idx end_idx} {
    
    variable VALID_CRAM_FRAMES
    
    if {[llength $VALID_CRAM_FRAMES] < $end_idx} {
        return "Too Far"
    }    
    
    set SUB_CRAM_FRAMES [lrange $VALID_CRAM_FRAMES $start_idx $end_idx]
    
    foreach hex_frad $SUB_CRAM_FRAMES {
           puts $hex_frad
           read_raw_frame_data_hex $hex_frad
        }
        
    return $SUB_CRAM_FRAMES 
    }
    


	initialize
}