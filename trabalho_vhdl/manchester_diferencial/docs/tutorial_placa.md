# Tutorial de programação da Basys 3 — Manchester Diferencial

CENTRO EDUCACIONAL FACULDADE ENGENHEIRO SALVADOR ARENA

Sistemas Reconfiguráveis • Engenharia da Computação • 7º semestre

Professor Vinícius S. Borges • Grupo 5 • 2026

## 1. Preparar placa e projeto

Use Basys 3 (xc7a35tcpg236-1), cabo micro USB de dados, drivers de programação e Vivado com suporte Artix-7. Abra o projeto e confirme manchester_diferencial_top como top de síntese.

## 2. Selecionar o modo visual

Execute scripts/modo_leds_vga.tcl. O generic de síntese CYCLES_PER_BIT fica em 100000000, correspondente a 1 segundo por bit no clock de 100 MHz. Cada metade dura 0,5 s. O testbench mantém seu próprio parâmetro pequeno.

## 3. Sintetizar e implementar

Execute Run Synthesis. Após conclusão, execute Run Implementation. Inspecione Messages e os relatórios de utilização e timing. Registre o número de LUTs e flip-flops e os resultados de setup/hold. Corrija erros antes de continuar.

## 4. Gerar o bitstream

Clique em Generate Bitstream. Quando solicitado, autorize as etapas pendentes e selecione Launch runs on local host. Aguarde Bitstream Generation Completed. O .bit será gerado em vivado_project/manchester_diferencial.runs/impl_1/. A pasta efetiva acompanha o nome do projeto se ele tiver sido recriado com outro nome.

![Janela real de lançamento do Generate Bitstream, registrada no projeto Manchester](midia/geracao_referencia.png)

## 5. Conectar e programar

Conecte o cabo na porta PROG da placa, ligue-a e abra Open Hardware Manager > Open Target > Auto Connect. Selecione Program Device, confira a FPGA e associe o .bit gerado neste projeto. Clique em Program. A programação JTAG é volátil e deve ser repetida após desligar a placa.

## 6. Operar e observar

SW15 a SW0 representam os 16 bits. BTNC mantém o codificador em reset enquanto pressionado. Ao soltar, a transmissão começa em SW15, avança até SW0 e repete. O LED da posição atual apresenta o nível codificado; os demais ficam apagados. No início do bit, 0 inverte o nível anterior e 1 mantém esse nível. A metade do bit sempre inverte a saída. Após reset, a referência é baixa. A memória do nível também atravessa a passagem de SW0 para SW15.

![Placa em demonstração física pelo grupo](midia/manchester_diferencial_2.jpg)

## 7. Reproduzir os ensaios

Teste todos os switches baixos, todos altos, alternados e B2C9. Pressione BTNC no meio da sequência e observe o reinício. Altere o switch durante seu bit e confira a mudança na próxima captura da posição. Grave cada caso com a posição e a duração visíveis. Uma sequência completa dura 16 s no modo padrão.

## Evidências disponíveis

A imagem acima foi extraída do vídeo original preservado em midia. O conjunto recebido não inclui o .bit nem relatórios de timing e recursos. A captura da janela de geração mostra o lançamento da tarefa, sem comprovar sua conclusão. Os vídeos registram a demonstração física relatada pelo grupo.

## Mapeamento de uso na placa

| Controle ou saída | Função | Resultado esperado |
|---|---|---|
| SW15 a SW0 | Representam os 16 bits de entrada | Transmissão de SW15 até SW0, seguida de repetição |
| BTNC | Reset ativo enquanto pressionado | Saída baixa; ao soltar, reinício em SW15 |
| LD15 a LD0 | Observação do sinal codificado por posição | Somente o LED da posição atual acompanha o código |
| Clock da placa | Base de tempo de 100 MHz | Com 100000000 ciclos por bit, intervalo de 1 s |

A tabela completa de pinos encontra-se em documentacao_projeto.pdf e no arquivo XDC do projeto. Após gerar e gravar o bitstream, registre a placa com os padrões de todos os bits baixos, todos altos e alternados. Registre também reset e mudança de switches durante a transmissão.
