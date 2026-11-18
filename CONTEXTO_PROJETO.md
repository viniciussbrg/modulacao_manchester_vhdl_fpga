# Contexto para continuidade — 17 de novembro de 2026

Este arquivo é um registro de trabalho para o Codex. Não é um capítulo dos tutoriais.

## Identificação

Faculdade Engenheiro Salvador Arena. Engenharia da Computação — 7° Semestre.
Disciplina: Comunicação de Dados — Sistemas Reconfiguráveis, conforme os guias.

| Nome | RA |
|---|---|
| Victor Mendes de Andrade Ferreira | 082230015 |
| Lucas Junqueira Gonçalves | 082230029 |
| Murilo Umbelino Oliveira dos Santos | 082230013 |
| Guilherme Alves Barbosa | 082220014 |

## Objetivo e escopo

Dois codificadores em VHDL, Manchester básico e Manchester Diferencial, em projetos Vivado separados. A fase atual no Codex trata de documentos, pastas e GitHub. Os códigos foram incluídos para leitura técnica e preservação, sem autorização para mudar o hardware nesta fase.

Raiz local indicada: `D:\Pessoal - Victor\Matérias Facul\EC7\Comunicação de Dados\N2B2`.

## Ambiente documentado

| Item | Valor |
|---|---|
| Vivado | 2025.2, com XSim |
| Sistema operacional | Windows 11 25H2 |
| Placa | Digilent Basys 3 |
| Projetos | manchester.xpr e manchester_diferencial.xpr |
| Osciloscópio | Analog Discovery 3 |
| Software de medição | WaveForms 3.24.4 |
| Scope utilizado | C1 habilitado, C2 desabilitado; 2 s/div; 1 V/div; offset 0 V; 1,6 kHz; 32.000 amostras |

As configurações descrevem as evidências históricas; não comprovam que os aplicativos estejam instalados no novo computador.

## Comportamento dos codificadores

- Ordem de transmissão: SW15 até SW0, com repetição cíclica.
- Cada switch é capturado no início de seu próprio intervalo; alterações no meio não modificam o bit em andamento.
- Manchester básico, convenção IEEE 802.3: 0 = alto/baixo; 1 = baixo/alto.
- Manchester Diferencial: 0 inverte no início; 1 mantém o nível anterior no início; sempre há inversão no meio. Reset deixa a saída baixa.
- Na placa, clock de 100 MHz e CYCLES_PER_BIT = 100.000.000: 1 s por bit e 0,5 s por metade.
- No testbench, clock de 10 ns e 10 ciclos por bit: 100 ns por bit. Nas capturas o primeiro bit começa em 100 ns.
- Simulação básica: 9 cenários, mensagem de sucesso em 19.641 ns. Diferencial: 10 cenários, sucesso em 24.471 ns. Esses resultados são os registrados nos logs das capturas, não uma execução nova feita no novo computador.
- Top de simulação: manchester_tb e manchester_dif_tb. Nas capturas, top de implementação básico: top_manchester_vga; diferencial: manchester_dif.

## Estado dos documentos

Os quatro tutoriais passaram pela revisão editorial e uniformização visual. Os PDFs aprovados foram copiados sem alteração de bytes para as pastas de entrega. A portabilidade dos geradores foi ajustada somente nos caminhos de arquivo e de fontes. Os geradores originais permanecem nos dois ZIPs de fontes.

| Documento | Páginas | Caminho |
|---|---:|---|
| Simulação — básico | 8 | manchester/docs/tutorial_simulacao.pdf |
| Simulação — diferencial | 8 | manchester_diferencial/docs/tutorial_simulacao.pdf |
| PMOD — básico | 11 | manchester/saidas/pmod_osciloscopio/docs/tutorial_pmod.pdf |
| PMOD — diferencial | 11 | manchester_diferencial/saidas/pmod_osciloscopio/docs/tutorial_pmod.pdf |

Não há DOCX original: a edição fiel desses tutoriais é feita pelos geradores Python. Não reconstruir a formatação a partir de texto extraído do PDF.

## Modelo visual aprovado

Fonte DejaVu Sans; papel A4. Conteúdo com laterais de 48 pt, topo de 60 pt e limite inferior de 57 pt. Corpo 10 pt / entrelinha 14,5 pt; legendas 8,1 / 11,4 pt; células 9,1 / 12,3 pt. Título 24 / 29 pt; subtítulo 19 / 24 pt; H1 17 / 22 pt; H2 11,2 / 15,5 pt. Azul-marinho #17364D e verde-azulado #117D8A. Cabeçalhos, rodapés e quadro dos integrantes são compartilhados.

Esse padrão reproduz o modelo de simulação aprovado pelo autor. Não afirmar conformidade integral com uma norma ABNT de apresentação sem verificá-la; as escolhas gráficas acima não equivalem automaticamente às margens e ao corpo usuais de um trabalho acadêmico. Preservar o modelo solicitado e as referências, sem adicionar explicações de formatação dentro dos tutoriais.

## Decisões de redação

Os textos devem parecer escritos pelos autores. Foram removidos trechos sobre recebimento de arquivos, informações repassadas pelo grupo, organização da entrega e descrição da própria formatação. Não reintroduzir esses trechos. Manter a descrição técnica objetiva e passos reproduzíveis para iniciantes.

## Fontes e estrutura

Os requisitos estão em referencias/professor/. A estrutura principal segue a página 4 de guia_entrega.pdf. O nome local N2B2 corresponde à raiz do trabalho; não é necessário criar outra camada N2B2/N2B2 ou uma pasta adicional apenas por causa do nome ilustrativo modulacao_manchester/ no guia.

As pastas ferramentas/, referencias/ e continuidade/ são apoio à manutenção, não exigências adicionais atribuídas ao professor. Cada codificador contém seus próprios fontes e evidências; imagens compartilhadas foram copiadas para os dois projetos para preservar essa autonomia.

## Fluxo de entrega confirmado no guia

1. Um integrante cria o fork do repositório oficial: https://github.com/viniciussbrg/modulacao_manchester_vhdl_fpga.
2. O desenvolvimento fica na main do fork; os demais integrantes são colaboradores.
3. Commits e pushes incrementais vão ao fork.
4. Ao concluir o trabalho, abre-se PR do fork/main para a branch grupoX do repositório oficial.
5. Título sugerido pelo guia: Entrega - Grupo X - Nome dos integrantes.

O número do grupo, a URL do fork, a identidade Git e o nome completo do professor não estão definidos neste pacote. Não deduzir a identidade do professor pelo nome de usuário do GitHub.


## Atualização após a integração do fork

O fork confirmado é [vmafdev/modulacao_manchester_vhdl_fpga](https://github.com/vmafdev/modulacao_manchester_vhdl_fpga). O commit `6bbbb59` já continha os dois arquivos ZIP de Vivado. Os XPRs, fontes referenciados, XDCs ativos, IPs, configurações de onda e bitstreams estão organizados por projeto. A seleção de top das capturas históricas difere da configuração salva para simulação do básico. Consulte a [auditoria atualizada](PENDENCIAS.md) para as evidências e o estado da entrega. As duas referências técnicas em docs/documentacao_projeto.pdf acrescentam seis páginas aos quatro tutoriais originais. O grupo fará o PR manualmente.
