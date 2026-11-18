-- Testbench do Manchester Diferencial (VHDL-93).
-- Primeiro bit em 100 ns; 100 ns por bit na configuracao padrao.
-- Dez cenarios com verificacao automatica. Executar Run All.

library ieee;
use ieee.std_logic_1164.all;

entity manchester_dif_tb is
    generic (
        SIM_CYCLES_PER_BIT : positive := 10
    );
end entity manchester_dif_tb;

architecture sim of manchester_dif_tb is
    constant CLK_PERIOD   : time := 10 ns;
    constant BIT_PERIOD   : time := CLK_PERIOD * SIM_CYCLES_PER_BIT;
    constant SAMPLE_DELAY : time := 1 ns;
    constant INITIAL_RESET_CYCLES : positive := 9;

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '1';
    signal data_in  : std_logic_vector(15 downto 0) := x"B2A5";
    signal data_out : std_logic;
    signal led      : std_logic_vector(15 downto 0);

    -- Referencias calculadas pelo testbench, para comparar no waveform.
    signal expected_index : natural range 0 to 15 := 15;
    signal expected_bit   : std_logic := '0';
    signal expected_level : std_logic := '0';
    signal test_case      : natural := 0;
    signal sim_done       : boolean := false;
begin
    dut : entity work.manchester_dif
        generic map (
            CYCLES_PER_BIT => SIM_CYCLES_PER_BIT
        )
        port map (
            clk      => clk,
            rst      => rst,
            data_in  => data_in,
            data_out => data_out,
            led      => led
        );

    clock_generator : process
    begin
        -- Subidas em 10, 20, 30 ns...; descidas em 15, 25, 35 ns...
        clk <= '0';
        wait for CLK_PERIOD;

        while not sim_done loop
            clk <= '1';
            wait for CLK_PERIOD / 2;

            clk <= '0';
            wait for CLK_PERIOD / 2;
        end loop;

        wait;
    end process;

    stimulus : process
        -- Memoria do MODELO DE REFERENCIA, independente da saida do DUT.
        -- So e zerada no reset; permanece entre bits e entre voltas.
        variable previous_level : std_logic := '0';

        procedure apply_reset(
            constant pattern : std_logic_vector(15 downto 0);
            constant reset_cycles : positive := 3
        ) is
        begin
            rst <= '1';
            data_in <= pattern;

            previous_level := '0';
            expected_index <= 15;
            expected_bit <= '0';
            expected_level <= '0';

            for n in 1 to reset_cycles loop
                wait until rising_edge(clk);
                wait for SAMPLE_DELAY;

                assert data_out = '0' and led = x"0000"
                    report "ERRO: reset deve manter a saida e os LEDs em zero."
                    severity failure;
            end loop;

            wait until falling_edge(clk);
            rst <= '0';
        end procedure;

        procedure check_bit(
            constant index_value : natural;
            constant bit_value : std_logic;
            constant change_index : integer := -1;
            constant change_value : std_logic := '0';
            constant change_cycle : natural := 0
        ) is
            variable first_level  : std_logic;
            variable second_level : std_logic;
            variable level_value  : std_logic;
            variable leds_value   : std_logic_vector(15 downto 0);
        begin
            -- Calcula as duas metades esperadas pela regra da codificacao.
            -- Nao usa data_out para descobrir o nivel esperado.
            if bit_value = '0' then
                first_level := not previous_level;
            else
                first_level := previous_level;
            end if;

            second_level := not first_level;

            for cycle in 0 to SIM_CYCLES_PER_BIT - 1 loop
                wait until rising_edge(clk);

                if cycle < SIM_CYCLES_PER_BIT / 2 then
                    level_value := first_level;
                else
                    level_value := second_level;
                end if;

                leds_value := (others => '0');
                leds_value(index_value) := level_value;

                expected_index <= index_value;
                expected_bit <= bit_value;
                expected_level <= level_value;

                -- Aguarda a atualizacao dos sinais pelo simulador.
                wait for SAMPLE_DELAY;

                assert data_out = level_value
                    report "ERRO Diferencial: teste=" & integer'image(test_case) &
                           " bit=" & integer'image(index_value) &
                           " ciclo=" & integer'image(cycle)
                    severity failure;

                assert led = leds_value
                    report "ERRO nos LEDs/ordem: teste=" & integer'image(test_case) &
                           " bit=" & integer'image(index_value)
                    severity failure;

                if change_index >= 0 and cycle = change_cycle then
                    wait for CLK_PERIOD / 4;
                    data_in(change_index) <= change_value;

                    wait for SAMPLE_DELAY;

                    assert data_out = level_value and led = leds_value
                        report "ERRO: alterar o switch mudou a saida no meio do bit."
                        severity failure;
                end if;
            end loop;

            -- O proximo bit parte do nivel final deste bit.
            previous_level := second_level;
        end procedure;

        procedure check_frame(
            constant pattern : std_logic_vector(15 downto 0)
        ) is
        begin
            for index_value in 15 downto 0 loop
                check_bit(index_value, pattern(index_value));
            end loop;
        end procedure;
    begin
        test_case <= 1;
        report "TESTE 1: B2A5, duas voltas e primeiro bit em 100 ns."
            severity note;

        -- Nove bordas em reset: 10 a 90 ns. Libera em 95 ns.
        apply_reset(x"B2A5", INITIAL_RESET_CYCLES);
        check_frame(x"B2A5");
        check_frame(x"B2A5");

        test_case <= 2;
        report "TESTE 2: todos zero; inversao no inicio de cada bit."
            severity note;

        apply_reset(x"0000");
        check_frame(x"0000");

        test_case <= 3;
        report "TESTE 3: todos um; mantem o nivel no inicio de cada bit."
            severity note;

        apply_reset(x"FFFF");
        check_frame(x"FFFF");

        test_case <= 4;
        report "TESTE 4: alternados AAAA."
            severity note;

        apply_reset(x"AAAA");
        check_frame(x"AAAA");

        test_case <= 5;
        report "TESTE 5: alternados 5555."
            severity note;

        apply_reset(x"5555");
        check_frame(x"5555");

        test_case <= 6;
        report "TESTE 6: preservacao do nivel na passagem de SW0 para SW15."
            severity note;

        -- Um unico bit 1 faz o nivel final alternar a cada volta.
        -- Isso detecta um reset indevido da saida no fim da sequencia.
        apply_reset(x"0001");
        check_frame(x"0001");
        check_frame(x"0001");
        check_frame(x"0001");

        test_case <= 7;
        report "TESTE 7: alterar SW15 na primeira metade."
            severity note;

        apply_reset(x"0000");
        check_bit(15, '0', 15, '1', 0);

        for index_value in 14 downto 0 loop
            check_bit(index_value, '0');
        end loop;

        check_frame(x"8000");

        test_case <= 8;
        report "TESTE 8: alterar SW14 enquanto SW15 e transmitido."
            severity note;

        apply_reset(x"0000");
        check_bit(15, '0', 14, '1', 0);
        check_bit(14, '1');

        for index_value in 13 downto 0 loop
            check_bit(index_value, '0');
        end loop;

        test_case <= 9;
        report "TESTE 9: alterar SW15 na segunda metade."
            severity note;

        apply_reset(x"FFFF");
        check_bit(15, '1', 15, '0', SIM_CYCLES_PER_BIT / 2);

        for index_value in 14 downto 0 loop
            check_bit(index_value, '1');
        end loop;

        check_frame(x"7FFF");

        test_case <= 10;
        report "TESTE 10: reset durante a transmissao e reinicio em SW15."
            severity note;

        apply_reset(x"AAAA");
        wait for (3 * BIT_PERIOD) / 4 + SAMPLE_DELAY;

        apply_reset(x"0F0F");
        check_frame(x"0F0F");

        report "SUCESSO: todos os testes do Manchester Diferencial passaram."
            severity note;

        sim_done <= true;
        wait;
    end process;

    registered_output_check : process (data_out)
    begin
        if now > 0 ns then
            assert clk = '1' and clk'last_event = 0 ns
                report "ERRO: data_out mudou fora da borda de subida do clock."
                severity failure;
        end if;
    end process;

    watchdog : process
    begin
        wait until sim_done for 512 * BIT_PERIOD + 20 * CLK_PERIOD;

        assert sim_done
            report "ERRO: a simulacao nao terminou dentro do tempo esperado."
            severity failure;

        wait;
    end process;
end architecture sim;