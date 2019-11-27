library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity TeaDecipher is
    Port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        num_rounds  : in  UNSIGNED(7 downto 0);
        input_data  : in  UNSIGNED(63 downto 0);
        key         : in  UNSIGNED(127 downto 0);
        output_data : out UNSIGNED(63 downto 0);
        done        : out STD_LOGIC
    );
end TeaDecipher;

architecture Behavioral of TeaDecipher is
    
    signal delta : UNSIGNED(31 downto 0);
    signal k0, k1, k2, k3 : UNSIGNED(31 downto 0);
    signal v0, v1, next_v0, next_v1, t1, t2, t3, t4,t5, t6, t7, t8, t9, t10, t11, t12, t13, t14 : UNSIGNED(31 downto 0);
    signal sum, next_sum : UNSIGNED(31 downto 0);
    
    signal round, next_round: UNSIGNED(7 downto 0);
    type STATE_TYPE is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24);
    signal curr_state, next_state : STATE_TYPE;
    
    signal max_rounds : UNSIGNED(63 downto 0);

begin

    delta <= x"9E3779B9";
    
    k3 <= key(31 downto 0);
    k2 <= key(63 downto 32);
    k1 <= key(95 downto 64);
    k0 <= key(127 downto 96);
    
    max_rounds <= delta * (x"000000" & num_rounds);
    
    CONTINUE: process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                curr_state <= s0;
            else
                curr_state <= next_state;
            end if;
        end if;
    end process;
    
    ENCIPHER_MACHINE: process (clk)
    begin
        case curr_state is
            -- reset all variables
            when s0 => 
                done   <= '0';
                sum    <= max_rounds(31 downto 0);
                next_sum <= (others => '0');
                round  <= (others => '0');
                next_round <= (others => '0');
                t1     <= (others => '0');
                t2     <= (others => '0');
                t3     <= (others => '0');
                t4     <= (others => '0');
                t5     <= (others => '0');
                t6     <= (others => '0');
                t7     <= (others => '0');
                t8     <= (others => '0');
                t9     <= (others => '0');
                t10    <= (others => '0');
                t11    <= (others => '0');
                t12    <= (others => '0');
                t13    <= (others => '0');
                t14    <= (others => '0');
                v1     <= input_data(31 downto 0);
                v0     <= input_data(63 downto 32);
                next_v0 <= (others => '0');
                next_v1 <= (others => '0');
                next_state <= s1;
            when s1 => 
                t1 <= v0 sll 4;
                next_state <= s2;
            when s2 => 
                t2 <= t1 + k2;
                next_state <= s3;
            when s3 => 
                t3 <= v0 + sum;
                next_state <= s4;
            when s4 => 
                t4 <= v0 srl 5;
                next_state <= s5;
            when s5 => 
                t5 <= t4 + k3;
                next_state <= s6;
            when s6 => 
                t6 <= t2 xor t3;
                next_state <= s7;
            when s7 => 
                t7 <= t5 xor t6;
                next_state <= s8;
            when s8 => 
                next_v1 <= v1 - t7;
                next_state <= s9;
            when s9 => 
                v1 <= next_v1;
                next_state <= s10;
            
            when s10 => 
                t8 <= v1 sll 4;
                next_state <= s11;
            when s11 => 
                t9 <= t8 + k0;
                next_state <= s12;
            when s12 => 
                t10 <= v1 + sum;
                next_state <= s13;
            when s13 => 
                t11 <= v1 srl 5;
                next_state <= s14;
            when s14 => 
                t12 <= t11 + k1;
                next_state <= s15;
            when s15 => 
                t13 <= t9 xor t10;
                next_state <= s16;
            when s16 => 
                t14 <= t12 xor t13;
                next_state <= s17;
            when s17 => 
                next_v0 <= v0 - t14;
                next_state <= s18;
            when s18 => 
                v0 <= next_v0;
                next_state <= s19;
            
            when s19 => 
                next_sum <= sum - delta;
                next_state <= s20;
            when s20 => 
                sum <= next_sum;
                next_state <= s21;
                
            when s21 => 
                next_round <= round + 1;
                next_state <= s22;
            when s22 => 
                round <= next_round;
                next_state <= s23;
            when s23 => 
                if round = num_rounds then
                    next_state <= s24;
                else
                    next_state <= s1;
                end if;
            when s24 => 
                output_data <= v0 & v1;
                done <= '1';
                if rst = '1' then
                    next_state <= s0;
                else
                    next_state <= s24;
                end if;
            when others => 
                next_state <= s0;
        end case;
    end process;

end Behavioral;