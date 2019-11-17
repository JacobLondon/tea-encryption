library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;

entity TeaEncipherTb is
    --Port()
end TeaEncipherTb; 

architecture Behavioral of TeaEncipherTb is

    component TeaEncipher is
        Generic (
            g_ROUNDS : POSITIVE := 64
        );
        Port (
            input_data  : in  UNSIGNED(63 downto 0);
            key         : in  UNSIGNED(127 downto 0);
            output_data : out UNSIGNED(63 downto 0)
        );
    end component;

    signal din, dout : UNSIGNED(63 downto 0);
    signal key       : UNSIGNED(127 downto 0);
    
begin

    din <= x"DEADBEEFFEEBDAED";
    key <= x"FEEDBEEF00C0FFEEF00000110FACADE0";
    
    ENCODER: TeaEncipher
        generic map (
            g_ROUNDS => 64
        )
        port map (
            input_data  => din,
            key         => key,
            output_data => dout
        );

end Behavioral;
