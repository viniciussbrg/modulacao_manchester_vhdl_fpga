# Codificação de linha Manchester em VHDL — Grupo 5

CENTRO EDUCACIONAL FACULDADE ENGENHEIRO SALVADOR ARENA

Sistemas Reconfiguráveis • Engenharia da Computação • 7º semestre

Professor Vinícius S. Borges • Grupo 5 • 2026

## Integrantes

| Integrante | RA |
|---|---|
| Beatriz Carvalho Sousa | 082230027 |
| Guilherme Pexirile Lourenco | 082230011 |
| Yuri Villaco de Souza | 082230036 |
| Lucas da Silva Macedo | 082230037 |
| Rhyu Costa de Souza | 082230023 |

## Apresentação

O trabalho implementa dois codificadores independentes para Basys 3, com transmissão cíclica de SW15 até SW0, LEDs por posição, saídas PMOD para dado e código e VGA com azul/verde. O código Manchester adota IEEE 802.3. O Diferencial usa referência inicial baixa e inversão inicial para 0.

## Estrutura e navegação

- [Manchester](manchester/) reúne fontes, testes, constraints, projeto e documentação.
- [Manchester Diferencial](manchester_diferencial/) reúne o segundo projeto completo.
- [Relatório final](relatorio_final/relatorio.pdf) apresenta teoria, desenvolvimento, resultados e comparação.
- [Vídeos originais da demonstração](relatorio_final/README.md#vídeos-originais) reúne os links dos sete registros separados.
- [Conferência da entrega](CHECKLIST_ENTREGA.md) apresenta a situação das evidências.

## Ferramentas

VHDL 2008, Vivado Simulator, FPGA Artix-7 xc7a35tcpg236-1 e placa Basys 3 com clock de 100 MHz. Os XPR recebidos são de Vivado 2026.1 em Windows. Há captura adicional de Vivado 2025.2. O equipamento e software de aquisição dos sinais não foram identificados pelo grupo.

## Como começar

Siga o [tutorial de simulação do Manchester](manchester/docs/tutorial_simulacao.pdf). Extraia toda a pasta antes de abrir um XPR. Os scripts usam caminhos relativos à própria localização.

## Evidências

Os logs XSim registram PASS nos dois testes principais. Os vídeos originais são preservados nas pastas docs/midia de cada experimento. O relatório distingue essas evidências dos cálculos teóricos e identifica as informações experimentais ainda ausentes.

## Entrega

A entrega é realizada pelo fork do grupo no GitHub, com Pull Request destinado à branch grupo5 do repositório viniciussbrg/modulacao_manchester_vhdl_fpga, conforme o guia fornecido pelo professor.
