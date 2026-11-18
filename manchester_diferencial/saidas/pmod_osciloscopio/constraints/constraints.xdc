## ============================================================
## CLOCK - OSCILADOR DE 100 MHz
## ============================================================
set_property PACKAGE_PIN W5 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}]
 
## ============================================================
## RESET - BOTAO CENTRAL BTNC
## ============================================================
set_property PACKAGE_PIN U18 [get_ports {rst}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst}]
 
## ============================================================
## SWITCHES - ENTRADA DOS 16 BITS (SW0 a SW15)
## ============================================================
set_property PACKAGE_PIN V17 [get_ports {data_in[0]}]
set_property PACKAGE_PIN V16 [get_ports {data_in[1]}]
set_property PACKAGE_PIN W16 [get_ports {data_in[2]}]
set_property PACKAGE_PIN W17 [get_ports {data_in[3]}]
set_property PACKAGE_PIN W15 [get_ports {data_in[4]}]
set_property PACKAGE_PIN V15 [get_ports {data_in[5]}]
set_property PACKAGE_PIN W14 [get_ports {data_in[6]}]
set_property PACKAGE_PIN W13 [get_ports {data_in[7]}]
set_property PACKAGE_PIN V2  [get_ports {data_in[8]}]
set_property PACKAGE_PIN T3  [get_ports {data_in[9]}]
set_property PACKAGE_PIN T2  [get_ports {data_in[10]}]
set_property PACKAGE_PIN R3  [get_ports {data_in[11]}]
set_property PACKAGE_PIN W2  [get_ports {data_in[12]}]
set_property PACKAGE_PIN U1  [get_ports {data_in[13]}]
set_property PACKAGE_PIN T1  [get_ports {data_in[14]}]
set_property PACKAGE_PIN R2  [get_ports {data_in[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[*]}]
 
## ============================================================
## LEDS - VISUALIZACAO (LD0 a LD15)
## ============================================================
set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]
set_property PACKAGE_PIN W18 [get_ports {led[4]}]
set_property PACKAGE_PIN U15 [get_ports {led[5]}]
set_property PACKAGE_PIN U14 [get_ports {led[6]}]
set_property PACKAGE_PIN V14 [get_ports {led[7]}]
set_property PACKAGE_PIN V13 [get_ports {led[8]}]
set_property PACKAGE_PIN V3  [get_ports {led[9]}]
set_property PACKAGE_PIN W3  [get_ports {led[10]}]
set_property PACKAGE_PIN U3  [get_ports {led[11]}]
set_property PACKAGE_PIN P3  [get_ports {led[12]}]
set_property PACKAGE_PIN N3  [get_ports {led[13]}]
set_property PACKAGE_PIN P1  [get_ports {led[14]}]
set_property PACKAGE_PIN L1  [get_ports {led[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
 
## ============================================================
## SAIDA SERIAL - CONECTOR PMOD JA (Pino 1)
## ============================================================
set_property PACKAGE_PIN L2 [get_ports {data_out}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_out}]
 
## ============================================================
## SAIDA DE VIDEO - CONECTOR VGA
## ============================================================
set_property PACKAGE_PIN P19 [get_ports {hsync}]
set_property IOSTANDARD LVCMOS33 [get_ports {hsync}]
set_property PACKAGE_PIN R19 [get_ports {vsync}]
set_property IOSTANDARD LVCMOS33 [get_ports {vsync}]
 
set_property PACKAGE_PIN J17 [get_ports {vgaGreen[0]}]
set_property PACKAGE_PIN H17 [get_ports {vgaGreen[1]}]
set_property PACKAGE_PIN G17 [get_ports {vgaGreen[2]}]
set_property PACKAGE_PIN D17 [get_ports {vgaGreen[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[*]}]
 
set_property PACKAGE_PIN G19 [get_ports {vgaRed[0]}]
set_property PACKAGE_PIN H19 [get_ports {vgaRed[1]}]
set_property PACKAGE_PIN J19 [get_ports {vgaRed[2]}]
set_property PACKAGE_PIN N19 [get_ports {vgaRed[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[*]}]
 
set_property PACKAGE_PIN N18 [get_ports {vgaBlue[0]}]
set_property PACKAGE_PIN L18 [get_ports {vgaBlue[1]}]
set_property PACKAGE_PIN K18 [get_ports {vgaBlue[2]}]
set_property PACKAGE_PIN J18 [get_ports {vgaBlue[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[*]}]