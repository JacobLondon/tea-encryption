----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2019 10:53:48 AM
-- Design Name: 
-- Module Name: decipher - Behavioral
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

entity XTeaDecipher is
    Generic(num_round: integer:= 64); 
    Port (
           input_data : in unsigned (63 downto 0);
           key : in unsigned (127 downto 0);
           output : out unsigned (63 downto 0)
           );
end XTeaDecipher;

architecture Behavioral of XTeaDecipher is
type mem_sum is array (0 to num_round) of unsigned(31 downto 0);
type memory is array (0 to num_round) of unsigned (63 downto 0);
signal matrix: memory := (others=>(others  => '0'));
signal sum: mem_sum := (others =>(others => '0'));
signal DELTA: UNSIGNED(31 downto 0);
signal v0, v1, v0_tmp, v1_tmp, tmp1, tmp2, tmp3 ,tmp4 :mem_sum;
type address is array (0 to num_round) of positive;
signal addr1 , addr2 : address;
signal tmp_sum: unsigned(63 downto 0);
begin
matrix(0) <= input_data;
output <= matrix(num_round);
Delta <=  x"9E3779B9";
tmp_sum <= x"9E3779B9" * num_round;
sum(0) <= tmp_sum(31 downto 0);
Round: for i in 0 to num_round - 1 generate
       begin
           v0(i) <= (matrix(i)(31 downto 0));
           v1(i) <= (matrix(i)(63 downto 32));
           
           addr1(i) <= to_integer(shift_right(sum(i),11)(1 downto 0));
           
           tmp1(i) <= (shift_left(v0(i),4) xor shift_right(v0(i),5))+ v0(i);
           tmp2(i) <= sum(i) + key(32* addr1(i) + 31 downto 32 * addr1(i));
           
           v1_tmp(i) <= v1(i) - (tmp1(i) xor tmp2(i));
           
           sum(i + 1) <= sum(i) - DELTA;
           
           addr2(i) <= to_integer(sum(i+1)(1 downto 0));
           
           tmp3(i) <= (shift_left(v1_tmp(i),4) xor shift_right(v1_tmp(i),5)) + v1_tmp(i);
           tmp4(i) <= sum(i+1) + key(32* addr2(i) + 31 downto 32 * addr2(i));
           
           v0_tmp(i) <= v0(i) - (tmp3(i) xor tmp4(i));
           
           matrix(i + 1)(31 downto 0) <= v0_tmp(i);
           matrix(i + 1)(63 downto 32) <= v1_tmp(i);
               
end generate;

end Behavioral;
