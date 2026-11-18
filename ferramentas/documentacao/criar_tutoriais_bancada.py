"""Tutoriais de programação e de saída VGA dos dois projetos da Basys 3."""
from PIL import Image

from caminhos_documentacao import localizar_midia
from criar_tutoriais_simulacao import CONFIGS, Tutorial
from estilo_tutoriais import WIDTH


def fotografia(doc, nome, largura, legenda):
    with Image.open(localizar_midia(nome)) as foto:
        caixa = (0, 0, *foto.size)
    doc.image(nome, caixa, legenda + ' Fonte: acervo dos autores (2026).', width=largura)


def abrir(cfg, tipo, titulo, paginas):
    doc = Tutorial(dict(cfg, filename=f"tutorial_{tipo}_{cfg['project']}.pdf", paginas=paginas))
    doc.c.setTitle(titulo + ' — ' + cfg['title'])
    doc.c.setKeywords('Basys 3, Vivado 2025.2, programação JTAG, VGA, codificação de linha')
    doc.start()
    doc.c.bookmarkPage('capa')
    doc.c.addOutlineEntry('Objetivo e materiais', 'capa', 0, False)
    doc.p(titulo, 'title', gap=3)
    doc.p(cfg['title'], 'subtitle', gap=16)
    doc.members()
    return doc


def placa(cfg):
    doc = abrir(cfg, 'placa', 'Programação da Basys 3', 4)
    doc.h2('Objetivo')
    doc.p('Gravar o bitstream via USB/JTAG e acompanhar a transmissão dos 16 switches nos LEDs. Reserve a Basys 3, um cabo micro-USB de dados e um computador com Vivado 2025.2, suporte a Artix-7 e drivers do cabo Digilent instalados.')
    doc.h2('Escolha o projeto')
    doc.p(f"Abra a pasta <b>{cfg['project']}</b>. Em vivado_project/projeto/{cfg['project']}/, abra <b>{cfg['project']}.xpr</b>. Em Project Settings, confira o componente xc7a35tcpg236-1. Mantenha a estrutura de diretórios para que o Vivado encontre os fontes e o IP.")
    doc.note('Para usar o bitstream arquivado, pule a geração da página 2 e siga para a conexão da página 3. Os dois projetos usam o nome top_manchester_vga.bit. Confira o nome da pasta do codificador antes de programar.')

    doc.start('1. Gerar o bitstream')
    doc.step(1, f"Expanda <b>Design Sources</b>. Confira a entidade de implementação <b>top_manchester_vga</b> e a instância do codificador <b>{cfg['entity']}</b>. Em Constraints, confira o XDC do projeto. O testbench é usado apenas na simulação.")
    doc.step(2, 'No Flow Navigator, selecione <b>Run Synthesis</b>. Aguarde a conclusão e consulte Messages caso apareça um erro.')
    doc.step(3, 'Selecione <b>Run Implementation</b>. Aguarde a conclusão do posicionamento e roteamento antes de avançar.')
    doc.step(4, 'Clique em <b>Generate Bitstream</b>. Após a conclusão, localize top_manchester_vga.bit na pasta .runs/impl_1 do projeto aberto.')
    doc.image('image(3).png',(0,775,254,890),'Figura 1. Comandos de geração do bitstream e acesso ao Hardware Manager no Flow Navigator. Fonte: acervo dos autores (2026).',width=248)
    doc.h2('Bitstream arquivado')
    doc.p(f"Para gravar a versão arquivada, selecione <b>{cfg['project']}/vivado_project/bitstream/top_manchester_vga.bit</b>. Anote o caminho escolhido ao registrar a demonstração.")

    doc.start('2. Conectar e programar a placa')
    doc.step(1, 'Com a placa desligada, confira a seleção de alimentação USB em JP2. Conecte o cabo de dados à porta micro-USB marcada PROG (J4) e ao computador. Ligue a chave POWER.')
    fotografia(doc,'basys3_usb',177,'Figura 2. Cabo conectado a J4. A foto também mostra a fileira de switches, os botões e o indicador DONE aceso.')
    doc.step(2, 'No Vivado, abra <b>Open Hardware Manager → Open Target → Auto Connect</b>. Expanda o alvo e selecione o dispositivo xc7a35t.')
    doc.step(3, 'Clique em <b>Program Device</b>. Confira o caminho completo no campo Bitstream file e clique em <b>Program</b>. Aguarde a conclusão no Hardware Manager e confira o LED DONE (LD19).')
    doc.note('Se o dispositivo não aparecer, confira a alimentação, o cabo de dados em J4 e a instalação do driver Digilent. O indicador DONE informa que a FPGA está configurada. Para identificar a versão, confira também o arquivo selecionado no Vivado.')

    doc.start('3. Testar switches, LEDs e reset')
    doc.step(1, 'Abaixe todos os switches e mantenha o botão central BTNC pressionado. Os LEDs de dados devem ficar apagados. Solte BTNC e comece a observar em LD15.')
    doc.step(2, 'Acompanhe a posição de LD15 até LD0. Cada bit dura 1 s e cada metade dura 0,5 s. Na metade de nível baixo todos os LEDs de dados ficam apagados. Após LD0, a transmissão volta a LD15.')
    if cfg['dif']:
        rows = [
            ['0000', 'Todos os bits 0', 'LD15 acende/apaga. LD14 também acende/apaga.'],
            ['FFFF', 'Todos os bits 1', 'LD15 apaga/acende. LD14 acende/apaga, pois conserva o nível anterior na entrada do bit.'],
            ['AAAA', 'SW15 = 1 e SW14 = 0', 'LD15 apaga/acende. LD14 apaga/acende após a inversão no início do bit 0.'],
        ]
    else:
        rows = [
            ['0000', 'Todos os bits 0', 'LD15 acende/apaga. LD14 repete a descida.'],
            ['FFFF', 'Todos os bits 1', 'LD15 apaga/acende. LD14 repete a subida.'],
            ['AAAA', 'SW15 = 1 e SW14 = 0', 'LD15 apaga/acende. LD14 acende/apaga.'],
        ]
    doc.table(['SW15…SW0 (hex)', 'Configuração', 'Primeira / segunda metade após soltar BTNC'], rows,[99,123,WIDTH-222],gap=4)
    doc.p('Quadro 1. Comportamento esperado a partir do reset. Fonte: elaboração própria (2026).','caption')
    doc.step(3, 'Repita o reset antes de comparar cada padrão. Durante uma transmissão, mude um switch após o início do seu bit. Observe a mesma posição na volta seguinte do ciclo.')
    doc.image('basys3_usb',(357,1425,953,1750),'Figura 3. Detalhe de LD4 aceso, da fileira de switches e do botão central BTNC. A fotografia registra uma posição em um instante. Fonte: acervo dos autores (2026).',width=245)
    doc.finish_page()
    doc.c.save()


def vga(cfg):
    doc = abrir(cfg, 'vga', 'Tutorial da saída VGA', 3)
    doc.h2('Montagem')
    doc.p('Utilize a Basys 3, o cabo USB de programação, um cabo VGA e um monitor com entrada VGA compatível com 1920 × 1080 a 60 Hz. A resolução e a taxa são os valores nominais do projeto.')
    doc.step(1, 'Com a placa desligada, conecte o cabo VGA ao conector de 15 contatos da Basys 3 e à entrada VGA do monitor. Aperte os parafusos do conector. Selecione VGA ou Analog no menu de entrada do monitor.')
    doc.step(2, f"Conecte o cabo de dados a J4, ligue a placa e abra o Hardware Manager. Programe o arquivo <b>{cfg['project']}/vivado_project/bitstream/top_manchester_vga.bit</b>. O passo a passo de programação está em docs/tutorial_placa.pdf, dentro deste projeto.")
    doc.h2('Sinal que controla a cor')
    doc.p('Na área visível, o monitor passa a branco na subida do sinal codificado e permanece branco enquanto o nível é alto. Na descida, passa a verde e permanece verde enquanto o nível é baixo. O LED da posição em transmissão acompanha esse mesmo sinal.')

    doc.start('1. Reconhecer as duas cores')
    doc.p('Observe primeiro o cabo azul na placa e a entrada escolhida no monitor. As fotografias de bancada abaixo servem como referência das duas cores nos dois tutoriais.')
    w = 198
    top = doc.y
    for i, nome in enumerate(('vga_branco','vga_verde')):
        with Image.open(localizar_midia(nome)) as foto:
            box = (0, 0, *foto.size)
        altura = doc.draw_crop(nome, box, 68 + i * 254, top, w)
    doc.y = top - altura - 8
    doc.p('Figura 1. À esquerda, tela branca, cor do nível alto. À direita, tela verde, cor do nível baixo. A Basys 3 e o cabo VGA aparecem nas duas fotografias. Fonte: acervo dos autores (2026).','caption')
    doc.step(1, 'Mantenha BTNC pressionado. Com a saída codificada em zero, a tela deve permanecer verde. Solte BTNC para iniciar a transmissão em SW15.')
    doc.step(2, 'Observe a tela e o LED da posição atual na primeira e na segunda metade do bit. A mudança central ocorre 0,5 s após o início do intervalo. A passagem de um bit para outro também pode alterar a cor.')
    doc.note('As imagens registram dois estados. Para conferir a ordem das mudanças, acompanhe a tela e os LEDs desde a liberação de BTNC.')

    doc.start('2. Conferir a sequência no monitor')
    doc.step(1, 'Levante SW15 e SW14 e abaixe SW13. Pressione e solte BTNC. Acompanhe os primeiros três segundos. Os demais switches só entram em transmissão depois desse trecho.')
    if cfg['dif']:
        rows = [['SW15 = 1', 'Verde → branco', 'O nível baixo do reset foi mantido no início.'],
                ['SW14 = 1', 'Branco → verde', 'O nível alto anterior é mantido. A descida ocorre no meio.'],
                ['SW13 = 0', 'Branco → verde', 'O nível baixo anterior inverte no início e volta a inverter no meio.']]
    else:
        rows = [['SW15 = 1', 'Verde → branco', 'A subida central representa 1.'],
                ['SW14 = 1', 'Verde → branco', 'O segundo 1 repete a subida central.'],
                ['SW13 = 0', 'Branco → verde', 'A descida central representa 0.']]
    doc.table(['Bit após o reset', '1ª → 2ª metade', 'Leitura esperada'],rows,[105,130,WIDTH-235],gap=4)
    doc.p('Quadro 1. Previsão para a sequência inicial 110. Fonte: elaboração própria (2026).','caption')
    doc.step(2, 'Repita a sequência com os três switches abaixados. Confira as mudanças no centro de cada bit e observe a passagem entre as posições dos LEDs.')
    doc.h2('Se o monitor indicar ausência de sinal')
    doc.p('Confira a entrada VGA selecionada, o encaixe nas duas pontas e o suporte ao modo de vídeo. No Hardware Manager, confirme o dispositivo e o bitstream do projeto. O top de implementação inclui os sinais de sincronismo e os canais RGB.')
    doc.h2('Registro do ensaio')
    doc.p('Enquadre o monitor e os LEDs. Registre o projeto gravado, a posição dos switches e o instante em que BTNC é solto. Grave alguns bits consecutivos para relacionar cada mudança de cor à posição em transmissão.')
    doc.finish_page()
    doc.c.save()


if __name__ == '__main__':
    for config in CONFIGS:
        placa(config)
        vga(config)
