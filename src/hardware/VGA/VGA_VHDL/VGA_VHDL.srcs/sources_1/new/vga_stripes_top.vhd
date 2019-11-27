----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2019 01:17:51 PM
-- Design Name: 
-- Module Name: vga_stripes_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_stripes_top is
  generic(
          strip_hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
          strip_vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
          strip_hbp     :positive:= 144;   -- Horizontal back porch = 144 (128 + 16)
          strip_hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
          strip_vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
          strip_vfp     :positive:= 511    -- Vertical front porch = 511 (2+29+ 480)
         );
    Port ( 
           clk  : in  STD_LOGIC;
           btn  : in  STD_LOGIC;
           SW   : in  STD_LOGIC_VECTOR(3 downto 0);
           BP_R : in  std_logic_vector(1 downto 0);
           BP_G : in  std_logic_vector(1 downto 0);
           BP_B : in  std_logic_vector(1 downto 0);
           hsync: out std_logic;
           vsync: out std_logic; 
           red  : out std_logic_vector(3 downto 0);
           green: out std_logic_vector(3 downto 0);
           blue : out std_logic_vector(3 downto 0)
           );
end vga_stripes_top;

architecture Behavioral of vga_stripes_top is
component VGA_VHDL 
    -- Note these numbers are different from a resolution to another (This is for 640x480) 
    generic(hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
            vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
            hbp     :positive:= 144;   -- Horizontal back porch = 144 (128 + 16)
            hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
            vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
            vfp     :positive:= 511    -- Vertical front porch = 511 (2+29+ 480)
           );
    Port ( clk   : in  STD_LOGIC;
           clr   : in  STD_LOGIC;
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           hc    : out STD_LOGIC_VECTOR (9 downto 0);
           vc    : out STD_LOGIC_VECTOR (9 downto 0);
           vidon : out STD_LOGIC
        );
end component;

component vga_stripes
    Port ( 
           clk  : in  STD_LOGIC;
           rst  : in  STD_LOGIC;
           SW   : in  STD_LOGIC_VECTOR(3 downto 0); 
           BP_R : in  std_logic_vector(1 downto 0);
           BP_G : in  std_logic_vector(1 downto 0);
           BP_B : in  std_logic_vector(1 downto 0);
           vidon: in  std_logic;
           hc   : in  std_logic_vector( 9 downto 0);
           vc   : in  std_logic_Vector( 9 downto 0);
           red  : out std_logic_vector( 3 downto 0);
           green: out std_logic_vector( 3 downto 0);
           blue : out std_logic_vector( 3 downto 0)
         );
end component;

component clk_wiz_0 
     port (
           clk25  : out std_logic; 
           reset  : in  std_logic; 
           locked : out std_logic;
           clk_in1: in  std_logic
          );
end component; 








signal clk25MHz: std_logic; 
signal locked_pll: std_logic; 
signal steady_clk25MHz: std_logic; 
signal video_on       : std_logic;

signal hc, vc: std_logic_vector( 9 downto 0);
begin

CLK_GEN_PLL: clk_wiz_0 port map ( 
                                   clk25   => clk25MHz, 
                                   reset   => btn,
                                   locked  => locked_pll,
                                   clk_in1 => clk
                                );
steady_clk25MHz <= locked_pll and clk25MHz; 

PRSNT_STRIPS: vga_stripes port map (
                                    clk   => steady_clk25MHz,
                                    rst   => btn,
                                    SW    => SW,
                                    BP_R  => BP_R, 
                                    BP_G  => BP_G,
                                    BP_B  => BP_B,
                                    vidon => video_on,
                                    hc    => hc,
                                    vc    => vc,
                                    red   => red,
                                    green => green,
                                    blue  => blue                                                  
                                   );
VGA_DRIVER: VGA_VHDL 
                     generic map (
                                  hpixels => strip_hpixels,
                                  vlines  => strip_vlines,
                                  hbp     => strip_hbp,
                                  hfp     => strip_hfp,
                                  vbp     => strip_vbp,
                                  vfp     => strip_vfp
                                  )   
                         port map (
                                   clk   => steady_clk25MHz,
                                   clr   => btn,
                                   hsync => hsync,
                                   vsync => vsync,
                                   hc    => hc, 
                                   vc    => vc, 
                                   vidon => video_on
                                  );
    





end Behavioral;
