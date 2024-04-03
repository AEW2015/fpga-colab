# Radiation Processor Systems (RPS)

## Examples
Currently Built for Vivado 2019.1 (my favorite version)

Noel-v Depenency: https://www.gaisler.com/products/grlib/grlib-gpl-2021.2-b4267.tar.gz -> ./duts/noelv/

### Design Generation
  * In Vivdao run `source src_proc.tcl'.
  * In this any DUT directory with Vivado tcl console, run `src ./<dut>_prj.tcl <proc count> <target> <interface>` 
  * Processor Count (Optional, Default is 1)
    * `1+`
  * Targets (Optional, Default is devkit2)
    * `devkit2`
    * `aesku40`
    * `kupci`
    * `video`
  * Interface (Optional, Default is UART)
    * `BRAM` ~ Need Example reader for this...

### TMR Netlist generation
  * In the TMR directory, 
  * pip install . submodules
    * `spydrnet`
    * `spydrnet-tmr`
  * `python3 ./generat_tmr_edifs.py`

### TMR PAR
  * from the TMR directory, in Vivado:
    * `source par_tmr_designs.tcl`
