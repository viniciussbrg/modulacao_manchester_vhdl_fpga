# Saída pelo PMOD (osciloscópio) — Manchester Diferencial

Coloca o **sinal codificado** e o **dado original (NRZ)** em dois pinos do conector **PMOD JA** da Basys 3, para que o sinal elétrico real seja observado em um osciloscópio.

**Por quê?** Os LEDs mostram o sinal devagar e só como "aceso/apagado". No osciloscópio é possível ver a forma de onda, conferir a transição no meio de cada bit e a duração das metades.

## Como foi implementada

A saída PMOD está **integrada ao circuito principal**: o mesmo bitstream atende LEDs, PMOD e VGA, sem regravar nada.

| Sinal | Pino PMOD | Pino FPGA | Onde está no código |
|---|---|---|---|
| `data_out` — sinal codificado | **JA1** | J1 | `src/manchester_diferencial.vhd` (`data_out <= lvl`) |
| `data_raw` — dado original | **JA2** | L2 | `src/manchester_diferencial.vhd` (`data_raw <= bit_r`) |
| Terra | **JA5** ou **JA11** (GND) | — | — |

Os dois sinais saem direto de flip-flops (sem *glitches*). Segurando o **BTNU**, cada bit dura 100 µs (10 kbit/s), taxa na faixa de kHz sugerida pelo enunciado para o osciloscópio.

## Estrutura desta pasta

```
pmod_osciloscopio/
|-- README.md                   Este arquivo
|-- src/README.md               Aponta para ../../src/ (mesmo código do projeto)
|-- constraints/README.md       Aponta para ../../constraints/ (mesmo XDC)
`-- docs/tutorial_pmod/
    |-- tutorial_pmod.md        Passo a passo: conexão, configuração e captura
    `-- *.jpg                   Fotos da bancada e das conexões
```

## Equipamentos necessários

- Basys 3 gravada com o projeto Manchester Diferencial
- Digilent **Analog Discovery 3** com o software **WaveForms** (ou osciloscópio de dois canais)
- Fios jumper fêmea-fêmea para o conector JA

## Como reproduzir

Ver o [tutorial completo](docs/tutorial_pmod/tutorial_pmod.md), que descreve:

1. a conexão física do instrumento aos pinos JA1, JA2 e GND;
2. a gravação do bitstream;
3. a configuração da escala no WaveForms;
4. a captura da forma de onda.
