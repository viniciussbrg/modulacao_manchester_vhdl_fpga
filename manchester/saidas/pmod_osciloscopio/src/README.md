# Reutilização do código

Esta saída usa o mesmo código do projeto, em [`../../../src/`](../../../src/) (`manchester.vhd`). LEDs, PMOD e VGA são gerados pelo mesmo top e pelo mesmo bitstream; por isso não há outro top aqui, evitando duplicar implementações.
