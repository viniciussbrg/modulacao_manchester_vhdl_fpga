# FACULDADE — Manchester / N2B2

## Escopo atual

Documentação, organização dos arquivos e versionamento no Git/GitHub. Trabalhar dentro da raiz do projeto. Não alterar VHDL, XDC, parâmetros, top modules ou programação da FPGA sem nova solicitação específica. É permitido copiar os fontes sem modificar seu conteúdo para organizar a entrega; preservar qualquer versão local mais recente.

## Leitura inicial

1. `LEIA-ME_CONTINUIDADE.md`, `CONTEXTO_PROJETO.md` e `PENDENCIAS.md`.
2. Os três PDFs em `referencias/professor/`.
3. `ferramentas/documentacao/README.md` e o estado Git.

## Documentos

- A referência visual aprovada são os quatro PDFs deste pacote, com estilo único em `ferramentas/documentacao/estilo_tutoriais.py`.
- Preservar azul-marinho, verde-azulado, fontes, margens e espaçamentos atuais. Não aplicar outro modelo genérico de formatação.
- Título seguido do quadro com faculdade, turma, nomes e RAs.
- Redação como autores do projeto: técnica, impessoal e autoexplicativa. Documentação no presente; relatório de execução no passado. Tutorial com instruções diretas, em passos pequenos.
- Não usar voz de intermediário: “informado pelo grupo”, “arquivos enviados”, “recebemos as capturas” e equivalentes.
- Não inserir nos tutoriais os blocos “FONTES DO ENSAIO”, “ORGANIZAÇÃO NA ENTREGA”, “Destino na entrega” ou parágrafos explicando margens/fontes do documento.
- Fotos e capturas: “Fonte: acervo dos autores (2026).” Quadros próprios: “Fonte: elaboração própria (2026).” Manter referências técnicas externas quando aplicáveis.
- Preservar os pixels das evidências; usar recortes/escala no layout sem recriar telas ou sinais. Não fabricar logs, testes ou resultados.
- A captura diferencial com switches alternados permanece no tutorial por decisão do autor. Sua ressalva fica em `PENDENCIAS.md` e na conversa; não afirmar que ela comprova a validação completa.

## Edição e conferência

- Editar os geradores, não fazer remendos visuais diretamente no PDF final.
- Gerar primeiro em `.build/documentacao/`. Conferir paginação, textos, figuras, links e padrão visual antes de publicar nas pastas finais.
- Executar `validar.py` e inspecionar visualmente as páginas afetadas. Não rerodar testes de FPGA só por alterações editoriais.
- Atualizar o checklist de pendências com evidências concretas. Não marcar entrega concluída por mera existência de pastas ou placeholders.
- Preservar os originais em `continuidade/fontes_fpga_originais/` e `continuidade/pacotes_fontes_aprovados/`.

## Git/GitHub

- Conferir `git status`, remotes e identidade antes de mudanças. Não inicializar um segundo repositório dentro de um existente nem afetar um repositório pai inadvertidamente.
- O destino de desenvolvimento é o fork do grupo; repositório oficial: https://github.com/viniciussbrg/modulacao_manchester_vhdl_fpga.
- O guia usa `main` no fork e entrega por PR para `grupoX` no oficial. Número do grupo e fork ainda precisam ser identificados.
- Se já houver clone do fork, usá-lo. Se houver só arquivos extraídos, preservar esses arquivos e integrar a uma cópia do fork com ancestralidade correta. Não sobrescrever arquivos existentes silenciosamente.
- Fazer commits por etapa coerente, após revisão do diff. Push normal para o `origin` confirmado; conferir que não aponta para a main oficial.
- Não usar force push, reset destrutivo, git clean, exclusão de branches ou reescrita de histórico. Não incluir credenciais, ambientes virtuais, caches ou arquivos temporários.
- Não inventar `user.name`/`user.email`; usar configuração válida existente ou solicitar os dados necessários. Não pedir permissões repetidas para trabalho já autorizado.
- Não abrir o PR final até concluir os requisitos. Não abrir issues, enviar mensagens ao professor ou criar outras comunicações externas sem pedido específico.
- “Versionamento automático” significa commits e pushes ao concluir as tarefas desta sessão; não instalar serviço, agendamento ou monitoramento permanente sem solicitação.

## Comunicação

Relatar resultado, arquivos alterados, verificações e pendências. Distinguir teste realizado, resultado documentado e informação ainda não disponível. Solicitar apenas dados que bloqueiem o próximo trabalho; continuar o que independe deles.
