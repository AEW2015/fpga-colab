/*
 * Copyright © 2017 Eric Matthews,  Lesley Shannon
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Initial code developed under the supervision of Dr. Lesley Shannon,
 * Reconfigurable Computing Lab, Simon Fraser University.
 *
 * Author(s):
 *             Eric Matthews <ematthew@sfu.ca>
 */

import taiga_config::*;
import taiga_types::*;
import l2_config_and_types::*;

module taiga_wrapper (
        input  logic sys_clk,
        input  logic sys_rst,
        
        output logic [31:0]bus_axi_araddr,
        input  logic bus_axi_arready,
        output logic bus_axi_arvalid,
        output logic [31:0]bus_axi_awaddr,
        input  logic bus_axi_awready,
        output logic bus_axi_awvalid,
        output logic bus_axi_bready,
        input  logic [1:0]bus_axi_bresp,
        input  logic bus_axi_bvalid,
        input  logic [31:0]bus_axi_rdata,
        output logic bus_axi_rready,
        input  logic [1:0]bus_axi_rresp,
        input  logic bus_axi_rvalid,
        output logic [31:0]bus_axi_wdata,
        input  logic bus_axi_wready,
        output logic [3:0]bus_axi_wstrb,
        output logic bus_axi_wvalid,
        
        //Arbiter AXI interface
        input  logic axi_arready,
        output logic axi_arvalid,
        output logic[31:0] axi_araddr,
        output logic[3:0] axi_arlen,
        output logic[2:0] axi_arsize,
        output logic[1:0] axi_arburst,
        output logic[2:0] axi_arprot,
        output logic[3:0] axi_arcache,
        output logic[4:0] axi_arid,
        output logic [1:0]axi_arlock,
        output logic [3:0]axi_arqos,
    
        //read data channel
        output logic axi_rready,
        input  logic axi_rvalid,
        input  logic[31:0] axi_rdata,
        input  logic[1:0] axi_rresp,
        input  logic axi_rlast,
        input  logic[3:0] axi_rid,
    
        //write addr channel
        input  logic axi_awready,
        output logic axi_awvalid,
        output logic [31:0] axi_awaddr,
        output logic [7:0] axi_awlen,
        output logic [2:0] axi_awsize,
        output logic [1:0] axi_awburst,
        output logic [1:0] axi_awlock,
        output logic [3:0] axi_awqos,
        output logic [5:0] axi_awid,
    
        output logic[3:0] axi_awcache,
        output logic[2:0] axi_awprot,
    
        //write data
        input  logic axi_wready,
        output logic axi_wvalid,
        output logic [31:0] axi_wdata,
        output logic [3:0] axi_wstrb,
        output logic axi_wlast,
        output logic [5:0]axi_wid,
    
    
        //write response
        output logic axi_bready,
        input  logic axi_bvalid,
        input  logic [1:0] axi_bresp,
        input  logic [5:0] axi_bid,
        
        output logic imem_en,
        input  logic [31:0] imem_dout,
        output logic [31:0] imem_din,
        output logic [3:0]  imem_we,
        output logic [29:0] imem_addr,
        
        output logic dmem_en,
        input  logic [31:0] dmem_dout,
        output logic [31:0] dmem_din,
        output logic [3:0]  dmem_we,
        output logic [29:0] dmem_addr


        );
        
        
    parameter SCRATCH_MEM_KB = 16;
    parameter MEM_LINES = (SCRATCH_MEM_KB*1024)/4;


    logic clk;
    logic rst;

    axi_interface m_axi();
    avalon_interface m_avalon();
    wishbone_interface m_wishbone();
    l2_requester_interface l2[L2_NUM_PORTS-1:0]();
    l2_memory_interface mem();
    trace_outputs_t tr;

    logic interrupt;
    //logic placer_rseed;
    logic timer_interrupt = 0;

    assign interrupt = 0;
    
    logic [31:0] dec_pc_debug;
    logic dec_advance_debug;
    logic [31:0] dec_instruction;
    logic [31:0] if2_pc_debug;

    assign instruction_bram.data_out = imem_dout;
    assign imem_en = instruction_bram.en;
    assign imem_we = instruction_bram.be;
    assign imem_din = instruction_bram.data_in;
    assign imem_addr = instruction_bram.addr;

    assign data_bram.data_out = dmem_dout;
    assign dmem_en = data_bram.en;
    assign dmem_we = data_bram.be;
    assign dmem_din = data_bram.data_in;
    assign dmem_addr = data_bram.addr;

    assign clk = sys_clk;

    assign rst = sys_rst;


    assign m_axi.arready = bus_axi_arready;
    assign bus_axi_arvalid = m_axi.arvalid;
    assign bus_axi_araddr = m_axi.araddr;


    //read data
    assign bus_axi_rready = m_axi.rready;
    assign m_axi.rvalid = bus_axi_rvalid;
    assign m_axi.rdata = bus_axi_rdata;
    assign m_axi.rresp = bus_axi_rresp;

    //Write channel
    //write address
    assign m_axi.awready = bus_axi_awready;
    assign bus_axi_awaddr = m_axi.awaddr;
    assign bus_axi_awvalid = m_axi.awvalid;


    //write data
    assign m_axi.wready = bus_axi_wready;
    assign bus_axi_wvalid = m_axi. wvalid;
    assign bus_axi_wdata = m_axi.wdata;
    assign bus_axi_wstrb = m_axi.wstrb;

    //write response
    assign bus_axi_bready = m_axi.bready;
    assign m_axi.bvalid = bus_axi_bvalid;
    assign m_axi.bresp = bus_axi_bresp;


    local_memory_interface instruction_bram();
    local_memory_interface data_bram();

    taiga cpu(.*, .l2(l2[0]));


    generate
        if (ENABLE_S_MODE || USE_ICACHE || USE_DCACHE) begin
            l2_arbiter l2_arb (.*, .request(l2));
            axi_to_arb l2_to_mem (.*, .l2(mem));
        end
    endgenerate
endmodule