# Checklist de continuidade — 17/11/2026

Controle interno de trabalho. “Disponível” significa presente neste pacote; não equivale a requisito integralmente validado na bancada.

## Pronto e preservado

- [x] Quatro tutoriais em PDF: simulação e PMOD dos dois codificadores.
- [x] Revisão da voz autoral e remoção dos blocos editoriais indesejados.
- [x] Mesmo modelo visual nos quatro tutoriais: 38 páginas no total.
- [x] Geradores editáveis, estilo compartilhado, fontes e licença de redistribuição.
- [x] Capturas usadas nos tutoriais, fotografias de bancada e cópias históricas disponíveis.
- [x] Enunciado, guia de documentação e guia de entrega do professor.
- [x] Fontes manchester.vhd, manchester_dif.vhd, seus testbenches, top_manchester_vga.vhd e constraints.xdc preservados.
- [x] Estrutura de diretórios preparada e READMEs iniciais com links para o que existe.

## Auditoria da integração — 17/11/2026

- [x] Dos 98 arquivos do manifesto, 97 coincidiram antes das edições. A única diferença prévia foi o prompt de continuidade do autor. Os 56 itens de `continuidade/originais_preservados.json` passaram na comparação SHA-256.
- [x] Geração no Windows em `.build/documentacao/` e validação dos quatro tutoriais nas versões gerada e final. As renderizações das 38 páginas coincidiram pixel a pixel na escala do validador. A inspeção visual, os marcadores e os destinos das 18 anotações de link foram conferidos.
- [x] Fork confirmado na conta autenticada [vmafdev](https://github.com/vmafdev/modulacao_manchester_vhdl_fpga). A pasta utiliza a `main` do fork, com base no commit `6bbbb59`.
- [x] Conferidos os dois ZIPs do fork. Cada pasta `vivado_project/` contém o XPR, seus arquivos de entrada, a configuração de onda e o bitstream arquivado. As sete referências de arquivo de cada XPR resolvem dentro do respectivo projeto.
- [x] Os dois XDCs ativos e os relatórios de pinos após o posicionamento associam `data_out` a L2 (JA2). A referência anterior com J1 permanece arquivada.
- [x] Integrações VGA e Clocking Wizard disponíveis nos dois projetos. Os XCI especificam 100 MHz de entrada e 148,5 MHz de saída. Nos dois ZIPs o top de implementação se chama `top_manchester_vga`.
- [x] Identificação confirmada pelo autor e aplicada à capa e ao README da raiz: Grupo 4, professor Vinicius Borges, 7º semestre.

**Reprodução no Vivado.** O XPR básico registra o top VGA em `sim_1` e marca o testbench como desabilitado. O [README do projeto](manchester/README.md) orienta a seleção de `manchester_tb`. No diferencial, o top da simulação salvo é `manchester_dif_tb`. Os XPRs conservam o caminho histórico do catálogo da placa. Falta verificar a abertura e a reprodução no ambiente de destino com suporte à Basys 3.

## Prioridade 3 — próximos documentos

- [x] [Tutorial de programação — Manchester básico](manchester/docs/tutorial_placa.pdf), com geração do bitstream, USB/JTAG, Program Device e testes previstos de reset, switches e LEDs.
- [x] [Tutorial de programação — Manchester Diferencial](manchester_diferencial/docs/tutorial_placa.pdf), com geração do bitstream, USB/JTAG, Program Device e testes previstos de reset, switches e LEDs.
- [x] [Documentação técnica do básico](manchester/docs/documentacao_projeto.pdf) com diagrama, interface, temporização, registro do XSim e mapeamento do XDC.
- [x] [Documentação técnica do diferencial](manchester_diferencial/docs/documentacao_projeto.pdf) com memória do nível anterior, transições, reset e mapeamento. Os dois PDFs têm três páginas cada e passaram pela validação estrutural e pela inspeção visual.
- [x] Tutoriais VGA do [básico](manchester/saidas/vga/docs/tutorial_vga.pdf) e do [diferencial](manchester_diferencial/saidas/vga/docs/tutorial_vga.pdf). As legendas relacionam a subida ao branco e a descida ao verde. A identificação do ensaio contínuo permanece em aberto.
- [x] Sete READMEs revisados com índice, fontes, projetos, saídas e instruções de uso. Índices atualizados com os tutoriais de placa/VGA e o relatório.
- [x] [Relatório técnico](relatorio_final/relatorio.pdf) com resultados documentados e comparação Manchester × diferencial × NRZ-L. Incorporar as aquisições em dois canais e a demonstração por projeto quando disponíveis.
- [ ] Vídeo de demonstração ou link acessível no README.

É possível redigir as seções sustentadas pelos fontes atuais. As etapas sem evidência devem permanecer em rascunho ou no checklist, sem fabricar comprovação. Os quatro PDFs já aprovados não precisam ser reescritos do zero.

## Prioridade 4 — medições e requisitos ainda sem comprovação completa

- [ ] Captura simultânea do sinal codificado e do dado original em dois canais, nos dois projetos. É requisito do enunciado, página 4; as capturas atuais mostram C1 habilitado e C2 desabilitado. Os tops arquivados expõem apenas o sinal codificado no PMOD.
- [x] Fotografias da Basys 3 conectada por USB e do monitor branco e verde com o cabo VGA conectado. Os dois anexos da placa são idênticos por SHA-256. O mesmo par de fotos VGA ilustra os dois tutoriais por indicação do autor.
- [ ] Vincular uma demonstração contínua ao bitstream de cada projeto e mostrar a liberação de BTNC, a sequência dos LEDs e a correspondência temporal entre o sinal e as cores.
- [ ] Verificação final da captura diferencial com switches alternados.

**Nota de conferência da captura alternada diferencial:** a imagem preservada mostra patamares regulares próximos de 1 s, semelhantes à captura alternada do básico. Isso, isoladamente, não estabelece a sequência 0101 no diferencial; falta referência temporal do dado original/início dos bits. Confirmar o bitstream carregado, a ordem SW15→SW0 e a captura em dois canais. Por decisão expressa do autor, essa observação deve ser comunicada na conversa e mantida neste controle, sem ser inserida no tutorial PMOD aprovado. Não substituir a imagem sem uma nova evidência nem declarar uma validação que ela não demonstra.

## Entrega final

- [ ] Reprodutibilidade de cada projeto sem arquivos externos à sua pasta.
- [x] Os 90 links relativos dos 17 READMEs resolvem localmente. Validação estrutural dos 11 PDFs (63 páginas), com conferência de nomes e RAs. As 19 páginas novas passaram por inspeção visual.
- [x] O navegador abriu o manual do Scope do WaveForms 3.24.4 e exibiu o conteúdo de Oscilloscope.
- [ ] Confirmar a leitura do PDF do manual da Basys 3. O endereço abriu no navegador, mas o visualizador não exibiu a página durante a conferência.
- [ ] Arquivos exigidos preenchidos; pasta vazia não conta como entrega.
- [x] Organização, fontes e tutoriais publicados na main do fork no commit [e6c6fe2](https://github.com/vmafdev/modulacao_manchester_vhdl_fpga/commit/e6c6fe2).
- [ ] PR manual pelo grupo para a branch grupo4 no repositório oficial, após concluir a entrega.
