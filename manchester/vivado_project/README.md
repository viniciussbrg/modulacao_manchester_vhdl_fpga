# Projeto Vivado — Manchester básico

Abra [manchester.xpr](projeto/manchester/manchester.xpr) no Vivado 2025.2, com suporte à Basys 3 (`xc7a35tcpg236-1`). O projeto de implementação usa a entidade `top_manchester_vga`, o Clocking Wizard `clk_wiz_0` e o XDC da pasta `.srcs/constrs_1/new/`.

O XPR referencia [manchester.vhd](manchester.vhd) e [manchester_tb.vhd](manchester_tb.vhd) dois níveis acima de seu diretório. Os dois arquivos acompanham o projeto nessa posição. A organização conserva os caminhos do ZIP do fork, inclusive a configuração de onda e o checkpoint de síntese referenciado em `utils_1`.

O arquivo de projeto registra o top VGA também em `sim_1` e marca o testbench como `AutoDisabled`. Para reproduzir o tutorial, habilite o testbench em **Simulation Sources** se necessário e use **Set as Top** em `manchester_tb` antes de executar a simulação.

O [bitstream de implementação](bitstream/top_manchester_vga.bit) pertence a este codificador. Os dois projetos usam o mesmo nome de bitstream. A conferência desta etapa consistiu em ler o XPR e resolver suas entradas no disco. A abertura em outro ambiente Vivado e a execução na placa seguem pendentes.
