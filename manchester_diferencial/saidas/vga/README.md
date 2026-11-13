# Saída VGA com Cores Pulsantes — Manchester Diferencial

Utiliza a saída **VGA (640×480 @ 60 Hz)** da placa Basys 3 para exibir visualmente o sinal codificado em **Manchester Diferencial** em tela cheia, alternando a cor do monitor conforme o estado do flip-flop `enc`.

## 🎯 O que esta saída implementa e por quê

O controlador `vga_pulse.vhd` recebe o sinal lento `sig_slow` (`CPB_LED = 100_000_000`, $1	ext{ s/bit}$) gerado pela instância `u_slow` do `manchester_dif` e colore toda a região visível de $640 	imes 480$ pixels:

* **Nível Baixo (`'0'`):** Tela inteira em **Azul** (`RGB = 0000_0000_1111`);
* **Nível Alto (`'1'`):** Tela inteira em **Amarelo/Claro** (`RGB = 1111_1111_0000`).

No **Manchester Diferencial**, observa-se no monitor VGA que:
1. Enquanto `BTNC` está pressionado (reset), a tela permanece fixa em **Azul** (nível inicial baixo `'0'`);
2. No meio de todo bit (a cada $0,5	ext{ s}$ dentro do bit), a cor da tela **sempre se inverte**;
3. Na passagem de um bit para o seguinte, a tela **muda de cor** imediatamente se o novo switch estiver em `'0'`, ou **permanece na mesma cor** em que o bit anterior terminou se o novo switch estiver em `'1'`.

## 📂 Estrutura desta Pasta

```text
vga/
├── README.md                        # Este arquivo
├── src/
│   ├── manchester_dif.vhd           # Codificador Manchester Diferencial
│   ├── vga_pulse.vhd                # Controlador VGA 640x480 @ 60Hz
│   └── manchester_dif_top.vhd       # Top-level integrando codificador e controlador VGA
├── constraints/
│   └── manchester_dif.xdc           # Constraint com mapeamento RGB (12 bits) e HSYNC/VSYNC
└── docs/
    ├── tutorial_vga.pdf             # Tutorial passo a passo da saída VGA
    └── midia/
        └── vga_cores_pulsantes.png
```

## 🧰 Equipamentos Necessários

* Placa FPGA **Digilent Basys 3**;
* **Monitor com entrada VGA** (640×480 @ 60 Hz);
* **Cabo VGA** (DB15).

## 🚀 Como Reproduzir

Consulte o [**Tutorial Completo da Saída VGA (`tutorial_vga.pdf`)**](./docs/tutorial_vga.pdf), que orienta a conexão física, a gravação do bitstream e a verificação visual das regras de transição para sequências de todos `'0'`, todos `'1'` e bits alternados.
