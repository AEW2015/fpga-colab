----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/14/2019 09:32:38 AM
-- Design Name: 
-- Module Name: taiga_vhdl - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity taiga_vhdl is
    Port ( 
    sys_clk                 : in STD_LOGIC;
    sys_rst                 : in STD_LOGIC;
    
    bus_axi_araddr      : out STD_LOGIC_VECTOR ( 31 downto 0);
    bus_axi_arready     : in  STD_LOGIC;
    bus_axi_arvalid     : out STD_LOGIC;
    bus_axi_awaddr      : out STD_LOGIC_VECTOR ( 31 downto 0);
    bus_axi_awready     : in  STD_LOGIC;
    bus_axi_awvalid     : out STD_LOGIC;
    bus_axi_bready      : out STD_LOGIC;
    bus_axi_bresp       : in  STD_LOGIC_VECTOR ( 1 downto 0);
    bus_axi_bvalid      : in  STD_LOGIC;
    bus_axi_rdata       : in  STD_LOGIC_VECTOR ( 31 downto 0);
    bus_axi_rready      : out STD_LOGIC;
    bus_axi_rresp       : in  STD_LOGIC_VECTOR ( 1 downto 0);
    bus_axi_rvalid      : in  STD_LOGIC;
    bus_axi_wdata       : out STD_LOGIC_VECTOR ( 31 downto 0);
    bus_axi_wready      : in  STD_LOGIC;
    bus_axi_wstrb       : out STD_LOGIC_VECTOR ( 3 downto 0);
    bus_axi_wvalid      : out STD_LOGIC;
    --bus_axi_clk         : out STD_LOGIC;
    
    --axi_clk         : out STD_LOGIC;
    
    --Arbiter AXI interface
    axi_arready         : in  STD_LOGIC;
    axi_arvalid         : out  STD_LOGIC;
    axi_araddr          : out STD_LOGIC_VECTOR ( 31 downto 0) := (others=>'0');
    axi_arlen           : out STD_LOGIC_VECTOR ( 3 downto 0) := (others=>'0');
    axi_arsize          : out STD_LOGIC_VECTOR ( 2 downto 0) := (others=>'0');
    axi_arburst         : out STD_LOGIC_VECTOR ( 1 downto 0) := (others=>'0');
    axi_arprot          : out STD_LOGIC_VECTOR ( 2 downto 0) := (others=>'0');
    axi_arcache         : out STD_LOGIC_VECTOR ( 3 downto 0) := (others=>'0');
    --axi_arid            : out STD_LOGIC_VECTOR ( 4 downto 0) := (others=>'0');
    axi_arlock          : out STD_LOGIC_VECTOR ( 1 downto 0) := (others=>'0');
    axi_arqos           : out STD_LOGIC_VECTOR ( 3 downto 0) := (others=>'0');

    --read data channel
    axi_rready          : out STD_LOGIC;
    axi_rvalid          : in  STD_LOGIC;
    axi_rdata           : in  STD_LOGIC_VECTOR ( 31 downto 0);
    axi_rresp           : in  STD_LOGIC_VECTOR ( 1 downto 0);
    axi_rlast           : in  STD_LOGIC;
    --axi_rid             : in  STD_LOGIC_VECTOR ( 3 downto 0);

    --write addr channel
    axi_awready         : in  STD_LOGIC;
    axi_awvalid         : out STD_LOGIC;
    axi_awaddr          : out STD_LOGIC_VECTOR ( 31 downto 0) := (others=>'0');
    axi_awlen           : out STD_LOGIC_VECTOR ( 7 downto 0) := (others=>'0');
    axi_awsize          : out STD_LOGIC_VECTOR ( 2 downto 0) := (others=>'0');
    axi_awburst         : out STD_LOGIC_VECTOR ( 1 downto 0) := (others=>'0');
    axi_awlock          : out STD_LOGIC_VECTOR ( 1 downto 0) := (others=>'0');
    axi_awqos           : out STD_LOGIC_VECTOR ( 3 downto 0) := (others=>'0');
    --axi_awid            : out STD_LOGIC_VECTOR ( 5 downto 0) := (others=>'0');
  
    axi_awcache         : out STD_LOGIC_VECTOR ( 3 downto 0) := (others=>'0');
    axi_awprot          : out STD_LOGIC_VECTOR ( 2 downto 0) := (others=>'0');

    --write data
    axi_wready          : in  STD_LOGIC;
    axi_wvalid          : out STD_LOGIC;
    axi_wdata           : out STD_LOGIC_VECTOR ( 31 downto 0) := (others=>'0');
    axi_wstrb           : out STD_LOGIC_VECTOR ( 3 downto 0) := (others=>'0');
    axi_wlast           : out STD_LOGIC;
    --axi_wid             : out STD_LOGIC_VECTOR ( 5 downto 0) := (others=>'0');


    --write response
    axi_bready          : out STD_LOGIC;
    axi_bvalid          : in  STD_LOGIC;
    axi_bresp           : in  STD_LOGIC_VECTOR ( 1 downto 0);
    --axi_bid             : in STD_LOGIC_VECTOR ( 5 downto 0);
    
    imem_en             : out STD_LOGIC;
    imem_dout           : in  STD_LOGIC_VECTOR ( 31 downto 0);
    imem_din            : out STD_LOGIC_VECTOR ( 31 downto 0);
    imem_we             : out STD_LOGIC_VECTOR (  3 downto 0);
    imem_addr           : out STD_LOGIC_VECTOR ( 31 downto 0);
    imem_clk            : out STD_LOGIC;
    imem_rst            : out STD_LOGIC;
    
    dmem_en             : out STD_LOGIC;
    dmem_dout           : in  STD_LOGIC_VECTOR ( 31 downto 0);
    dmem_din            : out STD_LOGIC_VECTOR ( 31 downto 0);
    dmem_we             : out STD_LOGIC_VECTOR (  3 downto 0);
    dmem_addr           : out STD_LOGIC_VECTOR ( 31 downto 0);
    dmem_clk            : out STD_LOGIC;
    dmem_rst            : out STD_LOGIC
    
    
    
    );
end taiga_vhdl;

architecture Behavioral of taiga_vhdl is

ATTRIBUTE X_INTERFACE_INFO : string;

ATTRIBUTE X_INTERFACE_INFO OF imem_addr : SIGNAL IS "xilinx.com:interface:bram:1.0 imem ADDR";
ATTRIBUTE X_INTERFACE_INFO OF imem_clk  : SIGNAL IS "xilinx.com:interface:bram:1.0 imem CLK";
ATTRIBUTE X_INTERFACE_INFO OF imem_din  : SIGNAL IS "xilinx.com:interface:bram:1.0 imem DIN";
ATTRIBUTE X_INTERFACE_INFO OF imem_dout : SIGNAL IS "xilinx.com:interface:bram:1.0 imem DOUT";
ATTRIBUTE X_INTERFACE_INFO OF imem_en   : SIGNAL IS "xilinx.com:interface:bram:1.0 imem EN";
ATTRIBUTE X_INTERFACE_INFO OF imem_rst  : SIGNAL IS "xilinx.com:interface:bram:1.0 imem RST";
ATTRIBUTE X_INTERFACE_INFO OF imem_we   : SIGNAL IS "xilinx.com:interface:bram:1.0 imem WE";

ATTRIBUTE X_INTERFACE_INFO OF dmem_addr : SIGNAL IS "xilinx.com:interface:bram:1.0 dmem ADDR";
ATTRIBUTE X_INTERFACE_INFO OF dmem_clk  : SIGNAL IS "xilinx.com:interface:bram:1.0 dmem CLK";
ATTRIBUTE X_INTERFACE_INFO OF dmem_din  : SIGNAL IS "xilinx.com:interface:bram:1.0 dmem DIN";
ATTRIBUTE X_INTERFACE_INFO OF dmem_dout : SIGNAL IS "xilinx.com:interface:bram:1.0 dmem DOUT";
ATTRIBUTE X_INTERFACE_INFO OF dmem_en   : SIGNAL IS "xilinx.com:interface:bram:1.0 dmem EN";
ATTRIBUTE X_INTERFACE_INFO OF dmem_rst  : SIGNAL IS "xilinx.com:interface:bram:1.0 dmem RST";
ATTRIBUTE X_INTERFACE_INFO OF dmem_we   : SIGNAL IS "xilinx.com:interface:bram:1.0 dmem WE";

signal zeros : std_logic_vector(31 downto 0) := (others=>'0');

begin

--axi_clk <= sys_clk;
--bus_axi_clk <= sys_clk;

imem_clk <= sys_clk;
imem_rst <= sys_rst;

dmem_clk <= sys_clk;
dmem_rst <= sys_rst;

core : entity work.taiga_wrapper
port map(
    sys_clk             => sys_clk,
    sys_rst             => sys_rst,
    
    bus_axi_araddr       => bus_axi_araddr,
    bus_axi_arready      => bus_axi_arready,
    bus_axi_arvalid      => bus_axi_arvalid,
    bus_axi_awaddr       => bus_axi_awaddr,
    bus_axi_awready      => bus_axi_awready,
    bus_axi_awvalid      => bus_axi_awvalid,
    bus_axi_bready       => bus_axi_bready,
    bus_axi_bresp        => bus_axi_bresp,
    bus_axi_bvalid       => bus_axi_bvalid,
    bus_axi_rdata        => bus_axi_rdata,
    bus_axi_rready       => bus_axi_rready,
    bus_axi_rresp        => bus_axi_rresp,
    bus_axi_rvalid       => bus_axi_rvalid,
    bus_axi_wdata        => bus_axi_wdata,
    bus_axi_wready       => bus_axi_wready,
    bus_axi_wstrb        => bus_axi_wstrb,
    bus_axi_wvalid       => bus_axi_wvalid,
    
    --Arbiter AXI interface
    axi_arready          => axi_arready,
    axi_arvalid          => axi_arvalid,
    axi_araddr           => axi_araddr,
    axi_arlen            => axi_arlen,
    axi_arsize           => axi_arsize,
    axi_arburst          => axi_arburst,
    axi_arprot           => open,
    axi_arcache          => axi_arcache,
    axi_arid             => open,
    axi_arlock           => open,
    axi_arqos            => open,

    --read data channel
    axi_rready           => axi_rready,
    axi_rvalid           => axi_rvalid,
    axi_rdata            => axi_rdata,
    axi_rresp            => axi_rresp,
    axi_rlast            => axi_rlast,
    axi_rid              => zeros(3 downto 0),

    --write addr channel
    axi_awready          => axi_awready,
    axi_awvalid          => axi_awvalid,
    axi_awaddr           => axi_awaddr,
    axi_awlen            => axi_awlen,
    axi_awsize           => axi_awsize,
    axi_awburst          => axi_awburst,
    axi_awlock           => open,
    axi_awqos            => open,
    axi_awid             => open,

    axi_awcache          => axi_awcache,
    axi_awprot           => open,

    --write data
    axi_wready           => axi_wready,
    axi_wvalid           => axi_wvalid,
    axi_wdata            => axi_wdata,
    axi_wstrb            => axi_wstrb,
    axi_wlast            => axi_wlast,
    axi_wid              => open,


    --write response
    axi_bready           => axi_bready,
    axi_bvalid           => axi_bvalid,
    axi_bresp            => axi_bresp,
    axi_bid              => zeros(5 downto 0),
    
    imem_en              => imem_en,
    imem_dout            => imem_dout,
    imem_din             => imem_din,
    imem_we              => imem_we,
    imem_addr            => imem_addr(31 downto 2),
    
    dmem_en              => dmem_en,
    dmem_dout            => dmem_dout,
    dmem_din             => dmem_din,
    dmem_we              => dmem_we,
    dmem_addr            => dmem_addr(31 downto 2)
    );

    imem_addr ( 1 downto 0) <= "00";
    dmem_addr ( 1 downto 0) <= "00";

end Behavioral;
