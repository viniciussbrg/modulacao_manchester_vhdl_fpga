# Saída pelo PMOD para Osciloscópio — Manchester Diferencial

Disponibiliza simultaneamente o **sinal codificado em Manchester Diferencial (`data_out`)** e o **dado NRZ original (`data_raw`)** nos pinos `JA1` e `JA2` do conector **PMOD JA** da placa Basys 3, permitindo capturar e analisar em um osciloscópio físico a presença ou ausência de transição na fronteira de cada bit.

## 🎯 O que esta saída implementa e por quê

No módulo de topo `manchester_dif_top.vhd`, a instância rápida `u_fast` opera com `CPB_SCOPE = 100_000` (taxa de **$1	ext{ kbit/s}$**, período de bit $T_b = 1	ext{ ms}$), adequada para visualização estacionária no osciloscópio. Ambos os sinais (`data_out` e `data_raw`) são registrados por flip-flops síncronos ao clock de 100 MHz, evitando *glitches* nas bordas de transição.

No osciloscópio, é possível verificar diretamente a regra diferencial comparando o Canal 1 (`data_out`) com o Canal 2 (`data_raw`):
* Quando `data_raw = '0'`, o Canal 1 **inverte** seu nível no início do bit e inverte novamente no meio do bit ($0,5	ext{ ms}$);
* Quando `data_raw = '1'`, o Canal 1 **mantém** o nível final do bit anterior no início do bit e inverte apenas no meio do bit ($0,5	ext{ ms}$).

## 📂 Estrutura desta Pasta

```text
pmod_osciloscopio/
├── README.md                        # Este arquivo
├── src/
│   ├── manchester_dif.vhd           # Codificador Manchester Diferencial
│   └── manchester_dif_top.vhd       # Top-level com instância u_fast (CPB_SCOPE = 100_000)
├── constraints/
│   └── manchester_dif.xdc           # Constraint mapeando JA1 (J1) e JA2 (L2)
└── docs/
    ├── tutorial_pmod.pdf            # Tutorial passo a passo de conexão e captura no osciloscópio
    └── midia/
        └── osciloscopio_manchester_dif.png
```

## 🧰 Equipamentos Necessários

* Placa FPGA **Digilent Basys 3** programada;
* **Osciloscópio digital de 2 canais**;
* 2 pontas de prova e cabos *jumper* para os pinos `JA1` (`J1`), `JA2` (`L2`) e `GND`.

## 🚀 Como Reproduzir

Consulte o [**Tutorial Completo da Saída PMOD (`tutorial_pmod.pdf`)**](./docs/tutorial_pmod.pdf), que descreve:
1. Conexão física do osciloscópio aos pinos `JA1` (`J1`) e `JA2` (`L2`) do PMOD JA;
2. Gravação do bitstream na Basys 3;
3. Configuração de escala (`2 V/div`, `1,0 ms/div`) e captura da forma de onda diferencial.
