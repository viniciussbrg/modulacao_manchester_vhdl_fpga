# Codificação de linha Manchester e Manchester Diferencial em VHDL

CENTRO EDUCACIONAL FACULDADE ENGENHEIRO SALVADOR ARENA

Engenharia da Computação

Beatriz Carvalho Sousa - RA 082230027

Guilherme Pexirile Lourenco - RA 082230011

Yuri Villaco De Souza - RA 082230036

Lucas Da Silva Macedo - RA 082230037

Rhyu Costa De Souza - RA 082230023

São Bernardo do Campo

2026

Sistemas Reconfiguráveis - 7º semestre

Professor Vinícius S. Borges

Grupo 5

## Resumo

Foram organizados dois projetos de codificação de linha para a placa Basys 3, utilizando VHDL e Vivado. A transmissão percorreu conceitualmente as 16 entradas na ordem SW15 a SW0, com captura por bit, reset e observação em LEDs, PMOD e VGA. Os logs fornecidos registraram aprovação dos testes principais de Manchester IEEE 802.3 e Manchester Diferencial. Os vídeos apresentaram demonstrações físicas dos dois códigos, alternância azul/verde no monitor e aquisição de sinais. A análise relacionou o código às evidências e comparou os esquemas com NRZ-L. A documentação quantitativa das aquisições, os relatórios de implementação e os prints de todas as etapas permaneceram sem registro no conjunto recebido.

## 1. Introdução e objetivos

O trabalho abordou codificação de linha em lógica reconfigurável. O objetivo geral foi desenvolver e analisar dois circuitos síncronos com transição central em cada bit. Como objetivos específicos, foram considerados o sequenciamento das 16 entradas, a preservação do bit capturado, o reinício pelo botão central, a parametrização temporal e a observação por LEDs, PMOD e VGA, conforme o enunciado. A documentação foi estruturada segundo os guias de documentação e entrega.

## 2. Fundamentação teórica

Na codificação Manchester IEEE 802.3 adotada no trabalho, o bit 0 foi representado por alto/baixo e o bit 1 por baixo/alto. No Manchester Diferencial, a transição central foi mantida para todos os bits, enquanto 0 provocou inversão no início e 1 preservou o nível anterior. A referência após reset foi definida como baixa.

A transição obrigatória central ofereceu referência de temporização para recuperação de clock. Cada bit ideal permaneceu metade do tempo em cada nível. Em uma representação bipolar simétrica, essa propriedade produziu média nula por bit. Nas saídas unipolares físicas da FPGA, os níveis baixo e alto tiveram média próxima à metade da amplitude lógica, considerando metades iguais. A expressão componente DC depende, portanto, da representação elétrica considerada.

Em NRZ-L, cada bit manteve um único nível e sequências constantes puderam permanecer sem transições por vários bits. Em Manchester, houve uma transição central e uma transição adicional possível entre bits. Para uma mesma taxa de bits, a necessidade de alternâncias em intervalos de meio bit levou a uma exigência de banda usualmente aproximada como o dobro de NRZ. A banda efetiva também dependeu da forma dos pulsos e do critério espectral adotado.

![Comparação calculada dos códigos; referência diferencial inicial baixa](midia/codificacoes.png)

## 3. Metodologia e materiais

Foram examinados os fontes VHDL, os testbenches, as constraints e os projetos recebidos. Foram utilizados os logs originais do XSim e sete vídeos encaminhados pelo grupo. As etapas documentadas compreenderam a configuração do projeto, a simulação, a preparação da geração do bitstream e a demonstração em placa.

A placa alvo foi a Basys 3 com FPGA xc7a35tcpg236-1 e clock de 100 MHz. Os dois XPR foram salvos no Vivado 2026.1. Também foi recebida uma captura de lançamento do bitstream no Vivado 2025.2. A versão efetivamente associada aos bitstreams filmados não foi identificada. O grupo confirmou que as medições foram realizadas diretamente nas saídas PMOD, conforme o enunciado. O modelo do equipamento e a identificação de seus canais não foram informados.

## 4. Desenvolvimento dos circuitos

A arquitetura foi dividida em input_conditioner, line_encoder, módulo top e vga_colors. O condicionamento sincronizou cada switch em dois flip-flops e utilizou asserção assíncrona e liberação sincronizada do reset. A separação permitiu utilizar o mesmo núcleo nos dois projetos e fixar DIFFERENTIAL em false ou true no respectivo top.

![Arquitetura identificada nos fontes recebidos](midia/arquitetura.png)

O contador percorreu 0 até CYCLES_PER_BIT-1. O índice iniciou em 15 e decrementou no limite dos bits, retornando a 15 após 0. No começo do intervalo, o switch sincronizado foi armazenado em bit_latched. A transição intermediária foi acionada quando o contador antigo atingiu CYCLES_PER_BIT/2-1, de modo que a nova metade começou após exatamente metade dos ciclos.

O Manchester definiu o primeiro nível como o inverso do bit capturado. O Diferencial utilizou o registrador level para manter a memória entre intervalos. No início, inverteu para bit 0 e manteve para bit 1. No meio, ambos inverteram level. O vetor de LEDs foi atualizado com zeros em todas as posições e com o nível codificado na posição selecionada.

O top disponibilizou pmod_encoded em JA1/J1 e pmod_data em JA2/L2. A saída de dado representou o bit capturado. A pinagem completa foi documentada nos dois documentos técnicos e foi extraída dos XDC recebidos. O processo de geração e programação foi descrito nos tutoriais com apoio na documentação de programação do Vivado.

## 5. Temporização e VGA

| Configuração dos fontes/scripts | Ciclos por bit | Duração calculada | Metade calculada | Taxa calculada |
|---|---|---|---|---|
| Testbench principal | 10 | 100 ns | 50 ns | 10 Mbit/s |
| LEDs e VGA | 100000000 | 1 s | 0,5 s | 1 bit/s |
| Roteiro de PMOD | 100000 | 1 ms | 0,5 ms | 1 kbit/s |

Esses valores foram calculados com clock de 10 ns. O parâmetro usado nas aquisições filmadas não pôde ser medido a partir das escalas recebidas. A mudança do generic de síntese exigiu um novo bitstream.

A VGA utilizou habilitação a cada quatro ciclos de 100 MHz, equivalente a pixels de 40 ns. Foram definidos 640 por 480 pixels ativos, com totais de 800 por 525. O período calculado do quadro foi 16,8 ms, correspondente a aproximadamente 59,52 Hz. Na área ativa, o nível baixo gerou azul e o alto gerou verde. O blanking permaneceu preto, e o controlador continuou ativo durante o reset da transmissão.

## 6. Resultados de simulação

| Teste principal no XSim | Resultado do log recebido | Instante final |
|---|---|---|
| manchester_tb, CYCLES_PER_BIT=10 | PASS | 30486 ns |
| manchester_diferencial_tb, CYCLES_PER_BIT=10 | PASS | 30486 ns |

Os testbenches verificaram padrões 0000, FFFF, AAAA, 5555, B2C9 e 8001, repetição de palavras, LEDs, estabilidade do bit e reset em diferentes fases. A aprovação dos testes foi verificada diretamente nos arquivos simulate.log. Os testbenches de integração e VGA foram recebidos, mas seus logs XSim não acompanharam o conjunto. O documento anterior VALIDACAO.md registrou testes GHDL realizados na preparação do código; esses resultados foram mantidos como registro anterior, sem nova execução nesta etapa de documentação.

![Captura real do ambiente de simulação Manchester](midia/simulacao_manchester.png)

As capturas recebidas apresentaram zoom temporal muito alto. Elas identificaram a sessão e os sinais, porém não permitiram analisar visualmente as transições por bit. A figura calculada da seção 2 serviu como referência explicativa. Uma exportação real legível das ondas continuou necessária para completar a evidência visual.

## 7. Resultados físicos

### 7.1 LEDs e sequenciamento

Os registros de Manchester e Diferencial mostraram a placa energizada e LEDs em posições distintas ao longo da demonstração. Um vídeo de Manchester também mostrou interação manual com a placa. A demonstração foi associada aos códigos pelos nomes dos arquivos encaminhados pelo grupo. Os vídeos não continham metadados de bitstream que permitissem estabelecer correspondência binária com os fontes recebidos.

![Manchester, quadro extraído do vídeo da placa](midia/led_manchester.jpg)

![Manchester Diferencial, quadro extraído do vídeo da placa](midia/led_diferencial.jpg)

### 7.2 Saídas VGA

Os registros dos dois projetos mostraram a alternância de tela cheia entre azul e verde, coerente com o mapeamento lógico implementado. As sequências contínuas foram preservadas no vídeo consolidado. As imagens a seguir documentaram dois estados de cada saída.

![Manchester com VGA em azul e verde, quadros do mesmo vídeo](midia/vga_manchester.jpg)

![Diferencial com VGA em azul e verde, quadros do mesmo vídeo](midia/vga_diferencial.jpg)

### 7.3 Aquisição das saídas PMOD

O grupo confirmou a medição diretamente no PMOD. Os vídeos mostraram a placa conectada ao arranjo de aquisição e formas de onda no monitor. A resolução recebida não permitiu determinar de forma confiável a identificação das curvas, a base de tempo, a escala de tensão ou a taxa medida. Assim, a discussão manteve caráter qualitativo, com a pinagem e os valores de reprodução documentados a partir dos fontes.

![Registro físico da aquisição Manchester](midia/pmod_manchester.jpg)

![Registro físico da aquisição Diferencial](midia/pmod_diferencial.jpg)

### 7.4 Síntese, implementação e programação

Foi recebida uma captura da janela de lançamento da geração do bitstream. Os vídeos mostraram funcionamento físico relatado pelo grupo. Não foram recebidos relatórios de utilização, WNS/TNS, hold, DRC nem os bitstreams utilizados. Por esse motivo, não foi atribuída uma quantidade de recursos nem declarado fechamento de timing a partir dos registros disponíveis.

## 8. Análise comparativa

| Aspecto | Manchester IEEE 802.3 | Manchester Diferencial | NRZ-L |
|---|---|---|---|
| Informação do bit | Sentido da transição central | Transição ou manutenção no início | Nível durante o intervalo |
| Transição central obrigatória | Sim | Sim | Não |
| Memória de nível no codificador usado | Saída reiniciada por bit | Nível anterior preservado | Nível definido pelo dado |
| Inversão global de polaridade | Troca o sentido e a interpretação | Preserva presença de transições, dada referência coerente | Troca níveis e interpretação |
| Sequências longas constantes | Mantêm transições | Mantêm transições | Podem omitir transições |
| Exigência usual de banda | Aproximadamente 2 vezes NRZ | Aproximadamente 2 vezes NRZ | Referência |

A solução diferencial tolerou conceitualmente uma inversão global de polaridade porque a informação foi associada à mudança relativa. A decodificação do primeiro bit exigiu uma referência inicial coerente ou mecanismo de enquadramento. O projeto entregue implementou codificadores e não realizou ensaio de recepção ou inversão física de polaridade.

A simulação forneceu verificações ciclo a ciclo por assertions. As demonstrações físicas acrescentaram observação do comportamento na placa e no monitor. A comparação quantitativa entre ambas ficou limitada pela falta de escalas legíveis das aquisições e relatórios temporais. Os vídeos de VGA sustentaram a correspondência qualitativa entre os níveis codificados e as duas cores.

## 9. Dificuldades registradas e soluções

Durante a abertura inicial, o projeto NRZL apresentou caminhos inválidos para os fontes. A reconstrução com fontes incluídos e scripts Tcl permitiu organizar os dois projetos. Outra ocorrência foi o bloqueio do criar_todos.tcl quando já existia um XPR na pasta de saída. A preservação da pasta anterior com outro nome permitiu recriar os projetos. Na simulação, o zoom excessivo ocultou as transições, motivando a orientação de Zoom Fit e ajuste de janela. A sequência de mensagens também registrou dúvidas sobre a criação dos dois projetos e a abertura automática apenas do Manchester.

Não foi informada a divisão individual de tarefas nem fornecido relato adicional de dificuldades de laboratório. Os nomes e RAs foram apresentados como autoria coletiva.

## 10. Conclusões

A organização do projeto evidenciou o uso de contagem síncrona, captura por bit, memória de nível e integração de interfaces físicas. Os logs do Vivado aprovaram os testes principais das duas codificações. Os vídeos acrescentaram demonstrações de LEDs, VGA e aquisição PMOD. A diferença entre codificação por sentido de transição e por transições relativas foi descrita e relacionada ao circuito.

A documentação quantitativa permaneceu limitada pela ausência de relatórios de implementação e de capturas instrumentais legíveis. Como continuação, foram identificadas a exportação dessas capturas, a identificação do instrumento e dos canais, a associação do bitstream ao código e a documentação dos ensaios de reset e alteração dos switches. Também poderiam ser estudados debounce, indicação do índice e recepção dos códigos.
