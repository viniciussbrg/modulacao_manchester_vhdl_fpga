# Geração dos tutoriais

As versões finais ficam nas pastas dos dois projetos. O conteúdo editável está em criar_tutoriais_simulacao.py e criar_tutoriais_pmod.py. estilo_tutoriais.py é a única definição compartilhada de fontes, medidas, cores e quadro dos integrantes.

Os scripts deste diretório foram adaptados para caminhos relativos e fontes locais. O conteúdo e o layout dos PDFs foram preservados. Os scripts anteriores à adaptação estão nos ZIPs de continuidade/pacotes_fontes_aprovados/.

## Instalação e geração

A partir da raiz, com Python 3.11 ou superior:

```powershell
py -3 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements-documentacao.txt
.\.venv\Scripts\python.exe ferramentas/documentacao/gerar.py
```

A geração escreve em .build/documentacao/pdf/. Ela não altera os quatro PDFs finais por padrão. O gerador já interrompe se o conteúdo ultrapassar o espaço reservado nas páginas.

## Validação

```powershell
.\.venv\Scripts\python.exe ferramentas/documentacao/validar.py --alvo build
.\.venv\Scripts\python.exe ferramentas/documentacao/validar.py --alvo finais
```

A conferência verifica leitura dos arquivos, quantidade de páginas prevista, A4, integrantes e presença de evidências. Gera uma imagem de cada página em .build/documentacao/revisao/ para inspeção visual. Isso não valida o comportamento elétrico nem transforma uma captura em comprovação de um teste não realizado.

Compare as páginas com o modelo aprovado. Após revisar a nova geração, publique-a:

```powershell
.\.venv\Scripts\python.exe ferramentas/documentacao/gerar.py --publicar
```

Essa opção gera, valida e copia os quatro PDFs para seus destinos; o Git registra as mudanças. Não executa git add, commit ou push automaticamente: o Codex faz essas operações após revisar o diff e o remoto correto.

## Evidências

evidencias.json liga os nomes originais aos arquivos nas pastas dos projetos. Para substituir uma evidência por uma nova captura real, preserve a anterior e atualize o caminho e os recortes necessários no gerador. Quando uma imagem compartilhada tiver cópias nos dois projetos, mantenha as cópias coerentes. Não reconstituir gráficos nem textos de capturas.

documentos.json registra destinos e contagem de páginas esperada. Os rodapés dos geradores também possuem o total de páginas; se o conteúdo aumentar, revise essas contagens e a distribuição antes de publicar.

## Integridade inicial

verificar_pacote.py confere MANIFESTO_SHA256.json usando somente a biblioteca padrão do Python. O manifesto descreve os bytes do pacote inicial; após alterações legítimas, o histórico Git é a referência da evolução. Não regenerar esse manifesto para fazer arquivos modificados parecerem originais.
