# Projeto 2 — Codificação Manchester Diferencial

Implementação em VHDL do codificador de linha **Manchester Diferencial**, com simulação comportamental no Vivado Simulator e implementação física na placa FPGA **Digilent Basys 3** (LEDs, conector PMOD para osciloscópio e saída VGA com cores pulsantes).

## 📐 Explicação Teórica e Convenção Adotada

Na codificação **Manchester Diferencial**, **sempre ocorre uma transição no meio do intervalo de bit** (utilizada exclusivamente para sincronismo de relógio), e o valor lógico do bit é representado pela **presença ou ausência de transição no início do intervalo de bit**:

| Bit de Entrada | Início do Intervalo de Bit | Meio do Intervalo de Bit | Expressão no Início do Bit (`enc`) |
| :---: | :---: | :---: | :---: |
| **`0`** | **Ocorre inversão** do nível anterior | **Ocorre inversão** do nível (`not enc`) | `enc <= not enc` |
| **`1`** | **Mantém** o nível anterior | **Ocorre inversão** do nível (`not enc`) | `enc <= enc` |

Como a codificação depende do nível anterior, o circuito armazena o estado atual da saída no flip-flop `enc`. Conforme especificado no enunciado, **o nível da saída imediatamente após o reset (`BTNC = '1'`) é baixo (`'0'`)**. Uma vantagem fundamental do Manchester Diferencial é sua **imunidade à inversão de polaridade** dos fios do canal de transmissão.

---

## 📂 Estrutura desta Pasta

```text
manchester_diferencial/
├── README.md                                  # Este arquivo (guia local do projeto Manchester Diferencial)
├── src/
│   ├── manchester_dif.vhd                     # Circuito principal do codificador Manchester Diferencial
│   ├── manchester_dif_top.vhd                 # Top-level para a placa (LEDs 1 Hz, PMOD 1 kHz e VGA)
│   └── vga_pulse.vhd                          # Controlador VGA 640x480 @ 60Hz com cores pulsantes
├── sim/
│   └── manchester_dif_tb.vhd                  # Testbench com verificação automática via assert
├── constraints/
│   └── manchester_dif.xdc                     # Mapeamento dos pinos da Basys 3 (Switches, LEDs, PMOD, VGA)
├── vivado_project/
│   └── manchester_diferencial.xpr             # Projeto Vivado 2025.2 pronto para abrir
├── docs/
│   ├── tutorial_simulacao.pdf                 # Passo a passo da simulação no Vivado
│   ├── tutorial_placa.pdf                     # Passo a passo de síntese, implementação e gravação
│   ├── documentacao_projeto.pdf               # Documentação técnica completa do circuito
│   └── midia/                                 # Prints da simulação e diagramas técnicos
└── saidas/
    ├── pmod_osciloscopio/                     # Saída em 1 kHz nos pinos PMOD JA1 (J1) e JA2 (L2)
    └── vga/                                   # Saída VGA 640x480 @ 60Hz com cores pulsantes
```

---

## 💻 Arquivos de Código

* **`src/manchester_dif.vhd`** — Módulo principal do codificador Manchester Diferencial. Mantém o registrador de estado `enc` inicializado em `'0'` durante o reset síncrono (`rst_s = '1'`). No início de cada novo bit (`cnt = CYCLES_PER_BIT - 1`), atualiza `enc <= enc xor (not data_in(nxt_idx))` (invertendo se o bit for `'0'` e mantendo se for `'1'`); na metade do bit (`cnt = HALF - 1`), executa `enc <= not enc`.
* **`src/manchester_dif_top.vhd`** — Entidade de topo para síntese na Basys 3, instanciando `u_slow` (`CPB_LED = 100_000_000`, 1 s/bit para LEDs e VGA), `u_fast` (`CPB_SCOPE = 100_000`, 1 kbit/s para PMOD) e `u_vga` (`vga_pulse`).
* **`src/vga_pulse.vhd`** — Controlador VGA 640×480 @ 60 Hz com cores de tela cheia pulsantes (**Azul** para nível `'0'` e **Amarelo/Claro** para nível `'1'`).
* **`sim/manchester_dif_tb.vhd`** — Testbench auto-verificável (`CYCLES_PER_BIT = 10`, `BIT_PERIOD = 100 ns`) que rastreia o estado anterior em uma variável `prev` (inicializada em `'0'`), exercita sequências com bits `0` e `1` consecutivos e alternados (`DATA_A = 0xB2A5` e `DATA_B = 0x5A3C`), testa a troca dinâmica de switches e o retorno ao nível `'0'` durante o reset.
* **`constraints/manchester_dif.xdc`** — Mapeamento físico de pinos da Basys 3 para Clock (`W5`), Reset (`U18`), Switches (`SW15..SW0`), LEDs (`LD15..LD0`), PMOD (`J1`/`L2`) e VGA.

---

## 📚 Documentação e Tutoriais (`docs/`)

* [📘 **Documentação Técnica (`documentacao_projeto.pdf`)**](./docs/documentacao_projeto.pdf) — Diagrama de blocos com realimentação de estado, tabela de portas, funcionamento interno e pinagem.
* [🧪 **Tutorial de Simulação (`tutorial_simulacao.pdf`)**](./docs/tutorial_simulacao.pdf) — Passo a passo para simular `manchester_dif_tb` no Vivado e conferir a regra diferencial.
* [🔌 **Tutorial de Gravação na Placa (`tutorial_placa.pdf`)**](./docs/tutorial_placa.pdf) — Síntese, geração de bitstream, programação da Basys 3 e conferência prática nos LEDs.

---

## 🚀 Por Onde Começar

### Para uma simulação rápida (2 minutos):
1. Abra o **Vivado** e carregue `vivado_project/manchester_diferencial.xpr`.
2. Clique em **Run Simulation** $ightarrow$ **Run Behavioral Simulation**.

### Para reproduzir o projeto do zero:
1. **Entenda o circuito** lendo a [Documentação Técnica](./docs/documentacao_projeto.pdf).
2. **Compare com o Manchester clássico** ([projeto anterior](../manchester/)) observando a memória de 1 bit no registrador `enc`.
3. **Simule no Vivado** seguindo o [Tutorial de Simulação](./docs/tutorial_simulacao.pdf).
4. **Grave na placa Basys 3** seguindo o [Tutorial de Gravação](./docs/tutorial_placa.pdf).
5. **Implemente as atividades de visualização** em [Saída PMOD](./saidas/pmod_osciloscopio/) e [Saída VGA](./saidas/vga/).

---

## 📡 Saídas PMOD e VGA

* [**Saída pelo PMOD para Osciloscópio**](./saidas/pmod_osciloscopio/) — Exibe `data_out` (`JA1`/`J1`) e `data_raw` (`JA2`/`L2`) em 1 kbit/s no osciloscópio.
* [**Saída VGA com Cores Pulsantes**](./saidas/vga/) — Exibe as transições de início e meio de bit do Manchester Diferencial em tela cheia num monitor VGA.

---

## ➡️ Próximo Passo

Você concluiu os dois projetos do trabalho! Agora acesse o [**Relatório Técnico Final (`relatorio.pdf`)**](../relatorio_final/relatorio.pdf) para ver a fundamentação teórica, a análise comparativa entre **Manchester (IEEE 802.3)**, **Manchester Diferencial** e **NRZ**, os resultados consolidados e as conclusões do **Grupo 8**.
