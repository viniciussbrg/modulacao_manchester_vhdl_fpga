# Como continuar este projeto no Codex

O histórico do fork já está integrado nesta cópia de trabalho. Para retomar a partir do estado atual, comece pelo [checklist](PENDENCIAS.md). As instruções de extração abaixo descrevem o pacote inicial.

## 1. Coloque os arquivos na pasta de trabalho

Extraia o conteúdo do ZIP em:

`D:\Pessoal - Victor\Matérias Facul\EC7\Comunicação de Dados\N2B2`

O ZIP já contém os arquivos da raiz. AGENTS.md deve ficar diretamente em N2B2, ao lado de manchester/ e manchester_diferencial/. Não crie uma segunda camada N2B2/N2B2. Se a pasta já contiver arquivos, preserve-os e compare antes de substituir; uma versão local pode ser mais recente.

## 2. Abra essa pasta como projeto no Codex

Copie o conteúdo de PROMPT_CONTINUIDADE_CODEX.md e envie ao Codex. Os arquivos AGENTS.md, CONTEXTO_PROJETO.md e PENDENCIAS.md levam as decisões desta conversa para o novo ambiente.

## 3. O que está incluído

- Os quatro PDFs aprovados, nas pastas indicadas pelo guia de entrega.
- Geradores Python editáveis e estilo visual compartilhado.
- Fontes DejaVu e licença, para preservar as medidas do layout.
- Imagens originais utilizadas nos tutoriais, sem alteração dos pixels.
- Fontes VHDL, testbenches e cópia de referência do XDC disponível.
- Três PDFs do professor.
- READMEs iniciais, checklist, instruções de continuidade e configuração básica de Git.
- Dois ZIPs originais de fontes dos tutoriais, como cópia de preservação.

Não há DOCX editável original. Para manter o visual aprovado, a edição usa os scripts de ferramentas/documentacao/.

## 4. O que deverá vir do seu computador

Os projetos .xpr completos, o XDC atualizado para a bancada, a configuração do IP clk_wiz_0 e demais arquivos finais que não estão neste pacote. As pendências estão detalhadas em PENDENCIAS.md. O ZIP reúne o material disponível; não é uma exportação completa e pronta para síntese dos projetos Vivado.

## 5. Conferência dos arquivos

Com Python 3.11 ou superior disponível, execute na raiz:

```powershell
py -3 ferramentas/documentacao/verificar_pacote.py
```

Esse comando confere os hashes de integridade do pacote recém-extraído, sem instalar dependências. Depois de editar arquivos legitimamente, diferenças em relação ao pacote inicial são esperadas; o Git passa a registrar a evolução. O manifesto inicial não deve ser reescrito para esconder diferenças.

Para instalar as bibliotecas e gerar os PDFs em uma pasta temporária:

```powershell
py -3 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements-documentacao.txt
.\.venv\Scripts\python.exe ferramentas/documentacao/gerar.py
.\.venv\Scripts\python.exe ferramentas/documentacao/validar.py --alvo finais
```

Os comandos não exigem ativar o ambiente virtual. Para publicar uma nova geração após revisar suas páginas, use a opção --publicar descrita em ferramentas/documentacao/README.md.

## 6. GitHub

O fluxo correto é fork + PR, conforme referencias/professor/guia_entrega.pdf. A main do fork recebe o desenvolvimento; o PR final vai para grupoX no repositório oficial. Informe ao Codex a URL do fork e o número do grupo quando disponíveis. Não é necessário compartilhar senha ou token na conversa: use a autenticação local do Git/GitHub.

Se ainda não existir clone, o Codex deve preservar estes arquivos ao integrá-los ao fork, sem criar um histórico independente para sobrescrever o remoto. Nenhum repositório foi criado, nenhum commit foi publicado e nenhum PR foi aberto na preparação deste pacote.
