set_property PACKAGE_PIN W23 [get_ports clk_p]
create_clock -period 5.000 -name input_clk -waveform {0.000 2.500} [get_ports clk_p]

set_property IOSTANDARD LVDS [get_ports clk_p]
set_property IOSTANDARD LVDS [get_ports clk_n]

set_property PACKAGE_PIN AE12 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]



