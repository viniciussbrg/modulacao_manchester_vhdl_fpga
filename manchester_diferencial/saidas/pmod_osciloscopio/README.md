# Saída pelo PMOD (Osciloscópio) - Manchester Diferencial

Disponibiliza o sinal codificado e o dado original em pinos do conector PMOD
JA da placa Basys 3, permitindo visualizar as duas formas de onda
simultaneamente em um osciloscópio físico. A comparação entre o dado e o
sinal codificado evidencia a regra de transição do código.

| Sinal       | Pino PMOD | Pino da FPGA | Conteúdo                                  |
|-------------|-----------|--------------|-------------------------------------------|
| `pmod_enc`  | JA1       | J1           | Sinal codificado (Manchester Diferencial) |
| `pmod_data` | JA2       | L2           | Bit original em transmissão (NRZ)         |

Os níveis lógicos são LVCMOS33 (3,3 V). O terminal de terra do PMOD (pino 5
ou 11 do conector JA) deve ser usado como referência do osciloscópio.

## Estrutura desta pasta

```
pmod_osciloscopio/
`-- docs/
    |-- tutorial_pmod_manchester_diferencial.pdf            Tutorial da saída PMOD
    `-- midia/
        |-- osciloscopio_manchester_diferencial.png         Captura da tela do osciloscópio
        `-- video_osciloscopio_manchester_diferencial.mp4   Vídeo do osciloscópio
```

As saídas do PMOD não têm código separado: estão no circuito principal do
projeto, em
[`manchester_diferencial.srcs/sources_1/new/Manchester_Diferencial.vhd`](../../manchester_diferencial.srcs/sources_1/new/Manchester_Diferencial.vhd)
(portas `pmod_enc` e `pmod_data`), e o mapeamento dos pinos está em
[`manchester_diferencial.srcs/constrs_1/new/basys3_Manchester_Diferencial.xdc`](../../manchester_diferencial.srcs/constrs_1/new/basys3_Manchester_Diferencial.xdc).

## Equipamentos necessários

- Placa FPGA Basys 3 e cabo micro-USB
- Osciloscópio de dois canais
- Duas pontas de prova (ou cabos BNC com adaptação para o conector PMOD)

## Como reproduzir

Ver o [tutorial completo](./docs/tutorial_pmod_manchester_diferencial.pdf), que descreve:

1. Conexão física do osciloscópio aos pinos JA1 (canal 1) e JA2 (canal 2) do
   PMOD, com o terra das pontas ligado ao GND do conector
2. Gravação do bitstream
3. Configuração da escala do osciloscópio
4. Captura da forma de onda

**Atenção à duração do bit.** O valor padrão do generic `CYCLES_PER_BIT` é
100.000.000 (1 s por bit com clock de 100 MHz), adequado para observar os
LEDs. Para observar o sinal no osciloscópio, ajustar o generic para um valor
menor e par (por exemplo, 100.000, que resulta em 1 ms por bit) e gerar o
bitstream novamente.
