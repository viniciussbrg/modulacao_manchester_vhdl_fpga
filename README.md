![VHDL](https://img.shields.io/badge/Linguagem-VHDL-1D4ED8?style=flat-square)
![Vivado](https://img.shields.io/badge/Vivado-2025.2-059669?style=flat-square)
![FPGA](https://img.shields.io/badge/FPGA-Basys%203%20(Artix--7)-D97706?style=flat-square)
![Padrao](https://img.shields.io/badge/Padrao-IEEE%20802.3-7C3AED?style=flat-square)
![Grupo](https://img.shields.io/badge/Entrega-Grupo%208-0F172A?style=flat-square)

# Codificação de Linha Manchester e Manchester Diferencial em VHDL (FPGA Basys 3)

> **Trabalho Prático** da disciplina de **Comunicação de Dados - Sistemas Reconfiguráveis**
> Ministrada pelo **Prof. Dr. Vinícius S. Borges** — Semestre **2026/2**

## 👥 Integrantes (Grupo 8)

* **Arthur Benevides** — RA: `082230016`
* **Fernando Montanher** — RA: `082230010`
* **Guilherme Costa** — RA: `081240041`
* **Juan Haddad** — RA: `081240043`
* **Murillo Ando** — RA: `082240042`

---

## 📖 Descrição do Trabalho

Este trabalho desenvolve, simula e implementa em hardware reconfigurável (FPGA), utilizando a linguagem **VHDL** e a suíte **Xilinx/AMD Vivado**, dois codificadores de linha autossincronizantes fundamentais em sistemas de comunicação digital: **Manchester (padrão IEEE 802.3)** e **Manchester Diferencial**.

Diferentemente dos códigos NRZ (*Non-Return-to-Zero*), nos códigos Manchester cada intervalo de símbolo é dividido em duas metades de mesma duração (`CYCLES_PER_BIT / 2`), garantindo sempre uma transição no meio de cada bit transmitido. Essa transição embute o sinal de relógio diretamente no fluxo de dados e elimina a componente DC (nível médio nulo), ao custo do dobro da largura de banda de um sinal NRZ equivalente. A validação abrange simulação comportamental automatizada com `assert`, execução visual nos 16 switches e 16 LEDs da placa **Digilent Basys 3**, captura simultânea em osciloscópio físico via conector **PMOD** (taxa de 1 kbit/s) e exibição visual em monitor **VGA (640×480 @ 60 Hz)** com cores pulsantes.

---

## 📂 Estrutura do Repositório

Cada projeto é **auto-contido**: possui seu próprio código-fonte VHDL, testbench de simulação, arquivo de constraints (`.xdc`), projeto do Vivado pronto para abrir, documentação técnica, tutoriais operacionais e subpastas das saídas PMOD e VGA.

```text
modulacao_manchester_vhdl_fpga/
├── README.md                                      # Visão geral, integrantes, índice e guia inicial
│
├── manchester/                                    # Projeto 1: Codificação Manchester (IEEE 802.3)
│   ├── README.md                                  # Descrição, convenção e índice local do projeto
│   ├── src/
│   │   ├── manchester.vhd                         # Codificador Manchester parametrizável
│   │   ├── manchester_top.vhd                     # Top-level integrando LEDs (1 Hz), PMOD (1 kHz) e VGA
│   │   └── vga_pulse.vhd                          # Controlador VGA 640x480 @ 60Hz com cores pulsantes
│   ├── sim/
│   │   └── manchester_tb.vhd                      # Testbench com verificação automática via assert
│   ├── constraints/
│   │   └── manchester.xdc                         # Mapeamento físico de pinos da placa Basys 3
│   ├── vivado_project/
│   │   └── manchester.xpr                         # Projeto Vivado 2025.2 pronto para abrir + bitstream
│   ├── docs/
│   │   ├── tutorial_simulacao.pdf                 # Passo a passo da simulação comportamental
│   │   ├── tutorial_placa.pdf                     # Passo a passo de síntese, bitstream e gravação
│   │   ├── documentacao_projeto.pdf               # Arquitetura interna, portas, generics e pinagem
│   │   └── midia/                                 # Prints da simulação e diagramas do projeto
│   └── saidas/
│       ├── pmod_osciloscopio/                     # Saída em 1 kHz nos pinos JA1 (J1) e JA2 (L2)
│       │   ├── README.md
│       │   ├── src/
│       │   ├── constraints/
│       │   └── docs/
│       │       ├── tutorial_pmod.pdf
│       │       └── midia/
│       └── vga/                                   # Saída de vídeo 640x480 @ 60Hz com cores pulsantes
│           ├── README.md
│           ├── src/
│           ├── constraints/
│           └── docs/
│               ├── tutorial_vga.pdf
│               └── midia/
│
├── manchester_diferencial/                        # Projeto 2: Codificação Manchester Diferencial
│   ├── README.md                                  # Descrição, regra de transição e índice local
│   ├── src/
│   │   ├── manchester_dif.vhd                     # Codificador Manchester Diferencial (reset baixo)
│   │   ├── manchester_dif_top.vhd                 # Top-level integrando LEDs (1 Hz), PMOD (1 kHz) e VGA
│   │   └── vga_pulse.vhd                          # Controlador VGA 640x480 @ 60Hz
│   ├── sim/
│   │   └── manchester_dif_tb.vhd                  # Testbench validando estado inicial e regras 0/1
│   ├── constraints/
│   │   └── manchester_dif.xdc                     # Mapeamento físico de pinos da placa Basys 3
│   ├── vivado_project/
│   │   └── manchester_diferencial.xpr             # Projeto Vivado 2025.2 pronto para abrir
│   ├── docs/
│   │   ├── tutorial_simulacao.pdf                 # Passo a passo da simulação comportamental
│   │   ├── tutorial_placa.pdf                     # Passo a passo de síntese, bitstream e gravação
│   │   ├── documentacao_projeto.pdf               # Arquitetura interna, portas, generics e pinagem
│   │   └── midia/                                 # Prints da simulação e diagramas do projeto
│   └── saidas/
│       ├── pmod_osciloscopio/                     # Saída PMOD para osciloscópio (JA1 e JA2)
│       └── vga/                                   # Saída VGA com cores pulsantes
│
└── relatorio_final/                               # Consolidação teórica, experimental e comparativa
    └── relatorio.pdf                              # Relatório técnico final do Grupo 8
```

---

## 🧭 Índice de Navegação

### Projetos
* [**Projeto 1 — Codificação Manchester (IEEE 802.3)**](./manchester/) — Bit representado pelo sentido da transição no meio do intervalo de bit (`0` = descida alto $ightarrow$ baixo; `1` = subida baixo $ightarrow$ alto).
* [**Projeto 2 — Codificação Manchester Diferencial**](./manchester_diferencial/) — Transição garantida no meio do bit para sincronismo; valor do bit representado pela presença (`0` = inverte) ou ausência (`1` = mantém) de transição no início do intervalo, com nível pós-reset **baixo**.

### Documentos de Referência Rápida
| Projeto / Escopo | Documentação Técnica | Tutorial de Simulação | Tutorial de Placa | Tutorial PMOD | Tutorial VGA |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Manchester (IEEE 802.3)** | [📄 PDF](./manchester/docs/documentacao_projeto.pdf) | [📄 PDF](./manchester/docs/tutorial_simulacao.pdf) | [📄 PDF](./manchester/docs/tutorial_placa.pdf) | [📄 PDF](./manchester/saidas/pmod_osciloscopio/docs/tutorial_pmod.pdf) | [📄 PDF](./manchester/saidas/vga/docs/tutorial_vga.pdf) |
| **Manchester Diferencial** | [📄 PDF](./manchester_diferencial/docs/documentacao_projeto.pdf) | [📄 PDF](./manchester_diferencial/docs/tutorial_simulacao.pdf) | [📄 PDF](./manchester_diferencial/docs/tutorial_placa.pdf) | [📄 PDF](./manchester_diferencial/saidas/pmod_osciloscopio/docs/tutorial_pmod.pdf) | [📄 PDF](./manchester_diferencial/saidas/vga/docs/tutorial_vga.pdf) |

### Relatório Técnico Consolidado
* [**Relatório Técnico Final (`relatorio.pdf`)**](./relatorio_final/relatorio.pdf) — Fundamentação teórica, metodologia, decisões de projeto, resultados de simulação/placa/PMOD/VGA e análise comparativa (Manchester $	imes$ Manchester Diferencial $	imes$ NRZ).

---

## 🛠️ Ferramentas Utilizadas

* **AMD/Xilinx Vivado Design Suite 2025.2** (compatível com versões 2023.1+)
* **Linguagem de Descrição de Hardware:** VHDL (padrão IEEE 1076 / `IEEE.STD_LOGIC_1164` e `IEEE.NUMERIC_STD`)
* **Simulador:** Vivado Simulator (`xsim`)
* **Placa FPGA:** Digilent **Basys 3** (FPGA Xilinx Artix-7 `xc7a35tcpg236-1`, clock interno de 100 MHz)
* **Instrumentação e Periféricos:** Osciloscópio digital de 2 canais (conectado ao PMOD `JA1`/`JA2`) e Monitor VGA (resolução 640×480 @ 60 Hz).

---

## 🚀 Como Começar

Recomendamos iniciar pelo projeto **Manchester (IEEE 802.3)**:

1. Acesse a pasta [`manchester/`](./manchester/) e leia o [README local](./manchester/README.md).
2. Siga o [Tutorial de Simulação](./manchester/docs/tutorial_simulacao.pdf) para visualizar as formas de onda no Vivado Simulator.
3. Siga o [Tutorial de Gravação na Placa](./manchester/docs/tutorial_placa.pdf) para testar nos switches `SW15..SW0` e LEDs `LD15..LD0` da Basys 3.
4. Em seguida, avance para o projeto [`manchester_diferencial/`](./manchester_diferencial/) e finalize com a leitura do [Relatório Técnico Final](./relatorio_final/relatorio.pdf).
