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

entity bscan_port is
    Generic (
    NUM_PRO: natural :=10);
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           en : in STD_LOGIC;
           tx : out STD_LOGIC;
           data : in UNSIGNED (31 downto 0));
end bscan_port;

architecture Behavioral of bscan_port is
component bscan_if is
	generic(
		FAMILY : String := "7SERIES";
		USE_INPUT_REGISTER : Boolean := true;
		USE_EXTERNAL_TCK : Boolean := false;
		INSTANCE_TCK_BUFG : Boolean := false;
		JTAG_CHAIN : Natural := 1;		-- Indicates the JTAG chain number (i.e. 1-4)
		DATA_WIDTH : Natural				-- Width of the register (must explicitly state when instancing)
	);
	port(
		data_out : in std_logic_vector(DATA_WIDTH-1 downto 0); -- data to send out of JTAG
		tck_in  : in std_logic;                                -- Input clock for logic (if clock comes from outside)
		data_in : out std_logic_vector(DATA_WIDTH-1 downto 0); -- data to receive from JTAG
		tck_out : out std_logic;                               -- JTAG tck signal used by logic (no matter where it comes from)
		data_in_update : out std_logic;                        -- Signal indicating data in has been updated
		data_out_capture : out std_logic                       -- Signal indicating that data out has been captured  
	);
end component;
constant array_max : integer := 16*NUM_PRO;
type ram_type is array (NUM_PRO-1 downto 0) of std_logic_vector(15 downto 0);
signal ram : ram_type;


signal bscan_array : std_logic_vector( array_max-1 downto 0) := (others=>'0');

begin

process (clk)
variable index : integer;
begin
    if (rising_edge(clk)) then
        if(en = '1') then
            index := to_integer(data(31 downto 16)-1);

            ram(index) <= std_logic_vector(data(15 downto 0)); 
        end if;
    end if; 
end process;

process (ram)
begin
    for i in 0 to NUM_PRO-1 loop
        bscan_array((16*(i+1))-1 downto (16*i)) <= ram(NUM_PRO-i-1);
    end loop;


end process;


	bscan_1 : bscan_if
        generic map (
            FAMILY => "7SERIES",
            USE_INPUT_REGISTER => false,
            USE_EXTERNAL_TCK => false,
            INSTANCE_TCK_BUFG => true,
            JTAG_CHAIN => 4,
            DATA_WIDTH => array_max
        )
        port map(
            -- data to send out of JTAG
            data_out =>bscan_array,
            -- Input clock for logic (if clock comes from outside)
            tck_in  => '0',                               
            -- data to receive from JTAG
            data_in => open,
            -- JTAG tck signal used by logic (no matter where it comes from)
            tck_out => open,                              
            -- Signal indicating data in has been updated
            data_in_update => open,                        
            -- Signal indicating that data out has been captured  
            data_out_capture => open                       
        );

end Behavioral;
