# Saída VGA - Manchester Diferencial

Esta saída mostra o sinal Manchester Diferencial em um monitor VGA: a tela inteira fica **verde**
quando o sinal está em nível 1 e **azul** quando está em nível 0. A imagem é gerada
no modo 640x480 a 60 Hz, com clock de pixel de 25 MHz obtido dividindo o clock de
100 MHz por 4. O codificador usa `CYCLES_PER_BIT = 100_000_000` (1 s por bit, 0,5 s
por cor). Os LEDs continuam funcionando junto com a saída VGA.

## Estrutura desta pasta
```
vga/
|-- src/manchester_dif.vhd           Codificador (cópia do projeto principal)
|-- src/manchester_dif_vga.vhd       Top da saída VGA (codificador + sincronismo VGA)
|-- constraints/manchester_dif_vga.xdc
|-- vivado_project/         Projeto Vivado manchester_dif_vga.xpr
`-- docs/                   Tutorial e mídias
```

## Equipamentos
- Placa Basys 3 e cabo micro-USB
- Monitor com entrada VGA e cabo VGA

## Como reproduzir
1. Abrir `vivado_project/manchester_dif_vga.xpr` no Vivado 2025.2.
2. Ligar o monitor na porta VGA da placa.
3. Gerar o bitstream e gravar na placa.
4. Configurar uma sequência nos switches e observar a tela alternar entre verde e azul.

Passo a passo completo: [tutorial VGA](./docs/tutorial_vga.pdf).
