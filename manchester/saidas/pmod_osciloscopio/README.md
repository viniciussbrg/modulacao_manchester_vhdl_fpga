# Saída PMOD — Manchester básico

O top encaminha o nível codificado de [manchester.vhd](src/manchester.vhd) para `data_out`. O [XDC](constraints/constraints.xdc) associa essa porta a L2, no contato JA2 da Basys 3. As [fotografias e capturas](docs/midia/) registram a ligação e os ensaios no WaveForms.

## Leitura no osciloscópio

1. Identifique a Basys 3, o Analog Discovery 3 e os contatos de sinal e terra na figura do [tutorial PMOD](docs/tutorial_pmod.pdf).
2. Com os equipamentos desligados, faça a ligação de C1 e da referência de terra conforme o tutorial.
3. Use o [projeto e bitstream de Manchester básico](../../vivado_project/README.md). No Scope do WaveForms 3.24.4, ajuste C1 para 1 V/div, offset de 0 V e base de tempo de 2 s/div.
4. Compare as transições com a posição dos switches. A duração prevista é de 1 s por bit e 0,5 s por metade.

As medições existentes mostram o sinal codificado em C1. A observação simultânea do dado original exige um segundo sinal exportado para o PMOD e uma captura com C2 habilitado.
