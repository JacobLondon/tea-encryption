library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.math_real.all; 
--use IEEE.STD_LOGIC_ARITH.ALL;

entity vga_initials_top is
 generic (strip_hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
          strip_vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
          strip_hbp     :positive:= 144;   -- Horizontal back porch = 144 (128 + 16)
          strip_hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
          strip_vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
          strip_vfp     :positive:= 511;    -- Vertical front porch = 511 (2+29+ 480)
          data_depth    :positive:= 5;
          data_length   :positive:= 7;
          mem_length    :positive:= 114;
          key_length    :positive:= 226;
          count_size_top:positive:= 10
         );
    Port ( clk  : in STD_LOGIC;
           rst  : in STD_LOGIC;
           --index: in STD_LOGIC_VECTOR (3 downto 0);
           enciphered_data: in STD_LOGIC_VECTOR (4*(mem_length-2)/7 - 1 downto 0);
		   deciphered_data : in STD_LOGIC_VECTOR(4*(mem_length-2)/7 - 1 downto 0);
		   key             : in STD_LOGIC_VECTOR(4*(key_length-2)/7 - 1 downto 0);
           --sw   : in STD_LOGIC_VECTOR (7 downto 0);
           hsync: out STD_LOGIC;
           vsync: out STD_LOGIC; 
           red  : out STD_LOGIC_VECTOR (2 downto 0); 
           green: out STD_LOGIC_VECTOR (2 downto 0);
           blue : out STD_LOGIC_VECTOR (2 downto 0)   
         );
end vga_initials_top;

architecture Behavioral of vga_initials_top is

component counter_generic 
    generic (count_size:integer:= 32); 
    Port ( clk   : in STD_LOGIC;
           rst   : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (count_size-1 downto 0));
end component;

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

component clk_wiz_0 
     port (
           clk25  : out std_logic; 
           reset  : in  std_logic; 
           locked : out std_logic;
           clk_in1: in  std_logic
          );
end component; 

component PROM_IMG
    generic(DEPTH    :positive:= 5; 
            DATA_SIZE:positive:= 7;
            MEM_SIZE :positive:= 114
           );
    Port   ( index   : in  STD_LOGIC_VECTOR(4*(MEM_SIZE-2)/7 -1 downto 0);
             --index   : in  STD_LOGIC_VECTOR(3 downto 0);
             addr    : in  STD_LOGIC_VECTOR (integer(ceil(log2(real(DEPTH))))-1 downto 0);
             PROM_OP : out STD_LOGIC_VECTOR (MEM_SIZE-1 downto 0)
           );
end component;


component vga_initials 
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
end component;

signal clk25MHz       :std_logic; 
signal locked_pll     :std_logic; 
signal steady_clk25MHz:std_logic;

signal hc, vc:std_logic_vector(9 downto 0); 
signal video_on :std_logic; 

signal IMG_in, IMG_out:std_logic_vector(mem_length-1 downto 0); 
signal IMG_key:std_logic_vector(key_length-1 downto 0); 
signal rom_addr4:std_logic_vector(integer(ceil(log2(real(data_depth))))-1 downto 0); 

signal sw1, sw2, sw3: std_logic_vector(7 downto 0);
signal R1, R2, R3, G1, G2, G3, B1, B2, B3: std_logic_vector(2 downto 0);
signal count_out:std_logic_vector(count_size_top-1 downto 0); 
--signal counter: std_logic_vector(9 downto 0):= "0000000000";
begin
CLK_GEN_PLL: clk_wiz_0 port map ( 
                                   clk25   => clk25MHz, 
                                   reset   => rst,
                                   locked  => locked_pll,
                                   clk_in1 => clk
                                );
steady_clk25MHz <= locked_pll and clk25MHz;


COUNT: counter_generic generic map (count_size => count_size_top)
                       port map    (
                                      clk => clk,
                                      rst => rst,
                                      count =>  count_out 
                                    );

sw1 <="00010001";
sw2 <="00100001";
sw3 <="00110001";

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
                               clr   => rst,
                               hsync => hsync,
                               vsync => vsync,
                               hc    => hc, 
                               vc    => vc, 
                               vidon => video_on
                              );
                              
INIT_in: vga_initials 
    generic map ( hbp =>144, 
                  vbp =>31, 
                  W   =>mem_length, 
                  H   =>data_depth
                )
    Port map ( 
                   clk       => steady_clk25MHz,
                   rst       => rst,
                   vidon     => video_on,
                   hc        => hc,
                   vc        => vc,
                   M         => IMG_in,
                   SW        => sw1,
                   rom_addr4 => rom_addr4,
                   red       =>  R1,
                   green     =>  G1,
                   blue      =>  B1
         );
         
INIT_key: vga_initials 
    generic map ( hbp =>144, 
                  vbp =>31, 
                  W   =>key_length, 
                  H   =>data_depth
                )
    Port map ( 
                   clk       => steady_clk25MHz,
                   rst       => rst,
                   vidon     => video_on,
                   hc        => hc,
                   vc        => vc,
                   M         => IMG_key,
                   SW        => sw2,
                   rom_addr4 => rom_addr4,
                   red       =>  R2,
                   green     =>  G2,
                   blue      =>  B2
         );

INIT_out: vga_initials 
    generic map ( hbp =>144, 
                  vbp =>31, 
                  W   =>mem_length, 
                  H   =>data_depth
                )
    Port map ( 
                   clk       => steady_clk25MHz,
                   rst       => rst,
                   vidon     => video_on,
                   hc        => hc,
                   vc        => vc,
                   M         => IMG_out,
                   SW        => sw3,
                   rom_addr4 => rom_addr4,
                   red       =>  R3,
                   green     =>  G3,
                   blue      =>  B3
         );

         
PROM_in: PROM_IMG generic map (
                            DEPTH     => data_depth ,
                            DATA_SIZE => data_length,
                            MEM_SIZE  => mem_length
                            )
               port map (
                          index   => enciphered_data,
                          addr    => rom_addr4,
                          PROM_OP => IMG_in
                        );

PROM_key: PROM_IMG generic map (
                            DEPTH     => data_depth ,
                            DATA_SIZE => data_length,
                            MEM_SIZE  => key_length
                            )
               port map (
                          index   => key,
                          addr    => rom_addr4,
                          PROM_OP => IMG_key
                        );  

PROM_out: PROM_IMG generic map (
                            DEPTH     => data_depth ,
                            DATA_SIZE => data_length,
                            MEM_SIZE  => mem_length
                            )
               port map (
                          index   => deciphered_data,
                          addr    => rom_addr4,
                          PROM_OP => IMG_out
                        );  

        
FLASHING_CONT: process(count_out(count_size_top -1 downto count_size_top -4))
    begin
        case(count_out(count_size_top -1 downto count_size_top -4)) is
        when "0000" =>
                red <= R1;
                green <= G1;
                blue <= B1;
                
       when "0001" =>
                
                red <= R2;
                green <= G2;
                blue <= B2;
                
      when "0010" =>
                red <= R3;
                green <= G3;
                blue <= B3;
      when "0011" =>
                red <= R1;
                green <= G1;
                blue <= B1;
      when "0100" =>
                
                red <= R2;
                green <= G2;
                blue <= B2;
                
      when "0101" =>
                red <= R3;
                green <= G3;
                blue <= B3;
      when "0110" =>
                red <= R1;
                green <= G1;
                blue <= B1;
      when "0111" =>
                
                red <= R2;
                green <= G2;
                blue <= B2;
       
       when "1000" =>
                red <= R3;
                green <= G3;
                blue <= B3;
      when "1001" =>
                red <= R1;
                green <= G1;
                blue <= B1;
      when "1010" =>
                
                red <= R2;
                green <= G2;
                blue <= B2;
                
      when "1011" =>
                red <= R3;
                green <= G3;
                blue <= B3;
      when "1100" =>
                red <= R1;
                green <= G1;
                blue <= B1;
      when "1101" =>
                
                red <= R2;
                green <= G2;
                blue <= B2;
      when "1110" =>
                red <= R3;
                green <= G3;
                blue <= B3;
      when "1111" =>
                red <= R1;
                green <= G1;
                blue <= B1;
        end case;
    end process;
end Behavioral;