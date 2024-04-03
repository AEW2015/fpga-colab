----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2017 07:00:08 PM
-- Design Name: 
-- Module Name: UART_TX - Behavioral
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

entity UART_TX is
    Generic (
    CLK_RATE: natural :=100_000_000;
    BAUD_RATE: natural :=115_200);
Port ( clk : in STD_LOGIC;
       rst_n : in STD_LOGIC;
       send_data : in STD_LOGIC;
       data_tx : in STD_LOGIC_VECTOR (7 downto 0);
       Full	: out STD_LOGIC;
       tx : out STD_LOGIC);
end UART_TX;

architecture Behavioral of UART_TX is
component FIFO is
    Generic (
		constant DATA_WIDTH  : positive := 8;
		constant FIFO_DEPTH	: positive := 156);
	Port ( 
		CLK		: in  STD_LOGIC;
		RST_N		: in  STD_LOGIC;
		WriteEn	: in  STD_LOGIC;
		DataIn	: in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		ReadEn	: in  STD_LOGIC;
		DataOut	: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		Empty	: out STD_LOGIC;
		Full	: out STD_LOGIC
	);
end component FIFO;
component Transmitter_Core is
      Generic (
          CLK_RATE: natural :=100_000_000;
          BAUD_RATE: natural :=115_200);
      Port ( clk : in STD_LOGIC;
             rst_n : in STD_LOGIC;
             send_data : in STD_LOGIC;
             data_tx : in STD_LOGIC_VECTOR (7 downto 0);
             tx : out STD_LOGIC;
             tx_busy : out STD_LOGIC);
end component Transmitter_Core;
signal WriteEn,ReadEn,Empty,tx_busy,tx_send: std_logic;  
signal data_out,reg,reg_next :std_logic_vector(7 downto 0);
type fsm is (READY_ST,READ_ST,REG_ST,SEND_ST,IDLE_ST);
signal state,state_next: fsm;
begin
FIFO_i: component FIFO
     Generic map(
        DATA_WIDTH  =>8,
        FIFO_DEPTH  =>2048)
     port map (
      clk => clk,
      RST_N => RST_N,
      WriteEn => send_data,
      DataIn => data_tx,
      ReadEn => ReadEn,
      DataOut => data_out,
      Empty => Empty,
      Full => Full
    );
TX_i: component Transmitter_Core
     Generic map(
        CLK_RATE  =>CLK_RATE,
        BAUD_RATE  =>BAUD_RATE)
     port map (
      clk => clk,
      RST_N => RST_N,
      send_data => tx_send,
      data_tx => reg_next,
      tx => tx,
      tx_busy => tx_busy
    );

process(clk,rst_n)
begin
    if(rst_n = '0') then
         state <= IDLE_ST;
         reg   <= (others=>'0');
    elsif(clk'event and clk = '1') then
        state <= state_next;
        reg   <= reg_next;
    end if;
end process;

------------------------
--FSM NEXT STATE LOGIC--
------------------------
process(state,empty,tx_busy,reg,data_out)
begin
    state_next <= state;
    reg_next   <= reg;
    ReadEn     <= '0';
    tx_send    <= '0';
    case state is
        when IDLE_ST =>
            if(not empty and not tx_busy) ='1' then
                state_next <= READY_ST;
            end if;
        when READY_ST =>
            state_next <= READ_ST;
        when READ_ST =>
            state_next <= REG_ST;
            ReadEn     <= '1';
        when REG_ST =>
            state_next <= SEND_ST;
            reg_next   <= data_out;
        when SEND_ST =>
            state_next <= IDLE_ST;
            tx_send    <= '1';    
    end case;
end process;




end Behavioral;
