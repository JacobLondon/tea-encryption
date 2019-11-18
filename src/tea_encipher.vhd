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
        output_data : out UNSIGNED(63 downto 0)
    );
end TeaEncipher;

architecture Behavioral of TeaEncipher is
    
    signal delta : UNSIGNED(31 downto 0);
    signal k0, k1, k2, k3 : UNSIGNED(31 downto 0);
    signal v0, v1 : UNSIGNED(31 downto 0);
    signal sum : UNSIGNED(31 downto 0);
    
    signal round : UNSIGNED(7 downto 0);
    signal state : UNSIGNED(3 downto 0) := "0000";
    signal result : UNSIGNED(63 downto 0);

begin

    --matrix(0)   <= input_data;
    --output_data <= matrix(g_ROUNDS);
    delta <= x"9E3779B9";
    
    k0 <= key(31 downto 0);
    k1 <= key(63 downto 32);
    k2 <= key(95 downto 64);
    k3 <= key(127 downto 96);
    
    ENCIPHER_MACHINE: process (clk) is
    begin
        if rising_edge(clk) then
            case state is
                -- initialize, only happen once
                when x"0" => 
                    sum <= x"00000000";
                    round <= x"00";
                    v0  <= input_data(31 downto 0);
                    v1  <= input_data(63 downto 32);
                    state <= x"1";
                when x"1" => 
                when x"2" => 
                when x"3" => 
                when x"4" => 
                when x"5" => 
                when x"6" => 
                when x"7" => 
                when x"8" => 
                when x"9" => 
                when x"A" => 
                when x"B" => 
                when x"C" => 
                when x"D" => 
                when x"E" => 
                    -- finished doing all rounds
                    if round + 1 = num_rounds then
                        state <= x"F";
                    -- go again for another round
                    else
                        round <= round + 1;
                        state <= x"1";
                    end if;
                -- close down, wait for rst signal
                when x"F" => 
                    if rst = '1' then
                        state <= x"0";
                    else
                        state <= x"F";
                    end if;
                when others => state <= x"0";
            end case;
        end if;
    end process;

end Behavioral;