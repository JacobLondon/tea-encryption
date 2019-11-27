library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

-- 
-- Controls
-- Switches(7 downto 0) => number of rounds
-- 
-- 

entity TeaTop is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        switches : in STD_LOGIC_VECTOR(15 downto 0);

        hsync : out STD_LOGIC;
        vsync : out STD_LOGIC;
        red  : out STD_LOGIC_VECTOR (2 downto 0);
        green: out STD_LOGIC_VECTOR (2 downto 0);
        blue : out STD_LOGIC_VECTOR (2 downto 0)
    );
end TeaTop;

architecture Behavioral of TeaTop is

    component TeaEncipher
        Port (
            clk         : in  STD_LOGIC;
            rst         : in  STD_LOGIC;
            num_rounds  : in  UNSIGNED(7 downto 0);
            input_data  : in  UNSIGNED(63 downto 0);
            key         : in  UNSIGNED(127 downto 0);
            output_data : out UNSIGNED(63 downto 0);
            done        : out STD_LOGIC
        );
    end component;

    component TeaDecipher
        Port (
            clk         : in  STD_LOGIC;
            rst         : in  STD_LOGIC;
            num_rounds  : in  UNSIGNED(7 downto 0);
            input_data  : in  UNSIGNED(63 downto 0);
            key         : in  UNSIGNED(127 downto 0);
            output_data : out UNSIGNED(63 downto 0);
            done        : out STD_LOGIC
        );
    end component;

    signal num_rounds : UNSIGNED(7 downto 0);

    signal encipher_input, encipher_output, decipher_output : UNSIGNED(63 downto 0);
    signal key : UNSIGNED(127 downto 0);
    signal encipher_done, decipher_done : STD_LOGIC;

begin

    num_rounds <= UNSIGNED(switches(7 downto 0));
    
    ENCIPHERER: TeaEncipher
        port map (
            clk => clk,
            rst => rst,
            num_rounds => num_rounds,
            input_data => encipher_input,
            key => key,
            output_data => encipher_output,
            done => encipher_done
        );
    
    DECIPHERER: TeaDecipher
        port map (
            clk => clk,
            rst => rst,
            num_rounds => num_rounds,
            input_data => encipher_output,
            key => key,
            output_data => decipher_output,
            done => decipher_done
        );

end Behavioral;