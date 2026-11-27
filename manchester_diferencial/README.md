# Codificação Manchester Diferencial

**Faculdade Engenheiro Salvador Arena**  
Disciplina: Comunicação de Dados — Sistemas Reconfiguráveis  
Professor: Vinícius S. Borges  
Semestre 2026/2 — Grupo 1

| Integrante | RA |
|---|---|
| Eduardo Souza Urbanovicz Bastiani | 082230018 |
| João Vitor Maciel Nai | 082230004 |
| Ronaldo de Oliveira Santos | 082230031 |

Implementação em VHDL do código **Manchester Diferencial**, gravada na placa Basys 3.

## O código em 3 linhas

Sempre há uma transição **no meio** do bit, usada só para sincronismo. O valor do bit é dado pelo **início** do intervalo: bit **0** → o nível **inverte** no início; bit **1** → o nível **se mantém**. Como a regra depende do nível anterior, o circuito memoriza o último nível transmitido. **Nível da saída após o reset: baixo.**

| Bit | Início do intervalo | Meio do intervalo |
|-----|---------------------|-------------------|
| 0 | inverte o nível | inverte o nível |
| 1 | mantém o nível anterior | inverte o nível |

## Estrutura desta pasta

```
manchester_diferencial/
|-- README.md
|-- src/
|   |-- manchester_diferencial.vhd      Circuito principal (top): codificador + LEDs + PMOD + VGA
|   `-- vga_sync.vhd                    Gerador de sincronismo VGA 640x480 (cópia própria)
|-- sim/
|   `-- manchester_diferencial_tb.vhd   Testbench com verificação automática (assert)
|-- constraints/
|   `-- manchester_diferencial.xdc      Mapeamento dos pinos da Basys 3
|-- vivado_project/
|   `-- Manchester_diferencial.xpr      Projeto do Vivado
|-- docs/
|   |-- documentacao_projeto/           Como o circuito funciona por dentro
|   |-- tutorial_simulacao/             Como simular no Vivado
|   `-- tutorial_placa/                 Como gravar e testar na placa
`-- saidas/
    |-- pmod_osciloscopio/              Sinal no conector PMOD JA (osciloscópio)
    `-- vga/                            Tela VGA com cores pulsantes
```

## Arquivos de código

| Arquivo | O que faz |
|---------|-----------|
| `src/manchester_diferencial.vhd` | Módulo principal (*top*). Lê os switches, gera o sinal diferencial e o envia para LEDs, PMOD e VGA. |
| `src/vga_sync.vhd` | Gera os sincronismos da tela VGA 640x480 (idêntico ao do projeto Manchester). |
| `sim/manchester_diferencial_tb.vhd` | Testbench: confere nível após reset, transição (ou não) no início e transição no meio de cada bit. |
| `constraints/manchester_diferencial.xdc` | Pino físico de cada sinal. |

Top de implementação: **manchester_diferencial**. Top de simulação: **manchester_diferencial_tb**. Use somente um XDC.

## Documentação

- [Documentação técnica](docs/documentacao_projeto/documentacao_projeto.md)
- [Tutorial de simulação](docs/tutorial_simulacao/tutorial_simulacao.md)
- [Tutorial de gravação na placa](docs/tutorial_placa/tutorial_placa.md)

## Por onde começar

Para uma **simulação rápida**:

1. Abra o Vivado 2026.1 e carregue `vivado_project/Manchester_diferencial.xpr`.
2. Clique em **Run Simulation → Run Behavioral Simulation** e depois em **Run All**.

Para **reproduzir o projeto do zero**:

1. **Entenda o circuito** na [documentação técnica](docs/documentacao_projeto/documentacao_projeto.md).
2. **Compare com o Manchester** (projeto anterior): a única diferença está no bloco codificador (seção 5 da documentação técnica).
3. **Simule** seguindo o [tutorial de simulação](docs/tutorial_simulacao/tutorial_simulacao.md).
4. **Grave na placa** seguindo o [tutorial de gravação](docs/tutorial_placa/tutorial_placa.md).
5. **Observe as saídas** PMOD e VGA (abaixo).

## Saídas PMOD e VGA

- [Saída pelo PMOD para osciloscópio](saidas/pmod_osciloscopio/README.md)
- [Saída VGA com cores pulsantes](saidas/vga/README.md): **vermelho** = nível 0, **amarelo** = nível 1.

## Próximo passo

Você concluiu os dois projetos. Acesse o [Relatório técnico final](../relatorio_final/relatorio/relatorio.md) para a análise comparativa entre os dois códigos, os resultados e as conclusões do grupo.
