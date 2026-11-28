# PMOD — Manchester Diferencial

A saída já está integrada no módulo principal. Não é necessário criar outro projeto ou adicionar IP.

| Pino físico do conector JA | Porta VHDL | Pino FPGA | Sinal |
|---|---|---|---|
| JA1 | `pmod_encoded` | J1 | Codificado |
| JA2 | `pmod_data` | L2 | Dado capturado do bit atual |
| JA5 ou JA11 | GND | Terra da placa | Referência das pontas |

Conecte CH1 a JA1, CH2 a JA2 e terras a GND. Use entradas de alta impedância e sondas apropriadas para lógica 3,3 V; não use os pinos de alimentação como terra.

[Passo a passo](docs/tutorial_pmod.pdf). A lógica está em `../../src/line_encoder.vhd` e `../../src/manchester_diferencial_top.vhd`, e o mapeamento em `../../constraints/manchester_diferencial.xdc`. Não duplique constraints.


## Documentação e registros do Grupo 5

- [Tutorial padronizado em PDF](docs/tutorial_pmod.pdf).
- [Vídeo original da demonstração](docs/midia/diferencial_pmod.mp4).
- As imagens e os demais registros estão em docs/midia/.
