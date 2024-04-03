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

entity kronos_v is
    Port ( 
    sys_clk                 : in STD_LOGIC;
    sys_rst                 : in STD_LOGIC;
    
    bus_axi_araddr      : out STD_LOGIC_VECTOR ( 31 downto 0);
    bus_axi_arready     : in  STD_LOGIC;
    bus_axi_arvalid     : out STD_LOGIC;    
	bus_axi_arprot      : out STD_LOGIC_VECTOR (  2 downto 0); 
    bus_axi_awaddr      : out STD_LOGIC_VECTOR ( 31 downto 0);
    bus_axi_awready     : in  STD_LOGIC;
    bus_axi_awvalid     : out STD_LOGIC;
	bus_axi_awprot      : out STD_LOGIC_VECTOR (  2 downto 0); 
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
end kronos_v;

architecture Behavioral of kronos_v is
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


    signal dmem_wstrb : std_logic_vector(3 downto 0);
    signal dmem_wr_en : std_logic;

    signal mem_addr : std_logic_vector(31 downto 0);
    signal mem_wdata : std_logic_vector(31 downto 0);
    signal mem_la_addr : std_logic_vector(31 downto 0);
    signal mem_la_wdata : std_logic_vector(31 downto 0);

    signal mem_rdata : std_logic_vector(31 downto 0);


    signal local_access : std_logic;
    --signal axi_access : std_logic;
    signal axi_access_next : std_logic;
    signal axi_access_reg : std_logic;
    signal bram_access : std_logic;
    signal imem_access : std_logic;
    signal imem_access_reg : std_logic;
    signal dmem_access : std_logic;
    signal dmem_access_reg : std_logic;
    
    signal dmem_ready : std_logic;
    signal dmem_we_tmp: std_logic_vector(3 downto 0);
    signal axi_wstb_reg: std_logic_vector(3 downto 0);
    signal axi_wstb_next: std_logic_vector(3 downto 0);
    signal dmem_addr_axi : std_logic_vector(31 downto 0);
    signal dmem_din_tmp : std_logic_vector(31 downto 0);
    
    signal resetn : std_logic;
    signal zeros : std_logic_vector (31 downto 0) := (others=>'0');
    signal ones : std_logic_vector (31 downto 0) := (others=>'1');

    signal amem_ready : std_logic;
    signal amem_rdata : std_logic_vector(31 downto 0);


begin

    resetn <= not sys_rst;

    dmem_clk  <= sys_clk;
    dmem_rst  <= sys_rst;
    imem_clk  <= sys_clk;
    imem_rst  <= sys_rst;
    imem_din  <= zeros;
    imem_we   <= zeros(3 downto 0);


    process(sys_clk)
    begin
        if (rising_edge(sys_clk)) then
            imem_access_reg <= imem_access;
            dmem_access_reg <= local_access;
            axi_access_reg  <= axi_access_next;
            axi_wstb_reg    <= axi_wstb_next;
            
            
        end if;
    end process;
    imem_en <= imem_access;
    dmem_en <= local_access;    
    dmem_we <= dmem_we_tmp; 
    dmem_we_tmp(0) <= dmem_wr_en and dmem_wstrb(0);
    dmem_we_tmp(1) <= dmem_wr_en and dmem_wstrb(1);
    dmem_we_tmp(2) <= dmem_wr_en and dmem_wstrb(2);
    dmem_we_tmp(3) <= dmem_wr_en and dmem_wstrb(3);  
    

    
dmem_ready <= dmem_access_reg or amem_ready;
mem_rdata <= dmem_dout when dmem_access_reg = '1' else amem_rdata when amem_ready='1' else zeros;
    
dmem_addr <= dmem_addr_axi;
dmem_din <= dmem_din_tmp;
bram_access <= '1' when dmem_addr_axi(31 downto 30) = "00" else '0';
local_access <= bram_access and dmem_access;
axi_access_next <= '1' when  bram_access='0' and dmem_access='1' else
                   '0' when amem_ready='1' else
                   axi_access_reg;
                   
axi_wstb_next   <= dmem_we_tmp when  bram_access='0' and dmem_access='1' else
                   "0000" when amem_ready='1' else
                   axi_wstb_reg;
    

    --Memory to Axi core
    mem2axi : entity work.picorv32_axi_adapter
    port map(
        clk => sys_clk,
        resetn => resetn,

        mem_axi_awvalid => bus_axi_awvalid,
        mem_axi_awready => bus_axi_awready,
        mem_axi_awaddr => bus_axi_awaddr,
        mem_axi_awprot => bus_axi_awprot,
    
        mem_axi_wvalid => bus_axi_wvalid,
        mem_axi_wready => bus_axi_wready,
        mem_axi_wdata => bus_axi_wdata,
        mem_axi_wstrb => bus_axi_wstrb,
    
        mem_axi_bvalid => bus_axi_bvalid,
        mem_axi_bready => bus_axi_bready,
    
        mem_axi_arvalid => bus_axi_arvalid,
        mem_axi_arready => bus_axi_arready,
        mem_axi_araddr => bus_axi_araddr,
        mem_axi_arprot => bus_axi_arprot,
    
        mem_axi_rvalid => bus_axi_rvalid,
        mem_axi_rready => bus_axi_rready,
        mem_axi_rdata => bus_axi_rdata,

        mem_instr   => zeros(0),
        mem_ready   => amem_ready,
        mem_addr    => dmem_addr_axi,
        mem_wdata   => dmem_din_tmp,
        mem_wstrb   => axi_wstb_reg, --next state?
        mem_rdata   => amem_rdata,
        mem_valid   => axi_access_reg  --next state?

    );



    --Pico Core
    core : entity work.kronos_core
    port map(
        clk     => sys_clk,
        rstz    => resetn,
        
        instr_req    =>imem_access,
        instr_addr   => imem_addr,
        instr_ack    => imem_access_reg,
        instr_data   => imem_dout,
        
        data_req     => dmem_access,
        data_wr_en   => dmem_wr_en,
        data_addr    => dmem_addr_axi,
        data_wr_data => dmem_din_tmp,
        data_mask    => dmem_wstrb,
        data_ack     => dmem_ready,
        data_rd_data => mem_rdata,


        timer_interrupt   => zeros(0),
        external_interrupt   => zeros(0),
        software_interrupt   => zeros(0)

        

        

    );   
    




end Behavioral;
