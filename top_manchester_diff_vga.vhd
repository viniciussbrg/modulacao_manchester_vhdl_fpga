library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity top_manchester_vga is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        data_in  : in  STD_LOGIC_VECTOR(15 downto 0);
        led      : out STD_LOGIC_VECTOR(15 downto 0);
        data_out : out STD_LOGIC;
 
        -- Portas VGA
        hsync    : out STD_LOGIC;
        vsync    : out STD_LOGIC;
        vgaGreen : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue  : out STD_LOGIC_VECTOR(3 downto 0);
        vgaRed   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end top_manchester_vga;
 
architecture Behavioral of top_manchester_vga is
 
    signal serial_manchester : STD_LOGIC;
 
    -- 1. Declarando o NOVO codificador Manchester Diferencial
    component manchester_dif
        generic ( CYCLES_PER_BIT : positive := 100_000_000 );
        port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            data_in  : in  STD_LOGIC_VECTOR(15 downto 0);
            data_out : out STD_LOGIC;
            led      : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
 
    -- 2. Declarando o IP Gerador de Clock (100MHz para 148.5MHz)
    component clk_wiz_0
        port (
            clk_out1 : out STD_LOGIC;
            reset    : in  STD_LOGIC;
            locked   : out STD_LOGIC;
            clk_in1  : in  STD_LOGIC
        );
    end component;
 
    -- Constantes para a resolução 1920x1080 @ 60Hz
    constant H_VISIBLE : integer := 1920;
    constant H_FRONT   : integer := 88;
    constant H_SYNC    : integer := 44;
    constant H_BACK    : integer := 148;
    constant H_TOTAL   : integer := 2200;
 
    constant V_VISIBLE : integer := 1080;
    constant V_FRONT   : integer := 4;
    constant V_SYNC    : integer := 5;
    constant V_BACK    : integer := 36;
    constant V_TOTAL   : integer := 1125;
 
    signal clk148     : STD_LOGIC := '0';
    signal wiz_locked : STD_LOGIC;
    signal h_count    : integer range 0 to H_TOTAL - 1 := 0;
    signal v_count    : integer range 0 to V_TOTAL - 1 := 0;
    signal video_on   : STD_LOGIC := '0';
 
begin
 
    -- Instanciando o Manchester Diferencial
    u_manchester_dif: manchester_dif
        generic map (
            CYCLES_PER_BIT => 100_000_000
        )
        port map (
            clk      => clk,
            rst      => rst,
            data_in  => data_in,
            data_out => serial_manchester,
            led      => led
        );
 
    -- Enviando o sinal simultaneamente para o conector Pmod JA
    data_out <= serial_manchester;
 
    -- Instanciando o IP Gerador de Clock de vídeo
    u_clk_wiz : clk_wiz_0
        port map (
            clk_in1  => clk,
            clk_out1 => clk148,
            reset    => '0',
            locked   => wiz_locked
        );
 
    -- Temporizador do monitor VGA
    p_vga_timing : process(clk148)
    begin
        if rising_edge(clk148) then
            if h_count = H_TOTAL - 1 then
                h_count <= 0;
                if v_count = V_TOTAL - 1 then
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
                end if;
            else
                h_count <= h_count + 1;
            end if;
        end if;
    end process;
 
    hsync <= '0' when (h_count >= H_VISIBLE + H_FRONT and h_count < H_VISIBLE + H_FRONT + H_SYNC) else '1';
    vsync <= '0' when (v_count >= V_VISIBLE + V_FRONT and v_count < V_VISIBLE + V_FRONT + V_SYNC) else '1';
    video_on <= '1' when (h_count < H_VISIBLE and v_count < V_VISIBLE) else '0';
 
    -- Desenho dos pixels na tela (Branco = 0, Verde = 1)
    vgaGreen <= "1111" when (video_on = '1' and serial_manchester = '1') else
                "1100" when (video_on = '1' and serial_manchester = '0') else "0000";
 
    vgaRed   <= "1111" when (video_on = '1' and serial_manchester = '1') else "0000";
    vgaBlue  <= "1111" when (video_on = '1' and serial_manchester = '1') else "0000";
 
end Behavioral;