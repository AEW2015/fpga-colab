----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2021 04:45:09 PM
-- Design Name: 
-- Module Name: noel_wrap - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library grlib;
use grlib.amba.all;
library gaisler;
use gaisler.noelv.all;
use gaisler.axi.all;



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity noel_wrap is
    Port ( clk : in std_logic;
           rstn: in std_logic;
           axi4bus_araddr      : out STD_LOGIC_VECTOR ( 31 downto 0);
           axi4bus_arready     : in  STD_LOGIC;
           axi4bus_arvalid     : out STD_LOGIC;
           axi4bus_arid        : out STD_LOGIC_VECTOR (  0 downto 0);  
           axi4bus_arregion    : out STD_LOGIC_VECTOR (  3 downto 0);  
           axi4bus_arlen       : out STD_LOGIC_VECTOR (  7 downto 0);  
           axi4bus_arsize      : out STD_LOGIC_VECTOR (  2 downto 0);  
           axi4bus_arburst     : out STD_LOGIC_VECTOR (  1 downto 0);  
           axi4bus_arlock      : out STD_LOGIC_VECTOR (  0 downto 0);  
           axi4bus_arcache     : out STD_LOGIC_VECTOR (  3 downto 0);  
           axi4bus_arqos       : out STD_LOGIC_VECTOR (  3 downto 0);  
           axi4bus_arprot      : out STD_LOGIC_VECTOR (  2 downto 0);  
           
           axi4bus_rdata       : in  STD_LOGIC_VECTOR ( 31 downto 0);
           axi4bus_rready      : out STD_LOGIC;
           axi4bus_rresp       : in  STD_LOGIC_VECTOR ( 1 downto 0);
           axi4bus_rid         : in  STD_LOGIC_VECTOR ( 0 downto 0);
           axi4bus_rvalid      : in  STD_LOGIC;
           axi4bus_rlast       : in  STD_LOGIC;
           
           axi4bus_awaddr      : out STD_LOGIC_VECTOR ( 31 downto 0);
           axi4bus_awready     : in  STD_LOGIC;
           axi4bus_awvalid     : out STD_LOGIC;
           axi4bus_awid        : out STD_LOGIC_VECTOR (  0 downto 0);
           axi4bus_awregion    : out STD_LOGIC_VECTOR (  3 downto 0);  
           axi4bus_awlen       : out STD_LOGIC_VECTOR (  7 downto 0);  
           axi4bus_awsize      : out STD_LOGIC_VECTOR (  2 downto 0);  
           axi4bus_awburst     : out STD_LOGIC_VECTOR (  1 downto 0);  
           axi4bus_awlock      : out STD_LOGIC_VECTOR (  0 downto 0);  
           axi4bus_awcache     : out STD_LOGIC_VECTOR (  3 downto 0);  
           axi4bus_awqos       : out STD_LOGIC_VECTOR (  3 downto 0);  
           axi4bus_awprot      : out STD_LOGIC_VECTOR (  2 downto 0);  
           
           axi4bus_wdata       : out STD_LOGIC_VECTOR ( 31 downto 0);
           axi4bus_wready      : in  STD_LOGIC;
           axi4bus_wstrb       : out STD_LOGIC_VECTOR ( 3 downto 0);
           axi4bus_wvalid      : out STD_LOGIC;
           axi4bus_wlast       : out  STD_LOGIC;
           
           axi4bus_bready      : out STD_LOGIC;
           axi4bus_bresp       : in  STD_LOGIC_VECTOR ( 1 downto 0);
           axi4bus_bvalid      : in  STD_LOGIC;
           axi4bus_bid         : in  STD_LOGIC_VECTOR ( 0 downto 0)
           );
end noel_wrap;

architecture Behavioral of noel_wrap is


signal ahbi  :ahb_mst_in_type;
signal ahbo  :ahb_mst_out_type;
signal ahbsi :ahb_slv_in_type;
signal ahbso :ahb_slv_out_type;
signal aximi :axi_somi_type;
signal aximo :axi4_mosi_type;



signal ahbsi_zero :ahb_slv_in_type;
signal ahbso_zero :ahb_slv_out_vector;
signal irqi :nv_irq_in_type;
signal dbgi :nv_debug_in_type;

begin

axi4bus_araddr      <= aximo.ar.addr;
aximi.ar.ready  <= axi4bus_arready;
axi4bus_arvalid     <= aximo.ar.valid; 
axi4bus_arid        <= aximo.ar.id;  
axi4bus_arregion    <= (others => '0');  
axi4bus_arlen       <= aximo.ar.len;  
axi4bus_arsize      <= aximo.ar.size;  
axi4bus_arburst     <= aximo.ar.burst;  
axi4bus_arlock(0)   <= aximo.ar.lock;  
axi4bus_arcache     <= aximo.ar.cache;  
axi4bus_arqos       <= aximo.ar.qos;  
axi4bus_arprot      <= aximo.ar.prot;  
                
aximi.r.data (31 downto 24)    <= axi4bus_rdata ( 7 downto  0);
aximi.r.data (23 downto 16)    <= axi4bus_rdata (15 downto  8);
aximi.r.data (15 downto  8)    <= axi4bus_rdata (23 downto 16);
aximi.r.data ( 7 downto  0)    <= axi4bus_rdata (31 downto 24);

axi4bus_rready      <= aximo.r.ready;
aximi.r.resp    <= axi4bus_rresp;
aximi.r.id      <= axi4bus_rid;
aximi.r.valid   <= axi4bus_rvalid;
aximi.r.last    <= axi4bus_rlast;
                
axi4bus_awaddr      <= aximo.aw.addr;
aximi.aw.ready  <= axi4bus_awready;
axi4bus_awvalid     <= aximo.aw.valid;
axi4bus_awid        <= aximo.aw.id;
axi4bus_awregion    <= (others => '0');  
axi4bus_awlen       <= aximo.aw.len;  
axi4bus_awsize      <= aximo.aw.size;  
axi4bus_awburst     <= aximo.aw.burst;  
axi4bus_awlock(0)   <= aximo.aw.lock;  
axi4bus_awcache     <= aximo.aw.cache;  
axi4bus_awqos       <= aximo.aw.qos;  
axi4bus_awprot      <= aximo.aw.prot;  
                
axi4bus_wdata (31 downto 24)     <= aximo.w.data ( 7 downto  0);
axi4bus_wdata (23 downto 16)     <= aximo.w.data (15 downto  8);
axi4bus_wdata (15 downto  8)     <= aximo.w.data (23 downto 16);
axi4bus_wdata ( 7 downto  0)     <= aximo.w.data (31 downto 24);

aximi.w.ready   <= axi4bus_wready;
axi4bus_wstrb       <= aximo.w.strb;
axi4bus_wvalid      <= aximo.w.valid;
axi4bus_wlast       <= aximo.w.last;
               
axi4bus_bready      <= aximo.b.ready;
aximi.b.resp    <= axi4bus_bresp;
aximi.b.valid   <= axi4bus_bvalid;
aximi.b.id      <= axi4bus_bid;




ahbsi.haddr <= ahbo.haddr;
ahbsi.hwrite <= ahbo.hwrite;
ahbsi.htrans <= ahbo.htrans;
ahbsi.hsize <= ahbo.hsize;
ahbsi.hburst <= ahbo.hburst;
ahbsi.hwdata <= ahbo.hwdata;
ahbsi.hprot <= ahbo.hprot;

ahbi.hgrant <= (others=> '1');
ahbi.hready <= ahbso.hready;
ahbi.hresp <= ahbso.hresp;
ahbi.hrdata <= ahbso.hrdata;


ahbm2axi4_i : entity work.ahbm2axi4 
    port map(
    clk   => clk,
    rstn  => rstn,
    ahbsi => ahbsi,
    ahbso => ahbso,
    aximi => aximi,
    aximo => aximo
    );


noelvcpu_i : entity work.noelvcpu
    port map(
    clk   => clk,
    rstn  => rstn,
    ahbi  => ahbi,
    ahbo  => ahbo,
    ahbsi => ahbsi_zero,
    ahbso => ahbso_zero,
    irqi  => irqi,
    --irqo  : out nv_irq_out_type;
    dbgi  => dbgi
    --dbgo  : out nv_debug_out_type;
    --cnt   : out nv_counter_out_type
    );   


end Behavioral;
