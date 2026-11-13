# Saída pelo PMOD para Osciloscópio — Manchester (IEEE 802.3)

Disponibiliza simultaneamente o **sinal codificado em Manchester (`data_out`)** e o **dado NRZ original (`data_raw`)** em dois pinos do conector **PMOD JA** da placa Basys 3, permitindo visualizar e comparar as duas formas de onda em tempo real em um osciloscópio físico de dois canais.

## 🎯 O que esta saída implementa e por quê

Nos LEDs da placa, utiliza-se `CYCLES_PER_BIT = 100_000_000` ($T_b = 1	ext{ s}$, frequência de $1	ext{ Hz}$) para que o olho humano consiga acompanhar a troca de metades de bit. Entretanto, em um osciloscópio, sinais de $1	ext{ Hz}$ exigem varredura lenta (modo *Roll*). Por isso, o módulo de topo `manchester_top.vhd` instancia um segundo codificador (`u_fast`) parametrizado com `CPB_SCOPE = 100_000`, gerando uma taxa de bits de **$1	ext{ kbit/s}$** ($T_b = 1	ext{ ms}$, meia duração de bit de $500	ext{ }\mu	ext{s}$), ideal para disparo (*trigger*) estável na tela do osciloscópio.

Além disso, tanto `data_out` quanto `data_raw` saem diretamente de flip-flops internos (`enc` e `cur_bit`), eliminando *glitches* combinacionais na captura do osciloscópio.

## 📂 Estrutura desta Pasta

```text
pmod_osciloscopio/
├── README.md                        # Este arquivo
├── src/
│   ├── manchester.vhd               # Codificador Manchester parametrizável
│   └── manchester_top.vhd           # Top-level com instância u_fast (CPB_SCOPE = 100_000)
├── constraints/
│   └── manchester.xdc               # Constraint mapeando JA1 (J1) e JA2 (L2)
└── docs/
    ├── tutorial_pmod.pdf            # Tutorial passo a passo de conexão e captura no osciloscópio
    └── midia/
        └── osciloscopio_manchester.png
```

## 🧰 Equipamentos Necessários

* Placa FPGA **Digilent Basys 3** programada;
* **Osciloscópio digital de 2 canais**;
* 2 pontas de prova (com garras de aterramento) e fios *jumper* macho-fêmea para fácil acesso ao conector **PMOD JA**.

## 🔌 Conexões Físicas no Conector PMOD JA

| Canal do Osciloscópio | Pino no PMOD JA | Pino da FPGA (Artix-7) | Sinal no VHDL | Função |
| :---: | :---: | :---: | :---: | :--- |
| **Canal 1 (CH1)** | **JA1** (pino 1) | `J1` (`LVCMOS33`) | `data_out` | Sinal codificado em Manchester (IEEE 802.3) |
| **Canal 2 (CH2)** | **JA2** (pino 2) | `L2` (`LVCMOS33`) | `data_raw` | Bit NRZ original em transmissão (`cur_bit`) |
| **Garras GND** | **GND** (pino 5 ou 11) | `GND` | Referência 0 V | Terra comum entre a Basys 3 e o osciloscópio |

## 🚀 Como Reproduzir

Consulte o [**Tutorial Completo da Saída PMOD (`tutorial_pmod.pdf`)**](./docs/tutorial_pmod.pdf), que detalha:
1. Conexão física das pontas de prova nos pinos `JA1` (`J1`), `JA2` (`L2`) e `GND`;
2. Gravação do bitstream na Basys 3 e configuração da palavra de teste nos switches (ex.: `0xB2A5`);
3. Ajuste da escala vertical (`2 V/div`), base de tempo horizontal (`1,0 ms/div`) e *trigger* no osciloscópio;
4. Conferência das transições de descida (`0`) e subida (`1`) no meio de cada bit.
