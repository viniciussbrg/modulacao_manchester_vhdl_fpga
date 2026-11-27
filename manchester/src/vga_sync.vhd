--------------------------------------------------------------------------------
-- Controlador VGA 640x480 @ ~60 Hz  (Basys 3, clock de 100 MHz)
--
-- O clock de pixel de 25 MHz e obtido por um clock-enable (divisao por 4 do
-- clock de 100 MHz), sem gerar um novo clock. (O padrao exato e 25,175 MHz;
-- 25 MHz resulta em ~59,5 Hz e e aceito pela grande maioria dos monitores.)
--
-- Temporizacao (pixels / linhas):
--   Horizontal: 640 visiveis + 16 front porch + 96 sync + 48 back porch = 800
--   Vertical  : 480 visiveis + 10 front porch +  2 sync + 33 back porch = 525
--   hsync e vsync sao ativos em nivel baixo.
--
-- Saidas hsync, vsync e video_on sao registradas e alinhadas entre si.
-- video_on = '1' dentro da area visivel (o RGB deve ser zero fora dela).
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_sync is
    port (
        clk      : in  std_logic;     -- 100 MHz
        hsync    : out std_logic;
        vsync    : out std_logic;
        video_on : out std_logic
    );
end entity vga_sync;

architecture rtl of vga_sync is

    constant H_VISIBLE : integer := 640;
    constant H_FP      : integer := 16;
    constant H_SYNC    : integer := 96;
    constant H_BP      : integer := 48;
    constant H_TOTAL   : integer := H_VISIBLE + H_FP + H_SYNC + H_BP;   -- 800

    constant V_VISIBLE : integer := 480;
    constant V_FP      : integer := 10;
    constant V_SYNC    : integer := 2;
    constant V_BP      : integer := 33;
    constant V_TOTAL   : integer := V_VISIBLE + V_FP + V_SYNC + V_BP;   -- 525

    signal div4   : integer range 0 to 3 := 0;
    signal pix_en : std_logic := '0';

    signal h_cnt : integer range 0 to H_TOTAL - 1 := 0;
    signal v_cnt : integer range 0 to V_TOTAL - 1 := 0;

    signal hs_r : std_logic := '1';
    signal vs_r : std_logic := '1';
    signal vo_r : std_logic := '0';

begin

    -- clock-enable de 25 MHz
    p_div : process (clk)
    begin
        if rising_edge(clk) then
            if div4 = 3 then
                div4   <= 0;
                pix_en <= '1';
            else
                div4   <= div4 + 1;
                pix_en <= '0';
            end if;
        end if;
    end process p_div;

    -- contadores de pixel e de linha
    p_cnt : process (clk)
    begin
        if rising_edge(clk) then
            if pix_en = '1' then
                if h_cnt = H_TOTAL - 1 then
                    h_cnt <= 0;
                    if v_cnt = V_TOTAL - 1 then
                        v_cnt <= 0;
                    else
                        v_cnt <= v_cnt + 1;
                    end if;
                else
                    h_cnt <= h_cnt + 1;
                end if;
            end if;
        end if;
    end process p_cnt;

    -- sincronismos e area visivel (registrados)
    p_out : process (clk)
    begin
        if rising_edge(clk) then
            if (h_cnt >= H_VISIBLE + H_FP) and (h_cnt < H_VISIBLE + H_FP + H_SYNC) then
                hs_r <= '0';
            else
                hs_r <= '1';
            end if;

            if (v_cnt >= V_VISIBLE + V_FP) and (v_cnt < V_VISIBLE + V_FP + V_SYNC) then
                vs_r <= '0';
            else
                vs_r <= '1';
            end if;

            if (h_cnt < H_VISIBLE) and (v_cnt < V_VISIBLE) then
                vo_r <= '1';
            else
                vo_r <= '0';
            end if;
        end if;
    end process p_out;

    hsync    <= hs_r;
    vsync    <= vs_r;
    video_on <= vo_r;

end architecture rtl;
