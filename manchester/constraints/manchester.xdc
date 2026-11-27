## ============================================================================
## Constraints - Manchester (IEEE 802.3)
## Placa : Basys 3  |  FPGA: Artix-7 xc7a35tcpg236-1
## Top   : manchester   (src/manchester.vhd)
## Baseado em Basys-3-Master.xdc (Digilent); portas renomeadas para o VHDL.
## ============================================================================

## ---------------------------------------------------------------------------
## Clock de 100 MHz (W5)
## ---------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN W5 IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## ---------------------------------------------------------------------------
## Reset: botao central BTNC (U18)
## ---------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports rst]

## ---------------------------------------------------------------------------
## Switches SW0..SW15  ->  data_in(0..15)
## ---------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports {data_in[0]}]
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports {data_in[1]}]
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports {data_in[2]}]
set_property -dict { PACKAGE_PIN W17 IOSTANDARD LVCMOS33 } [get_ports {data_in[3]}]
set_property -dict { PACKAGE_PIN W15 IOSTANDARD LVCMOS33 } [get_ports {data_in[4]}]
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports {data_in[5]}]
set_property -dict { PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports {data_in[6]}]
set_property -dict { PACKAGE_PIN W13 IOSTANDARD LVCMOS33 } [get_ports {data_in[7]}]
set_property -dict { PACKAGE_PIN V2  IOSTANDARD LVCMOS33 } [get_ports {data_in[8]}]
set_property -dict { PACKAGE_PIN T3  IOSTANDARD LVCMOS33 } [get_ports {data_in[9]}]
set_property -dict { PACKAGE_PIN T2  IOSTANDARD LVCMOS33 } [get_ports {data_in[10]}]
set_property -dict { PACKAGE_PIN R3  IOSTANDARD LVCMOS33 } [get_ports {data_in[11]}]
set_property -dict { PACKAGE_PIN W2  IOSTANDARD LVCMOS33 } [get_ports {data_in[12]}]
set_property -dict { PACKAGE_PIN U1  IOSTANDARD LVCMOS33 } [get_ports {data_in[13]}]
set_property -dict { PACKAGE_PIN T1  IOSTANDARD LVCMOS33 } [get_ports {data_in[14]}]
set_property -dict { PACKAGE_PIN R2  IOSTANDARD LVCMOS33 } [get_ports {data_in[15]}]

## ---------------------------------------------------------------------------
## LEDs LD0..LD15  ->  led(0..15)   (LED fica acima do switch de mesmo indice)
## ---------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports {led[0]}]
set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports {led[1]}]
set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports {led[2]}]
set_property -dict { PACKAGE_PIN V19 IOSTANDARD LVCMOS33 } [get_ports {led[3]}]
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports {led[4]}]
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports {led[5]}]
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports {led[6]}]
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports {led[7]}]
set_property -dict { PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports {led[8]}]
set_property -dict { PACKAGE_PIN V3  IOSTANDARD LVCMOS33 } [get_ports {led[9]}]
set_property -dict { PACKAGE_PIN W3  IOSTANDARD LVCMOS33 } [get_ports {led[10]}]
set_property -dict { PACKAGE_PIN U3  IOSTANDARD LVCMOS33 } [get_ports {led[11]}]
set_property -dict { PACKAGE_PIN P3  IOSTANDARD LVCMOS33 } [get_ports {led[12]}]
set_property -dict { PACKAGE_PIN N3  IOSTANDARD LVCMOS33 } [get_ports {led[13]}]
set_property -dict { PACKAGE_PIN P1  IOSTANDARD LVCMOS33 } [get_ports {led[14]}]
set_property -dict { PACKAGE_PIN L1  IOSTANDARD LVCMOS33 } [get_ports {led[15]}]

## ---------------------------------------------------------------------------
## Conector PMOD JA (osciloscopio)
##   JA1 (J1) : data_out = sinal codificado
##   JA2 (L2) : data_raw = dado original (NRZ)
##   GND do osciloscopio: pino 5 ou 11 do conector JA
## ---------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN J1 IOSTANDARD LVCMOS33 } [get_ports data_out]
set_property -dict { PACKAGE_PIN L2 IOSTANDARD LVCMOS33 } [get_ports data_raw]

## ---------------------------------------------------------------------------
## Entradas assincronas: botoes sincronizados; switches capturados diretamente
## ---------------------------------------------------------------------------
set_false_path -from [get_ports rst]
set_false_path -from [get_ports {data_in[*]}]

## ---------------------------------------------------------------------------
## Configuracao do bitstream
## ---------------------------------------------------------------------------
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

# BTNU - velocidade rapida enquanto pressionado
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports fast]
set_false_path -from [get_ports fast]

# VGA
set_property -dict { PACKAGE_PIN G19 IOSTANDARD LVCMOS33 } [get_ports {vgaRed[0]}]
set_property -dict { PACKAGE_PIN H19 IOSTANDARD LVCMOS33 } [get_ports {vgaRed[1]}]
set_property -dict { PACKAGE_PIN J19 IOSTANDARD LVCMOS33 } [get_ports {vgaRed[2]}]
set_property -dict { PACKAGE_PIN N19 IOSTANDARD LVCMOS33 } [get_ports {vgaRed[3]}]
set_property -dict { PACKAGE_PIN N18 IOSTANDARD LVCMOS33 } [get_ports {vgaBlue[0]}]
set_property -dict { PACKAGE_PIN L18 IOSTANDARD LVCMOS33 } [get_ports {vgaBlue[1]}]
set_property -dict { PACKAGE_PIN K18 IOSTANDARD LVCMOS33 } [get_ports {vgaBlue[2]}]
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports {vgaBlue[3]}]
set_property -dict { PACKAGE_PIN J17 IOSTANDARD LVCMOS33 } [get_ports {vgaGreen[0]}]
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports {vgaGreen[1]}]
set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports {vgaGreen[2]}]
set_property -dict { PACKAGE_PIN D17 IOSTANDARD LVCMOS33 } [get_ports {vgaGreen[3]}]
set_property -dict { PACKAGE_PIN P19 IOSTANDARD LVCMOS33 } [get_ports Hsync]
set_property -dict { PACKAGE_PIN R19 IOSTANDARD LVCMOS33 } [get_ports Vsync]
