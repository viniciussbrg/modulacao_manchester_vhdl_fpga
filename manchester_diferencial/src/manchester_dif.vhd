-- Manchester diferencial unificado: LEDs, PMOD e VGA simultaneos.
-- Basys 3, 100 MHz. Top: manchester_dif.
-- BTNC: reset. BTNU solto: 1 s/bit; pressionado: 100 us/bit.
-- A velocidade muda no inicio do proximo bit, sem encurtar o atual.
-- SW15 -> SW0 ciclicamente; bit 0 inverte no inicio, bit 1 mantem;
-- ambos invertem no meio. Nivel inicial apos reset: zero.
-- JA1: codificado; JA2: NRZ. VGA: preto=0, branco=1.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity manchester_dif is
    generic (
        CYCLES_PER_BIT : positive := 100_000_000;
        FAST_CYCLES_PER_BIT : positive := 10_000
    );
    port (
        clk      : in  std_logic;                       -- clock de 100 MHz (W5)
        fast     : in std_logic := '0'; -- BTNU: manter pressionado para rapido
        rst      : in  std_logic;                       -- reset (BTNC, U18)
        data_in  : in  std_logic_vector(15 downto 0);   -- switches SW15..SW0
        data_out : out std_logic;                       -- sinal codificado (PMOD)
        data_raw : out std_logic;                       -- dado original / NRZ (PMOD)
        led      : out std_logic_vector(15 downto 0);
        vgaRed, vgaGreen, vgaBlue : out std_logic_vector(3 downto 0);
        Hsync, Vsync : out std_logic
    );
end entity manchester_dif;

architecture rtl of manchester_dif is

    function maximum(a, b : positive) return positive is
    begin
        if a > b then return a; else return b; end if;
    end function;
    constant MAX_CYCLES : positive := maximum(CYCLES_PER_BIT, FAST_CYCLES_PER_BIT);
    signal period_r : positive range 2 to MAX_CYCLES := CYCLES_PER_BIT;
    signal fast_meta, fast_sync : std_logic := '0';
    signal hs, vs, vid_on : std_logic;
    signal rgb_r : std_logic_vector(11 downto 0) := (others => '0');
    signal hs_r, vs_r : std_logic := '1';

    -- Sincronizador do botao de reset (assincrono em relacao ao clock)
    signal rst_meta : std_logic := '1';
    signal rst_sync : std_logic := '1';

    attribute ASYNC_REG : string;
    attribute ASYNC_REG of fast_meta : signal is "TRUE";
    attribute ASYNC_REG of fast_sync : signal is "TRUE";
    attribute ASYNC_REG of rst_meta : signal is "TRUE";
    attribute ASYNC_REG of rst_sync : signal is "TRUE";

    -- Estado do transmissor
    -- No reset, cnt = ultimo ciclo do "bit 0": o primeiro clock apos soltar o
    -- reset ja inicia o bit de SW15.
    signal cnt   : integer range 0 to MAX_CYCLES - 1 := CYCLES_PER_BIT - 1;
    signal idx   : integer range 0 to 15 := 0;      -- indice do bit (15 -> 0)
    signal bit_r : std_logic := '0';                -- bit atual (registrado)
    signal lvl   : std_logic := '0';                -- nivel atual da saida (memoria)
    signal led_r : std_logic_vector(15 downto 0) := (others => '0');

begin

    assert (CYCLES_PER_BIT mod 2 = 0) and (CYCLES_PER_BIT >= 2)
        report "CYCLES_PER_BIT deve ser par e >= 2"
        severity failure;

    ----------------------------------------------------------------------------
    -- Sincronizacao do botao de reset (2 flip-flops em serie).
    -- Switches capturados diretamente, como no projeto original.
    -- Nao ha sincronizador nos switches: mantenha-os estaveis ao medir.
    -- A captura por bit e o false_path nao eliminam metastabilidade.
    ----------------------------------------------------------------------------
    assert (FAST_CYCLES_PER_BIT mod 2 = 0) and (FAST_CYCLES_PER_BIT >= 2)
        report "FAST_CYCLES_PER_BIT deve ser par e >= 2" severity failure;

    p_sync : process (clk)
    begin
        if rising_edge(clk) then
            fast_meta <= fast;
            fast_sync <= fast_meta;
            rst_meta <= rst;
            rst_sync <= rst_meta;
        end if;
    end process p_sync;

    ----------------------------------------------------------------------------
    -- Contador de ciclos + indice do bit + registrador do bit + codificador
    ----------------------------------------------------------------------------
    p_tx : process (clk)
        variable v_cnt : integer range 0 to MAX_CYCLES - 1;
        variable v_idx : integer range 0 to 15;
        variable v_bit : std_logic;
        variable v_lvl : std_logic;
        variable v_led : std_logic_vector(15 downto 0);
    begin
        if rising_edge(clk) then
            if rst_sync = '1' then
                period_r <= CYCLES_PER_BIT;
                cnt   <= CYCLES_PER_BIT - 1;
                idx   <= 0;
                bit_r <= '0';
                lvl   <= '0';                       -- nivel apos o reset: BAIXO
                led_r <= (others => '0');
            else
                v_cnt := cnt;
                v_idx := idx;
                v_bit := bit_r;
                v_lvl := lvl;

                if cnt = period_r - 1 then
                    -- Seleciona a duracao somente no inicio do novo bit.
                    if fast_sync = '1' then
                        period_r <= FAST_CYCLES_PER_BIT;
                    else
                        period_r <= CYCLES_PER_BIT;
                    end if;
                    -- Fim do bit anterior / INICIO de um novo bit
                    v_cnt := 0;
                    if idx = 0 then
                        v_idx := 15;
                    else
                        v_idx := idx - 1;
                    end if;
                    v_bit := data_in(v_idx);        -- leitura do switch no inicio do bit
                    if v_bit = '0' then
                        v_lvl := not lvl;           -- bit 0: inverte no inicio
                    else
                        v_lvl := lvl;               -- bit 1: mantem no inicio
                    end if;
                else
                    v_cnt := cnt + 1;
                    if cnt = period_r / 2 - 1 then
                        -- Proximo ciclo ja e a 2a metade: SEMPRE inverte no meio
                        v_lvl := not lvl;
                    end if;
                end if;

                v_led        := (others => '0');
                v_led(v_idx) := v_lvl;

                cnt   <= v_cnt;
                idx   <= v_idx;
                bit_r <= v_bit;
                lvl   <= v_lvl;
                led_r <= v_led;
            end if;
        end if;
    end process p_tx;

    ----------------------------------------------------------------------------
    -- Saidas (diretamente de registradores)
    ----------------------------------------------------------------------------
    data_out <= lvl;
    data_raw <= bit_r;
    led      <= led_r;

    u_vga : entity work.vga_sync
        port map (
            clk      => clk,
            hsync    => hs,
            vsync    => vs,
            video_on => vid_on
        );

    -- RGB registrado (fora da area visivel o RGB deve ser zero)
    p_rgb : process (clk)
    begin
        if rising_edge(clk) then
            if vid_on = '1' then
                if lvl = '1' then
                    rgb_r <= x"FFF";
                else
                    rgb_r <= x"000";
                end if;
            else
                rgb_r <= (others => '0');
            end if;
            hs_r <= hs;
            vs_r <= vs;
        end if;
    end process p_rgb;

    vgaRed   <= rgb_r(11 downto 8);
    vgaGreen <= rgb_r(7 downto 4);
    vgaBlue  <= rgb_r(3 downto 0);
    Hsync    <= hs_r;
    Vsync    <= vs_r;

end architecture rtl;
