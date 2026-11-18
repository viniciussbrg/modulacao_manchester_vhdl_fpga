# Manchester básico

A convenção IEEE 802.3 representa o bit 0 por uma transição de alto para baixo no meio do bit e o bit 1 pela transição de baixo para alto. A transmissão percorre SW15 a SW0 repetidamente, com captura de cada switch no início de seu intervalo.

## Organização local

| Pasta | Conteúdo |
|---|---|
| src/ | Codificador manchester.vhd |
| sim/ | Testbench manchester_tb.vhd |
| constraints/ | [Mapeamento da Basys 3](constraints/manchester.xdc) |
| vivado_project/ | [Projeto Vivado e bitstream](vivado_project/README.md) |
| docs/ | Tutorial de simulação e capturas; documentos adicionais em preparação |
| saidas/pmod_osciloscopio/ | Saída PMOD, tutorial e capturas |
| saidas/vga/ | Integração VGA e seu estado de preparação |

## Arquivos e parâmetros

[src/manchester.vhd](src/manchester.vhd) implementa o codificador. [sim/manchester_tb.vhd](sim/manchester_tb.vhd) aplica os estímulos e confere os resultados. O top de simulação é manchester_tb. O testbench usa clock de 10 ns e 10 ciclos por bit, totalizando 100 ns por bit. Na placa, o valor padrão de 100.000.000 ciclos a 100 MHz corresponde a 1 s por bit.

Consulte a [documentação do projeto](docs/documentacao_projeto.pdf) para o diagrama, a interface, a temporização e a correspondência entre portas e pinos.

## Como simular

1. Abra o [projeto no Vivado 2025.2](vivado_project/projeto/manchester/manchester.xpr).
2. Em **Simulation Sources**, selecione `manchester_tb` como top da simulação. O testbench está marcado como desabilitado na configuração arquivada. Habilite-o primeiro.
3. Execute **Run Simulation → Run Behavioral Simulation**. Siga o [tutorial de simulação](docs/tutorial_simulacao.pdf) para abrir os sinais e conferir as duas metades de cada bit.

## Como observar a saída

Na placa, BTNC aplica o reset síncrono. Ao soltar o botão, a transmissão recomeça em SW15. Somente o LED da posição em transmissão acompanha o nível codificado. Consulte as [conexões PMOD](saidas/pmod_osciloscopio/README.md) e a [integração VGA](saidas/vga/README.md).

O tutorial de programação da placa está pendente. O [checklist](../PENDENCIAS.md) acompanha os documentos e as evidências de bancada.

Próxima leitura → [Manchester Diferencial](../manchester_diferencial/README.md).
