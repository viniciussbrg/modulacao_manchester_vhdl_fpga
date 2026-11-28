# Tutorial de simulação — Manchester Diferencial

CENTRO EDUCACIONAL FACULDADE ENGENHEIRO SALVADOR ARENA

Sistemas Reconfiguráveis • Engenharia da Computação • 7º semestre

Professor Vinícius S. Borges • Grupo 5 • 2026

## 1. Preparar o ambiente

Utilize Vivado completo, com suporte a Artix-7, em Windows e fontes configurados como VHDL 2008. O XPR recebido foi salvo em 2026.1. Extraia o pacote inteiro em um caminho curto, por exemplo C:/VHDL/grupo5, antes de abrir os arquivos.

## 2. Abrir ou reconstruir o projeto

Abra vivado_project/manchester_diferencial.xpr por File > Open Project. Caso a versão ou os caminhos impeçam a abertura, feche o projeto, renomeie vivado_project para vivado_project_backup e execute criar_projeto.tcl por Tools > Run Tcl Script. O script importa os fontes e as constraints. Na raiz, criar_todos.tcl cria os dois projetos e abre o Manchester.

![Referência da interface do Vivado fornecida pelo grupo](midia/vivado_6.png)

## 3. Identificar as fontes

Em Design Sources, o top deve ser manchester_diferencial_top. O núcleo é line_encoder.vhd; input_conditioner.vhd sincroniza entradas e vga_colors.vhd gera vídeo. Em Simulation Sources, selecione manchester_diferencial_tb como top. O .xdc pertence a Constraints.

## 4. Configurar e executar

Confirme CLK_PERIOD=10 ns e CYCLES_PER_BIT=10 no testbench. Assim, BIT_PERIOD=100 ns, com duas metades de 50 ns. Execute Run Simulation > Run Behavioral Simulation. A janela inicial é 40 us. Se necessário, execute Run All. O log entregue registra PASS: manchester_diferencial_tb; CYCLES_PER_BIT=10 e término em 30486 ns.

## 5. Visualizar os sinais

Adicione clk, rst, sw, bit_index, data_bit, half_bit, encoded, led e active às ondas. Selecione Zoom Fit e amplie alguns bits, por exemplo 200 a 500 ns. Use decimal sem sinal para bit_index e binário ou hexadecimal para sw e led. Uma janela de poucos picossegundos oculta as transições.

![Sessão real de simulação fornecida pelo grupo](midia/vivado_6.png)

## 6. Interpretar e conferir

No início do bit, 0 inverte o nível anterior e 1 mantém esse nível. A metade do bit sempre inverte a saída. Após reset, a referência é baixa. A memória do nível também atravessa a passagem de SW0 para SW15. Confira índice 15 até 0, repetição, captura do switch apenas no começo do bit, reset mantido e reinício em 15. Somente o LED selecionado pode acompanhar encoded.

![Referência calculada, independente das capturas experimentais](midia/codificacoes.png)

Os padrões exercitados no teste são 0000, FFFF, AAAA, 5555, B2C9 e 8001, em hexadecimal. Há verificações de mudança dos switches e reset em diferentes fases. PASS indica que as assertions desse teste não detectaram falhas.

## 7. Executar os testes complementares

Pelo Tools > Run Tcl Script, execute scripts/simular_integracao.tcl e scripts/simular_vga.tcl. Eles verificam o top e dois quadros VGA, respectivamente. Registre PASS de cada um. Retorne ao teste principal com scripts/simular_core.tcl. A existência desses scripts não comprova sua execução no laboratório.

## Evidências e arquivos

O log original está em midia/simulate.log. As capturas reais recebidas mostram o ambiente do Vivado. O diagrama temporal foi calculado para explicar a regra; uma exportação legível das ondas reais com transições continua pendente.

## 8. Criar o projeto do zero pela interface

Para reproduzir sem utilizar o XPR recebido, selecione File > Project > New e informe um nome e uma pasta para o projeto. Escolha RTL Project. No dispositivo de destino, selecione xc7a35tcpg236-1. O nome do projeto pode ser manchester_diferencial.

Em Add Sources > Add or Create Design Sources, inclua src/input_conditioner.vhd, src/line_encoder.vhd, src/manchester_diferencial_top.vhd e saidas/vga/src/vga_colors.vhd. Marque Copy sources into project para manter as dependências junto ao projeto.

Em Add Sources > Add or Create Simulation Sources, inclua sim/manchester_diferencial_tb.vhd, sim/top_tb.vhd e sim/vga_tb.vhd. Em Add Sources > Add or Create Constraints, inclua constraints/manchester_diferencial.xdc.

Nas propriedades dos arquivos VHDL, configure File Type como VHDL 2008. Em Design Sources, selecione manchester_diferencial_top e use Set as Top. Em Simulation Sources, selecione manchester_diferencial_tb e use Set as Top. O top de síntese e o top de simulação possuem funções distintas no fluxo.

Na configuração de síntese, mantenha CYCLES_PER_BIT=100000000 para a observação lenta na placa. No testbench principal, mantenha o generic padrão igual a 10. Configure o tempo inicial da simulação como 40 us em Simulation Settings e execute Run Behavioral Simulation. Ajuste o zoom para visualizar os intervalos de 100 ns e confirme a mensagem PASS.

## 9. Salvar as capturas da reprodução

Registre Sources com os módulos e constraints, a configuração de simulação e uma janela das ondas com os sinais e a escala de tempo legíveis. Inclua uma região de reset, uma região de transmissão e a passagem de SW0 para SW15. Guarde essas capturas em docs/midia e mantenha os arquivos originais junto aos documentos.
