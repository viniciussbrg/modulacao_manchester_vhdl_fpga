# Validação do pacote

## Resultado executado neste ambiente

**Compilação e simulações passaram no GHDL 2.0.0, com VHDL 2008.**
Não há Vivado nem FPGA conectada neste ambiente. Nenhum arquivo `.bit`, captura física ou relatório de implementação AMD é fornecido como resultado validado.

| Verificação | Manchester | Manchester Diferencial |
|---|---|---|
| Compilação de todos os fontes e testbenches | Passou | Passou |
| Core, CYCLES_PER_BIT=2 | Passou | Passou |
| Core, CYCLES_PER_BIT=4 | Passou | Passou |
| Core, CYCLES_PER_BIT=10 | Passou | Passou |
| Core, CYCLES_PER_BIT=100 | Passou | Passou |
| Integração top, PMOD, LEDs, sincronização e reset | Passou | Passou |
| VGA: dois quadros completos e retorno ao início | Passou | Passou |
| Front-end de síntese do GHDL, top completo com valor padrão | Passou | Passou |
| Rejeição de CYCLES_PER_BIT=1 e 3 | Passou | Passou |
| Pinagem comparada ao XDC oficial da Digilent | 50/50 portas | 50/50 portas |

São 12 execuções positivas de simulação, além de quatro testes negativos de parâmetros inválidos e duas verificações de sintetizabilidade.
O log das execuções positivas está em [verificacao/ghdl_resultados.txt](verificacao/ghdl_resultados.txt).
Os scripts `scripts/testar_ghdl.sh` em cada projeto reproduzem os testes positivos com GHDL instalado.

O GHDL emite avisos de atributos AMD não tratados (`ASYNC_REG` e `SHREG_EXTRACT`) ao sintetizar. Eles não invalidam as simulações, mas a aplicação desses atributos na implementação deve ser conferida no Vivado.
O teste GHDL de síntese **não faz place-and-route**, não escolhe pinos e não comprova fechamento de timing na FPGA.

## Cobertura funcional

- Manchester IEEE 802.3: 0 alto/baixo, 1 baixo/alto.
- Diferencial: regra de início para 0 e 1, transição no meio, memória entre bits e entre quadros, estado inicial baixo.
- Seis padrões, três quadros completos por padrão, repetidos em quatro durações de bit.
- Captura por posição, estabilidade durante todo o bit, alteração de switches e próxima visita a SW15.
- Ordem 15 até 0 e retorno automático sem intervalo adicional.
- Um único LED podendo acender, exatamente na posição transmitida.
- Reset mantido, aplicado em cada fase do bit e reinício em SW15.
- Integração de PMOD com o bit original capturado e o sinal codificado.
- VGA: 640×480 ativos, totais 800×525, Hsync/Vsync, duas cores e blanking.

## Verificação dos scripts e arquivos

A sintaxe Tcl e a resolução dos 16 caminhos de importação foram conferidas com `tclsh` e substitutos locais para as chamadas Vivado. Isso verifica organização e caminhos, **não valida a execução das APIs no Vivado**.
As duas constraints cobrem todas as 50 portas físicas, sem pinos repetidos, comparadas com o arquivo oficial da Digilent.
Os links locais dos guias e a sintaxe dos scripts shell foram conferidos.

## Correspondência com o enunciado

| Requisito | Implementação | Evidência ainda necessária |
|---|---|---|
| Dois projetos separados | Dois scripts de criação, dois tops e duas pastas completas | Criar/abrir os dois `.xpr` no Vivado |
| Regras das duas codificações | `line_encoder.vhd`, modo fixado em cada top | Capturas XSim e placa |
| SW15..SW0 e repetição | Índice registrado no core | Vídeo/fotos |
| Captura no início do bit | Registro `bit_latched` após sincronizadores | Ensaio de troca de switches |
| Reset e reinício | `input_conditioner.vhd` e reset do core | Ensaio BTNC |
| LEDs por posição | Vetor registrado no core | Placa |
| Duração parametrizável | Generic par `CYCLES_PER_BIT`; `BIT_PERIOD` no TB | Medição da duração |
| PMOD em dois canais | JA1 codificado; JA2 dado original | Osciloscópio físico |
| VGA duas cores | `vga_colors.vhd` integrado | Monitor físico |
| Simulação Vivado | Testbenches e scripts fornecidos | Executar em XSim e capturar |
| Implementação física | XDC e fluxo de geração preparados | Síntese, implementação, timing e bitstream |
| Documentação final | READMEs e roteiros em Markdown | PDFs, resultados, relatório, vídeo e PR |

## Limitações que dependem do laboratório

O código é destinado à Basys 3 com clock de 100 MHz. Outra placa exige rever FPGA, pinos e temporização.
O modo VGA de 25 MHz produz aproximadamente 59,52 Hz; a compatibilidade deve ser confirmada no monitor usado.
As entradas têm sincronização, sem debounce. O tempo de amostragem de um switch físico próximo da borda não é determinístico, e repiques do botão podem estender o reset.
O padrão lento destina-se a LEDs/VGA; o modo de 1 kbit/s destina-se ao osciloscópio. A mudança de modo exige gerar e gravar novo bitstream.

Antes de afirmar que o trabalho funciona integralmente conforme a avaliação do professor, execute as etapas pendentes em [CHECKLIST_ENTREGA.md](CHECKLIST_ENTREGA.md).
