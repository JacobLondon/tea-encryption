----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2019 03:06:41 PM
-- Design Name: 
-- Module Name: tea_decipher - Behavioral
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

entity TeaDecipher is
    Generic(num_round: integer:= 64); 
    Port ( input_data : in UNSIGNED (63 downto 0);
           key : in UNSIGNED (127 downto 0);
           output : out UNSIGNED (63 downto 0));
end TeaDecipher;

architecture Behavioral of TeaDecipher is
type mem_sum is array (0 to num_round) of unsigned(31 downto 0);
type memory is array (0 to num_round) of unsigned (63 downto 0);
signal matrix: memory := (others=>(others  => '0'));
signal sum: mem_sum := (others =>(others => '0'));
signal DELTA: UNSIGNED(31 downto 0);
signal v0, v1, v0_tmp, v1_tmp, tmp1, tmp2, tmp3 ,tmp4,tmp5,tmp6 :mem_sum;
signal tmp_sum: unsigned(63 downto 0);
signal k0, k1, k2, k3: unsigned(31 downto 0);
begin
matrix(0) <= input_data;
output <= matrix(num_round);
Delta <=  x"9E3779B9";
tmp_sum <= x"9E3779B9" * num_round;
sum(0) <= tmp_sum(31 downto 0);
k0 <= key(31 downto 0);
k1 <= key(63 downto 32);
k2 <= key(95 downto 64);
k3 <= key(127 downto 96);
Round: for i in 0 to num_round - 1 generate
       begin
           v0(i) <= (matrix(i)(31 downto 0));
           v1(i) <= (matrix(i)(63 downto 32));
           
         --v1        =  v1    - ((v0     <<       4) + k2   ^   (v0    + sum   )  ^  (v0     >>         5) + k3 );
           v1_tmp(i) <= v1(i) - ((shift_left(v0(i),4) + k2) xor (v0(i) + sum(i)) xor (shift_right(v0(i),5) + k3));
         --v0        =  v1    - ((v1     <<       4) + k2   ^   (v1    + sum   )  ^  (v1     >>         5) + k3 );  
           v0_tmp(i) <= v0(i) - ((shift_left(v1_tmp(i),4) + k0) xor (v1_tmp(i) + sum(i)) xor (shift_right(v1_tmp(i),5) + k1));
           
           sum(i+1) <= sum(i) - Delta;
           matrix(i+1) <= v1_tmp(i) & v0_tmp(i);
               
end generate;

end Behavioral;
