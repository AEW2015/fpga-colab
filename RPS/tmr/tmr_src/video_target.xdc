set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports clk_p]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_p]

set_property PACKAGE_PIN AA19 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]
#set_property PULLUP true [get_ports tx]
#set_property SLEW FAST [get_ports tx]

set_property PACKAGE_PIN T4 [get_ports clk_n]
set_property IOSTANDARD LVCMOS33 [get_ports clk_n]

create_pblock uart_pb
add_cells_to_pblock [get_pblocks uart_pb] [get_cells -quiet [list gen_uart.uart_port_i/TX_i/TX_i/tx_reg_reg_TMR_0_Q_VOTER]]
resize_pblock [get_pblocks uart_pb] -add {SLICE_X0Y123:SLICE_X1Y124}

