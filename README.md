# Codificação Manchester e Manchester Diferencial em VHDL/FPGA

Trabalho prático da disciplina de **Comunicação de Dados - Sistemas Reconfiguráveis**.

O trabalho consiste em desenvolver, simular e implementar em FPGA (Basys 3), utilizando VHDL e o Vivado, dois codificadores de linha:

- **Manchester (IEEE 802.3)**: bit representado pelo sentido da transição no meio do bit (0 = descida, 1 = subida)
- **Manchester Diferencial**: sempre há transição no meio do bit; o bit é representado pela transição no início do intervalo (0 = inverte o nível, 1 = mantém o nível)

## Organização deste repositório

A branch `main` contém apenas o enunciado e os guias. Cada grupo tem uma **branch própria** (`grupo1`, `grupo2`, ...), criada pelo professor, que recebe a entrega do grupo. A estrutura evolui ao longo do semestre:

### Estado inicial (semestre começando)

```
modulacao_manchester_vhdl_fpga/
└── main
    ├── README.md
    ├── enunciado.pdf
    ├── guia_entrega.pdf
    └── guia_documentacao.pdf
```

### Durante o semestre (grupos entregando)

```
modulacao_manchester_vhdl_fpga/
├── main                  Enunciado e guias (não muda)
├── grupo1                Entrega do grupo 1
├── grupo2                Entrega do grupo 2
└── grupo3                Entrega do grupo 3
```

### Fim do semestre (todas as entregas consolidadas)

```
modulacao_manchester_vhdl_fpga/
├── main                  Enunciado e guias (sempre intocada)
├── grupo1                Entrega do grupo 1
├── grupo2                Entrega do grupo 2
├── ...
└── grupoN                Entrega do grupo N
```

**Como navegar entre as entregas:** clicar no seletor de branches (canto superior esquerdo, onde aparece `main`) e escolher a branch do grupo desejado.

## Documentos do trabalho

- [📄 Enunciado completo](./enunciado.pdf): descrição do trabalho, requisitos e critério de avaliação
- [📦 Guia de entrega](./guia_entrega.pdf): passo a passo da entrega via GitHub e estrutura de pastas
- [📘 Guia de documentação](./guia_documentacao.pdf): orientação sobre READMEs, tutoriais, documentação técnica e relatório

**Leia os três antes de começar.** O enunciado descreve *o que fazer*; o guia de entrega descreve *como entregar*; o guia de documentação descreve *o que escrever em cada documento*.

## Como entregar (fluxo de fork)

A entrega é feita via **fork + Pull Request**. Resumidamente:

1. **Fazer fork** deste repositório (botão `Fork` no canto superior direito)
2. **Clonar o fork** na máquina de um dos integrantes
3. **Desenvolver o trabalho** no fork seguindo a estrutura sugerida
4. **Abrir um Pull Request** para a **branch do grupo** (`base: grupoX`, nunca `main`), com o título no formato:
```
   Entrega - Grupo X - Nome dos integrantes
```
5. **Aguardar a revisão**. Correções são feitas no fork e o PR atualiza sozinho. Após aprovado, o trabalho é incorporado à branch do grupo neste repositório

Os passos detalhados, com todos os comandos Git, estão no [guia de entrega](./guia_entrega.pdf).

## Estrutura esperada dentro do fork de cada grupo

```
modulacao_manchester/
├── README.md
├── manchester/
│   ├── src/, sim/, constraints/, vivado_project/
│   ├── docs/      (tutoriais e documentação técnica)
│   └── saidas/    (saídas PMOD e VGA)
├── manchester_diferencial/   (mesma estrutura)
└── relatorio_final/
```

Detalhes completos no [guia de entrega](./guia_entrega.pdf) e no [guia de documentação](./guia_documentacao.pdf).

## Entregas dos grupos

Entregas aprovadas e incorporadas no repositório:

- (nenhuma entrega até o momento)

## Observações

- A implementação na placa é **obrigatória**
- A convenção do Manchester adotada é a **IEEE 802.3**; no Manchester Diferencial, o nível após o reset é **baixo**
- Cada projeto também deve ter as saídas **PMOD** (osciloscópio) e **VGA**
- Critério de avaliação: **50%** para a implementação e **50%** para o repositório Git com todos os arquivos (detalhes no [enunciado](./enunciado.pdf))
- Dúvidas: abrir uma **Issue** neste repositório
