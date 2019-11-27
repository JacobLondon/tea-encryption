----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2019 12:58:22 PM
-- Design Name: 
-- Module Name: vga_stripes - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_stripes is
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
end vga_stripes;

architecture Behavioral of vga_stripes is

begin

-- Generate red, green strips lines wide 

process(clk, rst)
begin 
    if (rst = '1') then 
        red   <= (others =>'0');        
        green <= (others =>'0');
        blue  <= (others =>'0'); 
    elsif(rising_edge(clk)) then 
        if (vidon = '1') then 
            case conv_integer(BP_R) is 
            when 0  => red <= vc(conv_integer(SW)) & vc(conv_integer(SW)) & vc(conv_integer(SW)) & vc(conv_integer(SW));
            when 1  => red <= vc(conv_integer(SW)) & vc(conv_integer(SW)) & vc(conv_integer(SW)) & '0';           
            when 2  => red <= vc(conv_integer(SW)) & vc(conv_integer(SW)) & '0' & '0';
            when 3  => red <= vc(conv_integer(SW)) & '0' & '0' & '0';
            when others => red <= (others => 'Z');
            end case; 

            case conv_integer(BP_G) is 
            when 0  => green <= not (vc(conv_integer(SW)) & vc(conv_integer(SW)) & vc(conv_integer(SW)) & vc(conv_integer(SW)));
            when 1  => green <= not (vc(conv_integer(SW)) & vc(conv_integer(SW)) & vc(conv_integer(SW)) & '0');           
            when 2  => green <= not (vc(conv_integer(SW)) & vc(conv_integer(SW)) & '0' & '0');
            when 3  => green <= not (vc(conv_integer(SW)) & '0' & '0' & '0');
            when others => green <= (others => 'Z');
            end case; 

            case conv_integer(BP_B) is 
            when 0  => blue <=  (vc(conv_integer(SW)) & vc(conv_integer(SW)) & vc(conv_integer(SW)) & vc(conv_integer(SW)));
            when 1  => blue <=  (vc(conv_integer(SW)) & vc(conv_integer(SW)) & vc(conv_integer(SW)) & '0');           
            when 2  => blue <=  (vc(conv_integer(SW)) & vc(conv_integer(SW)) & '0' & '0');
            when 3  => blue <=  (vc(conv_integer(SW)) & '0' & '0' & '0');
            when others => blue <= (others => 'Z');
            end case; 
            
            
        end if; 
    end if; 

end process; 



end Behavioral;
