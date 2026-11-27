# Codificação Manchester (IEEE 802.3)

**Faculdade Engenheiro Salvador Arena**  
Disciplina: Comunicação de Dados — Sistemas Reconfiguráveis  
Professor: Vinícius S. Borges  
Semestre 2026/2 — Grupo 1

| Integrante | RA |
|---|---|
| Eduardo Souza Urbanovicz Bastiani | 082230018 |
| João Vitor Maciel Nai | 082230004 |
| Ronaldo de Oliveira Santos | 082230031 |

Implementação em VHDL do código **Manchester** na convenção **IEEE 802.3** (Ethernet), gravada na placa Basys 3.

## O código em 3 linhas

Cada bit é dividido em duas metades e **sempre há uma troca de nível no meio do bit**. O valor do bit é dado pelo **sentido** dessa troca. Pela convenção IEEE 802.3, adotada explicitamente neste trabalho, o bit **0** é **alto → baixo (descida)** e o bit **1** é **baixo → alto (subida)**.

| Bit | 1ª metade | 2ª metade | Transição no meio |
|-----|-----------|-----------|-------------------|
| 0 | alto | baixo | descida |
| 1 | baixo | alto | subida |

## Estrutura desta pasta

```
manchester/
|-- README.md
|-- src/
|   |-- manchester.vhd          Circuito principal (top): codificador + LEDs + PMOD + VGA
|   `-- vga_sync.vhd            Gerador de sincronismo VGA 640x480
|-- sim/
|   `-- manchester_tb.vhd       Testbench com verificação automática (assert)
|-- constraints/
|   `-- manchester.xdc          Mapeamento dos pinos da Basys 3
|-- vivado_project/
|   `-- Manchester.xpr          Projeto do Vivado (aponta para src/, sim/ e constraints/)
|-- docs/
|   |-- documentacao_projeto/   Como o circuito funciona por dentro
|   |-- tutorial_simulacao/     Como simular no Vivado
|   `-- tutorial_placa/         Como gravar e testar na placa
`-- saidas/
    |-- pmod_osciloscopio/      Sinal no conector PMOD JA (osciloscópio)
    `-- vga/                    Tela VGA com cores pulsantes
```

## Arquivos de código

| Arquivo | O que faz |
|---------|-----------|
| `src/manchester.vhd` | Módulo principal (*top*). Lê os switches, gera o sinal Manchester e o envia para LEDs, PMOD e VGA. |
| `src/vga_sync.vhd` | Gera os sincronismos horizontal e vertical de uma tela VGA 640x480. |
| `sim/manchester_tb.vhd` | Testbench: simula a placa e confere automaticamente cada metade de cada bit. |
| `constraints/manchester.xdc` | Pino físico de cada sinal (clock, botões, switches, LEDs, PMOD, VGA). |

Top de implementação: **manchester**. Top de simulação: **manchester_tb**. Use somente um XDC.

## Documentação

- [Documentação técnica](docs/documentacao_projeto/documentacao_projeto.md): diagrama de blocos, portas, parâmetros e funcionamento interno.
- [Tutorial de simulação](docs/tutorial_simulacao/tutorial_simulacao.md): como abrir o projeto e simular no Vivado.
- [Tutorial de gravação na placa](docs/tutorial_placa/tutorial_placa.md): síntese, bitstream, gravação e testes.

## Por onde começar

Para uma **simulação rápida**:

1. Abra o Vivado 2026.1 e carregue `vivado_project/Manchester.xpr`.
2. Clique em **Run Simulation → Run Behavioral Simulation** e depois em **Run All**.

Para **reproduzir o projeto do zero**, siga esta ordem:

1. **Entenda o circuito** na [documentação técnica](docs/documentacao_projeto/documentacao_projeto.md).
2. **Simule** seguindo o [tutorial de simulação](docs/tutorial_simulacao/tutorial_simulacao.md).
3. **Grave na placa** seguindo o [tutorial de gravação](docs/tutorial_placa/tutorial_placa.md).
4. **Observe as saídas** PMOD e VGA (abaixo).

## Saídas PMOD e VGA

- [Saída pelo PMOD para osciloscópio](saidas/pmod_osciloscopio/README.md): sinal codificado em JA1 e dado original em JA2.
- [Saída VGA com cores pulsantes](saidas/vga/README.md): **azul** = nível 0, **verde** = nível 1.

O mesmo bitstream atende LEDs, PMOD e VGA ao mesmo tempo.

## Próximo passo

Depois de concluir este projeto, siga para a [Codificação Manchester Diferencial](../manchester_diferencial/README.md), a outra versão estudada no trabalho.
