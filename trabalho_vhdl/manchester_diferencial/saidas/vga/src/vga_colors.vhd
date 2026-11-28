library ieee;
use ieee.std_logic_1164.all;

-- 640x480, pixel de 40 ns (25 MHz), 800x525 total: 59,524 Hz.
-- Clock enable a cada quatro ciclos: nenhum clock dividido na logica.
-- Os contadores continuam durante BTNC, preservando sincronismo do monitor.
entity vga_colors is
  port (
    clk : in std_logic;
    encoded : in std_logic;
    vgaRed, vgaGreen, vgaBlue : out std_logic_vector(3 downto 0);
    Hsync, Vsync : out std_logic
  );
end entity;

architecture rtl of vga_colors is
  signal div4 : natural range 0 to 3 := 0;
  signal h : natural range 0 to 799 := 0;
  signal v : natural range 0 to 524 := 0;
  signal r, g, b : std_logic_vector(3 downto 0) := (others => '0');
  signal hs, vs : std_logic := '1';
begin
  vgaRed <= r;
  vgaGreen <= g;
  vgaBlue <= b;
  Hsync <= hs;
  Vsync <= vs;
  process(clk)
  begin
    if rising_edge(clk) then
      if div4 = 3 then
        div4 <= 0;
        -- RGB e sincronismos correspondem ao mesmo pixel (h,v).
        hs <= '1';
        vs <= '1';
        if h >= 656 and h < 752 then hs <= '0'; end if;
        if v >= 490 and v < 492 then vs <= '0'; end if;
        r <= (others => '0');
        g <= (others => '0');
        b <= (others => '0');
        if h < 640 and v < 480 then
          if encoded = '1' then g <= (others => '1');
          else b <= (others => '1'); end if;
        end if;
        if h = 799 then
          h <= 0;
          if v = 524 then v <= 0; else v <= v+1; end if;
        else
          h <= h+1;
        end if;
      else
        div4 <= div4+1;
      end if;
    end if;
  end process;
end architecture;
