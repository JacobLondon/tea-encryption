library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity EncipherTea is
    Generic (
        g_ROUNDS : POSITIVE := 64
    );
    Port (
        input_data  : in  UNSIGNED(63 downto 0);
        key         : in  UNSIGNED(127 downto 0);
        output_data : out UNSIGNED(63 downto 0)
    );
end EncipherTea;

architecture Behavioral of EncipherTea is

    type MEMORY is array(0 to g_ROUNDS) of UNSIGNED(63 downto 0);
    signal matrix : MEMORY := (others => (others => '0'));
    type MEMSUM is array(0 to g_ROUNDS) of UNSIGNED(31 downto 0);
    signal sum : MEMSUM := (others => (others => '0'));
    
    signal delta : UNSIGNED(31 downto 0);
    signal k0, k1, k2, k3 : UNSIGNED(31 downto 0);
    signal v0, v1, v0_new, v1_new : MEMSUM;

begin

    matrix(0)   <= input_data;
    output_data <= matrix(g_ROUNDS);
    delta       <= x"9E3779B9";
    sum(0)      <= x"00000000";
    
    k0 <= key(31 downto 0);
    k1 <= key(63 downto 32);
    k2 <= key(95 downto 64);
    k3 <= key(127 downto 96);
    
    ROUNDS: for i in 0 to g_ROUNDS - 1 generate
        v0(i) <= matrix(i)(31 downto 0);
        v1(i) <= matrix(i)(63 downto 32);
        
        -- sum      = sum    + delta;
        sum(i + 1) <= sum(i) + delta;
        -- v0       = v0    + ((v1       <<   4) + k0)  ^  (v1        + sum)         ^  ((v1        >>  5) + k1);
        v0_new(i)  <= v0(i) + ((v1(i)    sll  4) + k0) xor (v1(i)     + sum(i + 1)) xor ((v1(i)     srl 5) + k1);
        -- v1       = v1    + ((v0       <<   4) + k2)  ^  (v0        + sum)         ^  ((v0        >>  5) + k3);
        v1_new(i)  <= v1(i) + ((v0_new(i) sll 4) + k2) xor (v0_new(i) + sum(i + 1)) xor ((v0_new(i) srl 5) + k3);
    
        matrix(i + 1) <= v1_new(i) & v0_new(i);
                
    end generate;

end Behavioral;