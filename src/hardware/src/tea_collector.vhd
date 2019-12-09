library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TeaCollector is
    Generic ( 
        g_CLK_PER_BIT : POSITIVE:= 100000000 / 1000000;                  -- FPGA clock / baud rate
        g_DATA_SIZE   : POSITIVE:= 64;
        g_KEY_SIZE    : POSITIVE:= 128
    );
    Port ( 
        i_clk         : in  STD_LOGIC;
        i_rx          : in  STD_LOGIC;
        i_rst         : in  STD_LOGIC;
        --co_done       : out STD_LOGIC;
        o_data        : out UNSIGNED(g_DATA_SIZE - 1 downto 0);
        o_key         : out UNSIGNED(g_KEY_SIZE - 1 downto 0)
    );
end TeaCollector;

architecture Behavioral of TeaCollector is

    component UartRx
        Generic ( 
            g_CLK_PER_BIT : POSITIVE:= 100000000 / 1000000
        );
        Port ( 
            i_clk         : in  STD_LOGIC;
            i_rx          : in  STD_LOGIC;                      -- Serial bit transmitted to rx
            i_rst         : in  STD_LOGIC;
            o_byte        : out STD_LOGIC_VECTOR(7 downto 0);
            o_done        : out STD_LOGIC                       -- Byte received flag
        );
    end component;

    component AsciiToHex
    Port (
        i_ASCII  : in  STD_LOGIC_VECTOR(7 downto 0);
        o_hex    : out STD_LOGIC_VECTOR(3 downto 0)
    );
    end component;

    type STATE_MACHINE is (s_data, s_key, s_convert);
    signal state          : STATE_MACHINE:= s_data;

    signal state_index    : NATURAL:= 0;
        
    signal rx_done        : STD_LOGIC:= '0';
    signal choice         : STD_LOGIC:= '0';
    --signal temp_done      : STD_LOGIC:= '0';

    signal h_data         : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');       -- Output of ASCII_to_HEX function
    signal a_data         : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal temp           : STD_LOGIC_VECTOR(7 downto 0):= (others => '0');     -- Byte received by uart
    
    signal data           : STD_LOGIC_VECTOR(g_DATA_SIZE - 1 downto 0):= (others => '0');
    signal key            : STD_LOGIC_VECTOR(g_KEY_SIZE - 1 downto 0):= (others => '0');

begin

    BYTE_RX: UartRx 
        Generic map (
            g_CLK_PER_BIT => g_CLK_PER_BIT
        )
        Port map ( 
            i_clk         => i_clk,
            i_rx          => i_rx,
            i_rst         => i_rst,
            o_byte        => temp,
            o_done        => rx_done
        );

    CONVERT: AsciiToHex
        Port map (
            i_ASCII       => a_data,
            o_hex         => h_data
        );

    STATE_CONTROL: process (i_clk) is
    begin          
        if rising_edge(i_clk) then
            if (i_rst = '1') then
                state       <= s_data;
                --temp_done   <= '0';
                state_index <= 0;
                a_data      <= (others => '0');
                data        <= (others => '0');
                key         <= (others => '0');
            else
                case state is
                    when s_data =>
                        --temp_done <= '0';
                        choice    <= '0';

                        if (rx_done = '1') then
                            a_data <= temp;
                            state <= s_convert;
                        end if;

                    when s_key =>
                        choice    <= '1';
                        
                        if (rx_done = '1') then
                            a_data <= temp;
                            state <= s_convert;
                        end if;

                    when s_convert =>
                        if (h_data /= "ZZZZ") then
                            if (choice = '0') then
                                data(state_index + 3 downto state_index) <= h_data;

                                if (state_index + 4 > g_DATA_SIZE - 4) then
                                    state_index <= 0;
                                    state       <= s_key;
                                else
                                    state_index <= state_index + 4;
                                    state       <= s_data;
                                end if;
                            else
                                key(state_index + 3 downto state_index) <= h_data;

                                if (state_index + 4 > g_KEY_SIZE - 4) then
                                    --temp_done   <= '1';
                                    state_index <= 0;
                                    state       <= s_data;
                                else
                                    state_index <= state_index + 4;
                                    state       <= s_key;
                                end if;
                            end if;
                        else
                            if (choice = '0') then
                                state <= s_data;
                            else
                                state <= s_key;
                            end if;
                        end if;

                     when others => 
                        state <= s_data;
                end case;
            end if;
       end if;
    end process STATE_CONTROL;

    --co_done <= temp_done;
    o_data  <= UNSIGNED(data);
    o_key   <= UNSIGNED(key);

end Behavioral;