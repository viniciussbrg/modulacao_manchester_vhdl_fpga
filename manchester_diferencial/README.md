# Manchester Diferencial

Implementação em VHDL do codificador Manchester Diferencial para a placa Basys 3. O circuito transmite de forma cíclica os 16 bits definidos pelos switches (SW15 a SW0). O sinal codificado aparece no LED acima do switch em transmissão, no pino JA1 do conector PMOD e na saída VGA. O botão BTNC funciona como reset.

**Regra adotada:** sempre há transição no meio do bit. No início do bit, há transição se o bit for 0 e não há transição se o bit for 1. **Após o reset, a saída fica em nível baixo**, e o testbench verifica essa condição.

## Estrutura desta pasta
```
manchester_diferencial/
|-- src/            Código-fonte VHDL
|-- sim/            Testbench
|-- constraints/    Mapeamento de pinos da Basys 3 (.xdc)
|-- vivado_project/ Projeto Vivado pronto para abrir
|-- docs/           Tutoriais e documentação técnica
`-- saidas/         Saídas PMOD (osciloscópio) e VGA
```

## Arquivos de código
- `src/manchester_dif.vhd` - codificador (generic `CYCLES_PER_BIT`, 1 s por bit na placa)
- `sim/manchester_dif_tb.vhd` - testbench com verificação automática (assert) de cada metade de bit
- `constraints/manchester_dif.xdc` - pinos: clock (W5), BTNC (U18), SW15..SW0, LD15..LD0, JA1 e JA2

## Documentação
- [Tutorial de simulação](./docs/tutorial_simulacao.pdf)
- [Tutorial de implementação na placa](./docs/tutorial_placa.pdf)
- [Documentação técnica do projeto](./docs/documentacao_projeto.pdf)

## Por onde começar
1. Abrir `vivado_project/manchester_diferencial.xpr` no Vivado 2025.2.
2. Seguir o [tutorial de simulação](./docs/tutorial_simulacao.pdf).
3. Seguir o [tutorial de implementação na placa](./docs/tutorial_placa.pdf).

## Saídas PMOD e VGA
- [Saída PMOD (osciloscópio)](./saidas/pmod_osciloscopio/)
- [Saída VGA](./saidas/vga/)

## Próximo passo
Consulte o [relatório técnico final](../relatorio_final/relatorio.pdf).
