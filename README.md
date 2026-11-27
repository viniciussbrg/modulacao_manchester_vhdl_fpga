# Codificação Manchester em VHDL na Basys 3

Faculdade Engenheiro Salvador Arena · Comunicação de Dados — Sistemas Reconfiguráveis  
Professor Vinicius Borges · 7º semestre · Grupo 3

| Integrante | RA | GitHub |
|---|---|---|
| Emanuel Carneiro da Silva | 082230017 | [emanuel71silva](https://github.com/emanuel71silva) |
| José Gabriel de Morais Souza | 082230001 | [Gabriieu](https://github.com/Gabriieu) |
| Lucas Daiki Honda Kuniyosi | 082230020 | [LucasKuniyosi](https://github.com/LucasKuniyosi) |

Dois projetos VHDL independentes codificam a sequência de 16 switches da Basys 3: Manchester pela convenção IEEE 802.3 e Manchester Diferencial com nível inicial baixo. Cada projeto apresenta o sinal no LED da posição transmitida, no PMOD para observação em osciloscópio e por cores na saída VGA.

## Como começar

Abra o [tutorial de simulação do Manchester](manchester/docs/tutorial_simulacao.pdf) para criar o projeto no Vivado e conferir as transições na forma de onda. Em seguida, siga os tutoriais de placa, PMOD e VGA no README do projeto. O diferencial tem o mesmo roteiro, com seu próprio código, testbench e constraints.

- [Projeto Manchester](manchester/README.md)
- [Projeto Manchester Diferencial](manchester_diferencial/README.md)
- [Relatório técnico](relatorio_final/relatorio.pdf) e [vídeo de demonstração](relatorio_final/README.md)
- [Conferência da entrega](PENDENCIAS_ENTREGA.md)

## Estrutura da entrega

```text
.
├── manchester/               Codificador Manchester IEEE 802.3
├── manchester_diferencial/   Codificador Manchester Diferencial
│   ├── src/                  Implementação VHDL e controlador VGA
│   ├── sim/                  Testbench
│   ├── constraints/          Pinagem e clock da Basys 3
│   ├── vivado_project/       Script para gerar o projeto Vivado
│   ├── docs/                 Tutoriais, documentação técnica e mídias
│   └── saidas/               Instruções e mídias para PMOD e VGA
└── relatorio_final/          Relatório consolidado e índice do vídeo
```

Os dois projetos têm a mesma estrutura interna. Os PDFs ficam ao lado dos respectivos arquivos Markdown editáveis.

## Ferramentas utilizadas pelo grupo

Vivado 2025.2 com Vivado Simulator (XSim), Windows 11 Education 25H2, Basys 3 (Artix-7 `xc7a35tcpg236-1`), Analog Discovery 3, WaveForms 3.24.4 e monitor VGA.

## Entrega ao professor

De acordo com o [guia de entrega](guia_entrega.pdf), o pull request parte da `main` do fork e usa `grupo3` como branch de destino no repositório oficial. O título segue o formato `Entrega - Grupo 3 - Nome dos integrantes`. Os arquivos e as evidências incluídos estão na [conferência da entrega](PENDENCIAS_ENTREGA.md).
