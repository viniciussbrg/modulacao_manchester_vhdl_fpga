--------------------------------------------------------------------------------
-- Testbench : manchester_dif_tb  (Manchester Diferencial)
--
-- Regra verificada:
--   * Meio do bit : SEMPRE inverte o nivel.
--   * Inicio do bit: bit 0 -> inverte o nivel ; bit 1 -> mantem o nivel.
--   * Nivel da saida apos o reset: BAIXO ('0')  (condicao inicial do testbench).
--
-- Parametros facilmente modificaveis:
--   CLK_PERIOD           : periodo do clock simulado
--   TB_CYCLES_PER_BIT    : ciclos de clock por bit (par) - vai para o generic map
--   BIT_PERIOD           : = TB_CYCLES_PER_BIT * CLK_PERIOD (coerente com o generic)
--                          (padrao: 2 ciclos de 10 ns -> bit de 20 ns, metades de 10 ns)
--   PATTERN_A / PATTERN_B: sequencias de switches (SW15..SW0). Ambas contem
--                          bits 0 e 1 consecutivos e alternados, exercitando os
--                          dois casos da regra de transicao no inicio do bit.
--
-- Roteiro:
--   1) Reset ativo: saida e LEDs em nivel baixo.
--   2) Libera o reset e confere 1 quadro (16 bits, SW15 -> SW0). No MEIO do bit
--      de SW8 todos os switches passam de PATTERN_A para PATTERN_B: o bit em
--      transmissao nao pode mudar; os bits seguintes ja usam PATTERN_B.
--   3) Confere o 2o quadro (transmissao ciclica). O nivel NAO volta a baixo na
--      virada de quadro: a codificacao depende do nivel anterior.
--   4) Aplica reset no meio da sequencia (nivel pode estar alto), confere que a
--      saida vai a nivel baixo e que a transmissao recomeca em SW15 a partir
--      do nivel baixo.
--
-- Em cada bit sao verificados, com assert, a 1a e a 2a metade (amostradas a 1/4
-- e a 3/4 do bit), a presenca/ausencia de transicao no inicio do bit (1a metade
-- contra o nivel final do bit anterior), a transicao no meio, o LED ativo e o
-- dado original (data_raw).
--
-- Execucao: Run Behavioral Simulation -> Run All (a simulacao termina sozinha).
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity manchester_dif_tb is
end entity manchester_dif_tb;

architecture sim of manchester_dif_tb is

    ---------------------------------------------------------------- parametros
    constant CLK_PERIOD        : time    := 10 ns;                     -- 100 MHz
    constant TB_CYCLES_PER_BIT : integer := 2;                         -- par
    constant BIT_PERIOD        : time    := TB_CYCLES_PER_BIT * CLK_PERIOD;  -- 20 ns

    constant PATTERN_A : std_logic_vector(15 downto 0) := x"B2C5";  -- 1011 0010 1100 0101
    constant PATTERN_B : std_logic_vector(15 downto 0) := x"4D3A";  -- 0100 1101 0011 1010

    ------------------------------------------------------------------- sinais
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '1';
    signal data_in  : std_logic_vector(15 downto 0) := PATTERN_A;
    signal data_out : std_logic;
    signal data_raw : std_logic;
    signal led      : std_logic_vector(15 downto 0);

    signal sim_done : boolean := false;

    -- Sinais so para visualizar no waveform (indice e bit esperado)
    signal tb_bit_idx : integer range 0 to 15 := 15;
    signal tb_bit     : std_logic := '0';

begin

    ------------------------------------------------------------------- DUT
    dut : entity work.manchester_dif
        generic map (
            CYCLES_PER_BIT => TB_CYCLES_PER_BIT
        )
        port map (
            clk      => clk,
            rst      => rst,
            data_in  => data_in,
            data_out => data_out,
            data_raw => data_raw,
            fast     => '0',
            vgaRed => open, vgaGreen => open, vgaBlue => open,
            Hsync => open, Vsync => open,
            led      => led
        );

    ------------------------------------------------------------------- clock
    p_clk : process
    begin
        -- Bordas de subida em 0, 10, 20, ... ns (multiplos de CLK_PERIOD)
        while not sim_done loop
            clk <= '1';
            wait for CLK_PERIOD / 2;
            clk <= '0';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process p_clk;

    ------------------------------------------------- estimulos e verificacao
    p_stim : process
        variable errors : integer := 0;
        -- Nivel da saida ao final do bit anterior (modelo de referencia).
        -- Apos o reset o nivel e BAIXO.
        variable prev   : std_logic := '0';

        procedure expect (constant cond : in boolean; constant msg : in string) is
        begin
            if not cond then
                errors := errors + 1;
                report "ERRO em " & time'image(now) & ": " & msg severity error;
            end if;
        end procedure;

        -- Confere reset ativo: tudo em nivel baixo
        procedure check_reset_low is
        begin
            expect(data_out = '0', "data_out deveria estar em nivel baixo durante o reset");
            expect(data_raw = '0', "data_raw deveria estar em nivel baixo durante o reset");
            expect(led = x"0000",  "LEDs deveriam estar apagados durante o reset");
            prev := '0';
        end procedure;

        -- Solta o reset e sincroniza com o inicio do bit de SW15.
        -- Latencia do DUT: 2 flip-flops do sincronizador + 1 ciclo de inicio
        -- = 3 bordas de clock apos a liberacao do reset. A liberacao e feita na
        -- borda em que (instante + 3 ciclos) e multiplo de BIT_PERIOD, de modo
        -- que todos os bits comecem em multiplos exatos de BIT_PERIOD
        -- (com os valores padrao: bit de SW15 em t = 100 ns).
        procedure release_reset is
        begin
            loop
                wait until rising_edge(clk);
                exit when ((now + 3 * CLK_PERIOD) / BIT_PERIOD) * BIT_PERIOD
                          = now + 3 * CLK_PERIOD;
            end loop;
            rst <= '0';
            wait until rising_edge(clk);
            wait until rising_edge(clk);
            wait until rising_edge(clk);   -- aqui comeca o bit de SW15
        end procedure;

        -- Confere um bit completo (duracao = BIT_PERIOD). 'pos' e o indice do switch.
        -- Se 'disturb' = true, altera os switches no MEIO do bit.
        procedure check_bit (constant pos : in integer; constant disturb : in boolean) is
            variable b       : std_logic;
            variable first   : std_logic;
            variable second  : std_logic;
            variable exp_led : std_logic_vector(15 downto 0);
        begin
            b := data_in(pos);                 -- valor do switch no INICIO do bit
            tb_bit_idx <= pos;
            tb_bit     <= b;

            -- Inicio do bit: bit 0 inverte ; bit 1 mantem.  Meio: sempre inverte.
            if b = '0' then
                first := not prev;
            else
                first := prev;
            end if;
            second := not first;

            -- 1a metade (amostra a 1/4 do bit)
            wait for BIT_PERIOD / 4;
            exp_led      := (others => '0');
            exp_led(pos) := first;
            expect(data_out = first, "SW" & integer'image(pos) & " (bit " & std_logic'image(b)
                   & "): nivel errado na 1a metade (transicao no inicio do bit)");
            expect(led = exp_led, "SW" & integer'image(pos) & ": LEDs errados na 1a metade");
            expect(data_raw = b,  "SW" & integer'image(pos) & ": data_raw errado");
            if b = '0' then
                expect(data_out /= prev, "SW" & integer'image(pos) & ": bit 0 deveria inverter no inicio");
            else
                expect(data_out = prev,  "SW" & integer'image(pos) & ": bit 1 deveria manter no inicio");
            end if;

            -- meio do bit (1/2)
            wait for BIT_PERIOD / 4;
            if disturb then
                data_in <= PATTERN_B;          -- altera switches no meio do bit
            end if;

            -- 2a metade (amostra a 3/4 do bit)
            wait for BIT_PERIOD / 4;
            exp_led      := (others => '0');
            exp_led(pos) := second;
            expect(data_out = second, "SW" & integer'image(pos) & " (bit " & std_logic'image(b)
                   & "): nivel errado na 2a metade");
            expect(led = exp_led, "SW" & integer'image(pos) & ": LEDs errados na 2a metade");
            expect(data_raw = b,  "SW" & integer'image(pos) & ": data_raw mudou no meio do bit");
            expect(data_out /= first, "SW" & integer'image(pos) & ": sem transicao no meio do bit");

            prev := second;                    -- nivel final deste bit
            wait for BIT_PERIOD / 4;           -- fim do bit
        end procedure;

    begin
        ---------------------------------------------------------- 1) reset
        rst     <= '1';
        data_in <= PATTERN_A;
        wait for 6 * CLK_PERIOD;
        check_reset_low;

        ----------------------------------------------- 2) quadro 1 (A -> B)
        release_reset;
        for n in 0 to 15 loop
            check_bit(15 - n, n = 7);          -- no meio do bit de SW8, A -> B
        end loop;

        ------------------------------------------ 3) quadro 2 (ciclico, B)
        for n in 0 to 15 loop
            check_bit(15 - n, false);
        end loop;

        ------------------------------------- 4) reset no meio da sequencia
        for n in 0 to 2 loop
            check_bit(15 - n, false);
        end loop;
        wait for BIT_PERIOD / 2;               -- meio do bit de SW12
        rst <= '1';
        wait for 6 * CLK_PERIOD;
        check_reset_low;                       -- nivel volta a BAIXO

        release_reset;                         -- deve recomecar em SW15, nivel inicial baixo
        for n in 0 to 15 loop
            check_bit(15 - n, false);
        end loop;

        ------------------------------------------------------------ fim
        if errors = 0 then
            report "SIMULACAO CONCLUIDA: nenhum erro (Manchester Diferencial)." severity note;
        else
            report "SIMULACAO CONCLUIDA COM " & integer'image(errors) & " ERRO(S)." severity error;
        end if;
        sim_done <= true;
        wait;
    end process p_stim;

end architecture sim;
