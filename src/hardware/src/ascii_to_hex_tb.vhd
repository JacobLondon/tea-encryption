library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AsciiToHexTb is
end AsciiToHexTb;

architecture Behavioral of AsciiToHexTb is

    component AsciiToHex
        Port (
            i_ASCII  : in  STD_LOGIC_VECTOR(7 downto 0);
            o_hex    : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
 
    constant wt       : TIME:= 5ns;              -- (FPGA clock period)/2
    
    signal tb_clk     : STD_LOGIC := '0';
    signal tb_ASCII  : STD_LOGIC_VECTOR(7 downto 0):= (others => '0');
    signal tb_hex    : STD_LOGIC_VECTOR(3 downto 0):= (others => '0');

begin

    CONVERT_INST: AsciiToHex
        Port map (
            i_ASCII  => tb_ASCII,
            o_hex    => tb_hex
        );

    CLK_GEN: process      -- Generates 100 MHz clock signal
    begin
                
        tb_clk <= '1';
        wait for wt;
        tb_clk <= '0';
        wait for wt;

    end process CLK_GEN;

    SIM_GEN: process
    begin

        tb_ASCII  <= X"31";
        wait for 7*wt;
        tb_ASCII  <= X"32";
        wait for 2*wt;
        tb_ASCII  <= X"39";
        wait for 3*wt;
        
        tb_ASCII  <= X"11";
        wait for 2*wt;
        tb_ASCII <= X"43";
        wait for 13*wt;
        tb_ASCII <= X"61";
        wait;

    end process SIM_GEN;
end Behavioral;