# Codificação Manchester em VHDL

Faculdade Engenheiro Salvador Arena — Engenharia da Computação

Comunicação de Dados — Sistemas Reconfiguráveis 

Professor Vinicius Borges · 7º semestre.

| Nome | RA |
|---|---|
| Victor Mendes de Andrade Ferreira | 082230015 |
| Lucas Junqueira Gonçalves | 082230029 |
| Murilo Umbelino Oliveira dos Santos | 082230013 |
| Guilherme Alves Barbosa | 082220014 |

O trabalho implementa dois codificadores de linha para a placa Basys 3: Manchester, segundo a convenção IEEE 802.3, e Manchester Diferencial. A sequência de entrada é definida nos 16 switches; o sinal codificado é observado na simulação, nos LEDs e nas medições realizadas pelo PMOD.

Os projetos são organizados separadamente. As saídas PMOD e VGA têm pastas próprias, assim como os tutoriais e a documentação técnica de cada codificador.

## Onde começar

Abra o [tutorial de simulação do Manchester básico](manchester/docs/tutorial_simulacao.pdf). Ele mostra como acompanhar um bit de SW15 até a transição no meio do intervalo. Em seguida, compare a mesma sequência no projeto diferencial.

| Projeto | Simulação | Programação | Medição na bancada | Saída VGA |
|---|---|---|---|---|
| [Manchester básico](manchester/README.md) | [Tutorial XSim](manchester/docs/tutorial_simulacao.pdf) | [Tutorial da placa](manchester/docs/tutorial_placa.pdf) | [Tutorial PMOD](manchester/saidas/pmod_osciloscopio/docs/tutorial_pmod.pdf) | [Tutorial VGA](manchester/saidas/vga/docs/tutorial_vga.pdf) |
| [Manchester Diferencial](manchester_diferencial/README.md) | [Tutorial XSim](manchester_diferencial/docs/tutorial_simulacao.pdf) | [Tutorial da placa](manchester_diferencial/docs/tutorial_placa.pdf) | [Tutorial PMOD](manchester_diferencial/saidas/pmod_osciloscopio/docs/tutorial_pmod.pdf) | [Tutorial VGA](manchester_diferencial/saidas/vga/docs/tutorial_vga.pdf) |

A documentação técnica descreve os registradores, a temporização e os pinos de cada implementação. Consulte a [referência do básico](manchester/docs/documentacao_projeto.pdf) e a [referência do diferencial](manchester_diferencial/docs/documentacao_projeto.pdf).

## Estrutura

```text
manchester/ e manchester_diferencial/    Um projeto por codificação
├── src/ e sim/                        Codificador e testbench
├── constraints/                       XDC do projeto com saídas VGA e PMOD
├── vivado_project/                    Projeto Vivado, IP e bitstream arquivado
├── docs/                              Tutoriais, documentação técnica e capturas
└── saidas/
    ├── pmod_osciloscopio/             Ligações, tutorial e medições
    └── vga/                           Integração de vídeo
relatorio_final/                       Relatório técnico do Grupo 4
```

## Ambiente e resultados

Os ensaios documentados utilizaram Vivado 2025.2 com XSim no Windows 11 25H2, placa Digilent Basys 3, Analog Discovery 3 e WaveForms 3.24.4. Cada projeto inclui seu próprio bitstream em `vivado_project/bitstream/`.

O [relatório técnico](relatorio_final/relatorio.pdf) compara Manchester, Manchester Diferencial e NRZ-L. As capturas no PMOD registram o sinal codificado em C1. Faltam as aquisições simultâneas com o dado original em C2 e o vídeo de demonstração. No ensaio diferencial com switches alternados, a identificação da sequência depende dessa referência temporal.
