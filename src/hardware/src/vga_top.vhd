library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

entity VGATop is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        enciphered_data : in UNSIGNED(63 downto 0);
        deciphered_data : in UNSIGNED(63 downto 0);
        key             : in UNSIGNED(127 downto 0);
        hsync : out STD_LOGIC;
        vsync : out STD_LOGIC;
        red   : out STD_LOGIC_VECTOR (2 downto 0);
        green : out STD_LOGIC_VECTOR (2 downto 0);
        blue  : out STD_LOGIC_VECTOR (2 downto 0)
    );
end VGATop;

architecture Behavioral of VGATop is

    component vga_initials_top
        generic (
            strip_hpixels  : positive := 800;   -- Value of pixels in a horizontal line = 800
            strip_vlines   : positive := 512;   -- Number of horizontal lines in the display = 521
            strip_hbp      : positive := 144;   -- Horizontal back porch = 144 (128 + 16)
            strip_hfp      : positive := 784;   -- Horizontal front porch = 784 (128+16 + 640)
            strip_vbp      : positive := 31;    -- Vertical back porch = 31 (2 + 29)
            strip_vfp      : positive := 511;   -- Vertical front porch = 511 (2+29+ 480)
            data_depth     : positive := 5;
            data_length    : positive := 7;
            mem_length     : positive := 114;
            key_length     : positive := 226;
            count_size_top : positive := 10
        );
        Port (
            clk  : in STD_LOGIC;
            rst  : in STD_LOGIC;
            enciphered_data : in STD_LOGIC_VECTOR (63 downto 0);
		    deciphered_data : in STD_LOGIC_VECTOR(63 downto 0);
		    key             : in STD_LOGIC_VECTOR(127 downto 0);
            hsync: out STD_LOGIC;
            vsync: out STD_LOGIC; 
            red  : out STD_LOGIC_VECTOR (2 downto 0); 
            green: out STD_LOGIC_VECTOR (2 downto 0);
            blue : out STD_LOGIC_VECTOR (2 downto 0)   
        );
    end component;

    --signal index : STD_LOGIC_VECTOR(3 downto 0);

begin

    VGA_INITIALS: vga_initials_top
        port map (
            clk => clk,
            rst => rst,
            enciphered_data => std_logic_vector(enciphered_data),
			deciphered_data => std_logic_vector(deciphered_data),
			key => std_logic_vector(key),
            hsync => hsync,
            vsync => vsync,
            red => red,
            green => green,
            blue => blue
        );

end Behavioral;
