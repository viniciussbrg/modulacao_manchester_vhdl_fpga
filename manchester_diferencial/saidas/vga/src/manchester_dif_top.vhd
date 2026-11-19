library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity manchester_dif_top is
    generic (
        CPB_LED   : positive := 100_000_000;  -- 1 s por bit nos LEDs e no VGA
        CPB_SCOPE : positive := 100_000       -- 1 ms por bit (1 kHz) no PMOD para osciloscopio
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        data_in  : in  std_logic_vector(15 downto 0);
        led      : out std_logic_vector(15 downto 0);
        data_out : out std_logic;
        data_raw : out std_logic;
        vga_r    : out std_logic_vector(3 downto 0);
        vga_g    : out std_logic_vector(3 downto 0);
        vga_b    : out std_logic_vector(3 downto 0);
        vga_hs   : out std_logic;
        vga_vs   : out std_logic
    );
end manchester_dif_top;

architecture rtl of manchester_dif_top is
    signal sig_slow : std_logic;
    signal raw_slow : std_logic;
    signal led_fast : std_logic_vector(15 downto 0);
begin
    -- Instancia lenta (1 s/bit) para observacao visual nos LEDs e no monitor VGA
    u_slow : entity work.manchester_dif
        generic map (
            CYCLES_PER_BIT => CPB_LED
        )
        port map (
            clk      => clk,
            rst      => rst,
            data_in  => data_in,
            data_out => sig_slow,
            data_raw => raw_slow,
            led      => led
        );

    -- Instancia rapida (1 kHz) para observacao estavel no osciloscopio via conector PMOD JA
    u_fast : entity work.manchester_dif
        generic map (
            CYCLES_PER_BIT => CPB_SCOPE
        )
        port map (
            clk      => clk,
            rst      => rst,
            data_in  => data_in,
            data_out => data_out,
            data_raw => data_raw,
            led      => led_fast
        );

    -- Controlador VGA 640x480 @ 60Hz com cores pulsantes conforme o nivel do sinal codificado
    u_vga : entity work.vga_pulse
        port map (
            clk    => clk,
            rst    => rst,
            level  => sig_slow,
            vga_r  => vga_r,
            vga_g  => vga_g,
            vga_b  => vga_b,
            vga_hs => vga_hs,
            vga_vs => vga_vs
        );
end rtl;
