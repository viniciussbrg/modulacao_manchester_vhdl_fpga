# Codificação Manchester em VHDL

Trabalho das disciplinas de Comunicação de Dados e Sistemas Reconfiguráveis,
ministradas pelo Prof. Dr. Vinicius Borges (FESA). Semestre 2026/2.

## Integrantes
- Tayson Moisés Costa do Carmo (RA 082230008)
- Paulo Henrique de Carvalho Santos (RA 082230006)
- Luigi Guilherme Pereira Silva (RA 082230025)
- Guilherme de Oliveira Mattos (RA 082230009)
- Pedro Henrique de Holanda Carvalho (RA 082230005)

## Descrição
Este repositório contém a implementação, em VHDL, de dois codificadores de linha:
Manchester (convenção IEEE 802.3) e Manchester Diferencial (nível baixo após o reset).
Cada codificador transmite de forma cíclica os 16 bits definidos pelos switches da
placa Basys 3, do SW15 ao SW0, e apresenta o sinal codificado nos LEDs, no conector
PMOD (para o osciloscópio) e na saída VGA.

## Estrutura do repositório
```
|-- manchester/              Projeto Manchester (auto-contido)
|-- manchester_diferencial/  Projeto Manchester Diferencial (auto-contido)
`-- relatorio_final/         Relatório técnico consolidado e vídeo de demonstração
```
Cada projeto possui sua própria pasta `docs/` com tutoriais e documentação técnica,
e uma pasta `saidas/` com as saídas PMOD (osciloscópio) e VGA.

## Projetos
- [Manchester](./manchester/) - o valor do bit é dado pelo sentido da transição no meio do bit
- [Manchester Diferencial](./manchester_diferencial/) - o valor do bit é dado pela presença
  ou ausência de transição no início do bit

## Relatório
- [Relatório técnico final](./relatorio_final/relatorio.pdf)
- [Vídeo de demonstração do VGA](https://github.com/user-attachments/assets/e37dda7d-78a2-4d72-880f-d25fb86633c8)
- [Vídeo de demonstração do PMOD](https://github.com/user-attachments/assets/ba210b33-666e-466d-933f-9549bb397525)


## Ferramentas utilizadas
- Vivado 2025.2 (Vivado Simulator)
- Placa Basys 3 (Artix-7 xc7a35tcpg236-1)
- Analog Discovery 3 como osciloscópio de dois canais (saída PMOD)
- Monitor VGA (saída VGA)

## Como começar
Recomenda-se iniciar pelo projeto Manchester. Acesse a pasta
[manchester/](./manchester/) e siga o README local.
