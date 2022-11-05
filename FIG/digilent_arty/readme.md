# Hackaday Supercon Space FGPA Demo

Release v0.0.3 has all pre-compiled files.

## Build Design under Test (DUT) 
### Requirements
* Vivado 2021.2 (can change tcl script for other versions)
### Build
* open Vivado
* cd to dut directory
* run in tcl console `source ./built_dut.tcl`
### output
* dut/outputs/kronos.bit
* dut/outputs/kronos.edf

## Build Triple Modular Redundant (TMR) DUT
### Requirements
* Google Colab or Jupyter Notebooks (local)
* dut/outputs/kronos.edf (can be found in release)
* Vivado 2021.2 (can change tcl script for other versions)
### Build
* Open Jupyter Notebook (tmr/digilent_arty_SpyDrNet_TMR.ipynb)
* Run all (default uses release binary)
* Download kronos_tmr.edf to (tmr/inputs)
* open Vivado
* cd to tmr directory
* run in tcl console `source ./built_tmr.tcl`
### output
* tmr/outputs/kronos_tmr.bit
* tmr/outputs/kronos_tmr.edf
* tmr/outputs/kronos_tmr.dcp

## Perform Fault Injection
### Requirements
* xsdb from Vivado or Vivado Lab
### Operation
* Have Vivado binaries on path
* From fault_injection directory, run `xsdb -interactive ./init_arty.tcl
* Open Jupyter Notebook (tmr/arty_a7_fault_injection.ipynb)
* Run all (uses outputs of dut and tmr directories)
* Lists ten errors for both designs
* See error_bits.json in releases for TMR Sensitive CRAM bits

## Perform Fault Analysis
### Requirements
* Google Colab or Jupyter Notebooks (local)
* Vivado
* tmr/outputs/kronos_tmr.edf (can be found in release)
* tmr/outputs/kronos_tmr.dcp (can be found in release)
* tmr/outputs/kronos_tmr.bit (can be found in release)
* error_bits.json (example in release)
### Build
* Open Jupyter Notebook (digilent_arty_BFAT.ipynb)
* Run all (default uses release binaries)
* Open kronos_tmr.dcp in Vivado
* Use error_bits_fault_report.txt Vivado tcl commands to trace errors 
