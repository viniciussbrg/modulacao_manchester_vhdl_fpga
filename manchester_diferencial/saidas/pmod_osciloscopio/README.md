# PMOD para osciloscópio — Manchester Diferencial

Leva ao conector JA o sinal codificado e o dado NRZ registrado, para comparar os dois canais na mesma aquisição.

## Estrutura

```text
pmod_osciloscopio/
├── src/            Referências para as fontes VHDL do projeto
├── constraints/    Referência para o XDC do projeto
└── docs/           Tutorial e mídias
```

## Como reproduzir

Use a Basys 3 programada, um osciloscópio de dois canais ou Analog Discovery 3 com WaveForms e fios de conexão. Ligue CH1 a JA1, CH2 a JA2 e as referências a GND. Use o mesmo bitstream da demonstração dos LEDs.

[Tutorial em PDF](docs/tutorial_pmod.pdf) · [Fonte editável](docs/tutorial_pmod.md)
