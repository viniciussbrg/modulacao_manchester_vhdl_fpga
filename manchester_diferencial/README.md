# Codificação Manchester Diferencial

Implementação em VHDL do código Manchester Diferencial, em que sempre há
transição no meio do bit e o valor do bit é dado pela transição no início do
intervalo (0 = inversão do nível, 1 = mantém o nível anterior). Nível após o
reset: baixo.

## Estrutura desta pasta

```
manchester_diferencial/
|-- manchester_diferencial.xpr   Projeto Vivado pronto para abrir
|-- manchester_diferencial.srcs/
|   |-- sources_1/new/           Código-fonte VHDL do circuito
|   |-- sim_1/new/               Testbench para simulação
|   `-- constrs_1/new/           Mapeamento dos pinos da FPGA (.xdc)
|-- docs/                        Tutoriais e documentação técnica
|   `-- midia/                   Captura da simulação
`-- saidas/                      Saídas PMOD e VGA
```

## Arquivos de código

- [`manchester_diferencial.srcs/sources_1/new/Manchester_Diferencial.vhd`](./manchester_diferencial.srcs/sources_1/new/Manchester_Diferencial.vhd) - código-fonte do circuito principal
  (codificador com registrador do nível de saída, sincronização do reset,
  saídas de LED/PMOD e gerador de sinal VGA)
- [`manchester_diferencial.srcs/sim_1/new/tb_Manchester_Diferencial.vhd`](./manchester_diferencial.srcs/sim_1/new/tb_Manchester_Diferencial.vhd) - testbench com verificação automática
  (`assert`) das duas metades de cada bit, acompanhando o nível anterior, para
  duas palavras consecutivas
- [`manchester_diferencial.srcs/constrs_1/new/basys3_Manchester_Diferencial.xdc`](./manchester_diferencial.srcs/constrs_1/new/basys3_Manchester_Diferencial.xdc) - mapeamento dos pinos da
  FPGA (Basys 3) e definição do clock de 100 MHz

## Documentação

- [Tutorial de simulação](./docs/tutorial_simulacao_manchester_diferencial.pdf) - como simular no
  Vivado passo a passo
- [Tutorial de gravação na placa](./docs/tutorial_placa_manchester_diferencial.pdf) - como
  sintetizar, gerar o bitstream e gravar na FPGA
- [Documentação técnica](./docs/documentacao_projeto_manchester_diferencial.pdf) - diagrama de
  blocos, descrição das portas e funcionamento
- [Captura da simulação](./docs/midia/simulacao_manchester_diferencial.png) - formas de
  onda obtidas no Vivado Simulator

## Por onde começar

Para uma **simulação rápida** (apenas ver funcionando):

1. Abrir o Vivado e carregar `manchester_diferencial.xpr` (nesta pasta)
2. Clicar em `Run Simulation` -> `Run Behavioral Simulation`

Para **reproduzir o projeto do zero**, seguir esta ordem:

1. **Entender o circuito** lendo a
   [documentação técnica](./docs/documentacao_projeto_manchester_diferencial.pdf)
2. **Comparar com o Manchester** (visto no projeto anterior) para identificar
   as diferenças na lógica de transição
3. **Simular no Vivado** seguindo o
   [tutorial de simulação](./docs/tutorial_simulacao_manchester_diferencial.pdf)
4. **Gravar na placa** seguindo o
   [tutorial de gravação](./docs/tutorial_placa_manchester_diferencial.pdf)
5. **Implementar as atividades** de [saídas PMOD e VGA](./saidas/)

## Saídas PMOD e VGA

- [Saída pelo PMOD para osciloscópio](./saidas/pmod_osciloscopio/)
- [Saída VGA com cores pulsantes](./saidas/vga/)

## Próximo passo

Os dois projetos do trabalho estão concluídos. Acessar o
[Relatório técnico final](../relatorio_final/relatorio.pdf) para ver a análise
comparativa entre os dois códigos, os resultados obtidos e as conclusões do
grupo.
