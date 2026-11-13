# Projeto 1 — Codificação Manchester (IEEE 802.3)

Implementação em VHDL do codificador de linha **Manchester** segundo a convenção do padrão **IEEE 802.3 (Ethernet)**, com simulação comportamental no Vivado Simulator e implementação física na placa FPGA **Digilent Basys 3** (LEDs, conector PMOD para osciloscópio e saída VGA com cores pulsantes).

## 📐 Explicação Teórica e Convenção Adotada

Na codificação Manchester, cada intervalo de bit (`CYCLES_PER_BIT`) é dividido em duas metades iguais (`HALF = CYCLES_PER_BIT / 2`) e **sempre ocorre uma transição no meio do bit**, tornando o sinal autossincronizante e livre de componente DC. Neste trabalho adota-se a convenção **IEEE 802.3**:

| Bit de Entrada | 1ª Metade do Bit | 2ª Metade do Bit | Sentido da Transição no Meio do Bit | Expressão Lógica (`enc`) |
| :---: | :---: | :---: | :---: | :---: |
| **`0`** | Nível Alto (`'1'`) | Nível Baixo (`'0'`) | **Descida** (Alto $ightarrow$ Baixo) | 1ª metade: `not bit` / 2ª metade: `bit` |
| **`1`** | Nível Baixo (`'0'`) | Nível Alto (`'1'`) | **Subida** (Baixo $ightarrow$ Alto) | 1ª metade: `not bit` / 2ª metade: `bit` |

---

## 📂 Estrutura desta Pasta

```text
manchester/
├── README.md                                  # Este arquivo (guia local do projeto Manchester)
├── src/
│   ├── manchester.vhd                         # Circuito principal do codificador Manchester
│   ├── manchester_top.vhd                     # Top-level para a placa (LEDs 1 Hz, PMOD 1 kHz e VGA)
│   └── vga_pulse.vhd                          # Controlador VGA 640x480 @ 60Hz com cores pulsantes
├── sim/
│   └── manchester_tb.vhd                      # Testbench com verificação automática via assert
├── constraints/
│   └── manchester.xdc                         # Mapeamento dos pinos da Basys 3 (Switches, LEDs, PMOD, VGA)
├── vivado_project/
│   ├── manchester.xpr                         # Projeto Vivado 2025.2 pronto para abrir
│   └── manchester_top.bit                     # Bitstream sintetizado pronto para gravação na Basys 3
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

* **`src/manchester.vhd`** — Módulo principal do codificador Manchester (IEEE 802.3). Recebe o vetor `data_in(15 downto 0)` dos switches, sincroniza o botão de reset `rst` por dois flip-flops em série, varre ciclicamente de `SW15` até `SW0` (1 segundo por bit por padrão, `CYCLES_PER_BIT = 100_000_000`) e registra as saídas `data_out` (sinal codificado), `data_raw` (bit NRZ atual) e `led(15 downto 0)` (acende apenas o LED acima do switch em transmissão).
* **`src/manchester_top.vhd`** — Entidade de topo para síntese na placa Basys 3. Instancia duas cópias do codificador: `u_slow` (`CPB_LED = 100_000_000`, 1 s/bit para visualização humana nos LEDs e no monitor VGA) e `u_fast` (`CPB_SCOPE = 100_000`, 1 kbit/s para visualização estável no osciloscópio via PMOD), além do controlador `u_vga`.
* **`src/vga_pulse.vhd`** — Controlador de vídeo VGA padrão 640×480 @ 60 Hz (pixel clock de 25 MHz derivado de 100 MHz) que preenche a tela inteira com **Azul** quando o sinal codificado está em nível baixo (`'0'`) e **Amarelo/Claro** quando está em nível alto (`'1'`).
* **`sim/manchester_tb.vhd`** — Testbench auto-verificável que instancia `manchester` com `CYCLES_PER_BIT = 10` (`BIT_PERIOD = 100 ns`), testa o quadro `DATA_A = 0xB2A5`, realiza troca dinâmica de chaves no meio do último bit para `DATA_B = 0x5A3C`, aciona o `rst` assíncrono durante a transmissão e valida todas as metades de bit com instruções `assert`.
* **`constraints/manchester.xdc`** — Arquivo Xilinx Design Constraints mapeando o clock de 100 MHz (`W5`), botão `BTNC` (`U18`), switches `SW15..SW0`, LEDs `LD15..LD0`, PMOD `JA1` (`J1`) / `JA2` (`L2`) e conector VGA.

---

## 📚 Documentação e Tutoriais (`docs/`)

* [📘 **Documentação Técnica (`documentacao_projeto.pdf`)**](./docs/documentacao_projeto.pdf) — Diagrama de blocos, tabela de portas e generics, funcionamento interno ciclo a ciclo e pinagem completa.
* [🧪 **Tutorial de Simulação (`tutorial_simulacao.pdf`)**](./docs/tutorial_simulacao.pdf) — Como abrir o projeto no Vivado, executar a simulação comportamental e interpretar o waveform.
* [🔌 **Tutorial de Gravação na Placa (`tutorial_placa.pdf`)**](./docs/tutorial_placa.pdf) — Como sintetizar, gerar o bitstream, gravar na Basys 3 e conferir os bits nos LEDs.

---

## 🚀 Por Onde Começar

### Para uma simulação rápida (2 minutos):
1. Abra o **Vivado** e carregue o projeto em `vivado_project/manchester.xpr`.
2. No painel *Flow Navigator*, clique em **Run Simulation** $ightarrow$ **Run Behavioral Simulation**.

### Para reproduzir o projeto do zero:
1. **Entenda o circuito** lendo a [Documentação Técnica](./docs/documentacao_projeto.pdf).
2. **Simule no Vivado** seguindo o [Tutorial de Simulação](./docs/tutorial_simulacao.pdf).
3. **Grave na placa Basys 3** seguindo o [Tutorial de Placa](./docs/tutorial_placa.pdf).
4. **Explore as saídas adicionais** acessando as pastas de [Saída PMOD](./saidas/pmod_osciloscopio/) e [Saída VGA](./saidas/vga/).

---

## 📡 Saídas PMOD e VGA

* [**Saída pelo PMOD para Osciloscópio**](./saidas/pmod_osciloscopio/) — Disponibiliza `data_out` no pino `JA1` (`J1`) e `data_raw` no pino `JA2` (`L2`) a 1 kbit/s (`CYCLES_PER_BIT = 100_000`) para captura simultânea em dois canais do osciloscópio.
* [**Saída VGA com Cores Pulsantes**](./saidas/vga/) — Apresenta o nível lógico instantâneo do código Manchester em tela cheia (640×480 @ 60 Hz) num monitor externo.

---

## ➡️ Próximo Passo

Após concluir este projeto, siga para o [**Projeto 2 — Codificação Manchester Diferencial**](../manchester_diferencial/), que implementa a codificação diferencial baseada na presença ou ausência de transição no início do intervalo de bit.
