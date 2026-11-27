library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity manchester_vga is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        data_in  : in  std_logic_vector(15 downto 0);
        led      : out std_logic_vector(15 downto 0);
        Hsync    : out std_logic;
        Vsync    : out std_logic;
        vgaRed   : out std_logic_vector(3 downto 0);
        vgaGreen : out std_logic_vector(3 downto 0);
        vgaBlue  : out std_logic_vector(3 downto 0)
    );
end manchester_vga;
architecture rtl of manchester_vga is
    constant H_VISIVEL : integer := 640;
    constant H_FRENTE  : integer := 16;
    constant H_SYNC    : integer := 96;
    constant H_TOTAL   : integer := 800;
    constant V_VISIVEL : integer := 480;
    constant V_FRENTE  : integer := 10;
    constant V_SYNC    : integer := 2;
    constant V_TOTAL   : integer := 525;
    signal sinal   : std_logic;
    signal div     : integer range 0 to 3 := 0;
    signal hcnt    : integer range 0 to H_TOTAL - 1 := 0;
    signal vcnt    : integer range 0 to V_TOTAL - 1 := 0;
    signal visivel : std_logic := '0';
begin
    u_cod : entity work.manchester
        generic map (
            CYCLES_PER_BIT => 100_000_000
        )
        port map (
            clk      => clk,
            rst      => rst,
            data_in  => data_in,
            data_out => sinal,
            data_nrz => open,
            led      => led
        );
    process(clk)
    begin
        if rising_edge(clk) then
            if div = 3 then
                div <= 0;
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
            else
                div <= div + 1;
            end if;
        end if;
    end process;
    process(clk)
    begin
        if rising_edge(clk) then
            if hcnt >= H_VISIVEL + H_FRENTE and hcnt < H_VISIVEL + H_FRENTE + H_SYNC then
                Hsync <= '0';
            else
                Hsync <= '1';
            end if;
            if vcnt >= V_VISIVEL + V_FRENTE and vcnt < V_VISIVEL + V_FRENTE + V_SYNC then
                Vsync <= '0';
            else
                Vsync <= '1';
            end if;
            if hcnt < H_VISIVEL and vcnt < V_VISIVEL then
                visivel <= '1';
            else
                visivel <= '0';
            end if;
        end if;
    end process;
    vgaRed   <= (others => '0');
    vgaGreen <= (others => sinal) when visivel = '1' else (others => '0');
    vgaBlue  <= (others => not sinal) when visivel = '1' else (others => '0');
end rtl;