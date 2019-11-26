----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2019 03:15:00 PM
-- Design Name: 
-- Module Name: PROM_IMG - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PROM_IMG is
    generic(DEPTH    :positive:= 5; 
            DATA_SIZE:positive:= 7;
            MEM_SIZE :positive:= 114
           );
    Port   ( --index   : in  STD_LOGIC_VECTOR(4*MEM_SIZE/7 -1 downto 0);
             index   : in  STD_LOGIC_VECTOR(3 downto 0);
             addr    : in  STD_LOGIC_VECTOR (integer(ceil(log2(real(DEPTH))))-1 downto 0);
             PROM_OP : out STD_LOGIC_VECTOR (MEM_SIZE-1 downto 0)
           );
end PROM_IMG;

architecture Behavioral of PROM_IMG is

type mem_type is array (0 to DEPTH-1) of std_logic_vector(MEM_SIZE-3 downto 0);

--signal tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7: STD_lOGIC_VECTOR(DATA_SIZE -1 downto 0);
--signal tmp8, tmp9, tmp10, tmp11, tmp12, tmp13, tmp14, tmp15: STD_lOGIC_VECTOR(DATA_SIZE -1 downto 0);

signal tmp: std_logic_vector(MEM_SIZE-3 downto 0);
signal mem: mem_type:= (
                        "0111110011111001000000111110000001000010000111110011111001111100111110011111000100100111110011111000000100111110",
                        "0000010000001001000000000010000001000101000100010010001000100000000010000001000100100100000010000000000100100010",
                        "0011110011111001111100000010011111000111000111110011111000010000111110011111001111100111110011111000000100100010",
                        "0000010000001001000100000010010001001000100100000010001000001000100010010000000100000100000000001000000100100010",
                        "0000010011111001111100111110011111001000100111110011111000000100111110011111000100000111110011111000000100111110"
                        ); 

begin
--tmp_loop:for i in 0 to ((MEM_SIZE-2)/7) - 1 generate
--    tmp(7*i+6 downto 7*i) <=mem(conv_integer(addr))(((conv_integer(index(4*i+3 downto 4*i))+1)*7 -1) downto (conv_integer(index(4*i+3 downto 4*i))*7));
--end generate tmp_loop;

tmp_loop:for i in 0 to ((MEM_SIZE-2)/7) - 1 generate
    tmp(7*i+6 downto 7*i) <=mem(conv_integer(addr))(((conv_integer(index(3 downto 0))+1)*7 -1) downto (conv_integer(index(3 downto 0))*7));
end generate tmp_loop;

--tmp15 <= mem(conv_integer(addr))(((conv_integer(index(63 downto 60))+1)*7 -1) downto (conv_integer(index(63 downto 60))*7)); 
--tmp14 <= mem(conv_integer(addr))(((conv_integer(index(59 downto 56))+1)*7 -1) downto (conv_integer(index(59 downto 56))*7)); 
--tmp13 <= mem(conv_integer(addr))(((conv_integer(index(55 downto 52))+1)*7 -1) downto (conv_integer(index(55 downto 52))*7)); 
--tmp12 <= mem(conv_integer(addr))(((conv_integer(index(51 downto 48))+1)*7 -1) downto (conv_integer(index(51 downto 48))*7)); 

--tmp11 <= mem(conv_integer(addr))(((conv_integer(index(47 downto 44))+1)*7 -1) downto (conv_integer(index(47 downto 44))*7)); 
--tmp10 <= mem(conv_integer(addr))(((conv_integer(index(43 downto 40))+1)*7 -1) downto (conv_integer(index(43 downto 40))*7)); 
--tmp9 <= mem(conv_integer(addr))(((conv_integer(index(39 downto 36))+1)*7 -1) downto (conv_integer(index(39 downto 36))*7)); 
--tmp8 <= mem(conv_integer(addr))(((conv_integer(index(35 downto 32))+1)*7 -1) downto (conv_integer(index(35 downto 32))*7)); 

--tmp7 <= mem(conv_integer(addr))(((conv_integer(index(31 downto 28))+1)*7 -1) downto (conv_integer(index(31 downto 28))*7)); 
--tmp6 <= mem(conv_integer(addr))(((conv_integer(index(27 downto 24))+1)*7 -1) downto (conv_integer(index(27 downto 24))*7)); 
--tmp5 <= mem(conv_integer(addr))(((conv_integer(index(23 downto 20))+1)*7 -1) downto (conv_integer(index(23 downto 20))*7)); 
--tmp4 <= mem(conv_integer(addr))(((conv_integer(index(19 downto 16))+1)*7 -1) downto (conv_integer(index(19 downto 16))*7)); 

--tmp3 <= mem(conv_integer(addr))(((conv_integer(index(15 downto 12))+1)*7 -1) downto (conv_integer(index(15 downto 12))*7)); 
--tmp2 <= mem(conv_integer(addr))(((conv_integer(index(11 downto 8))+1)*7 -1) downto (conv_integer(index(11 downto 8))*7)); 
--tmp1 <= mem(conv_integer(addr))(((conv_integer(index(7 downto 4))+1)*7 -1) downto (conv_integer(index(7 downto 4))*7)); 
--tmp0 <= mem(conv_integer(addr))(((conv_integer(index(3 downto 0))+1)*7 -1) downto (conv_integer(index(3 downto 0))*7)); 

--tmp15 <= mem(conv_integer(addr))(((conv_integer(index(7 downto 4))+1)*7 -1) downto (conv_integer(index(7 downto 4))*7)); 
--tmp14 <= mem(conv_integer(addr))(((conv_integer(index(3 downto 0))+1)*7 -1) downto (conv_integer(index(3 downto 0))*7)); 

--tmp13 <= mem(conv_integer(addr))(((conv_integer(index(7 downto 4))+1)*7 -1) downto (conv_integer(index(7 downto 4))*7)); 
--tmp12 <= mem(conv_integer(addr))(((conv_integer(index(3 downto 0))+1)*7 -1) downto (conv_integer(index(3 downto 0))*7)); 

--tmp11 <= mem(conv_integer(addr))(((conv_integer(index(7 downto 4))+1)*7 -1) downto (conv_integer(index(7 downto 4))*7)); 
--tmp10 <= mem(conv_integer(addr))(((conv_integer(index(3 downto 0))+1)*7 -1) downto (conv_integer(index(3 downto 0))*7)); 

--tmp9 <= mem(conv_integer(addr))(((conv_integer(index(7 downto 4))+1)*7 -1) downto (conv_integer(index(7 downto 4))*7)); 
--tmp8 <= mem(conv_integer(addr))(((conv_integer(index(3 downto 0))+1)*7 -1) downto (conv_integer(index(3 downto 0))*7)); 

--tmp7 <= mem(conv_integer(addr))(((conv_integer(index(7 downto 4))+1)*7 -1) downto (conv_integer(index(7 downto 4))*7)); 
--tmp6 <= mem(conv_integer(addr))(((conv_integer(index(3 downto 0))+1)*7 -1) downto (conv_integer(index(3 downto 0))*7)); 

--tmp5 <= mem(conv_integer(addr))(((conv_integer(index(7 downto 4))+1)*7 -1) downto (conv_integer(index(7 downto 4))*7)); 
--tmp4 <= mem(conv_integer(addr))(((conv_integer(index(3 downto 0))+1)*7 -1) downto (conv_integer(index(3 downto 0))*7)); 

--tmp3 <= mem(conv_integer(addr))(((conv_integer(index(7 downto 4))+1)*7 -1) downto (conv_integer(index(7 downto 4))*7)); 
--tmp2 <= mem(conv_integer(addr))(((conv_integer(index(3 downto 0))+1)*7 -1) downto (conv_integer(index(3 downto 0))*7)); 

--tmp1 <= mem(conv_integer(addr))(((conv_integer(index(7 downto 4))+1)*7 -1) downto (conv_integer(index(7 downto 4))*7)); 
--tmp0 <= mem(conv_integer(addr))(((conv_integer(index(3 downto 0))+1)*7 -1) downto (conv_integer(index(3 downto 0))*7)); 

--PROM_OP <= "00"&tmp15 & tmp14 & tmp13 & tmp12&
--           tmp11 & tmp10 & tmp9 & tmp8&
--           tmp7 & tmp6 & tmp5 & tmp4&
--           tmp3 & tmp2 & tmp1 & tmp0;

PROM_OP <= "00" & tmp;


end Behavioral;
