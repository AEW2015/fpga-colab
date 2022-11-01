set_property PACKAGE_PIN E3 [get_ports clk_in]
create_clock -period 10.000 -name input_clk -waveform {0.000 5.000} [get_ports clk_in]

set_property IOSTANDARD LVCMOS33  [get_ports clk_in]

set_property PACKAGE_PIN D10 [get_ports tx]
set_property IOSTANDARD LVCMOS33  [get_ports tx]

set_property PULLUP true [get_ports tx]

set_property OFFCHIP_TERM NONE [get_ports tx]
set_property SLEW FAST [get_ports tx]