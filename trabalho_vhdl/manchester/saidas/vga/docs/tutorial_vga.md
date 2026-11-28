# VGA — Manchester IEEE 802.3

1. Execute `scripts/modo_leds_vga.tcl`, gere novo bitstream e programe a Basys 3.
2. Conecte monitor à saída VGA e selecione essa entrada no monitor.
3. O projeto gera pixels de 25 MHz usando habilitação a cada quatro clocks de 100 MHz, sem IP de clock.
4. Com BTNC pressionado, a tela ativa deve ficar azul; ao soltar, a cor acompanha o sinal: azul=0, verde=1.
5. Confira no LED da posição atual as duas metades de 0,5 s, junto com as cores da tela. Bit 0: alto na primeira metade e baixo na segunda. Bit 1: baixo na primeira metade e alto na segunda.
6. Fotografe as duas cores e filme a alternância. Não use o modo de 1 kbit/s para avaliar cores a olho.

## Se o monitor não sincronizar

Confira cabo, entrada selecionada, modelo da placa, bitstream carregado e nomes/pinos do XDC. O modo é 640×480 a aproximadamente 59,52 Hz (25 MHz / 800 / 525), comum em projetos FPGA, mas a compatibilidade do monitor precisa ser verificada fisicamente.

## Temporização implementada

| Eixo | Área ativa | Front porch | Pulso sync | Back porch | Total |
|---|---:|---:|---:|---:|---:|
| Horizontal, pixels | 640 | 16 | 96 | 48 | 800 |
| Vertical, linhas | 480 | 10 | 2 | 33 | 525 |

Hsync e Vsync são ativos em nível baixo. RGB é zerado fora da área ativa.
O teste `sim/vga_tb.vhd` confere todos os pixels de dois quadros e o retorno ao início.
A cor acompanha o sinal no próximo pixel habilitado; como um monitor desenha a imagem por varredura, uma mudança durante o quadro pode produzir uma divisão momentânea de cores. Não se armazena a cor por quadro, para preservar a relação temporal com o sinal.



## Registro experimental

Conecte o VGA da Basys 3 ao monitor e mantenha o modo lento. A imagem ativa fica azul quando encoded=0 e verde quando encoded=1; o blanking permanece preto. Pressione BTNC e observe azul na região ativa enquanto o codificador está em reset. O controlador de vídeo mantém os sincronismos durante esse período.

![Tela em um dos níveis da transmissão](midia/manchester_vga_1.jpg)

![Outro quadro do mesmo registro físico](midia/manchester_vga_2.jpg)

O vídeo original manchester_vga.mp4 registra a demonstração e está na mesma pasta de mídia. As cores variam ao longo do vídeo. Quadros extraídos isoladamente não determinam a duração de cada bit.

## Resultado esperado

No modo padrão, cada metade dura 0,5 s. Para 0, verde antecede azul; para 1, azul antecede verde. O modo de aquisição rápida do PMOD exige retornar ao script modo_leds_vga.tcl e gerar novo bitstream para observar cores lentamente.
