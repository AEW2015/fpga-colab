###############################################################################
#
#     File Name: generate_bitstream.xdc
#         Model: syn (Synthesisable)
#
#  Dependencies:
#
#       Company: Alpha Data
#        Design: various
#
#   Description: Vivado constraints file for bitstream generation, targeting
#                the ADA-SDEV-KIT.
#
#   Limitations:
#
#         Notes:
#
#    Disclaimer: THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY
#                WHATSOEVER AND ALPHA DATA SPECIFICALLY DISCLAIMS ANY
#                IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR
#                A PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
#
#                Copyright (C) 2013-2015 Alpha Data, All rights reserved
#
#     Revisions: 0.1, SM, 18 Dec 2018: Initial design
#
###############################################################################

# Configuration from SPI Flash as per XAPP1233
# Enable bitstream compression
set_property BITSTREAM.GENERAL.COMPRESS FALSE [current_design]

set_property CONFIG_MODE S_SELECTMAP32 [current_design]

set_property BITSTREAM.CONFIG.PERSIST YES [current_design]

# Don't pull unused pins up or down
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullnone [current_design]

# Set CFGBVS to GND to match schematics
set_property CFGBVS GND [current_design]

# Set CONFIG_VOLTAGE to 1.8V to match schematics
set_property CONFIG_VOLTAGE 1.8 [current_design]

# Set safety trigger to power down FPGA at 125degC
set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN Enable [current_design]




