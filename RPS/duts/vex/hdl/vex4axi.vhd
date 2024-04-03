----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/10/2019 05:25:46 PM
-- Design Name: 
-- Module Name: pico_top - Behavioral
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

entity vex4axi is
    Port ( 
    sys_clk                 : in STD_LOGIC;
    
    ibus_araddr      : out STD_LOGIC_VECTOR ( 31 downto 0);
    ibus_arready     : in  STD_LOGIC;
    ibus_arvalid     : out STD_LOGIC;
    ibus_arid        : out STD_LOGIC_VECTOR (  0 downto 0);  
    ibus_arregion    : out STD_LOGIC_VECTOR (  3 downto 0);  
    ibus_arlen       : out STD_LOGIC_VECTOR (  7 downto 0);  
    ibus_arsize      : out STD_LOGIC_VECTOR (  2 downto 0);  
    ibus_arburst     : out STD_LOGIC_VECTOR (  1 downto 0);  
    ibus_arlock      : out STD_LOGIC_VECTOR (  0 downto 0);  
    ibus_arcache     : out STD_LOGIC_VECTOR (  3 downto 0);  
    ibus_arqos       : out STD_LOGIC_VECTOR (  3 downto 0);  
    ibus_arprot      : out STD_LOGIC_VECTOR (  2 downto 0);  
    
    ibus_rdata       : in  STD_LOGIC_VECTOR ( 31 downto 0);
    ibus_rready      : out STD_LOGIC;
    ibus_rresp       : in  STD_LOGIC_VECTOR ( 1 downto 0);
    ibus_rid         : in  STD_LOGIC_VECTOR ( 0 downto 0);
    ibus_rvalid      : in  STD_LOGIC;
    ibus_rlast       : in  STD_LOGIC;
    
    dbus_araddr      : out STD_LOGIC_VECTOR ( 31 downto 0);
    dbus_arready     : in  STD_LOGIC;
    dbus_arvalid     : out STD_LOGIC;
    dbus_arid        : out STD_LOGIC_VECTOR (  0 downto 0);  
    dbus_arregion    : out STD_LOGIC_VECTOR (  3 downto 0);  
    dbus_arlen       : out STD_LOGIC_VECTOR (  7 downto 0);  
    dbus_arsize      : out STD_LOGIC_VECTOR (  2 downto 0);  
    dbus_arburst     : out STD_LOGIC_VECTOR (  1 downto 0);  
    dbus_arlock      : out STD_LOGIC_VECTOR (  0 downto 0);  
    dbus_arcache     : out STD_LOGIC_VECTOR (  3 downto 0);  
    dbus_arqos       : out STD_LOGIC_VECTOR (  3 downto 0);  
    dbus_arprot      : out STD_LOGIC_VECTOR (  2 downto 0);  
    
    dbus_rdata       : in  STD_LOGIC_VECTOR ( 31 downto 0);
    dbus_rready      : out STD_LOGIC;
    dbus_rresp       : in  STD_LOGIC_VECTOR ( 1 downto 0);
    dbus_rid         : in  STD_LOGIC_VECTOR ( 0 downto 0);
    dbus_rvalid      : in  STD_LOGIC;
    dbus_rlast       : in  STD_LOGIC;
    		
    dbus_awaddr      : out STD_LOGIC_VECTOR ( 31 downto 0);
    dbus_awready     : in  STD_LOGIC;
    dbus_awvalid     : out STD_LOGIC;
    dbus_awid        : out STD_LOGIC_VECTOR (  0 downto 0);
    dbus_awregion    : out STD_LOGIC_VECTOR (  3 downto 0);  
    dbus_awlen       : out STD_LOGIC_VECTOR (  7 downto 0);  
    dbus_awsize      : out STD_LOGIC_VECTOR (  2 downto 0);  
    dbus_awburst     : out STD_LOGIC_VECTOR (  1 downto 0);  
    dbus_awlock      : out STD_LOGIC_VECTOR (  0 downto 0);  
    dbus_awcache     : out STD_LOGIC_VECTOR (  3 downto 0);  
    dbus_awqos       : out STD_LOGIC_VECTOR (  3 downto 0);  
    dbus_awprot      : out STD_LOGIC_VECTOR (  2 downto 0);  
    
    dbus_wdata       : out STD_LOGIC_VECTOR ( 31 downto 0);
    dbus_wready      : in  STD_LOGIC;
    dbus_wstrb       : out STD_LOGIC_VECTOR ( 3 downto 0);
    dbus_wvalid      : out STD_LOGIC;
    dbus_wlast       : out  STD_LOGIC;
	
    dbus_bready      : out STD_LOGIC;
    dbus_bresp       : in  STD_LOGIC_VECTOR ( 1 downto 0);
    dbus_bvalid      : in  STD_LOGIC;
    dbus_bid         : in  STD_LOGIC_VECTOR ( 0 downto 0);
   
    sys_rst                 : in STD_LOGIC

    );
end vex4axi;

architecture Behavioral of vex4axi is
  


    signal zeros : std_logic_vector (31 downto 0) := (others=>'0');
    signal ones : std_logic_vector (31 downto 0) := (others=>'1');




begin

   

    --Pico Core
    core : entity work.VexRiscvAxi4
    port map(
        clk     => sys_clk   ,
        reset  => sys_rst,
        
        iBusAxi_ar_valid => ibus_arvalid,
        iBusAxi_ar_ready => ibus_arready,     
        iBusAxi_ar_payload_addr => ibus_araddr,
        iBusAxi_ar_payload_id => ibus_arid,
        iBusAxi_ar_payload_region => ibus_arregion,
        iBusAxi_ar_payload_len => ibus_arlen,
        iBusAxi_ar_payload_size => ibus_arsize,
        iBusAxi_ar_payload_burst => ibus_arburst,
        iBusAxi_ar_payload_lock => ibus_arlock,
        iBusAxi_ar_payload_cache => ibus_arcache,
        iBusAxi_ar_payload_qos => ibus_arqos,
        iBusAxi_ar_payload_prot => ibus_arprot,
        iBusAxi_r_valid => ibus_rvalid,
        iBusAxi_r_ready => ibus_rready,
        iBusAxi_r_payload_data => ibus_rdata,
        iBusAxi_r_payload_id => ibus_rid,
        iBusAxi_r_payload_resp => ibus_rresp,
        iBusAxi_r_payload_last => ibus_rlast,
        
        dzBusAxi_aw_valid                    => dbus_awvalid,
        dzBusAxi_aw_ready                   => dbus_awready,
        dzBusAxi_aw_payload_addr                   => dbus_awaddr,
        dzBusAxi_aw_payload_id                   => dbus_awid,
        dzBusAxi_aw_payload_region                   => dbus_awregion,
        dzBusAxi_aw_payload_len                   => dbus_awlen,
        dzBusAxi_aw_payload_size                   => dbus_awsize,
        dzBusAxi_aw_payload_burst                   => dbus_awburst,
        dzBusAxi_aw_payload_lock                   => dbus_awlock,
        dzBusAxi_aw_payload_cache                   => dbus_awcache,
        dzBusAxi_aw_payload_qos                   => dbus_awqos,
        dzBusAxi_aw_payload_prot                   => dbus_awprot,
        dzBusAxi_w_valid                   => dbus_wvalid,
        dzBusAxi_w_ready                   => dbus_wready,
        dzBusAxi_w_payload_data                   => dbus_wdata,
        dzBusAxi_w_payload_strb                   => dbus_wstrb,
        dzBusAxi_w_payload_last                   => dbus_wlast,
        dzBusAxi_b_valid                   => dbus_bvalid,
        dzBusAxi_b_ready                   => dbus_bready,
        dzBusAxi_b_payload_id                   => dbus_bid,
        dzBusAxi_b_payload_resp                   => dbus_bresp,
        dzBusAxi_ar_valid                   => dbus_arvalid,
        dzBusAxi_ar_ready                   => dbus_arready,
        dzBusAxi_ar_payload_addr                   => dbus_araddr,
        dzBusAxi_ar_payload_id                   => dbus_arid,
        dzBusAxi_ar_payload_region                   => dbus_arregion,
        dzBusAxi_ar_payload_len                   => dbus_arlen,
        dzBusAxi_ar_payload_size                   => dbus_arsize,
        dzBusAxi_ar_payload_burst                   => dbus_arburst,
        dzBusAxi_ar_payload_lock                   => dbus_arlock,
        dzBusAxi_ar_payload_cache                   => dbus_arcache,
        dzBusAxi_ar_payload_qos                   => dbus_arqos,
        dzBusAxi_ar_payload_prot                   => dbus_arprot,
        dzBusAxi_r_valid                   => dbus_rvalid,
        dzBusAxi_r_ready                   => dbus_rready,
        dzBusAxi_r_payload_data                   => dbus_rdata,
        dzBusAxi_r_payload_id                   => dbus_rid,
        dzBusAxi_r_payload_resp                   => dbus_rresp,
        dzBusAxi_r_payload_last                   => dbus_rlast,


        timerInterrupt   => zeros(0),
        externalInterrupt   => zeros(0),
        softwareInterrupt   => zeros(0)

        

        

    );   



end Behavioral;
