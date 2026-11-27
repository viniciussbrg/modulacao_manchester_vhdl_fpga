# Saída VGA com cores pulsantes — Manchester (IEEE 802.3)

Usa a saída **VGA** da Basys 3 para mostrar o sinal codificado em um monitor. A **tela inteira** muda de cor conforme o nível do sinal:

| Nível do sinal | Cor da tela |
|---|---|
| 0 (baixo) | **Azul** (`x"00F"`) |
| 1 (alto) | **Verde** (`x"0F0"`) |

**Por quê?** Uma tela que pisca conforme o sinal deixa as **duas metades de cada bit** visíveis de longe, o que ajuda na demonstração e no vídeo. A tela acompanha o LED ativo: LED aceso = verde, LED apagado = azul.

## Como foi implementada

A saída VGA está **integrada ao circuito principal** e funciona ao mesmo tempo que os LEDs e o PMOD:

- `src/vga_sync.vhd` gera a temporização **640x480 a ~59,5 Hz** (`hsync`, `vsync`, `video_on`) com um *clock enable* de 25 MHz derivado dos 100 MHz.
- `src/manchester.vhd` escolhe a cor: dentro da área visível, `COLOR_HIGH` (verde) com o sinal em 1 e `COLOR_LOW` (azul) com o sinal em 0; fora dela, preto, como exige o padrão VGA.
- Para trocar as cores, basta alterar essas duas constantes (formato `x"RGB"`).

| Sinal | Pinos FPGA (bit 3 → bit 0) |
|---|---|
| `vgaRed` | N19, J19, H19, G19 |
| `vgaGreen` | D17, G17, H17, J17 |
| `vgaBlue` | J18, K18, L18, N18 |
| `Hsync` / `Vsync` | P19 / R19 |

## Estrutura desta pasta

```
vga/
|-- README.md               Este arquivo
|-- src/README.md           Aponta para ../../src/ (manchester.vhd e vga_sync.vhd)
|-- constraints/README.md   Aponta para ../../constraints/manchester.xdc
`-- docs/tutorial_vga/
    |-- tutorial_vga.md     Passo a passo: conexão, gravação e observação
    `-- *.jpg               Fotos da montagem e da tela
```

## Equipamentos necessários

- Basys 3 gravada com o projeto Manchester
- Monitor com entrada VGA
- Cabo VGA (DB-15)

## Como reproduzir

Ver o [tutorial completo](docs/tutorial_vga/tutorial_vga.md).
