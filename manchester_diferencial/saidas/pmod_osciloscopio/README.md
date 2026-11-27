# Saída PMOD (osciloscópio) - Manchester Diferencial

Esta saída envia o sinal Manchester Diferencial e o dado original (NRZ) para o conector PMOD JA da
Basys 3, permitindo observar os dois sinais lado a lado em um osciloscópio de dois canais.
Para que as transições fiquem visíveis no osciloscópio, o codificador é instanciado com
`CYCLES_PER_BIT = 20_000`, o que resulta em 200 µs por bit (5 kbit/s) e 100 µs por metade de bit.

## Estrutura desta pasta
```
pmod_osciloscopio/
|-- src/manchester_dif.vhd           Codificador (cópia do projeto principal)
|-- src/manchester_dif_pmod.vhd      Top da saída PMOD (instancia o codificador)
|-- constraints/manchester_dif_pmod.xdc
|-- vivado_project/         Projeto Vivado manchester_dif_pmod.xpr
`-- docs/                   Tutorial e mídias
```

## Ligações
| Pino JA | Sinal | Osciloscópio |
|---|---|---|
| 1 (J1) | pmod_cod - sinal codificado | Canal 1 |
| 2 (L2) | pmod_nrz - dado original | Canal 2 |
| 5 | GND | Terra das pontas |

## Equipamentos
- Placa Basys 3 e cabo micro-USB
- Osciloscópio de dois canais e duas pontas de prova

## Como reproduzir
1. Abrir `vivado_project/manchester_dif_pmod.xpr` no Vivado 2025.2.
2. Gerar o bitstream e gravar na placa.
3. Ligar as pontas conforme a tabela e ajustar o osciloscópio (1 V/div, 100 µs/div, trigger no canal 1).

Passo a passo completo: [tutorial PMOD](./docs/tutorial_pmod.pdf).
