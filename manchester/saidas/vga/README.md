# Saída VGA com Cores Pulsantes — Manchester (IEEE 802.3)

Utiliza o conector **VGA (DB15)** da placa Basys 3 para apresentar visualmente o sinal codificado em Manchester em um monitor externo (resolução **640×480 @ 60 Hz**), alternando a cor de tela cheia conforme o nível lógico instantâneo do sinal codificado.

## 🎯 O que esta saída implementa e por quê

O módulo `vga_pulse.vhd` gera os sinais de sincronismo horizontal (`vga_hs`) e vertical (`vga_vs`) do padrão industrial VGA 640×480 @ 60 Hz a partir de um *pixel clock* de **25 MHz** (obtido dividindo o clock de 100 MHz da Basys 3 por 4). Durante a região ativa de vídeo ($640 	imes 480$ pixels), os barramentos de cor de 4 bits (`vga_r`, `vga_g`, `vga_b`) são acionados em função do nível atual do sinal codificado lento (`sig_slow`, com $1	ext{ s/bit}$):

* **Sinal em Nível Baixo (`'0'`):** Tela inteira em **Azul** (`vga_r = "0000"`, `vga_g = "0000"`, `vga_b = "1111"`);
* **Sinal em Nível Alto (`'1'`):** Tela inteira em **Amarelo/Claro** (`vga_r = "1111"`, `vga_g = "1111"`, `vga_b = "0000"`).

Dessa forma, a tela pisca exatamente em sincronia com o LED ativo da placa: na codificação **Manchester (IEEE 802.3)**, um bit `'1'` exibe **0,5 s de tela Azul seguido de 0,5 s de tela Amarela/Clara**, enquanto um bit `'0'` exibe **0,5 s de tela Amarela/Clara seguido de 0,5 s de tela Azul**.

## 📂 Estrutura desta Pasta

```text
vga/
├── README.md                        # Este arquivo
├── src/
│   ├── manchester.vhd               # Codificador Manchester
│   ├── vga_pulse.vhd                # Controlador VGA 640x480 @ 60Hz
│   └── manchester_top.vhd           # Top-level integrando codificador e controlador VGA
├── constraints/
│   └── manchester.xdc               # Constraint com mapeamento RGB (12 bits) e HSYNC/VSYNC
└── docs/
    ├── tutorial_vga.pdf             # Tutorial passo a passo da saída VGA
    └── midia/
        └── vga_cores_pulsantes.png
```

## 🧰 Equipamentos Necessários

* Placa FPGA **Digilent Basys 3**;
* **Monitor com entrada VGA** (compatível com 640×480 @ 60 Hz);
* **Cabo VGA** (DB15 macho-macho).

## 🚀 Como Reproduzir

Consulte o [**Tutorial Completo da Saída VGA (`tutorial_vga.pdf`)**](./docs/tutorial_vga.pdf), que descreve:
1. Conexão do cabo VGA entre a placa Basys 3 e o monitor externo;
2. Gravação do bitstream e seleção da sequência de bits nos switches `SW15..SW0`;
3. Observação das duas metades de cada bit pelas cores pulsantes na tela em sincronia com os LEDs `LD15..LD0`.
