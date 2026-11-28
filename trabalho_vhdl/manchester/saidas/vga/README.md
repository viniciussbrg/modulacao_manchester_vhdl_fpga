# VGA — Manchester IEEE 802.3

O módulo `src/vga_colors.vhd` desta pasta está integrado ao top e incluído pelo script de criação.
Usa 640×480 pixels, com totais 800×525, pixel de 40 ns e atualização aproximada de 59,52 Hz.

- Sinal codificado 0: área ativa azul.
- Sinal codificado 1: área ativa verde.
- Blanking: RGB preto, conforme o protocolo VGA.
- Durante BTNC, a transmissão fica baixa e o raster continua funcionando.

Use monitor com entrada VGA e modo de 1 s/bit. [Tutorial](docs/tutorial_vga.pdf).
Todos os pinos RGB, Hsync e Vsync estão no `.xdc` principal em `../../constraints/`. Não adicione outro XDC para estas mesmas portas.


## Documentação e registros do Grupo 5

- [Tutorial padronizado em PDF](docs/tutorial_vga.pdf).
- [Vídeo original da demonstração](docs/midia/manchester_vga.mp4).
- As imagens e os demais registros estão em docs/midia/.
