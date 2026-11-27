# Manchester (IEEE 802.3)

Codificador VHDL para a Basys 3 com saída em LEDs, PMOD e VGA. A transição central é de descida para o bit 0 e de subida para o bit 1, segundo a convenção IEEE 802.3.

## Estrutura

```text
manchester/
├── src/               Fontes para síntese
├── sim/               Testbench para o Vivado Simulator
├── constraints/       Mapeamento da Basys 3
├── vivado_project/    Script para recriar o projeto
├── docs/              Tutoriais, documentação técnica e mídias
└── saidas/            Tutoriais e mídias de PMOD e VGA
```

- [manchester.vhd](src/manchester.vhd) implementa o codificador e distribui as saídas.
- [vga_sync.vhd](src/vga_sync.vhd) gera a temporização VGA.
- [manchester_tb.vhd](sim/manchester_tb.vhd) verifica as metades dos bits, os LEDs, o dado original, a troca de dados e o reset.
- [manchester.xdc](constraints/manchester.xdc) configura a pinagem e o clock de 100 MHz.

## Vivado

Use o [script Tcl](vivado_project/README.md) para gerar `manchester.xpr` com o top `manchester` em Design Sources e `manchester_tb` em Simulation Sources. Abra a simulação comportamental e execute **Run All**.

1. Consulte o [diagrama e a documentação técnica](docs/documentacao_projeto.pdf).
2. Siga o [tutorial de simulação](docs/tutorial_simulacao.pdf) para recriar o projeto e interpretar a forma de onda.
3. Siga o [tutorial de placa](docs/tutorial_placa.pdf) para gerar o bitstream, programar a Basys 3 e testar os LEDs.
4. Reproduza as saídas de [PMOD para osciloscópio](saidas/pmod_osciloscopio/README.md) e [VGA com cores pulsantes](saidas/vga/README.md).

## Próximo passo

[Projeto Manchester Diferencial](../manchester_diferencial/README.md)
