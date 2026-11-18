# Saída VGA — Manchester básico

O [top de vídeo](src/top_manchester_vga.vhd) instancia o [codificador](src/manchester.vhd). Durante a área visível, o nível baixo seleciona verde (RGB hexadecimal 0C0) e o alto seleciona branco (FFF). Durante o apagamento, as três componentes ficam em zero.

O circuito conta 2.200 períodos de pixel por linha e 1.125 linhas por quadro. Com o `clk_wiz_0` configurado para 148,5 MHz, a área ativa é de 1920 × 1080 pixels a 60 Hz. O [XDC](constraints/constraints.xdc) contém os sinais RGB de quatro bits por cor e os sincronismos horizontal e vertical.

## Observação prevista

1. Conecte a Basys 3 a um monitor compatível por cabo VGA e selecione a entrada VGA do monitor.
2. Utilize o [projeto Vivado](../../vivado_project/projeto/manchester/manchester.xpr) e o [bitstream deste codificador](../../vivado_project/bitstream/top_manchester_vga.bit).
3. Configure SW15 a SW0 e pressione BTNC. Com reset atendido, o nível codificado fica baixo. Ao soltar BTNC, acompanhe a mudança de cor em cada metade de bit e compare com o LED da posição atual.

O [tutorial VGA](docs/tutorial_vga.pdf) reúne a montagem, a sequência de teste e as [fotografias da bancada](docs/midia/). Na subida do sinal codificado, o monitor passa a branco. Na descida, passa a verde. As fotos registram as cores observadas. A demonstração contínua, identificada por projeto, permanece pendente.
