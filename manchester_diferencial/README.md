# Manchester Diferencial

Codificador VHDL para a Basys 3 com saída em LEDs, PMOD e VGA. Todo bit tem transição no meio. O bit 0 inverte o nível no início e o bit 1 mantém o nível anterior. O reset coloca a saída em nível baixo.

## Estrutura

```text
manchester_diferencial/
├── src/               Fontes para síntese
├── sim/               Testbench para o Vivado Simulator
├── constraints/       Mapeamento da Basys 3
├── vivado_project/    Script para recriar o projeto
├── docs/              Tutoriais, documentação técnica e mídias
└── saidas/            Tutoriais e mídias de PMOD e VGA
```

- [manchester_dif.vhd](src/manchester_dif.vhd) implementa o codificador e distribui as saídas.
- [vga_sync.vhd](src/vga_sync.vhd) gera a temporização VGA.
- [manchester_dif_tb.vhd](sim/manchester_dif_tb.vhd) verifica as metades dos bits, os LEDs, o dado original, a troca de dados e o reset.
- [manchester_dif.xdc](constraints/manchester_dif.xdc) configura a pinagem e o clock de 100 MHz.

## Vivado

Use o [script Tcl](vivado_project/README.md) para gerar `manchester_dif.xpr` com o top `manchester_dif` em Design Sources e `manchester_dif_tb` em Simulation Sources. Abra a simulação comportamental e execute **Run All**.

1. Consulte o [diagrama e a documentação técnica](docs/documentacao_projeto.pdf).
2. Siga o [tutorial de simulação](docs/tutorial_simulacao.pdf) para recriar o projeto e interpretar a forma de onda.
3. Siga o [tutorial de placa](docs/tutorial_placa.pdf) para gerar o bitstream, programar a Basys 3 e testar os LEDs.
4. Reproduza as saídas de [PMOD para osciloscópio](saidas/pmod_osciloscopio/README.md) e [VGA com cores pulsantes](saidas/vga/README.md).

## Próximo passo

[Relatório técnico final](../relatorio_final/relatorio.pdf)
