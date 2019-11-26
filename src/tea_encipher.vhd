library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity TeaEncipher is
    Port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        num_rounds  : in  UNSIGNED(7 downto 0);
        input_data  : in  UNSIGNED(63 downto 0);
        key         : in  UNSIGNED(127 downto 0);
        output_data : out UNSIGNED(63 downto 0);
        done        : out STD_LOGIC
    );
end TeaEncipher;

architecture Behavioral of TeaEncipher is
    
    signal delta : UNSIGNED(31 downto 0);
    signal k0, k1, k2, k3 : UNSIGNED(31 downto 0);
    signal v0, v1, v0_new, v1_new, t1, t2, t3, t4,t5, t6, t7 : UNSIGNED(31 downto 0);
    signal sum, next_sum : UNSIGNED(31 downto 0);
    
    signal round, next_round: UNSIGNED(7 downto 0);
    type STATE_TYPE is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20);
    signal curr_state, next_state : STATE_TYPE;

begin

    delta <= x"9E3779B9";
    
    k0 <= key(31 downto 0);
    k1 <= key(63 downto 32);
    k2 <= key(95 downto 64);
    k3 <= key(127 downto 96);
    
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
                sum    <= (others => '0');
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
                v0     <= input_data(31 downto 0);
                v1     <= input_data(63 downto 32);
                v0_new <= (others => '0');
                v1_new <= (others => '0');
                next_state <= s1;
            when s1 => 
                next_state <= s2;
            when s2 => 
                next_state <= s3;
            when s3 => 
                next_state <= s4;
            when s4 => 
                next_state <= s5;
            when s5 => 
                next_state <= s6;
            when s6 => 
                next_state <= s7;
            when s7 => 
                next_state <= s8;
            when s8 => 
                next_state <= s9;
            when s9 => 
                next_state <= s10;
            when s10 => 
                next_state <= s11;
            when s11 => 
                next_state <= s12;
            when s12 => 
                next_state <= s13;
            when s13 => 
                next_state <= s14;
            when s14 => 
                next_state <= s15;
            when s15 => 
                t6 <= t2 xor t3;
                next_state <= s16;
            when s16 => 
                next_state <= s17;
            when s17 => 
                next_state <= s18;
            when s18 => 
                next_state <= s19;
            when s19 => 
            when s20 => 
            when s21 => 
            when s22 => 
            when s23 => 
            when s24 => 
            when others => 
                next_state <= s0;
        end case;
    end process;

end Behavioral;