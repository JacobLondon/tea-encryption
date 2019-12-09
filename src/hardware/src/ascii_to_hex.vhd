library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AsciiToHex is
    Port (
        i_ASCII  : in  STD_LOGIC_VECTOR(7 downto 0);
        o_hex    : out STD_LOGIC_VECTOR(3 downto 0)
    );
end AsciiToHex;
    
architecture Behavioral of AsciiToHex is

begin

    CONVERT_CONTROL: process (i_ASCII) is
    begin
        if (i_ASCII = X"30") then
            o_hex <= "0000";
        elsif (i_ASCII = X"31") then
            o_hex <= "0001";
        elsif (i_ASCII = X"32") then
            o_hex <= "0010";
        elsif (i_ASCII = X"33") then
            o_hex <= "0011";
        elsif (i_ASCII = X"34") then
            o_hex <= "0100";
        elsif (i_ASCII = X"35") then
            o_hex <= "0101";
        elsif (i_ASCII = X"36") then
            o_hex <= "0110";
        elsif (i_ASCII = X"37") then
            o_hex <= "0111";
        elsif (i_ASCII = X"38") then
            o_hex <= "1000";
        elsif (i_ASCII = X"39") then
            o_hex <= "1001";
        elsif (i_ASCII = X"41" or i_ASCII = X"61") then
            o_hex <= "1010";
        elsif (i_ASCII = X"42" or i_ASCII = X"62") then
            o_hex <= "1011";
        elsif (i_ASCII = X"43" or i_ASCII = X"63") then
            o_hex <= "1100";
        elsif (i_ASCII = X"44" or i_ASCII = X"64") then
            o_hex <= "1101";
        elsif (i_ASCII = X"45" or i_ASCII = X"65") then
            o_hex <= "1110";
        elsif (i_ASCII = X"46" or i_ASCII = X"66") then
            o_hex <= "1111";
        else
            o_hex <= "ZZZZ";
        end if;
    end process CONVERT_CONTROL;
end Behavioral;