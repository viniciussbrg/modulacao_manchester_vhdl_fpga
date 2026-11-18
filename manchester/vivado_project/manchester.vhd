-- MANCHESTER BASICO - CONVENCAO IEEE 802.3
--
-- Cada bit ocupa duas metades de mesma duracao:
--   dado 0: primeira metade = 1; segunda metade = 0.
--   dado 1: primeira metade = 0; segunda metade = 1.
-- Portanto: primeira metade = NOT dado; segunda metade = dado.
--
-- A sequencia e lida de data_in(15) ate data_in(0) e se repete.
-- Cada posicao e capturada somente no inicio do seu intervalo.
-- O inicio em 100 ns e determinado pelo testbench, nao por este arquivo.

-- [1] BIBLIOTECA E TIPOS LOGICOS
-- std_logic_1164 fornece std_logic, std_logic_vector, rising_edge
-- e os operadores logicos utilizados neste circuito.

library ieee;
use ieee.std_logic_1164.all;

-- [2] ENTITY: INTERFACE DO CIRCUITO
-- A entity apresenta o nome, os parametros e as portas do modulo.
entity manchester is
    generic (
        -- Generic: parametro definido ao instanciar o circuito.
        -- positive: numero inteiro maior que zero.
        -- 100_000_000 e o mesmo numero que 100000000.
        -- A 100 MHz, esse valor produz 1 segundo por bit.
        -- O testbench usa generic map para substitui-lo por 10:
        -- 10 ciclos de 10 ns = 100 ns por bit.
        CYCLES_PER_BIT : positive := 100_000_000
    );
    port (
        -- Clock de entrada. A logica principal usa suas bordas de subida.
        clk      : in  std_logic;

        -- Reset ativo em 1, atendido somente na borda de subida do clock.
        rst      : in  std_logic;

        -- Vetor de 16 entradas: indices 15, 14, ... 0.
        -- Representa os switches; na simulacao, vem do testbench.
        data_in  : in  std_logic_vector(15 downto 0);

        -- Sinal Manchester serial: transmite um bit de entrada por vez.
        data_out : out std_logic;

        -- Vetor de 16 saidas. Somente a posicao atual recebe o sinal.
        led      : out std_logic_vector(15 downto 0)
    );
end entity manchester;

-- [3] ARCHITECTURE: IMPLEMENTACAO INTERNA
-- "rtl" e o nome escolhido para esta arquitetura.
-- Antes de begin, declaramos as constantes e os sinais internos.
architecture rtl of manchester is
    -- Numero de ciclos em cada metade do bit.
    -- natural: inteiro maior ou igual a zero.
    -- constant: valor que nao muda durante a execucao.
    constant HALF_CYCLES : natural := CYCLES_PER_BIT / 2;

    -- Conta a posicao temporal dentro do bit.
    -- Com CYCLES_PER_BIT = 10, percorre os valores de 0 a 9.
    -- O := 0 nesta declaracao define o valor inicial do sinal.
    signal cycle_count : natural range 0 to CYCLES_PER_BIT - 1 := 0;

    -- Escolhe qual entrada transmitir: 15, 14, ... 0, 15, ...
    signal bit_index   : natural range 0 to 15 := 15;

    -- Guarda o valor capturado da entrada no inicio do bit.
    -- Assim, uma mudanca posterior no switch nao altera o bit em andamento.
    signal current_bit : std_logic := '0';

    -- Marcador para observar a fase na simulacao:
    -- 0 = primeira metade; 1 = segunda metade.
    -- Quem decide quando mudar a saida e o contador, nao este marcador.
    signal half_bit    : std_logic := '0';

    -- Registrador que guarda o nivel atual da saida Manchester.
    signal encoded_reg : std_logic := '0';

    -- Indica se a transmissao ja comecou desde o ultimo reset.
    -- 0 = falta iniciar o primeiro bit; 1 = transmissao em andamento.
    signal started     : std_logic := '0';
begin
    -- [4] VERIFICACAO DO PARAMETRO E CONEXAO DA SAIDA
    -- mod calcula o resto da divisao. Resto zero por 2 significa par.
    -- Exigimos pelo menos dois ciclos: um para cada metade.
    -- Na simulacao, um parametro invalido provoca uma falha com mensagem.
    assert CYCLES_PER_BIT >= 2 and CYCLES_PER_BIT mod 2 = 0
        report "CYCLES_PER_BIT deve ser par e maior ou igual a 2."
        severity failure;

    -- Atribuicao concorrente: data_out acompanha encoded_reg.
    -- Funciona como uma conexao entre o registrador e a porta de saida.
    -- A saida nao depende diretamente de mudancas nos switches.
    data_out <= encoded_reg;

    -- [5] PROCESSO SEQUENCIAL E RESET
    -- O processo e reavaliado quando clk muda.
    -- rising_edge permite atualizar os registradores apenas na subida.
    process (clk)
        -- Variavel local para calcular o proximo indice.
        -- A atribuicao := atualiza a variavel imediatamente no processo.
        variable next_index : natural range 0 to 15;
    begin
        if rising_edge(clk) then
            -- O reset tem prioridade sobre todas as outras condicoes.
            -- Como esta dentro de rising_edge, ele e sincrono.
            if rst = '1' then
                -- Reinicia a contagem e prepara a posicao 15.
                cycle_count <= 0;
                bit_index   <= 15;

                -- Limpa o dado armazenado e o marcador de metade.
                current_bit <= '0';
                half_bit    <= '0';

                -- Forca saida baixa e prepara um novo inicio.
                encoded_reg <= '0';
                started     <= '0';

            -- [6] INICIO DO PRIMEIRO BIT APOS O RESET
            elsif started = '0' then
                -- O primeiro bit comeca nesta borda de clock.
                cycle_count <= 0;
                bit_index   <= 15;

                -- Captura o bit 15 para utiliza-lo durante todo o intervalo.
                current_bit <= data_in(15);
                half_bit    <= '0';

                -- Primeira metade: saida = inverso do bit de entrada.
                -- Usamos data_in(15) aqui porque current_bit ainda possui
                -- seu valor anterior durante esta execucao do processo.
                -- As atribuicoes <= agendam a atualizacao dos sinais.
                encoded_reg <= not data_in(15);

                -- Nas proximas bordas, seguimos para a contagem normal.
                started     <= '1';

            -- [7] FIM DO BIT ATUAL E INICIO DO PROXIMO
            -- Com 10 ciclos, encontrar o valor antigo 9 nesta borda
            -- significa que chegou o momento de iniciar o proximo bit.
            elsif cycle_count = CYCLES_PER_BIT - 1 then
                if bit_index = 0 then
                    -- Apos a ultima posicao, recomeca pela primeira.
                    next_index := 15;
                else
                    -- Exemplo: se transmitimos 15, a proxima posicao e 14.
                    next_index := bit_index - 1;
                end if;

                -- Comeca o novo intervalo, sem inserir pausas entre bits.
                cycle_count <= 0;
                bit_index   <= next_index;

                -- Le a entrada correspondente somente agora.
                -- next_index ja tem o valor novo, pois e uma variavel.
                -- bit_index ainda sera atualizado depois do processo.
                current_bit <= data_in(next_index);
                half_bit    <= '0';

                -- Primeira metade do novo bit = inverso do novo dado.
                encoded_reg <= not data_in(next_index);

            -- [8] AVANCO DO TEMPO E TRANSICAO NO MEIO DO BIT
            else
                -- Agenda o incremento do contador para esta borda.
                cycle_count <= cycle_count + 1;

                -- Esta comparacao ainda usa o valor ANTIGO do contador.
                -- Exemplo com 10 ciclos por bit: HALF_CYCLES = 5.
                -- Quando o valor antigo e 4, esta borda muda o contador
                -- para 5 e inicia a segunda metade do bit.
                if cycle_count = HALF_CYCLES - 1 then
                    half_bit    <= '1';

                    -- Segunda metade: saida = proprio bit armazenado.
                    -- Como antes era NOT bit, sempre ocorre uma transicao.
                    encoded_reg <= current_bit;
                end if;

                -- Nas outras bordas, encoded_reg nao recebe atribuicao.
                -- Por ser um registrador, conserva o nivel anterior.
            end if;
        end if;
    end process;

    -- [9] PROCESSO COMBINACIONAL DOS LEDS
    -- E reavaliado quando muda a posicao ou o nivel codificado.
    -- Nao espera uma borda de clock: calcula o vetor a partir desses sinais.
    process (bit_index, encoded_reg)
        -- Variavel auxiliar para montar o valor completo das 16 saidas.
        variable leds_value : std_logic_vector(15 downto 0);
    begin
        -- Define todas as posicoes como zero em cada avaliacao.
        -- Isso evita manter valores antigos nos outros LEDs.
        leds_value := (others => '0');

        -- Substitui somente a posicao selecionada pelo nivel Manchester.
        -- Exemplo: bit_index = 15 e encoded_reg = 1 acendem apenas LD15.
        -- Se encoded_reg = 0, todos os LEDs ficam apagados.
        leds_value(bit_index) := encoded_reg;

        -- Aplica o vetor final a porta de saida.
        -- As atribuicoes acima montam um resultado; nao sao pausas no tempo.
        led <= leds_value;
    end process;
end architecture rtl;