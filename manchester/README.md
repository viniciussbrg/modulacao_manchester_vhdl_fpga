# Codificação Manchester

Implementação em VHDL do código Manchester (convenção IEEE 802.3), em que o
bit é representado pelo sentido da transição no meio do intervalo de bit
(0 = descida, 1 = subida). Há sempre uma transição no meio de cada bit; a
primeira metade do intervalo carrega o nível oposto ao do bit e a segunda
metade carrega o próprio valor do bit.

## Estrutura desta pasta

```
manchester/
|-- manchester.xpr       Projeto Vivado pronto para abrir
|-- manchester.srcs/
|   |-- sources_1/new/   Código-fonte VHDL do circuito
|   |-- sim_1/new/       Testbench para simulação
|   `-- constrs_1/new/   Mapeamento dos pinos da FPGA (.xdc)
|-- docs/                Tutoriais e documentação técnica
|   `-- midia/           Captura da simulação
`-- saidas/              Saídas PMOD e VGA
```

## Arquivos de código

- [`manchester.srcs/sources_1/new/Manchester.vhd`](./manchester.srcs/sources_1/new/Manchester.vhd) - código-fonte do circuito principal (codificador,
  sincronização do reset, saídas de LED/PMOD e gerador de sinal VGA)
- [`manchester.srcs/sim_1/new/tb_Manchester.vhd`](./manchester.srcs/sim_1/new/tb_Manchester.vhd) - testbench com verificação automática (`assert`)
  das duas metades de cada bit, para duas palavras consecutivas
- [`manchester.srcs/constrs_1/new/basys3_Manchester.xdc`](./manchester.srcs/constrs_1/new/basys3_Manchester.xdc) - mapeamento dos pinos da FPGA (Basys 3)
  e definição do clock de 100 MHz

## Documentação

- [Tutorial de simulação](./docs/tutorial_simulacao_manchester.pdf) - como simular no
  Vivado passo a passo
- [Tutorial de gravação na placa](./docs/tutorial_placa_manchester.pdf) - como
  sintetizar, gerar o bitstream e gravar na FPGA
- [Documentação técnica](./docs/documentacao_projeto_manchester.pdf) - diagrama de
  blocos, descrição das portas e funcionamento
- [Captura da simulação](./docs/midia/simulacao_manchester.png) - formas de
  onda obtidas no Vivado Simulator

## Por onde começar

Para uma **simulação rápida** (apenas ver funcionando):

1. Abrir o Vivado e carregar `manchester.xpr` (nesta pasta)
2. Clicar em `Run Simulation` -> `Run Behavioral Simulation`

Para **reproduzir o projeto do zero**, seguir esta ordem:

1. **Entender o circuito** lendo a
   [documentação técnica](./docs/documentacao_projeto_manchester.pdf)
2. **Simular no Vivado** seguindo o
   [tutorial de simulação](./docs/tutorial_simulacao_manchester.pdf)
3. **Gravar na placa** seguindo o
   [tutorial de gravação](./docs/tutorial_placa_manchester.pdf)
4. **Implementar as atividades** de [saídas PMOD e VGA](./saidas/)

## Saídas PMOD e VGA

- [Saída pelo PMOD para osciloscópio](./saidas/pmod_osciloscopio/)
- [Saída VGA com cores pulsantes](./saidas/vga/)

## Próximo passo

Após concluir este projeto, seguir para a
[Codificação Manchester Diferencial](../manchester_diferencial/), que
implementa a outra versão estudada no trabalho.
