# Codificação de Linha Manchester em VHDL (Vivado)

**Faculdade Engenheiro Salvador Arena**  
Disciplina: Comunicação de Dados — Sistemas Reconfiguráveis  
Professor: Vinícius S. Borges  
Semestre 2026/2 — Grupo 1

| Integrante | RA |
|---|---|
| Eduardo Souza Urbanovicz Bastiani | 082230018 |
| João Vitor Maciel Nai | 082230004 |
| Ronaldo de Oliveira Santos | 082230031 |

## Descrição

Este trabalho implementa, em VHDL, dois **codificadores de linha**: o **Manchester** (convenção **IEEE 802.3**) e o **Manchester Diferencial**. Um codificador de linha transforma uma sequência de bits em um sinal elétrico pronto para ser transmitido por um fio. Os dois códigos têm uma característica em comum: **todo bit tem uma transição no meio**, o que permite ao receptor se sincronizar com o transmissor sem um fio extra de relógio.

Os dois circuitos foram simulados no **Vivado Simulator** e gravados na placa FPGA **Basys 3**. Os 16 *switches* definem a sequência de bits, transmitida de SW15 até SW0 de forma cíclica. O sinal codificado aparece ao mesmo tempo em três lugares, com **um único bitstream** por projeto: no **LED** acima do switch em transmissão, no pino **JA1** do conector **PMOD** (osciloscópio) e na **tela VGA**, que muda de cor conforme o nível do sinal.

## Estrutura do repositório

```
MinhaDocumentacao/
|-- README.md                  Este arquivo (visão geral)
|-- ORIGEM_IMAGENS.md          De onde vem cada imagem usada
|-- manchester/                Projeto 1: Manchester (IEEE 802.3), auto-contido
|   |-- src/                   Código-fonte VHDL (manchester.vhd, vga_sync.vhd)
|   |-- sim/                   Testbench (manchester_tb.vhd)
|   |-- constraints/           Mapeamento dos pinos (manchester.xdc)
|   |-- vivado_project/        Projeto do Vivado pronto para abrir (Manchester.xpr)
|   |-- docs/                  Documentação técnica e tutoriais (simulação e placa)
|   `-- saidas/                Saídas PMOD (osciloscópio) e VGA
|-- manchester_diferencial/    Projeto 2: Manchester Diferencial (mesma estrutura)
`-- relatorio_final/           Relatório técnico consolidado e vídeos de demonstração
```

Cada projeto tem a própria pasta `docs/` e a própria pasta `saidas/`. Quem entrar em uma das pastas consegue reproduzir aquele projeto sem depender de arquivos de fora dela. Cada documento Markdown fica na mesma subpasta das imagens que utiliza, e a versão em PDF de cada tutorial e documentação fica com os nomes do guia de entrega (`docs/tutorial_simulacao.pdf`, `docs/tutorial_placa.pdf`, `docs/documentacao_projeto.pdf`, `saidas/*/docs/tutorial_*.pdf` e `relatorio_final/relatorio.pdf`).

## Projetos

- [Manchester](manchester/README.md): o bit é indicado pelo **sentido da transição no meio do bit** (0 = descida, 1 = subida).
- [Manchester Diferencial](manchester_diferencial/README.md): o bit é indicado pela **presença ou ausência de transição no início do bit** (0 = inverte o nível, 1 = mantém o nível). Nível após o reset: baixo.

## Relatório e vídeos

- [Relatório técnico final (PDF)](relatorio_final/relatorio.pdf) — versão em Markdown: [relatorio.md](relatorio_final/relatorio/relatorio.md)
- [Vídeos de demonstração e índice](relatorio_final/README.md)

## Ferramentas utilizadas

| Item | Detalhe |
|------|---------|
| Software | AMD Vivado 2026.1 (síntese, implementação e Vivado Simulator) |
| Sistema operacional | Windows 11 |
| Linguagem | VHDL (biblioteca IEEE `std_logic_1164`) |
| Placa FPGA | Digilent Basys 3, FPGA Artix-7 `xc7a35tcpg236-1`, clock de 100 MHz |
| Osciloscópio | Digilent Analog Discovery 3 com o software WaveForms |
| Monitor | Monitor com entrada VGA (640x480 a ~60 Hz) |

## Resultados em uma linha

Os dois testbenches terminam com `SIMULACAO CONCLUIDA: nenhum erro`, os dois projetos atendem o timing (WNS de +2,436 ns e +2,239 ns) e foram gravados e observados na placa (LEDs, osciloscópio e VGA).

## Como começar

Recomendamos começar pelo projeto **Manchester**. Entre na pasta [manchester/](manchester/README.md) e siga o README dela. Ele indica a ordem de leitura: documentação técnica, tutorial de simulação, tutorial de gravação na placa e, por fim, as saídas PMOD e VGA.

## Entrega

Enviar por *fork* e *pull request* ao repositório oficial `viniciussbrg/modulacao_manchester_vhdl_fpga`, com destino à branch **grupoX** do grupo, nunca à `main`. Título do PR: `Entrega - Grupo X - Nome dos integrantes`.
