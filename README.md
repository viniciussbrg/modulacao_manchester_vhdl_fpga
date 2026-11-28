# Codificação Manchester em VHDL

Trabalho da disciplina de Comunicação de Dados - Sistemas Reconfiguráveis,
ministrada por Vinícius Borges.
Curso de Engenharia de Computação, 7º semestre.

## Integrantes

- Acsa Santos Silva
- Geni Aparecida de Carvalho
- Patrick Nathan Gomes
- Yuri Pilatis de Andrade

## Descrição

Este trabalho implementa, em VHDL, dois codificadores de linha: Manchester
(convenção IEEE 802.3) e Manchester Diferencial. Em ambos, uma palavra de 16
bits, definida pelos switches da placa, é transmitida em série, do bit mais
significativo para o menos significativo, e repetida continuamente.

Os códigos foram simulados no Vivado Simulator e implementados na placa
Basys 3. O sinal codificado é disponibilizado em LEDs, no conector PMOD (para
visualização em osciloscópio) e em um monitor, por meio da saída VGA.

## Estrutura do repositório

```
modulacao_manchester_vhdl_fpga/
|-- manchester/               Projeto Manchester (auto-contido)
|-- manchester_diferencial/   Projeto Manchester Diferencial (auto-contido)
`-- relatorio_final/          Relatório técnico consolidado e vídeo de demonstração
    `-- videos/              Vídeo da placa em funcionamento
```

Cada projeto é um projeto Vivado (`.xpr`) com as pastas padrão do Vivado
(`<projeto>.srcs/sources_1`, `sim_1` e `constrs_1`), além de uma pasta `docs/`,
com tutoriais e documentação técnica, e uma pasta `saidas/`, com a
documentação das saídas PMOD (osciloscópio) e VGA.

## Projetos

- [Manchester](./manchester/) - o bit é dado pelo sentido da transição no
  meio do intervalo de bit
- [Manchester Diferencial](./manchester_diferencial/) - o bit é dado pela
  presença ou ausência de transição no início do intervalo de bit

## Relatório

- [Relatório técnico final](./relatorio_final/relatorio.pdf)
- [Vídeo de demonstração](./relatorio_final/videos/Placa%20rodando%20Manchester.mp4)

## Ferramentas utilizadas

- Vivado 2025.2 (síntese, implementação e Vivado Simulator)
- Linguagem VHDL (bibliotecas `IEEE.STD_LOGIC_1164` e `IEEE.NUMERIC_STD`)
- Placa Basys 3 (FPGA Artix-7 XC7A35T), clock de 100 MHz
- Osciloscópio de dois canais (saída PMOD)
- Monitor com entrada VGA e cabo VGA (saída VGA)

## Como começar

Recomenda-se iniciar pelo projeto Manchester. Acesse a pasta
[manchester/](./manchester/) e siga o README local.
