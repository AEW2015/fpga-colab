"""
Xilinx TMR
===========
This is a xilinx TMR example using SpyDrNet SHREC
"""

import spydrnet as sdn
from spydrnet.uniquify import uniquify
from spydrnet_tmr import apply_nmr, insert_organs
from spydrnet_tmr.support_files.vendor_names import XILINX
from spydrnet_tmr.apply_tmr_to_netlist import apply_tmr_to_netlist
from spydrnet_tmr.analysis.voter_insertion.find_reduction_voter_points import find_reduction_voter_points
from spydrnet_tmr.analysis.voter_insertion.find_voter_insertion_points import find_voter_insertion_points
from spydrnet_tmr.transformation.replication.organ import XilinxTMRVoter
from spydrnet_tmr.transformation.replication.uniquify_nmr_property import uniquify_nmr_property 


def generate_tmr(input_file,output_file):
    # set_property design_mode GateLvl [current_fileset]
    # set_property edif_top_file <path_to_file> [current_fileset]
    # link_design -part <part_number> -mode out_of_context
    #netlist = sdn.load_example_netlist_by_name('b13')  # loading an example, use `sdn.parse(<netlist filename>)` otherwise
    netlist = sdn.parse(input_file)  # loading an example, use `sdn.parse(<netlist filename>)` otherwise

    # uniquify is called to insure that non-leaf definitions are instanced only once, prevents unintended transformations.
    uniquify(netlist)

    # set instances_to_replicate [get_cells -hierarchical -filter {PRIMITIVE_LEVEL==LEAF||PRIMITIVE_LEVEL==MACRO}]
    hinstances_to_replicate = list(netlist.get_hinstances(recursive=True, filter=lambda x: x.item.reference.is_leaf() is True))
    hinstances_to_replicate = list(x for x in hinstances_to_replicate if x.item.reference.name not in {'BSCANE2','OBUF','IBUF','OSERDESE2','ODDR','OBUFDS','MMCME2_ADV','ISERDESE2','IOBUFDS','IOBUF','IDELAYE2','IDELAYCTRL','IDDR','GND','VCC','IBUFDS','ISERDESE3','IDELAYE3','IOBUFDSE3','MMCME3_ADV','OBFUS','OSERDESE3','ODELAYE3'})
    hinstances_to_replicate = list(x for x in hinstances_to_replicate if (x.item.name.find('IDELAYCTRL_TOP_AND')==-1))
    hinstances_to_replicate_without_BUFGs = list(x for x in hinstances_to_replicate if x.item.reference.name not in {'BUFG','BUFGCE_DIV','BUFGCE'})
    instances_to_replicate = list(x.item for x in hinstances_to_replicate)



    # set ports_to_replicate [get_ports]
    hports_to_replicate = []#list(netlist.get_hports())
    ports_to_replicate = []#list(x.item for x in hports_to_replicate)

    # find out where to insert reduction and feedback voters
    insertion_points = find_voter_insertion_points(netlist, [*hinstances_to_replicate_without_BUFGs, *hports_to_replicate], {'FDRE', 'FDSE', 'FDPE', 'FDCE'})


    # replicate instances and ports
    replicas = apply_nmr([*instances_to_replicate, *ports_to_replicate], 3, name_suffix='TMR', rename_original=True)
    uniquify_nmr_property(replicas, {'HBLKNM', 'HLUTNM', 'SOFT_HLUTNM'}, "TMR")

    # insert voters on the selected drivers
    voters = insert_organs(replicas, insertion_points, XilinxTMRVoter(), 'VOTER')

    #compose out the netlist
    netlist.compose(output_file)
    