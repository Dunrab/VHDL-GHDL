library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga7seg is
  port(
            btnC :  in STD_LOGIC;
             seg : out STD_LOGIC_VECTOR(6 downto 0);
              an : out STD_LOGIC_VECTOR(3 downto 0);
       CLK100MHZ :  in std_logic;
              sw :  in std_logic_vector(15 downto 0);
          vgaRed : out std_logic_vector (3 downto 0);
        vgaGreen : out std_logic_vector (3 downto 0);
         vgaBlue : out std_logic_vector (3 downto 0);
           Hsync : out std_logic;
           Vsync : out std_logic);
end vga7seg;

architecture Behavioral of vga7seg is

  shared variable   hsp : integer := 96;
  shared variable   hbp : integer := 48;
  shared variable    ha : integer := 640;
  shared variable   hfp : integer := 16;
  shared variable   vsp : integer := 2;
  shared variable   vbp : integer := 31;
  shared variable    va : integer := 480;
  shared variable   vfp : integer := 11;
  shared variable hstart: integer := 320;		-- beginning of horizontal display
  shared variable vstart: integer := 240;		-- beginning of vertical display	
  shared variable  hsize: integer := 100;       -- pixel width of 7-segment display
  shared variable  vsize: integer := 200;       -- pixel height of 7-segment display

  procedure sync (hctr: inout integer; vctr: inout integer;
                  signal hs: out std_logic; signal vs: out std_logic) is
    begin
      if (hctr > 0) and (hctr < hsp+1) then  -- horizontal sync pulse 
        hs <= '0';
      else
        hs <= '1';
      end if;
      if (vctr > 0) and (vctr < vsp+1) then  -- vertical sync pulse
        vs <= '0';
      else
        vs <= '1';
      end if;
      hctr := hctr+1;                        -- increment horizontal counter
      if (hctr=hsp+hbp+ha+hfp-1) then
        vctr := vctr+1;                      -- advance vertical counter
        hctr := 0;                           -- wrap horizontal counter
        if (vctr=vsp+vbp+va+vfp-1) then
          vctr := 0;                         -- wrap vertical counter
        end if;
      end if;
    end sync;

  function numto7seg (digit: std_logic_vector(3 downto 0)) return std_logic_vector is
    begin
      case digit is
        when "0000" => return "1000000"; ---0
        when "0001" => return "1111001"; ---1
        when "0010" => return "0100100"; ---2
        when "0011" => return "0110000"; ---3
        when "0100" => return "0011001"; ---4
        when "0101" => return "0010010"; ---5
        when "0110" => return "0000010"; ---6
        when "0111" => return "1111000"; ---7
        when "1000" => return "0000000"; ---8
        when "1001" => return "0010000"; ---9
        when "1010" => return "0001000"; ---A
        when "1011" => return "0000011"; ---b
        when "1100" => return "1000110"; ---C
        when "1101" => return "0100001"; ---d
        when "1110" => return "0000110"; ---E
        when "1111" => return "0001110"; ---F
        when others => return "1111111"; ---null      
      end case;
    end numto7seg;

  impure function vgadisp ( hctr: integer;   vctr: integer; 
                           digit: std_logic_vector(3 downto 0);  column: integer) return boolean is
    variable disp: boolean;
    variable segD0: std_logic_vector(6 downto 0);
    variable hoffset: integer;
    variable voffset: integer;
    begin
      segD0 := numto7seg(digit);
      hoffset := hsp + hbp + hstart - 5*hsize/4 + column*hsize*3/2;
      voffset := vsp + vbp + vstart-vsize/2;
      disp := ((hctr > hoffset+10) and (hctr < hoffset+hsize-10)
              and (vctr > voffset) and (vctr < voffset+10) and (segD0(0)='0'))                  -- a
              or
              ((hctr > hoffset) and (hctr < hoffset+10)
              and (vctr > voffset+10) and (vctr < voffset+vsize/2-10) and (segD0(5)='0'))       -- f
              or
              ((hctr > hoffset+hsize-10) and (hctr < hoffset+hsize)
              and (vctr > voffset+10) and (vctr < voffset+vsize/2-10) and (segD0(1)='0'))       -- b
              or
              ((hctr > hoffset+10) and (hctr < hoffset+hsize-10)
              and (vctr > voffset+vsize/2-10) and (vctr < voffset+vsize/2) and (segD0(6)='0'))  -- g
              or
              ((hctr > hoffset) and (hctr < hoffset+10)
              and (vctr > voffset+vsize/2) and (vctr < voffset+vsize-20) and (segD0(4)='0'))    -- e
              or
              ((hctr > hoffset+hsize-10) and (hctr < hoffset+hsize)
              and (vctr > voffset+vsize/2) and (vctr < voffset+vsize-20) and (segD0(2)='0'))    -- c
              or
              ((hctr > hoffset+10) and (hctr < hoffset+hsize-10)
              and (vctr > voffset+vsize-20) and (vctr < voffset+vsize-10) and (segD0(3)='0'));  -- d
    return disp;
  end vgadisp;

  signal count: std_logic_vector(39 downto 0); 
  signal state: std_logic_vector(1 downto 0) := "00";
  signal count2: std_logic_vector(3 downto 0) := x"0";
  signal count2clock : std_logic := '0';
  signal count3: std_logic_vector(3 downto 0) := x"0";
  signal count3clock : std_logic := '0';
  signal count4: std_logic_vector(3 downto 0) := x"0";
  signal count4clock : std_logic := '0';
  alias clk25 : std_logic is count(1);
  alias clk100Hz : std_logic is count(20);
  signal enable : std_logic := '0';

  begin
  
   count2clock <= count(26);
   seg <= numto7seg(count2) when count(10) = '0' else
         numto7seg(count3);
   an <= "1110" when count(10) = '0' else
        "1101";

   process (count2clock)
     begin
       if count2clock'event and count2clock='1' and enable='1' then 
         count2 <= count2 + '1';
			if count2="1001" then
				count2<="0000";
				count3clock <= not count3clock;
			end if;
       end if;
     end process;
     
        process (count3clock)
     begin
       if count3clock'event and count3clock='1' then 
         count3 <= count3 + '1';
			if count3="1001" then
				count3<="0000";
				count4clock <= not count4clock;
			end if;
       end if;
     end process;
     
            process (count4clock)
     begin
       if count4clock'event and count4clock='1' then 
         count4 <= count4 + '1';
			if count4="1001" then
				count4<="0000";
			end if;
       end if;
     end process;

   process (CLK100MHZ)
     begin
       if CLK100MHZ'event and CLK100MHZ='1' then
         case btnC & state is
         when  "000" => state <= "00";
         when  "001" => state <= "00";
         when  "010" => state <= "11";
         when  "011" => state <= "00"; enable <= not enable;
         when  "100" => state <= "01";
         when  "101" => state <= "10";
         when  "110" => state <= "10";
         when  "111" => state <= "10";
         when others => state <= "00";
       end case; 
       count <= count + 1; 
       end if;
     end process;

  process (clk25) 
  
    variable horizontal_counter : integer;
    variable vertical_counter   : integer;

    begin
      if clk25'event and clk25 = '1' then
        if 
          vgadisp(horizontal_counter, vertical_counter, count4, 0)
        then
           vgaRed <= sw(11 downto 8); vgaGreen <= sw(7 downto 4); vgaBlue <= sw(3 downto 0); 
        else
           vgaRed <= "0000"; vgaGreen <= "0000"; vgaBlue <= "0000"; 
        end if;
        sync(horizontal_counter, vertical_counter, Hsync, Vsync);
      end if;
    end process;

end Behavioral;