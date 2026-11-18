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
- [ ] Confirmar o número do grupo, o nome completo do professor e o período acadêmico para a identificação final.

**Reprodução no Vivado.** O XPR básico registra o top VGA em `sim_1` e marca o testbench como desabilitado. O [README do projeto](manchester/README.md) orienta a seleção de `manchester_tb`. No diferencial, o top da simulação salvo é `manchester_dif_tb`. Os XPRs conservam o caminho histórico do catálogo da placa. Falta verificar a abertura e a reprodução no ambiente de destino com suporte à Basys 3.

## Prioridade 3 — próximos documentos

- [ ] tutorial_placa.pdf — Manchester básico, com síntese, implementação, bitstream, Hardware Manager, programação e uso de switches/LEDs/reset.
- [ ] tutorial_placa.pdf — Manchester Diferencial, com o mesmo roteiro e evidências correspondentes.
- [x] [Documentação técnica do básico](manchester/docs/documentacao_projeto.pdf) com diagrama, interface, temporização, registro do XSim e mapeamento do XDC.
- [x] [Documentação técnica do diferencial](manchester_diferencial/docs/documentacao_projeto.pdf) com memória do nível anterior, transições, reset e mapeamento. Os dois PDFs têm três páginas cada e passaram pela validação estrutural e pela inspeção visual.
- [ ] tutorial_vga.pdf e evidências — ambos os projetos.
- [x] Sete READMEs revisados com índice, fontes, projetos, saídas e instruções de uso. A identificação acadêmica e os links para documentos futuros seguem em aberto.
- [ ] relatorio_final/relatorio.pdf, incluindo comparação Manchester × diferencial × NRZ e análise dos resultados.
- [ ] Vídeo de demonstração ou link acessível no README.

É possível redigir as seções sustentadas pelos fontes atuais. As etapas sem evidência devem permanecer em rascunho ou no checklist, sem fabricar comprovação. Os quatro PDFs já aprovados não precisam ser reescritos do zero.

## Prioridade 4 — medições e requisitos ainda sem comprovação completa

- [ ] Captura simultânea do sinal codificado e do dado original em dois canais, nos dois projetos. É requisito do enunciado, página 4; as capturas atuais mostram C1 habilitado e C2 desabilitado. Os tops arquivados expõem apenas o sinal codificado no PMOD.
- [ ] Evidências completas de VGA nos dois codificadores.
- [ ] Verificação final da captura diferencial com switches alternados.

**Nota de conferência da captura alternada diferencial:** a imagem preservada mostra patamares regulares próximos de 1 s, semelhantes à captura alternada do básico. Isso, isoladamente, não estabelece a sequência 0101 no diferencial; falta referência temporal do dado original/início dos bits. Confirmar o bitstream carregado, a ordem SW15→SW0 e a captura em dois canais. Por decisão expressa do autor, essa observação deve ser comunicada na conversa e mantida neste controle, sem ser inserida no tutorial PMOD aprovado. Não substituir a imagem sem uma nova evidência nem declarar uma validação que ela não demonstra.

## Entrega final

- [ ] Reprodutibilidade de cada projeto sem arquivos externos à sua pasta.
- [x] Os 77 links relativos dos 17 READMEs resolvem localmente. As 44 páginas dos seis PDFs passaram no validador, com conferência de nomes e RAs na abertura e comparação das renderizações com os arquivos finais.
- [ ] Confirmar em navegador o acesso ao manual da Basys 3 e ao manual do Scope do WaveForms. As consultas HTTP aos dois endereços da Digilent receberam 403. Os outros sete endereços distintos citados nos tutoriais responderam 200.
- [ ] Arquivos exigidos preenchidos; pasta vazia não conta como entrega.
- [x] Organização, fontes e tutoriais publicados na main do fork no commit [e6c6fe2](https://github.com/vmafdev/modulacao_manchester_vhdl_fpga/commit/e6c6fe2).
- [ ] PR manual pelo grupo para sua branch no repositório oficial, após concluir a entrega.
