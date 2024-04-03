----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2021 05:46:52 PM
-- Design Name: 
-- Module Name: noelv32 - Behavioral
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


entity noelv32 is
    Port ( clk : in std_logic;
           rst: in std_logic;
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
end noelv32;

architecture Behavioral of noelv32 is

signal rstn : std_logic;

begin

rstn <= not rst;

noel_i : entity work.noel_wrap
    port map(
    clk   => clk,
    rstn  => rstn,
   axi4bus_araddr      =>axi4bus_araddr  ,
   axi4bus_arready     =>axi4bus_arready ,
   axi4bus_arvalid     =>axi4bus_arvalid ,
   axi4bus_arid        =>axi4bus_arid    ,  
   axi4bus_arregion    =>axi4bus_arregion,  
   axi4bus_arlen       =>axi4bus_arlen   ,  
   axi4bus_arsize      =>axi4bus_arsize  ,  
   axi4bus_arburst     =>axi4bus_arburst ,  
   axi4bus_arlock      =>axi4bus_arlock  ,  
   axi4bus_arcache     =>axi4bus_arcache ,  
   axi4bus_arqos       =>axi4bus_arqos   ,  
   axi4bus_arprot      =>axi4bus_arprot  ,  
                   
   axi4bus_rdata       =>axi4bus_rdata   ,
   axi4bus_rready      =>axi4bus_rready  ,
   axi4bus_rresp       =>axi4bus_rresp   ,
   axi4bus_rid         =>axi4bus_rid     ,
   axi4bus_rvalid      =>axi4bus_rvalid  ,
   axi4bus_rlast       =>axi4bus_rlast   ,
                  
   axi4bus_awaddr      =>axi4bus_awaddr  ,
   axi4bus_awready     =>axi4bus_awready ,
   axi4bus_awvalid     =>axi4bus_awvalid ,
   axi4bus_awid        =>axi4bus_awid    ,
   axi4bus_awregion    =>axi4bus_awregion,  
   axi4bus_awlen       =>axi4bus_awlen   ,  
   axi4bus_awsize      =>axi4bus_awsize  ,  
   axi4bus_awburst     =>axi4bus_awburst ,  
   axi4bus_awlock      =>axi4bus_awlock  ,  
   axi4bus_awcache     =>axi4bus_awcache ,  
   axi4bus_awqos       =>axi4bus_awqos   ,  
   axi4bus_awprot      =>axi4bus_awprot  ,  
                   
   axi4bus_wdata       =>axi4bus_wdata   ,
   axi4bus_wready      =>axi4bus_wready  ,
   axi4bus_wstrb       =>axi4bus_wstrb   ,
   axi4bus_wvalid      =>axi4bus_wvalid  ,
   axi4bus_wlast       =>axi4bus_wlast   ,
                   
   axi4bus_bready      =>axi4bus_bready  ,
   axi4bus_bresp       =>axi4bus_bresp   ,
   axi4bus_bvalid      =>axi4bus_bvalid  ,
   axi4bus_bid         =>axi4bus_bid     

    );


end Behavioral;
