set_property PACKAGE_PIN H22 [get_ports clk_p]
create_clock -period 4.000 -name input_clk -waveform {0.000 2.000} [get_ports clk_p]
set_property IOSTANDARD DIFF_HSTL_I [get_ports clk_p]
set_property IOSTANDARD DIFF_HSTL_I [get_ports clk_n]

set_property PACKAGE_PIN D20 [get_ports tx]
set_property IOSTANDARD LVCMOS18 [get_ports tx]


set_property PULLUP true [get_ports tx]

set_property OFFCHIP_TERM NONE [get_ports tx]
set_property SLEW FAST [get_ports tx]

#todo uart placement!
