# Manchester

Implementação em VHDL do codificador Manchester para a placa Basys 3. O circuito transmite de forma cíclica os 16 bits definidos pelos switches (SW15 a SW0). O sinal codificado aparece no LED acima do switch em transmissão, no pino JA1 do conector PMOD e na saída VGA. O botão BTNC funciona como reset.

**Convenção adotada: IEEE 802.3.** Bit 0: nível alto na primeira metade e baixo na segunda (transição de descida no meio). Bit 1: nível baixo na primeira metade e alto na segunda (transição de subida no meio).

## Estrutura desta pasta
```
manchester/
|-- src/            Código-fonte VHDL
|-- sim/            Testbench
|-- constraints/    Mapeamento de pinos da Basys 3 (.xdc)
|-- vivado_project/ Projeto Vivado pronto para abrir
|-- docs/           Tutoriais e documentação técnica
`-- saidas/         Saídas PMOD (osciloscópio) e VGA
```

## Arquivos de código
- `src/manchester.vhd` - codificador (generic `CYCLES_PER_BIT`, 1 s por bit na placa)
- `sim/manchester_tb.vhd` - testbench com verificação automática (assert) de cada metade de bit
- `constraints/manchester.xdc` - pinos: clock (W5), BTNC (U18), SW15..SW0, LD15..LD0, JA1 e JA2

## Documentação
- [Tutorial de simulação](./docs/tutorial_simulacao.pdf)
- [Tutorial de implementação na placa](./docs/tutorial_placa.pdf)
- [Documentação técnica do projeto](./docs/documentacao_projeto.pdf)

## Por onde começar
1. Abrir `vivado_project/manchester.xpr` no Vivado 2025.2.
2. Seguir o [tutorial de simulação](./docs/tutorial_simulacao.pdf).
3. Seguir o [tutorial de implementação na placa](./docs/tutorial_placa.pdf).

## Saídas PMOD e VGA
- [Saída PMOD (osciloscópio)](./saidas/pmod_osciloscopio/)
- [Saída VGA](./saidas/vga/)

## Próximo passo
Depois deste projeto, siga para o [Manchester Diferencial](../manchester_diferencial/).
