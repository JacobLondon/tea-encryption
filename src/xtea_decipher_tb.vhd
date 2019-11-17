----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2019 12:25:26 PM
-- Design Name: 
-- Module Name: decipher_TB - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity XTeaDecipherTB is
Generic(num_round : integer:= 63);
--  Port ( );
end XTeaDecipherTB;

architecture Behavioral of XTeaDecipherTB is
component XTeaDecipher is
    Generic(num_round: integer:= 1); 
    Port ( input_data : in unsigned (63 downto 0);
           key : in unsigned (127 downto 0);
           output : out unsigned (63 downto 0)
           );
end component;
signal input_data: unsigned( 63 downto 0);
signal key: unsigned(127 downto 0);
signal output: unsigned(63 downto 0);
constant period: time:= 4ns;
begin
decipher_gen: XTeaDecipher generic map(num_round => num_round)
                       port map(
                                    input_data => input_data,
                                    key => key,
                                    output => output
                                );
SIM_ENV:process
        begin
        --input_data <= x"20938cc88a7133fd";
        input_data   <= x"b8ff05a8ec3814aa";
        key <= x"feedbeef00c0ffeef00000110facade0";
        wait for period;
        end process;
        

end Behavioral;
