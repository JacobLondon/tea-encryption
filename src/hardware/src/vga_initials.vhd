----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2019 04:16:02 PM
-- Design Name: 
-- Module Name: vga_initials - Behavioral
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

entity vga_initials is
    generic (hbp:positive:=144; vbp:positive:=31; W:positive:=32; H:positive:= 5 );
    Port ( 
           clk      : in  STD_LOGIC; 
           rst      : in  STD_LOGIC; 
           vidon    : in  STD_LOGIC;
           hc       : in  STD_LOGIC_VECTOR (9  downto 0);
           vc       : in  STD_LOGIC_VECTOR (9  downto 0);
           M        : in  STD_LOGIC_VECTOR (W-1 downto 0);
           SW       : in  STD_LOGIC_VECTOR (7  downto 0);
           rom_addr4: out STD_LOGIC_VECTOR (2  downto 0);
           red      : out STD_LOGIC_VECTOR (2  downto 0); 
           green    : out STD_LOGIC_VECTOR (2  downto 0); 
           blue     : out STD_LOGIC_VECTOR (2  downto 0)
         );
end vga_initials;

architecture Behavioral of vga_initials is


signal C1, R1, rom_addr, rom_pix: std_logic_vector(10 downto 0); 
signal spriteon, R, G, B: std_logic; 

begin

C1 <= ("00" & sw(3 downto 0) & "00001");
R1 <= ("00" & sw(7 downto 4) & "00001");
rom_addr  <= vc - vbp- R1; 
rom_pix   <= hc - hbp- C1;
rom_addr4 <= rom_addr(2 downto 0); 

-- Enable sprite video out when within the sprite region 

REGION_ACTIVE:process(clk,rst)
              begin 
              if (rst = '1') then 
                spriteon <= '0';                              
              elsif(rising_edge(clk)) then 
                if (hc >= C1 + hbp) and (hc < C1 + hbp+ W) and (VC >= R1 +vbp) and (vc < R1 + vbp +H) then 
                    spriteon <= '1';
                else 
                    spriteon <= '0';
                end if; 
              end if; 
              end process; 

-- Output video color signals

OUTP_COLOR:process(clk,rst)
           begin 
            if (rst = '1') then 
                red   <= (others =>'0');
                green <= (others =>'0');
                blue  <= (others =>'0'); 
            elsif(rising_edge(clk)) then 
                if (spriteon = '1' and vidon = '1') then 
                
                    R <= M(conv_integer(rom_pix)); 
                    G <= M(conv_integer(rom_pix)); 
                    B <= M(conv_integer(rom_pix));
                    
                    red  <= (R & R & R); 
                    green<= (G & G & G); 
                    blue <= (B & B & B);
                end if; 
                
            end if; 
           end process; 


end Behavioral;
