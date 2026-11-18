"""Gera as duas referências técnicas com o modelo de página dos tutoriais."""
from criar_tutoriais_simulacao import CONFIGS, Tutorial
from estilo_tutoriais import LEFT, NAVY, PALE, TEAL, WIDTH


def diagrama(doc, diferencial):
    """Fluxo do dado na borda de início e atualização na metade do bit."""
    doc.check(96)
    c = doc.c
    y = doc.y - 40
    largura = (WIDTH - 42) / 3
    blocos = [
        ('Seleção', 'data_in(bit_index)'),
        ('Regra do bit', 'inverte ou mantém' if diferencial else 'complementa o dado'),
        ('Nível registrado', 'encoded_reg'),
    ]
    for i, (titulo, sinal) in enumerate(blocos):
        x = LEFT + i * (largura + 21)
        c.setFillColor(PALE)
        c.roundRect(x, y, largura, 40, 4, fill=1, stroke=0)
        c.setFillColor(NAVY)
        c.setFont('BodyBold', 9.5)
        c.drawCentredString(x + largura / 2, y + 24, titulo)
        c.setFont('Body', 8.5)
        c.drawCentredString(x + largura / 2, y + 10, sinal)
        if i < len(blocos) - 1:
            c.setStrokeColor(TEAL)
            c.setLineWidth(1.2)
            ponta = x + largura + 18
            c.line(x + largura + 3, y + 20, ponta, y + 20)
            c.line(ponta - 4, y + 23, ponta, y + 20)
            c.line(ponta - 4, y + 17, ponta, y + 20)
    doc.y = y - 7
    doc.p('Figura 1. Caminho do dado na borda que inicia o bit. O contador determina a borda de início e a de meia duração. Fonte: elaboração própria (2026).', 'caption')


def criar(cfg):
    dif = cfg['dif']
    doc = Tutorial(dict(cfg, filename=f"documentacao_{cfg['project']}.pdf", paginas=3))
    doc.c.setTitle('Documentação do projeto — ' + cfg['title'])
    doc.c.setKeywords('VHDL, Basys 3, codificação de linha, interface, temporização, mapeamento de pinos')
    doc.start()
    doc.p('Documentação do projeto', 'title', gap=3)
    doc.p(cfg['title'], 'subtitle', gap=16)
    doc.members()
    doc.h2('Arquitetura do codificador')
    doc.p(f"O módulo <b>{cfg['entity']}</b> transmite os 16 switches da Basys 3 em ordem decrescente. Na borda de início de cada bit, seleciona a entrada da posição atual e armazena seu valor em <b>current_bit</b>. Uma mudança posterior no switch só afeta a próxima leitura daquela posição.")
    diagrama(doc, dif)
    if dif:
        doc.p('O registrador encoded_reg conserva o último nível transmitido. Na borda inicial, o dado 0 inverte esse nível e o dado 1 o mantém. Na borda central, o registrador sempre inverte. A memória de nível se conserva inclusive na passagem de SW0 para SW15.')
    else:
        doc.p('Na convenção IEEE 802.3, a primeira metade recebe o complemento do dado e a segunda, o valor capturado em current_bit. Assim, o bit 0 apresenta uma transição de descida no centro e o bit 1, de subida.')
    doc.p('A saída data_out acompanha encoded_reg. A lógica dos LEDs zera o vetor e atribui o nível registrado apenas a led(bit_index). Quando esse nível é baixo, todos os LEDs ficam apagados.')

    doc.start('Interface e temporização')
    doc.table(['Porta', 'Direção e tipo VHDL', 'Função'], [
        ['clk', 'in std_logic', 'Clock de 100 MHz na placa. A lógica sequencial usa a borda de subida.'],
        ['rst', 'in std_logic', 'Reset síncrono ativo em 1. Prepara o índice 15 e zera o nível da saída.'],
        ['data_in', 'in std_logic_vector(15 downto 0)', 'Vetor dos switches. Cada posição é lida no início do seu intervalo.'],
        ['data_out', 'out std_logic', 'Nível codificado, encaminhado ao PMOD e à lógica de cor no top.'],
        ['led', 'out std_logic_vector(15 downto 0)', 'Vetor de LEDs. Somente a posição em transmissão pode acender.'],
    ], [77, 160, WIDTH - 237], gap=4)
    doc.p('Fonte: elaboração própria (2026).', 'caption')
    doc.h2('Contagem e troca de posição')
    doc.p('O generic CYCLES_PER_BIT aceita um inteiro positivo. Uma asserção exige valor par e pelo menos dois ciclos. HALF_CYCLES vale metade desse número. Na borda em que a contagem anterior vale HALF_CYCLES − 1, começa a segunda metade. Quando vale CYCLES_PER_BIT − 1, o contador volta a zero e o próximo índice é selecionado.')
    doc.p('Enquanto rst está ativo, started permanece em zero. A primeira borda de subida após a liberação do reset inicia SW15. Ao final de SW0, o índice retorna a 15 sem intervalo ocioso.')
    doc.table(['Ambiente', 'Clock', 'Ciclos por bit', 'Tempo por bit / metade'], [
        ['Basys 3', '100 MHz', '100.000.000', '1 s / 0,5 s'],
        ['Testbench', '10 ns de período', '10', '100 ns / 50 ns'],
    ], [90, 125, 113, WIDTH - 328], gap=4)
    doc.p('Fonte: elaboração própria (2026).', 'caption')
    doc.h2('Resultado documentado na simulação')
    horario = '24.471' if dif else '19.641'
    doc.image(cfg['log'], cfg['log_box'],
              f"Figura 2. O registro histórico do XSim mostra o término das verificações do testbench em {horario} ns. Fonte: acervo dos autores (2026).",
              width=WIDTH - 40)

    doc.start('Mapeamento na Basys 3')
    doc.p('O projeto usa o componente xc7a35tcpg236-1. No XDC associado a constrs_1, as portas abaixo usam LVCMOS33. Em cada vetor, a sequência de pinos acompanha a ordem de índices indicada.')
    doc.table(['Porta e ordem', 'Pinos físicos'], [
        ['clk / rst', 'W5 (clock de 100 MHz) / U18 (BTNC)'],
        ['data_in[15:8]', 'R2, T1, U1, W2, R3, T2, T3, V2'],
        ['data_in[7:0]', 'W13, W14, V15, W15, W17, W16, V16, V17'],
        ['led[15:8]', 'L1, P1, N3, P3, U3, W3, V3, V13'],
        ['led[7:0]', 'V14, U14, U15, W18, V19, U19, E19, U16'],
        ['data_out', 'L2, contato JA2 do conector PMOD'],
        ['hsync / vsync', 'P19 / R19'],
        ['vgaRed[3:0]', 'N19, J19, H19, G19'],
        ['vgaGreen[3:0]', 'D17, G17, H17, J17'],
        ['vgaBlue[3:0]', 'J18, K18, L18, N18'],
    ], [160, WIDTH - 160], gap=4)
    doc.p('Fonte: elaboração própria (2026), a partir do XDC do projeto.', 'caption')
    doc.h2('Integração com o monitor e o osciloscópio')
    doc.p('O top usa o sinal codificado para selecionar a cor na área visível. Para nível baixo, RGB vale 0C0 em hexadecimal (verde). Para nível alto, vale FFF (branco). O IP clk_wiz_0 solicita 148,5 MHz a partir de 100 MHz. Com totais de 2.200 pixels por linha e 1.125 linhas por quadro, a taxa nominal é de 60 Hz para uma área ativa de 1920 × 1080.')
    doc.p('O mesmo nível codificado chega ao PMOD. A interface arquivada exporta um único sinal serial. A comparação simultânea com o dado original em outro canal permanece pendente.')
    doc.h2('Arquivos de referência')
    top = 'top_manchester_diff_vga' if dif else 'top_manchester_vga'
    doc.p(f"Codificador e testbench: src/{cfg['entity']}.vhd e sim/{cfg['tb']}.vhd. Integração: saidas/vga/src/{top}.vhd. Mapeamento: constraints/{cfg['entity']}.xdc. O codificador usa ieee.std_logic_1164. O projeto Vivado 2025.2 e o IP estão em vivado_project/.", 'small')
    doc.finish_page()
    doc.c.save()
    print(doc.path)


if __name__ == '__main__':
    for config in CONFIGS:
        criar(config)
