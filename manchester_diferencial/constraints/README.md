# Mapeamento da Basys 3 — Manchester Diferencial

[manchester_dif.xdc](manchester_dif.xdc) é uma cópia do XDC referenciado por `constrs_1` no [projeto Vivado](../vivado_project/README.md). O arquivo associa `clk` a W5 (100 MHz), `rst` a U18 (BTNC) e `data_out` a L2 (JA2). O relatório de pinos após o posicionamento, arquivado no ZIP, também associa `data_out` a L2.

O mesmo XDC cobre os switches, LEDs e sinais de vídeo do top de implementação. O codificador isolado e o testbench têm interfaces distintas do top com VGA.
