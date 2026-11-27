# Reutilização do código

Esta saída usa o mesmo código do projeto, em [`../../../src/`](../../../src/) (`manchester_diferencial.vhd` e `vga_sync.vhd`). LEDs, PMOD e VGA são gerados pelo mesmo top e pelo mesmo bitstream; por isso não há outro top aqui, evitando duplicar implementações.
