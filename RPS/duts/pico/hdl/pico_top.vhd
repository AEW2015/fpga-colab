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

entity pico_top is
    Generic (
    ENABLE_COUNTERS         : boolean := true;
    ENABLE_COUNTERS64       : boolean := true;
    ENABLE_REGS_16_31       : boolean := true;
    ENABLE_REGS_DUALPORT    : boolean := true;
    LATCHED_MEM_RDATA       : boolean := false;
    TWO_STAGE_SHIFT         : boolean := true;
    BARREL_SHIFTER          : boolean := false;
    TWO_CYCLE_COMPARE       : boolean := false;
    TWO_CYCLE_ALU           : boolean := false;
    COMPRESSED_ISA          : boolean := false;
    CATCH_MISALIGN          : boolean := true;
    CATCH_ILLINSN           : boolean := true;
    ENABLE_PCPI             : boolean := false;
    ENABLE_MUL              : boolean := false;
    ENABLE_FAST_MUL         : boolean := false;
    ENABLE_DIV              : boolean := false;
    ENABLE_IRQ              : boolean := false;
    ENABLE_IRQ_QREGS        : boolean := true;
    ENABLE_IRQ_TIMER        : boolean := true;
    ENABLE_TRACE            : boolean := false;
    REGS_INIT_ZERO          : boolean := false;
    MASKED_IRQ              : std_logic_vector (31 downto 0) := x"0000_0000";
    LATCHED_IRQ             : std_logic_vector (31 downto 0) := x"FFFF_FFFF";
    PROGADDR_RESET          : std_logic_vector (31 downto 0) := x"0000_0000";
    PROGADDR_IRQ            : std_logic_vector (31 downto 0) := x"0000_0010";
    STACKADDR               : std_logic_vector (31 downto 0) := x"FFFF_FFFF"
    );
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
    --bus_axi_clk         : out STD_LOGIC;
    
    --imem_en             : out STD_LOGIC;
    --imem_dout           : in  STD_LOGIC_VECTOR ( 31 downto 0);
    --imem_din            : out STD_LOGIC_VECTOR ( 31 downto 0);
    --imem_we             : out STD_LOGIC_VECTOR (  3 downto 0);
    --imem_addr           : out STD_LOGIC_VECTOR ( 29 downto 0);
    --imem_clk            : out STD_LOGIC;
    --imem_rst            : out STD_LOGIC;
    
    bmem_en             : out STD_LOGIC;
    bmem_dout           : in  STD_LOGIC_VECTOR ( 31 downto 0);
    bmem_din            : out STD_LOGIC_VECTOR ( 31 downto 0);
    bmem_we             : out STD_LOGIC_VECTOR (  3 downto 0);
    bmem_addr           : out STD_LOGIC_VECTOR ( 31 downto 0);
    bmem_clk            : out STD_LOGIC;
    bmem_rst            : out STD_LOGIC
    );
end pico_top;

architecture Behavioral of pico_top is
    ATTRIBUTE X_INTERFACE_INFO : string;

    --ATTRIBUTE X_INTERFACE_INFO OF imem_addr : SIGNAL IS "xilinx.com:interface:bram:1.0 imem ADDR";
    --ATTRIBUTE X_INTERFACE_INFO OF imem_clk  : SIGNAL IS "xilinx.com:interface:bram:1.0 imem CLK";
    --ATTRIBUTE X_INTERFACE_INFO OF imem_din  : SIGNAL IS "xilinx.com:interface:bram:1.0 imem DIN";
    --ATTRIBUTE X_INTERFACE_INFO OF imem_dout : SIGNAL IS "xilinx.com:interface:bram:1.0 imem DOUT";
    --ATTRIBUTE X_INTERFACE_INFO OF imem_en   : SIGNAL IS "xilinx.com:interface:bram:1.0 imem EN";
    --ATTRIBUTE X_INTERFACE_INFO OF imem_rst  : SIGNAL IS "xilinx.com:interface:bram:1.0 imem RST";
    --ATTRIBUTE X_INTERFACE_INFO OF imem_we   : SIGNAL IS "xilinx.com:interface:bram:1.0 imem WE";
    
    ATTRIBUTE X_INTERFACE_INFO OF bmem_addr : SIGNAL IS "xilinx.com:interface:bram:1.0 bmem ADDR";
    ATTRIBUTE X_INTERFACE_INFO OF bmem_clk  : SIGNAL IS "xilinx.com:interface:bram:1.0 bmem CLK";
    ATTRIBUTE X_INTERFACE_INFO OF bmem_din  : SIGNAL IS "xilinx.com:interface:bram:1.0 bmem DIN";
    ATTRIBUTE X_INTERFACE_INFO OF bmem_dout : SIGNAL IS "xilinx.com:interface:bram:1.0 bmem DOUT";
    ATTRIBUTE X_INTERFACE_INFO OF bmem_en   : SIGNAL IS "xilinx.com:interface:bram:1.0 bmem EN";
    ATTRIBUTE X_INTERFACE_INFO OF bmem_rst  : SIGNAL IS "xilinx.com:interface:bram:1.0 bmem RST";
    ATTRIBUTE X_INTERFACE_INFO OF bmem_we   : SIGNAL IS "xilinx.com:interface:bram:1.0 bmem WE";

    signal mem_valid : std_logic;
    signal mem_instr : std_logic;
    signal mem_la_read : std_logic;
    signal mem_la_write : std_logic;

    signal mem_ready : std_logic;

    signal mem_la_wstrb : std_logic_vector(3 downto 0);
    signal mem_wstrb : std_logic_vector(3 downto 0);

    signal mem_addr : std_logic_vector(31 downto 0);
    signal mem_wdata : std_logic_vector(31 downto 0);
    signal mem_la_addr : std_logic_vector(31 downto 0);
    signal mem_la_wdata : std_logic_vector(31 downto 0);

    signal mem_rdata : std_logic_vector(31 downto 0);

    signal local_write : std_logic;
    signal local_access : std_logic;
    signal axi_access : std_logic;
    signal bram_access : std_logic;
    signal bram_write : std_logic;

    signal resetn : std_logic;
    signal zeros : std_logic_vector (31 downto 0) := (others=>'0');

    signal amem_ready : std_logic;
    signal amem_rdata : std_logic_vector(31 downto 0);


begin

    resetn <= not sys_rst;
    --bus_axi_clk <= sys_clk;

    --Mux for local Memory
    bmem_en <= '1';
    bmem_din <= mem_la_wdata;
    bram_write <= '1' when mem_la_addr(31 downto 30) = "00" else '0';
    local_write <= bram_write and mem_la_write;
    bmem_we(0) <= local_write and mem_la_wstrb(0);
    bmem_we(1) <= local_write and mem_la_wstrb(1);
    bmem_we(2) <= local_write and mem_la_wstrb(2);
    bmem_we(3) <= local_write and mem_la_wstrb(3);
    bmem_addr <= mem_la_addr;
    bmem_clk  <= sys_clk;
    bmem_rst  <= sys_rst;

    bram_access <= '1' when mem_addr(31 downto 30) = "00" else '0';
    local_access <= bram_access and mem_valid;
    axi_access <= not bram_access and mem_valid;

    mem_rdata <= bmem_dout when local_access = '1' else amem_rdata;
    mem_ready <= local_access or amem_ready;

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

        mem_instr   => mem_instr,
        mem_ready   => amem_ready,
        mem_addr    => mem_addr,
        mem_wdata   => mem_wdata,
        mem_wstrb   => mem_wstrb,
        mem_rdata   => amem_rdata,
        mem_valid   => axi_access

    );


    --Pico Core
    core : entity work.picorv32
    generic map(
        ENABLE_COUNTERS         => ENABLE_COUNTERS,
        ENABLE_COUNTERS64       => ENABLE_COUNTERS64,
        ENABLE_REGS_16_31       => ENABLE_REGS_16_31,
        ENABLE_REGS_DUALPORT    => ENABLE_REGS_DUALPORT,
        LATCHED_MEM_RDATA       => LATCHED_MEM_RDATA,
        TWO_STAGE_SHIFT         => TWO_STAGE_SHIFT,
        BARREL_SHIFTER          => BARREL_SHIFTER,
        TWO_CYCLE_COMPARE       => TWO_CYCLE_COMPARE,
        TWO_CYCLE_ALU           => TWO_CYCLE_ALU,
        COMPRESSED_ISA          => COMPRESSED_ISA,
        CATCH_MISALIGN          => CATCH_MISALIGN,
        CATCH_ILLINSN           => CATCH_ILLINSN,
        ENABLE_PCPI             => ENABLE_PCPI,
        ENABLE_MUL              => ENABLE_MUL,
        ENABLE_FAST_MUL         => ENABLE_FAST_MUL,
        ENABLE_DIV              => ENABLE_DIV,
        ENABLE_IRQ              => ENABLE_IRQ,
        ENABLE_IRQ_QREGS        => ENABLE_IRQ_QREGS,
        ENABLE_IRQ_TIMER        => ENABLE_IRQ_TIMER,
        ENABLE_TRACE            => ENABLE_TRACE,
        REGS_INIT_ZERO          => REGS_INIT_ZERO,
        MASKED_IRQ              => MASKED_IRQ,
        LATCHED_IRQ             => LATCHED_IRQ,
        PROGADDR_RESET          => PROGADDR_RESET,
        PROGADDR_IRQ            => PROGADDR_IRQ,
        STACKADDR               => STACKADDR
    )
    port map(
        clk     => sys_clk   ,
        resetn  => resetn,
        trap    => open  ,
        
        mem_valid   => mem_valid,
        mem_instr   => mem_instr,
        mem_ready   => mem_ready,
        mem_addr    => mem_addr ,
        mem_wdata   => mem_wdata,
        mem_wstrb   => mem_wstrb,
        mem_rdata   => mem_rdata,
        
        mem_la_read     => mem_la_read ,
        mem_la_write    => mem_la_write,
        mem_la_addr     => mem_la_addr ,
        mem_la_wdata    => mem_la_wdata,
        mem_la_wstrb    => mem_la_wstrb,
        
        pcpi_valid => open,
        pcpi_insn  => open ,
        pcpi_rs1   => open  ,
        pcpi_rs2   => open  ,
        pcpi_wr    => zeros(0),
        pcpi_rd    => zeros,
        pcpi_wait  => zeros(0),
        pcpi_ready => zeros(0),
        
        irq        => zeros,
        eoi        => open,
        
        trace_valid => open,
        trace_data  => open
    );   



end Behavioral;
