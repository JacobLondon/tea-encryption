----------------------------------------------------------------------------------
-- Company: California Polytechnic State University Pomona, University of Illinois at Ubrana-Champagin, US AirForce Research Labratory 
-- Engineer: Professor Mohamed El-Hadedy Aly
-- 
-- Create Date: 10/30/2019 12:29:03 PM
-- Design Name: 
-- Module Name: VGA_VHDL - Behavioral
-- Project Name: VGA driver 640x480
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_VHDL is
    -- Note these numbers are different from a resolution to another (This is for 640x480) 
    generic(
    
            H_SP    :positive:= 128;  -- Horizontal Sync Pulse
            H_BP    :positive:= 16;   -- Horizontal Back Porch
            H_FP    :positive:= 16;   -- Horizontal Front Porch
            H_Video :positive:= 640;  -- Horizontal Video lines (Active area)
    
            hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800 (H_SP+H_BP+H_VIDEO+H_FP)
             
            hbp     :positive:= 144;   -- Horizontal back porch = 144 (128 + H_BP)
            hfp     :positive:= 784;   -- Horizontal front porch = 784 (H_SP+H_FP + H_VIDEO)
            
            
            
            
            
            V_SP   :positive:=  2;     -- Virtical Sync Porch 
            V_BP   :positive:= 29;     -- Virtical Back Porch 
            V_FP   :positive:= 10;     -- Virtical Front Porch 
            V_Video:positive:= 480;    -- Virtical Video lines  (Active area)
            
            vlines  :positive:= 521;   -- Number of horizontal lines in the display = V_SP + V_BP + V_Video + V_FP
            vbp     :positive:= 31;    -- Vertical back porch = 31 (V_SP + V_BP)
            vfp     :positive:= 511    -- Vertical front porch = 511 (V_SP+V_BP+ V_Video)
           );
    Port ( clk   : in  STD_LOGIC;
           clr   : in  STD_LOGIC;
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           hc    : out STD_LOGIC_VECTOR (9 downto 0);
           vc    : out STD_LOGIC_VECTOR (9 downto 0);
           vidon : out STD_LOGIC
        );
end VGA_VHDL;

architecture Behavioral of VGA_VHDL is

signal vsenable: std_logic; 
signal hc_reg  : std_logic_vector( 9 downto 0); 
signal vc_reg  : std_logic_vector( 9 downto 0); 

begin

-- Counter for Horizontal sync signal 

CHSS:process(clk, clr)
     begin 
        if (clr = '1') then 
            hc_reg <= (others =>'0'); 
            vsenable <= '0';
        elsif(rising_edge(clk)) then 
           if (hc_reg = hpixels -1) then 
               hc_reg <= (others =>'0');
               vsenable <= '1';
           else    
               hc_reg <= hc_reg + 1;
               vsenable <= '0';
           end if;          
        end if; 
     end process; 

-- Generate hsync pulse (Horizontal Sync Pulse is low when hc_reg is 0 - 127)

GHSS:process(clk,clr)
     begin 
        if (clr = '1') then 
            hsync <= '0';
        elsif(rising_edge(clk)) then 
            if (hc_reg <H_SP) then 
                hsync <= '0';
            else 
               hsync <= '1';             
            end if; 
        end if; 
     end process; 

-- Counter for the Vertical sync signal 

CVSS:process(clk,clr)
     begin 
        if (clr = '1') then 
            vc_reg <= (others =>'0'); 
        elsif(rising_edge(clk)) then 
            if (vsenable = '1') then 
                if (vc_reg = vlines -1) then 
                    vc_reg <= (others =>'0'); 
                else 
                    vc_reg <= vc_reg + 1; 
                end if; 
            end if; 
        end if; 
     end process; 

-- Generate vsync pulse 
-- Vertical Sync Pulse is low when vc is 0 -1 
GSYNCV:process(clk,clr)
       begin 
        if (clr = '1') then 
            vsync <= '1'; 
        elsif(rising_edge(clk)) then 
            if (vc_reg <V_SP) then
                vsync <= '0';
            else 
                vsync <= '1';
            end if; 
        end if; 
       end process; 
       
-- Enable video out when within the proches        

ENV:process(clk,clr)
    begin 
        if (clr = '1') then 
            vidon <= '0';
        elsif(rising_edge(clk)) then 
            if ((hc_reg < hfp) and (hc_reg > hbp)) and ((vc_reg <vfp) and (vc_reg > vbp)) then 
                   vidon <= '1'; 
            else
                   vidon <= '0';
            end if;
        end if;
    end process; 
    
    vc <= vc_reg;
    hc <= hc_reg;
end Behavioral;
