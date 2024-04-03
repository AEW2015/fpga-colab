----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2018 03:57:10 PM
-- Design Name: 
-- Module Name: bscan_port - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_port is
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
end uart_port;

architecture Behavioral of uart_port is



constant array_max : integer := 16*NUM_PRO;
type ram_type is array (NUM_PRO-1 downto 0) of unsigned(15 downto 0);
signal ram : ram_type;


signal  send_data :  STD_LOGIC;
signal  data_tx : STD_LOGIC_VECTOR (7 downto 0);
signal  full	:  STD_LOGIC;

signal uart_it,uart_it_next :unsigned(7 downto 0);
signal wait_count,wait_count_next :unsigned(31 downto 0);
signal proc_count,proc_count_next :unsigned(15 downto 0);
signal nibble_count,nibble_count_next :unsigned(1 downto 0);

type fsm is (IDLE_ST,READY_ST,COUNT_ST,COLON_ST,REG_ST,NL_ST,CR_ST);
signal state,state_next: fsm;


signal decode_input:unsigned(3 downto 0):=(others=>'0');
signal decode_output:STD_LOGIC_VECTOR(7 downto 0):=(others=>'0');

begin

process (clk)
variable index : integer;
begin
    if (rising_edge(clk)) then
        if(en = '1') then
            index := to_integer(data(31 downto 16)-1);

            ram(index) <= data(15 downto 0); 
        end if;
    end if; 
end process;

process(clk,rst_n)
begin
    if(rst_n = '0') then
         state <= IDLE_ST;
         uart_it     <= (others=>'0');
         wait_count     <= (others=>'0');
         proc_count     <= (others=>'0');
         nibble_count   <= (others=>'0');
    elsif(clk'event and clk = '1') then
        state <= state_next;
        uart_it      <= uart_it_next;
        wait_count   <= wait_count_next;
        proc_count   <= proc_count_next;
        nibble_count   <= nibble_count_next;
    end if;
end process;

------------------------
--FSM NEXT STATE LOGIC--
------------------------
process(state,en,wait_count,full,nibble_count,uart_it,decode_output,ram,proc_count)
begin
    state_next <= state;
    uart_it_next   <= uart_it;
    wait_count_next   <= (others=>'0');
    proc_count_next   <= proc_count;
    nibble_count_next   <= nibble_count;
    data_tx <= (others=>'0');
    send_data <= '0';
    
    case state is
        when IDLE_ST =>
            if(en = '1') then
                state_next <= READY_ST;
            end if;
            
        when READY_ST =>
            wait_count_next   <= wait_count+1;
            if (wait_count >= WAIT_TIME) then
                nibble_count_next   <= "01";
                state_next <= COUNT_ST;
            end if;
            
        when COUNT_ST =>
             if(full = '0') then
                nibble_count_next <= nibble_count - 1;
                decode_input <= uart_it((to_integer(nibble_count)*4)+3 downto (to_integer(nibble_count)*4));
                data_tx <= decode_output;
                send_data <= '1';
                if (nibble_count = "00") then 
                   state_next <= COLON_ST;
                   uart_it_next   <= uart_it + 1;
                end if;
             end if;
             
        when COLON_ST =>
            if(full = '0') then
                data_tx <= x"3A";
                send_data <= '1';
                nibble_count_next <= "11";
                proc_count_next <= (others=>'0');
                state_next <= REG_ST;
            end if;
             
        when REG_ST =>
             if(full = '0') then
                nibble_count_next <= nibble_count - 1;
                decode_input <= ram(to_integer(proc_count))((to_integer(nibble_count)*4)+3 downto (to_integer(nibble_count)*4));
                data_tx <= decode_output;
                send_data <= '1';
                if (nibble_count = "00") then 
                   proc_count_next <= proc_count + 1;
                   if (proc_count >= (NUM_PRO-1)) then
                        state_next <= NL_ST;
                   end if;
                end if;
             end if;
             
        when NL_ST =>
            if(full = '0') then
                data_tx <= x"0A";
                send_data <= '1';
                state_next <= CR_ST;
            end if;
             
        when CR_ST =>
            if(full = '0') then
                data_tx <= x"0D";
                send_data <= '1';
                state_next <= READY_ST;
            end if;
            
        when others =>
           state_next <= IDLE_ST;
    end case;
end process;

with decode_input select decode_output <=
    x"30" when "0000",
    x"31" when "0001",
    x"32" when "0010",
    x"33" when "0011",
    x"34" when "0100",
    x"35" when "0101",
    x"36" when "0110",    
    x"37" when "0111",    
    x"38" when "1000",    
    x"39" when "1001",    
    x"41" when "1010",    
    x"42" when "1011",    
    x"43" when "1100",    
    x"44" when "1101",    
    x"45" when "1110",    
    x"46" when "1111",
    x"3F" when others;   







TX_i: entity work.UART_TX
     Generic map(
        CLK_RATE  =>CLK_RATE,
        BAUD_RATE  =>BAUD_RATE)
     port map (
      clk => clk,
      rst_n => RST_N,
      send_data => send_data,
      data_tx => data_tx,
      full => full,
      tx => tx
    );

end Behavioral;
