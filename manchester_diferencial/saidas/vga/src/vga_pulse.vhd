library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_pulse is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        level  : in  std_logic;
        vga_r  : out std_logic_vector(3 downto 0);
        vga_g  : out std_logic_vector(3 downto 0);
        vga_b  : out std_logic_vector(3 downto 0);
        vga_hs : out std_logic;
        vga_vs : out std_logic
    );
end vga_pulse;

architecture rtl of vga_pulse is
    -- Temporizacao VGA 640x480 @ 60 Hz (pixel clock = 25 MHz a partir de 100 MHz)
    constant H_VISIBLE : integer := 640;
    constant H_FP      : integer := 16;
    constant H_SYNC    : integer := 96;
    constant H_BP      : integer := 48;
    constant H_TOTAL   : integer := 800;

    constant V_VISIBLE : integer := 480;
    constant V_FP      : integer := 10;
    constant V_SYNC    : integer := 2;
    constant V_BP      : integer := 33;
    constant V_TOTAL   : integer := 525;

    signal clk_div   : unsigned(1 downto 0) := (others => '0');
    signal pix_en    : std_logic := '0';
    signal hcnt      : integer range 0 to H_TOTAL - 1 := 0;
    signal vcnt      : integer range 0 to V_TOTAL - 1 := 0;
    signal hsync_reg : std_logic := '1';
    signal vsync_reg : std_logic := '1';
    signal r_reg     : std_logic_vector(3 downto 0) := (others => '0');
    signal g_reg     : std_logic_vector(3 downto 0) := (others => '0');
    signal b_reg     : std_logic_vector(3 downto 0) := (others => '0');
begin
    pix_en <= '1' when clk_div = "11" else '0';

    process(clk)
        variable active : boolean;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                clk_div   <= (others => '0');
                hcnt      <= 0;
                vcnt      <= 0;
                hsync_reg <= '1';
                vsync_reg <= '1';
                r_reg     <= (others => '0');
                g_reg     <= (others => '0');
                b_reg     <= (others => '0');
            else
                clk_div <= clk_div + 1;
                if pix_en = '1' then
                    if hcnt = H_TOTAL - 1 then
                        hcnt <= 0;
                        if vcnt = V_TOTAL - 1 then
                            vcnt <= 0;
                        else
                            vcnt <= vcnt + 1;
                        end if;
                    else
                        hcnt <= hcnt + 1;
                    end if;
                end if;

                if (hcnt >= H_VISIBLE + H_FP) and (hcnt < H_VISIBLE + H_FP + H_SYNC) then
                    hsync_reg <= '0';
                else
                    hsync_reg <= '1';
                end if;

                if (vcnt >= V_VISIBLE + V_FP) and (vcnt < V_VISIBLE + V_FP + V_SYNC) then
                    vsync_reg <= '0';
                else
                    vsync_reg <= '1';
                end if;

                active := (hcnt < H_VISIBLE) and (vcnt < V_VISIBLE);
                if active then
                    if level = '1' then
                        -- Nivel alto (1): Branco/Amarelo pulsante
                        r_reg <= "1111";
                        g_reg <= "1111";
                        b_reg <= "0000";
                    else
                        -- Nivel baixo (0): Azul pulsante
                        r_reg <= "0000";
                        g_reg <= "0000";
                        b_reg <= "1111";
                    end if;
                else
                    r_reg <= "0000";
                    g_reg <= "0000";
                    b_reg <= "0000";
                end if;
            end if;
        end if;
    end process;

    vga_hs <= hsync_reg;
    vga_vs <= vsync_reg;
    vga_r  <= r_reg;
    vga_g  <= g_reg;
    vga_b  <= b_reg;
end rtl;
