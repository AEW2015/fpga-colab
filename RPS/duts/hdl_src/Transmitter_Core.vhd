----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2017 09:47:45 AM
-- Design Name: 
-- Module Name: Transmitter_Core - Behavioral
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

entity Transmitter_Core is
    Generic (
        CLK_RATE: natural :=100_000_000;
        BAUD_RATE: natural :=115_200);
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           send_data : in STD_LOGIC;
           data_tx : in STD_LOGIC_VECTOR (7 downto 0);
           tx : out STD_LOGIC;
           tx_busy : out STD_LOGIC);
end Transmitter_Core;

architecture Behavioral of Transmitter_Core is
-----------------------------------------------
function log2c (n: integer) return integer is 
variable m, p: integer; 
begin 
m := 0; 
p := 1; 
while p < n loop 
m := m + 1; 
p := p * 2; 
end loop; 
return m; 
end log2c;
---------------------------------------------------

type fsm is (IDLE,STRT,B0,B1,B2,B3,B4,B5,B6,B7,STP,RETRN);
signal state,state_next: fsm;
constant BIT_COUNTER_MAX_VAL : Natural := CLK_RATE / BAUD_RATE - 1;
constant BIT_COUNTER_BITS : Natural := log2c(BIT_COUNTER_MAX_VAL);
signal bit_timer,bit_timer_next : unsigned(BIT_COUNTER_BITS-1 downto 0);
signal reg, reg_next : std_logic_vector(7 downto 0);
signal tx_reg: std_logic:='1';
signal tx_reg_next: std_logic;
signal tx_bit,shift,load,stop,start,shift_out,clrTimer: std_logic;

begin
process(rst_n,clk)
begin
    if(rst_n ='0') then
        state <= IDLE;
        bit_timer<= (others=>'0');
        reg<=(others=>'0');
        tx_reg<='1';
    elsif (clk'event and clk = '1') then
        state<=state_next;
        bit_timer<=bit_timer_next;
        reg<=reg_next;
        tx_reg<=tx_reg_next;
    end if;
end process;

------------------------
--FSM NEXT STATE LOGIC--
------------------------
process(send_data,state,tx_bit)
begin
    shift <= '0';
    load <= '0';
    stop <= '0';
    start <= '0';
    clrTimer <= '0';
    tx_busy<= '1';
    case state is
        when IDLE =>
            tx_busy<= '0';
            stop<= '1';
            clrTimer<='1';
            if (send_data = '1') then
                state_next <= STRT;
                load <= '1';
            else
                state_next <= IDLE;
            end if;
        when STRT =>
            start <= '1';
            if (tx_bit = '1') then
                state_next <= B0;
            else
                state_next <= STRT;
            end if;
        when B0 =>
            if (tx_bit = '1') then
                state_next <= B1;
                shift <= '1';
            else
                state_next <= B0;
            end if;
        when B1 =>
            if (tx_bit = '1') then
                state_next <= B2;
                shift <= '1';
            else
                state_next <= B1;
            end if;
        when B2 =>
            if (tx_bit = '1') then
                state_next <= B3;
                shift <= '1';
            else
                state_next <= B2;
            end if;
        when B3 =>
            if (tx_bit = '1') then
                state_next <= B4;
                shift <= '1';
            else
                state_next <= B3;
            end if;
        when B4 =>
            if (tx_bit = '1') then
                state_next <= B5;
                shift <= '1';
            else
                state_next <= B4;
            end if;
        when B5 =>
            if (tx_bit = '1') then
                state_next <= B6;
                shift <= '1';
            else
                state_next <= B5;
            end if;
        when B6 =>
            if (tx_bit = '1') then
                state_next <= B7;
                shift <= '1';
            else
                state_next <= B6;
            end if;
        when B7 =>
            if (tx_bit = '1') then
                state_next <= STP;
                shift <= '1';
            else
                state_next <= B7;
            end if;		
        when STP =>
            stop<= '1';
            if (tx_bit = '1') then
                state_next <= RETRN;
            else
                state_next <= STP;
            end if;	
        when RETRN =>
            stop<= '1';
            if (send_data = '0') then
                state_next <= IDLE;
            else
                state_next <= RETRN;
            end if;
    end case;
end process;

----------------------------------------
--COUNTER NEXT STATE LOGIC--------------
----------------------------------------
bit_timer_next<= (others=>'0') when (clrTimer='1' or bit_timer = BIT_COUNTER_MAX_VAL) else
						bit_timer+1;
tx_bit <= '1' when bit_timer = BIT_COUNTER_MAX_VAL else
				'0';
						
reg_next <= Data_TX when load = '1' else
				'0' & reg(7 downto 1) when shift='1' else
				reg;
shift_out <= reg(0);
				
tx_reg_next<= '1' when stop = '1' else 
			'0' when start = '1' else
			shift_out;
				

----------------------
--outputs
TX<= tx_reg;

end Behavioral;
