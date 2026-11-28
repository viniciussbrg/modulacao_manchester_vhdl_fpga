# Saída VGA com cores pulsantes - Manchester Diferencial

Exibe o nível do sinal codificado em um monitor, por meio da saída VGA da
Basys 3. A área visível da tela (640 x 480) assume uma cor conforme o nível
lógico do sinal codificado: **verde** para nível alto e **azul** para nível
baixo; fora da área visível a saída permanece preta. Como o código tem
transição a cada meio bit, a tela alterna de cor ("pulsa") acompanhando o
sinal codificado, o que permite visualizar a codificação sem osciloscópio.

O sinal VGA usa temporização de 640 x 480 a 60 Hz (800 x 525 pixels totais),
com clock de pixel de 25 MHz obtido pela divisão por 4 do clock de 100 MHz.

## Estrutura desta pasta

```
vga/
`-- docs/
    |-- tutorial_vga_manchester_diferencial.pdf   Tutorial da saída VGA
    `-- midia/
        `-- Manchester Diferencial.mp4Vídeo da tela
```

A geração do sinal VGA não tem código separado: está no circuito principal do
projeto, em
[`manchester_diferencial.srcs/sources_1/new/Manchester_Diferencial.vhd`](../../manchester_diferencial.srcs/sources_1/new/Manchester_Diferencial.vhd)
(portas `vga_r`, `vga_g`, `vga_b`, `vga_hs` e `vga_vs`), e o mapeamento dos
pinos está em
[`manchester_diferencial.srcs/constrs_1/new/basys3_Manchester_Diferencial.xdc`](../../manchester_diferencial.srcs/constrs_1/new/basys3_Manchester_Diferencial.xdc).

## Equipamentos necessários

- Placa FPGA Basys 3 e cabo micro-USB
- Monitor com entrada VGA (ou conversor VGA para HDMI)
- Cabo VGA ligado ao conector VGA da placa

## Como reproduzir

Ver o [tutorial completo](./docs/tutorial_vga_manchester_diferencial.pdf), que descreve:

1. Conexão do monitor ao conector VGA da Basys 3
2. Gravação do bitstream
3. Escolha da palavra de 16 bits nos switches e reset pelo botão central
4. Registro da tela (foto ou vídeo)

Com o generic `CYCLES_PER_BIT` padrão (100.000.000, ou seja, 1 s por bit), a
cor muda a cada meio segundo, ritmo adequado para acompanhar a olho nu.

[Vídeo da tela em funcionamento](./docs/midia/Manchester%20Diferencial.mp4)
