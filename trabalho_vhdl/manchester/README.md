# Manchester IEEE 802.3 — Grupo 5

CENTRO EDUCACIONAL FACULDADE ENGENHEIRO SALVADOR ARENA

Sistemas Reconfiguráveis • Engenharia da Computação • 7º semestre

Professor Vinícius S. Borges • Grupo 5 • 2026

A convenção IEEE 802.3 representa 0 por alto/baixo e 1 por baixo/alto. A transição central é de descida para 0 e de subida para 1.

## Organização

- src/ reúne condicionamento das entradas, núcleo e top manchester_top.
- sim/ reúne manchester_tb, top_tb e vga_tb.
- constraints/ reúne manchester.xdc.
- vivado_project/ contém o projeto Vivado recebido e fontes importados.
- docs/ contém tutoriais, referência técnica e mídia de simulação/placa.
- saidas/ contém os experimentos PMOD e VGA, fontes e respectivas evidências.
- scripts/ contém seleção do modo de operação e roteiros de teste/bitstream.

## Roteiro de leitura

1. [Documentação técnica](docs/documentacao_projeto.pdf).
2. [Tutorial de simulação](docs/tutorial_simulacao.pdf).
3. [Tutorial de placa](docs/tutorial_placa.pdf).
4. [PMOD](saidas/pmod_osciloscopio/) e [VGA](saidas/vga/).

Para iniciar rapidamente, abra vivado_project/manchester.xpr e execute Run Behavioral Simulation. Se os caminhos ou a versão impedirem a abertura, use a reconstrução descrita no tutorial. O top de síntese é manchester_top; o de simulação principal é manchester_tb.

## Continuidade

[Próximo projeto: Manchester Diferencial](../manchester_diferencial/)
