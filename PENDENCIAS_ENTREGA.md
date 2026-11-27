# Conferência da entrega — Grupo 3

A prioridade segue o [enunciado](enunciado.pdf), o [guia de entrega](guia_entrega.pdf) e o [guia de documentação](guia_documentacao.pdf).

## Evidências exigidas

| Item | Material disponível | Situação |
|---|---|---|
| PMOD — Manchester IEEE 802.3 | Fotos da conexão, configuração do WaveForms e sinal codificado no [vídeo](relatorio_final/video_demo.mp4) por volta de 00:20 | A comparação simultânea com NRZ foi deixada fora do material apresentado por decisão do grupo. |
| PMOD — Manchester Diferencial | [Aquisição no modo lento](manchester_diferencial/saidas/pmod_osciloscopio/docs/midia/nova_47.png) e sinal codificado no vídeo por volta de 00:42 | A captura disponível mostra o sinal codificado no CH1 e o CH2 próximo de 0 V. |
| Basys 3 e LEDs — ambos | [Foto da bancada](relatorio_final/midia/nova_53.jpg), programação no Vivado e LEDs em operação nos trechos identificados do vídeo | Foto no relatório e vídeo em `relatorio_final/`. |
| VGA — ambos | Fotos de tela preta e branca e alternância de cores nos trechos por volta de 00:14 e 00:34 | Os trechos estão no [índice do vídeo](relatorio_final/README.md). |
| Vídeo de demonstração | [MP4 com os dois projetos](relatorio_final/video_demo.mp4) | Arquivo exportado e vinculado no README do relatório. |
| Simulação comportamental — ambos | Um print de forma de onda por projeto com dados, saída e LEDs. As janelas de 1 µs mostram `sim_done = FALSE` | A versão de entrega usa os prints disponíveis. Os registros do fim do **Run All** ficaram fora desta versão por decisão do grupo. |

## Projetos Vivado

Os arquivos `.xpr` pedidos no guia ficaram fora desta versão por decisão do grupo. As fontes, os testbenches e os XDCs estão nas pastas dos projetos. Os scripts Tcl permitem recriar [Manchester](manchester/vivado_project/README.md) e [Manchester Diferencial](manchester_diferencial/vivado_project/README.md) no Vivado 2025.2.

## Conferência final das ilustrações

- Os tutoriais de simulação têm imagens da criação manual, da hierarquia e da forma de onda nos dois projetos.
- Os tutoriais de placa têm imagens dos comandos de síntese, implementação e geração de bitstream, além da seleção do arquivo e do estado `Programmed`. Se forem coletadas na próxima execução, imagens de `Implementation Complete` e `Bitstream Generation Complete` ilustram os respectivos estados finais.
- Os documentos técnicos das duas codificações têm diagrama de blocos e tabelas de portas e de pinos.
- Ao acrescentar evidências, guarde as imagens em `docs/midia/` da seção correspondente, atualize os Markdown e exporte os PDFs com os mesmos nomes.

## Materiais locais

A estrutura de entrega está em `manchester/`, `manchester_diferencial/` e `relatorio_final/`. Os diretórios com os pacotes originais, as capturas brutas de entrada e o ZIP do OneDrive servem de referência na máquina local. O [guia de entrega](guia_entrega.pdf) orienta o envio pela branch `grupo3`.
