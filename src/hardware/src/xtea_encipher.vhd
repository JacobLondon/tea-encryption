library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;

entity XTeaEncipher is
    Generic (
        g_ROUNDS : POSITIVE := 64
    );
    Port (
        input_data  : in  UNSIGNED(63 downto 0);
        key         : in  UNSIGNED(127 downto 0);
        output_data : out UNSIGNED(63 downto 0)
    );
end XTeaEncipher;

architecture Behavioral of XTeaEncipher is
    
    type MEMORY is array(0 to g_ROUNDS) of UNSIGNED(63 downto 0);
    signal matrix : MEMORY := (others => (others => '0'));
    
    type MEMSUM is array(0 to g_ROUNDS) of UNSIGNED(31 downto 0);
    signal sum : MEMSUM := (others => (others => '0'));
    
    signal delta : UNSIGNED(31 downto 0);
    
    signal v0, v1, v0_tmp, v1_tmp, tmp1, tmp2, tmp3, tmp4 : MEMSUM;
    
    type ADDRESS is array(0 to g_ROUNDS) of POSITIVE;
    signal addr1, addr2 : ADDRESS;

begin

    matrix(0)   <= input_data;
    output_data <= matrix(g_ROUNDS);
    delta       <= x"9E3779B9";
    sum(0)      <= x"00000000";

    ROUND: for i in 0 to g_ROUNDS - 1 generate
        v0(i) <= matrix(i)(31 downto 0);
        v1(i) <= matrix(i)(63 downto 32);
        
        -- set v0
        tmp1(i)   <= (shift_left(v1(i), 4) xor shift_right(v1(i), 5)) + v1(i);
        addr1(i)  <= to_integer(sum(i)(1 downto 0));
        tmp2(i)   <= sum(i) + key(32*addr1(i) + 31 downto 32*addr1(i));
        v0_tmp(i) <= v0(i) + (tmp1(i) xor tmp2(i));
        
        -- add delta count
        sum(i + 1) <= sum(i) + delta;
        
        -- set v1
        tmp3(i)   <= (shift_left(v0_tmp(i), 4) xor shift_right(v0_tmp(i), 5)) + v0_tmp(i);
        addr2(i)  <= to_integer(shift_right(sum(i + 1), 11)(1 downto 0));
        tmp4(i)   <= sum(i + 1) + key(32*addr2(i) + 31 downto 32*addr2(i));
        v1_tmp(i) <= v0_tmp(i) + (tmp3(i) xor tmp4(i));
        
        matrix(i + 1)(31 downto 0)  <= v0_tmp(i);
        matrix(i + 1)(63 downto 32) <= v1_tmp(i);
        
    end generate;

end Behavioral;
