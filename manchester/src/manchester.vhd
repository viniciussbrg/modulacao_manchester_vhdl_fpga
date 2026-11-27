-- Top unico: LEDs, PMOD e VGA simultaneos.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity manchester is
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
end entity manchester;

architecture rtl of manchester is

    function maximum(a,b: positive) return positive is
    begin if a>b then return a; else return b; end if; end;
    constant MAX_CYCLES : positive := maximum(CYCLES_PER_BIT,FAST_CYCLES_PER_BIT);
    -- Fim do bit (periodo-1) e meio do bit (periodo/2-1) ja calculados e
    -- registrados: a comparacao com cnt fica rapida (sem subtracao/divisao).
    signal last_r : integer range 1 to MAX_CYCLES - 1     := CYCLES_PER_BIT - 1;
    signal half_r : integer range 0 to MAX_CYCLES / 2 - 1 := CYCLES_PER_BIT / 2 - 1;
    signal fast_meta,fast_sync : std_logic := '0';
    -- Cores da tela VGA (formato RGB 4:4:4 -> x"RGB")
    constant COLOR_LOW  : std_logic_vector(11 downto 0) := x"00F";  -- nivel 0: azul
    constant COLOR_HIGH : std_logic_vector(11 downto 0) := x"0F0";  -- nivel 1: verde

    signal hs,vs,vid_on : std_logic;
    signal rgb_r : std_logic_vector(11 downto 0) := (others=>'0');
    signal hs_r,vs_r : std_logic := '1';

    -- Sincronizador do botao de reset (assincrono em relacao ao clock)
    signal rst_meta : std_logic := '1';
    signal rst_sync : std_logic := '1';

    attribute ASYNC_REG : string;
    attribute ASYNC_REG of fast_meta,fast_sync : signal is "TRUE";
    attribute ASYNC_REG of rst_meta : signal is "TRUE";
    attribute ASYNC_REG of rst_sync : signal is "TRUE";

    -- Estado do transmissor
    -- No reset, cnt = ultimo ciclo do "bit 0": o primeiro clock apos soltar o
    -- reset ja inicia o bit de SW15.
    signal cnt   : integer range 0 to MAX_CYCLES - 1 := CYCLES_PER_BIT - 1;
    signal idx   : integer range 0 to 15 := 0;      -- indice do bit (15 -> 0)
    signal bit_r : std_logic := '0';                -- bit atual (registrado)
    signal lvl   : std_logic := '0';                -- nivel codificado atual
    signal led_r : std_logic_vector(15 downto 0) := (others => '0');

begin

    assert (CYCLES_PER_BIT mod 2 = 0) and (CYCLES_PER_BIT >= 2)
        report "CYCLES_PER_BIT deve ser par e >= 2"
        severity failure;

    assert FAST_CYCLES_PER_BIT >= 2 and FAST_CYCLES_PER_BIT mod 2 = 0
        report "FAST_CYCLES_PER_BIT deve ser par e >=2" severity failure;
    ----------------------------------------------------------------------------
    -- Sincronizacao do botao de reset (2 flip-flops em serie).
    -- Switches capturados diretamente, como no original.
    -- Isso nao elimina o risco de metaestabilidade ao alterar perto da captura.
    ----------------------------------------------------------------------------
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
                last_r <= CYCLES_PER_BIT - 1;
                half_r <= CYCLES_PER_BIT / 2 - 1;
                cnt   <= CYCLES_PER_BIT - 1;
                idx   <= 0;
                bit_r <= '0';
                lvl   <= '0';
                led_r <= (others => '0');
            else
                v_cnt := cnt;
                v_idx := idx;
                v_bit := bit_r;
                v_lvl := lvl;

                if cnt = last_r then
                    -- A nova velocidade so entra no inicio do proximo bit.
                    if fast_sync = '1' then
                        last_r <= FAST_CYCLES_PER_BIT - 1;
                        half_r <= FAST_CYCLES_PER_BIT / 2 - 1;
                    else
                        last_r <= CYCLES_PER_BIT - 1;
                        half_r <= CYCLES_PER_BIT / 2 - 1;
                    end if;
                    -- Fim do bit anterior / INICIO de um novo bit
                    v_cnt := 0;
                    if idx = 0 then
                        v_idx := 15;
                    else
                        v_idx := idx - 1;
                    end if;
                    v_bit := data_in(v_idx);        -- leitura do switch no inicio do bit
                    v_lvl := not v_bit;             -- 1a metade: NOT bit (IEEE 802.3)
                else
                    v_cnt := cnt + 1;
                    if cnt = half_r then
                        -- Proximo ciclo ja e a 2a metade do bit
                        v_lvl := bit_r;             -- 2a metade: bit (IEEE 802.3)
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
        port map(clk=>clk,hsync=>hs,vsync=>vs,video_on=>vid_on);
    process(clk)
    begin
        if rising_edge(clk) then
            -- Fora da area visivel o RGB deve ser zero (exigencia do padrao VGA)
            if vid_on = '0' then rgb_r <= x"000";
            elsif lvl = '1' then rgb_r <= COLOR_HIGH;
            else rgb_r <= COLOR_LOW; end if;
            hs_r<=hs; vs_r<=vs;
        end if;
    end process;
    vgaRed<=rgb_r(11 downto 8);
    vgaGreen<=rgb_r(7 downto 4);
    vgaBlue<=rgb_r(3 downto 0);
    Hsync<=hs_r; Vsync<=vs_r;
end architecture rtl;
