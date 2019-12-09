library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TeaCollectorTb is
    Generic (
        tb_CLK_PER_BIT : POSITIVE := 100000000 / 1000000;           -- Needs to be set correctly
        tb_DATA_SIZE   : POSITIVE := 32;
        tb_KEY_SIZE    : POSITIVE := 32
    );
end TeaCollectorTb;

architecture Behavioral of TeaCollectorTb is
    
    component UartTx
        Generic (
            g_CLK_PER_BIT : POSITIVE:= 100000000 / 1000000         -- FPGA clock / baud rate
        );
        Port ( 
            i_clk         : in  STD_LOGIC;
            i_enable      : in  STD_LOGIC;
            i_rst         : in  STD_LOGIC;
            i_byte        : in  STD_LOGIC_VECTOR(7 downto 0);   -- Byte to be transmitted 
            o_tx          : out STD_LOGIC;                      -- Individual serial bits transmitted       
            o_ready       : out STD_LOGIC;                      -- Transmission ready flag
            o_done        : out STD_LOGIC
        );
    end component;
    
    component TeaCollector
        Generic ( 
            g_CLK_PER_BIT : POSITIVE:= 100000000 / 1000000;
            g_DATA_SIZE   : POSITIVE:= 64;
            g_KEY_SIZE    : POSITIVE:= 128
        );
        Port ( 
            i_clk         : in  STD_LOGIC;
            i_rx          : in  STD_LOGIC;
            i_rst         : in  STD_LOGIC;
            --co_done       : out STD_LOGIC;
            o_data        : out STD_LOGIC_VECTOR(g_DATA_SIZE - 1 downto 0);
            o_key         : out STD_LOGIC_VECTOR(g_KEY_SIZE - 1 downto 0)
        );
    end component;
    
    constant wt       : TIME:= 5ns;              -- (FPGA clock period)/2
    
    signal tb_clk     : STD_LOGIC := '0';
    signal tb_enable  : STD_LOGIC := '0';
    signal tb_rst     : STD_LOGIC := '0';
    signal tb_ready   : STD_LOGIC := '0';
    signal tb_done    : STD_LOGIC := '0';
    signal tb_tx      : STD_LOGIC := '1';
    --signal tb_co_done : STD_LOGIC := '0';

    signal tb_tx_byte : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');   -- Byte to be transmitted
    
    signal tb_data    : STD_LOGIC_VECTOR(tb_DATA_SIZE - 1 downto 0) := (others => '0');
    signal tb_key     : STD_LOGIC_VECTOR(tb_KEY_SIZE - 1 downto 0) := (others => '0');
    
begin
    
    UART_TX_INST: UartTx
        Generic map (
            g_CLK_PER_BIT => tb_CLK_PER_BIT
        )
        Port map (
            i_clk         => tb_clk,
            i_enable      => tb_enable,
            i_rst         => tb_rst,
            i_byte        => tb_tx_byte,
            o_tx          => tb_tx,
            o_ready       => tb_ready,
            o_done        => tb_done
        );
    
    XTEA_COLL_INST: TeaCollector
        Generic map (
            g_CLK_PER_BIT => tb_CLK_PER_BIT,
            g_DATA_SIZE   => tb_DATA_SIZE,
            g_KEY_SIZE    => tb_KEY_SIZE
        )
        Port map (
            i_clk         => tb_clk,
            i_rx          => tb_tx,
            i_rst         => tb_rst,
            --co_done       => tb_co_done,
            o_data        => tb_data,
            o_key         => tb_key
        );
    
    CLK_GEN: process      -- Generates 100 MHz clock signal
    begin
                
        tb_clk <= '1';
        wait for wt;
        tb_clk <= '0';
        wait for wt;

    end process CLK_GEN;
    
    SIM_GEN: process
    begin
    
        -- (FPGA clock period) * (g_CLK_PER_BIT) for 1 bit
        -- 1 start bit, 8 bit data, 1 stop bit
        -- Approx. 10,000 ns for 1 byte to transfer (100 MHz clock and 1000000 baud rate)

        tb_rst     <= '1';
        wait for 4*wt;
        tb_rst     <= '0';
        wait for 4*wt;

        -- Sending non-hex character
        tb_tx_byte <= X"FF";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;
        --

        tb_tx_byte <= X"66";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;     -- (10,000 / 5) ns
        
        tb_tx_byte <= X"41";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        -- Sending non-hex character
        tb_tx_byte <= X"00";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;
        --

        tb_tx_byte <= X"32";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        tb_tx_byte <= X"33";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        tb_tx_byte <= X"66";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        tb_tx_byte <= X"66";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        tb_tx_byte <= X"66";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        tb_tx_byte <= X"66";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        -- Sending non-hex character
        tb_tx_byte <= X"11";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;
        --

        tb_tx_byte <= X"34";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;
        
        tb_tx_byte <= X"35";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        tb_tx_byte <= X"36";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        -- Sending non-hex character
        tb_tx_byte <= X"55";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;
        --

        tb_tx_byte <= X"37";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        tb_tx_byte <= X"44";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        tb_tx_byte <= X"44";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        tb_tx_byte <= X"44";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        tb_tx_byte <= X"44";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait for 2010*wt;

        -- Sending non-hex character
        tb_tx_byte <= X"99";
        tb_enable  <= '1';
        wait for 2*wt;
        tb_enable  <= '0';
        wait;
        --

    end process SIM_GEN;
end Behavioral;