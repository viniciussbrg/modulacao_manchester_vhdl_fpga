# Documentação técnica — Manchester IEEE 802.3

## Arquitetura

![Arquitetura dos módulos](midia/arquitetura.png)

## Regras

Bit 0: alto na primeira metade e baixo na segunda. Bit 1: baixo na primeira metade e alto na segunda.
A transmissão é contínua, de SW15 até SW0. O índice retorna a 15 ao fim de SW0, sem intervalo ocioso.
No Diferencial, o nível é preservado também entre SW0 e SW15; somente reset reinicia a memória em zero.
Todos os outros LEDs ficam em zero. A saída PMOD codificada e o dado original são registrados.

## Interface do top

| Porta | Direção | Tipo | Função |
|---|---|---|---|
| `clk` | entrada | std_logic | Clock 100 MHz |
| `btnC` | entrada | std_logic | Reset ativo alto |
| `sw` | entrada | std_logic_vector(15 downto 0) | Bits nos switches |
| `led` | saída | std_logic_vector(15 downto 0) | Somente posição atual recebe o código |
| `pmod_encoded` | saída | std_logic | Código em JA1 |
| `pmod_data` | saída | std_logic | Bit original capturado em JA2 |
| `vgaRed`, `vgaGreen`, `vgaBlue` | saída | std_logic_vector(3 downto 0) | RGB de 4 bits/cor |
| `Hsync`, `Vsync` | saída | std_logic | Sincronismo VGA ativo baixo |

## Parâmetros e fronteiras temporais

`CYCLES_PER_BIT` é positive, par e >=2; valor padrão 100000000. No clock de 100 MHz: Tbit = CYCLES_PER_BIT × 10 ns.
O core captura o switch no flanco que inicia cada bit, mantendo o dado por exatamente CYCLES_PER_BIT ciclos.
O contador percorre 0..CYCLES_PER_BIT-1. Na passagem para CYCLES_PER_BIT/2, inverte a saída.
A implementação usa um único domínio de clock; a VGA usa clock enable e não cria um clock secundário.
O contador de transmissão com o padrão de 1 s requer 27 bits.

## Entradas assíncronas e reset

Cada switch passa por dois flip-flops marcados `ASYNC_REG`; o core captura a versão sincronizada.
Isso adiciona aproximadamente dois ciclos de sincronização antes da disponibilidade para captura. Alterações muito próximas da borda podem ser percebidas na próxima captura, como em qualquer entrada física assíncrona.
Não se pretende capturar um barramento multibit atomicamente: cada posição é lida separadamente conforme o enunciado.

O botão usa asserção assíncrona e liberação por dois flip-flops. Enquanto pressionado, core e LEDs são zerados.
Após soltar, o core inicia no terceiro flanco de clock, sempre por SW15. Na inicialização da FPGA, `rst_pipe="11"` garante a mesma sequência de partida.
O condicionamento não implementa debounce; repiques podem reiniciar a transmissão durante a liberação do botão.

## Saídas e constraints

LEDs são registrados para evitar seleção combinacional que gere pulsos espúrios na troca de posição.
PMOD codificado é diretamente ligado ao registrador de nível; dado original, ao registrador de captura.
O XDC contém pinagem oficial Digilent, LVCMOS33, clock de 10 ns e exceções restritas às entradas assíncronas até o primeiro estágio.
O caminho do primeiro para o segundo estágio dos switches e os caminhos internos do reset continuam sujeitos à análise temporal.
As saídas de observação não possuem clock externo de captura, logo não se inventam `set_output_delay` para elas; avisos correspondentes devem ser interpretados nesse contexto. Não é aceitável ignorar falhas de setup/hold nos caminhos internos.

## VGA

640×480 ativos, 800×525 totais; pixel de 40 ns, linha de 32 µs e quadro de 16,8 ms (~59,52 Hz).
Hsync: baixo em h=656..751; Vsync: baixo em v=490..491; blanking preto.
RGB e sincronismos são registrados para o mesmo pixel. A VGA continua durante o reset da transmissão.
O nível é observado a cada pixel: atraso até o próximo pixel mais um ciclo de registro se a mudança coincidir com a borda. A cor não é retida até o próximo quadro.


## Regras e exemplo temporal

A convenção IEEE 802.3 representa 0 por alto/baixo e 1 por baixo/alto. A transição central é de descida para 0 e de subida para 1.

![Diagrama calculado para comparação dos códigos](midia/codificacoes.png)

## Tabela completa de pinagem

Todas as portas utilizam LVCMOS33. Os índices seguem o XDC entregue.

| Porta | Pino FPGA |
|---|---|
| `clk` | W5 |
| `sw[0]` | V17 |
| `sw[1]` | V16 |
| `sw[2]` | W16 |
| `sw[3]` | W17 |
| `sw[4]` | W15 |
| `sw[5]` | V15 |
| `sw[6]` | W14 |
| `sw[7]` | W13 |
| `sw[8]` | V2 |
| `sw[9]` | T3 |
| `sw[10]` | T2 |
| `sw[11]` | R3 |
| `sw[12]` | W2 |
| `sw[13]` | U1 |
| `sw[14]` | T1 |
| `sw[15]` | R2 |
| `led[0]` | U16 |
| `led[1]` | E19 |
| `led[2]` | U19 |
| `led[3]` | V19 |
| `led[4]` | W18 |
| `led[5]` | U15 |
| `led[6]` | U14 |
| `led[7]` | V14 |
| `led[8]` | V13 |
| `led[9]` | V3 |
| `led[10]` | W3 |
| `led[11]` | U3 |
| `led[12]` | P3 |
| `led[13]` | N3 |
| `led[14]` | P1 |
| `led[15]` | L1 |
| `btnC` | U18 |
| `pmod_encoded` | J1 |
| `pmod_data` | L2 |
| `vgaRed[0]` | G19 |
| `vgaRed[1]` | H19 |
| `vgaRed[2]` | J19 |
| `vgaRed[3]` | N19 |
| `vgaBlue[0]` | N18 |
| `vgaBlue[1]` | L18 |
| `vgaBlue[2]` | K18 |
| `vgaBlue[3]` | J18 |
| `vgaGreen[0]` | J17 |
| `vgaGreen[1]` | H17 |
| `vgaGreen[2]` | G17 |
| `vgaGreen[3]` | D17 |
| `Hsync` | P19 |
| `Vsync` | R19 |

## Bibliotecas e ambiente

O circuito utiliza ieee.std_logic_1164 e ieee.numeric_std. O testbench usa std.env.finish e requer VHDL 2008. Os dois XPR recebidos foram salvos no Vivado 2026.1, em Windows. Há registro de uma sessão de geração no Vivado 2025.2, mas a versão exata do bitstream dos vídeos não foi informada. Para reproduzir em 2025.2, recrie o projeto pelos scripts Tcl a partir dos fontes, preservando uma cópia do projeto original.

## Verificações e alcance da evidência

O log simulate.log recebido contém PASS para o teste principal com CYCLES_PER_BIT=10 e término em 30486 ns. Os demais testbenches existem no pacote. Seus resultados no XSim não foram fornecidos. Os vídeos documentam demonstrações físicas, sem relatórios de utilização ou timing associados. O display de sete segmentos aparece iluminado em vídeos, mas não possui portas nem controle no top recebido e não integra a funcionalidade documentada.

## Análise dos resultados

O log recebido de manchester_tb registra PASS com CYCLES_PER_BIT=10 e encerramento em 30486 ns. Esse resultado corresponde às verificações automáticas do núcleo presentes no testbench, incluindo regras de codificação, ordem do índice, LEDs, estabilidade do bit capturado e reinício após reset.

As demonstrações físicas recebidas apresentam a placa e os estados dos LEDs, a alternância azul/verde no monitor VGA e o arranjo de aquisição das saídas PMOD. A saída azul corresponde ao nível baixo e a verde ao alto no código integrado. A observação qualitativa é coerente com as regras descritas neste documento.

A comparação quantitativa entre simulação e hardware requer identificar o bitstream utilizado, as escalas e canais das aquisições e os relatórios de implementação. Esses registros não acompanharam o material recebido. Assim, os valores de 1 s por bit no modo visual e 1 ms por bit no modo de aquisição são configurações calculadas a partir dos scripts, sem atribuição de medidas numéricas às imagens dos vídeos.
