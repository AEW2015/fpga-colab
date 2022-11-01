--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
--Date        : Wed Aug 18 06:40:46 2021
--Host        : CB459-EE11237 running 64-bit major release  (build 9200)
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  generic (
         NUM_PROS : natural := 1;
         USE_BSCAN : Boolean := false
    );
  port (
    clk_in : in STD_LOGIC;
    tx : out STD_LOGIC
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    rst : in STD_LOGIC;
    en_in : in STD_LOGIC;
    data_in : in STD_LOGIC_VECTOR ( 31 downto 0 );
    count_in : in STD_LOGIC_VECTOR ( 15 downto 0 );
    en_out : out STD_LOGIC;
    data_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    count_out : out STD_LOGIC_VECTOR ( 15 downto 0 );
    clk : in STD_LOGIC
  );
  end component design_1;
  
  component clk_wiz_0 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    reset : in     std_logic;
    locked : out STD_LOGIC;
    clk_in1 : in     std_logic
  );

end component clk_wiz_0;
  
  component uart_port is
    Generic (
    CLK_RATE: natural :=100_000_000;
    WAIT_TIME: natural:= 50_000_000;
    NUM_PRO: natural :=10;
    BAUD_RATE: natural :=921_600);
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           en : in STD_LOGIC;
           tx : out STD_LOGIC;
           data : in UNSIGNED (31 downto 0));
end component uart_port;
  
component bscan_port is
Generic (
NUM_PRO: natural :=10);
Port ( clk : in STD_LOGIC;
       rst_n : in STD_LOGIC;
       en : in STD_LOGIC;
       data : in UNSIGNED (31 downto 0));
end component bscan_port;
  
  --signal zero : std_logic_vector (31 downto 0);
  signal clk  : std_logic;
  signal locked :std_logic;
  signal lockedn :std_logic;
  
  
  
  signal en_array: std_logic_vector(NUM_PROS downto 0);
  
  type data_type is array (NUM_PROS downto 0) of std_logic_vector(31 downto 0);
  signal data_array : data_type;
  
  type count_type is array (NUM_PROS downto 0) of std_logic_vector(15 downto 0);
  signal count_array : count_type;
  
begin
--zero <= (others=>'0');
en_array(0) <= '0';
data_array(0) <= (others=>'0');
count_array(0) <= (others=>'0');


clk_wiz_i: component clk_wiz_0
  port map( 
    clk_out1 => clk,
    reset => '0',
    locked  => locked,
    clk_in1  => clk_in
  );

lockedn <= not locked;
GEN_DUT: for I in 1 to NUM_PROS generate
design_1_i: component design_1
     port map (
      clk => clk,
      count_in(15 downto 0) => count_array(I-1),
      count_out(15 downto 0) => count_array(I),
      data_in(31 downto 0) => data_array(I-1),
      data_out(31 downto 0) => data_array(I),
      en_in => en_array(I-1),
      en_out => en_array(I),
      rst => lockedn
    );
end generate GEN_DUT;

gen_bscan : if USE_BSCAN = true generate

bscan_port_i: component bscan_port
     Generic map(        
        NUM_PRO => NUM_PROS)
     port map (
      clk => clk,
      rst_n => locked,
      en => en_array(NUM_PROS),
      data => unsigned(data_array(NUM_PROS))
    );
tx <= locked;
end generate;

gen_uart : if USE_BSCAN = false generate

uart_port_i: component uart_port
     Generic map(        
        CLK_RATE => 100_000_000,
        NUM_PRO => NUM_PROS,
        BAUD_RATE  =>115_200)
     port map (
      clk => clk,
      rst_n => locked,
      en => en_array(NUM_PROS),
      data => unsigned(data_array(NUM_PROS)),
      tx => tx
    );
    
end generate;
    
    
end STRUCTURE;
