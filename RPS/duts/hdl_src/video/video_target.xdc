set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports clk_p]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_p]

set_property PACKAGE_PIN AA19 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]
#set_property PULLUP true [get_ports tx]
#set_property SLEW FAST [get_ports tx]

set_property OFFCHIP_TERM NONE [get_ports tx]
set_property PACKAGE_PIN T4 [get_ports clk_n]
set_property IOSTANDARD LVCMOS33 [get_ports clk_n]
