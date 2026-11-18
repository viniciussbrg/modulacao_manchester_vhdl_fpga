from pathlib import Path
from xml.sax.saxutils import escape
import json
from PIL import Image
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.platypus import Paragraph, Table, TableStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfbase.pdfdoc import PDFString
from pypdf import PdfReader

from caminhos_documentacao import ROOT, BUILD, localizar_midia
OUT = BUILD / 'pdf'
OUT.mkdir(parents=True, exist_ok=True)
from estilo_tutoriais import (
    FONT, NAVY, TEAL, INK, MUTED, PALE, LINE, WHITE,
    PW, PH, LEFT, RIGHT, TOP, BOTTOM, WIDTH,
    BODY_GAP, STEP_GAP, HEADING_GAP, SUBHEADING_GAP,
    TABLE_FONT, TABLE_LEADING, TABLE_PAD, TABLE_HORIZONTAL_PAD,
    STYLES, group_table,
)

M = LEFT
W = WIDTH

MEMBERS = [
    ['Victor Mendes de Andrade Ferreira', '082230015'],
    ['Lucas Junqueira Gonçalves', '082230029'],
    ['Murilo Umbelino Oliveira dos Santos', '082230013'],
    ['Guilherme Alves Barbosa', '082220014'],
]

def para(text, style='body'):
    return Paragraph(text, STYLES[style])

class Tutorial:
    def __init__(self, cfg):
        self.cfg = cfg
        self.path = OUT / cfg['filename']
        self.c = canvas.Canvas(str(self.path), pagesize=A4, pageCompression=1)
        self.c.setTitle('Tutorial de simulação - ' + cfg['title'])
        self.c.setAuthor('; '.join(x[0] for x in MEMBERS))
        self.c.setSubject('Faculdade Engenheiro Salvador Arena - Engenharia da Computação - 7° Semestre')
        self.c.setKeywords('Vivado 2025.2, VHDL, XSim, Manchester, Basys 3, tutorial de simulação')
        self.c._doc.Catalog.Lang = PDFString('pt-BR')
        self.page = 0
        self.lowest = {}

    def start(self, section=None):
        if self.page:
            self.finish_page()
            self.c.showPage()
        self.page += 1
        self.y = PH - TOP
        self.c.setStrokeColor(LINE)
        self.c.setLineWidth(.6)
        self.c.line(M, PH-40, PW-M, PH-40)
        self.c.setFillColor(MUTED)
        self.c.setFont('Body', 7.1)
        self.c.drawString(M, PH-29, 'FACULDADE ENGENHEIRO SALVADOR ARENA')
        self.c.drawRightString(PW-M, PH-29, self.cfg['short'].upper() + ' | VIVADO 2025.2')
        if section:
            self.c.bookmarkPage('p'+str(self.page))
            self.c.addOutlineEntry(section, 'p'+str(self.page), 0, False)
            self.p(section, 'h1', gap=HEADING_GAP)

    def check(self, height):
        if self.y-height < BOTTOM:
            raise RuntimeError(f"Overflow {self.cfg['short']} página {self.page}: y={self.y:.1f}, h={height:.1f}")

    def finish_page(self):
        self.lowest[self.page] = round(self.y, 1)
        self.c.setStrokeColor(LINE)
        self.c.setLineWidth(.6)
        self.c.line(M, 43, PW-M, 43)
        self.c.setFont('Body', 7.4)
        self.c.setFillColor(MUTED)
        self.c.drawString(M, 29, 'Engenharia da Computação | 7° Semestre | Novembro de 2026')
        self.c.drawRightString(PW-M, 29, f"{self.page} / {self.cfg.get('paginas', 8)}")

    def p(self, text, style='body', gap=BODY_GAP, width=None, x=None):
        p = para(text, style)
        _, h = p.wrap(width or W, 1000)
        self.check(h+gap)
        p.drawOn(self.c, M if x is None else x, self.y-h)
        self.y -= h+gap

    def h2(self, text):
        self.p(text, 'h2', gap=SUBHEADING_GAP)

    def step(self, n, text):
        self.p(f'<b>{n}.</b> {text}', gap=STEP_GAP)

    def table(self, headers, rows, widths=None, gap=12):
        widths = widths or [W/len(headers)]*len(headers)
        cellstyle = STYLES['cell']
        cells = [[para(escape(str(x)), 'headcell') for x in headers]]
        for row in rows:
            cells.append([Paragraph(str(x),cellstyle) for x in row])
        t = Table(cells, colWidths=widths, hAlign='LEFT')
        ts = [('BACKGROUND',(0,0),(-1,0),NAVY), ('VALIGN',(0,0),(-1,-1),'TOP'),
              ('LEFTPADDING',(0,0),(-1,-1),TABLE_HORIZONTAL_PAD), ('RIGHTPADDING',(0,0),(-1,-1),TABLE_HORIZONTAL_PAD),
              ('TOPPADDING',(0,0),(-1,-1),TABLE_PAD), ('BOTTOMPADDING',(0,0),(-1,-1),TABLE_PAD),
              ('LINEBELOW',(0,0),(-1,0),.4,NAVY), ('LINEBELOW',(0,1),(-1,-1),.35,LINE)]
        for i in range(1,len(cells)):
            if i%2: ts.append(('BACKGROUND',(0,i),(-1,i),PALE))
        t.setStyle(TableStyle(ts))
        _,h = t.wrap(W,1000)
        self.check(h+gap)
        t.drawOn(self.c,M,self.y-h)
        self.y -= h+gap

    def code(self, text, gap=10):
        lines = text.splitlines()
        fs = 9.1
        h = 15*len(lines)+18
        self.check(h+gap)
        self.c.setFillColor(PALE)
        self.c.roundRect(M,self.y-h,W,h,5,stroke=0,fill=1)
        self.c.setFillColor(NAVY)
        self.c.setFont('Mono',fs)
        for i,line in enumerate(lines):
            if pdfmetrics.stringWidth(line,'Mono',fs) > W-22:
                raise RuntimeError('Código muito largo: '+line)
            self.c.drawString(M+11,self.y-18-15*i,line)
        self.y -= h+gap

    def note(self, text, gap=10):
        p=para(text,'small')
        _,h=p.wrap(W-25,1000)
        self.check(h+20+gap)
        self.c.setFillColor(PALE)
        self.c.rect(M,self.y-h-20,W,h+20,stroke=0,fill=1)
        self.c.setFillColor(TEAL)
        self.c.rect(M,self.y-h-20,3,h+20,stroke=0,fill=1)
        p.drawOn(self.c,M+13,self.y-h-10)
        self.y -= h+20+gap

    def draw_crop(self, filename, box, x, top, width):
        # Place unchanged screenshot bytes behind a PDF clipping rectangle.
        # No pixels, labels, values or waveform transitions are regenerated.
        path=localizar_midia(filename)
        iw,ih=Image.open(path).size
        left,t,right,bottom=box
        scale=width/(right-left)
        height=(bottom-t)*scale
        c=self.c
        c.saveState()
        clip=c.beginPath();clip.rect(x,top-height,width,height)
        c.clipPath(clip,stroke=0,fill=0)
        c.drawImage(str(path),x-left*scale,top-(ih-t)*scale,width=iw*scale,height=ih*scale)
        c.restoreState()
        return height

    def image(self, filename, box, caption, width=None, gap=12):
        width=width or W
        height=(box[3]-box[1])*width/(box[2]-box[0])
        self.check(height+35)
        x=M+(W-width)/2
        self.draw_crop(filename,box,x,self.y,width)
        self.c.setStrokeColor(LINE);self.c.setLineWidth(.5)
        self.c.rect(x,self.y-height,width,height,stroke=1,fill=0)
        self.y -= height+6
        self.p(caption,'caption',gap=gap)

    def wave(self, filename, top, bottom, caption):
        # Align name and trace crops at their original vertical coordinates.
        name_right=972 if self.cfg['dif'] else 990
        name_width=name_right-810
        namebox=(810,top,name_right,bottom)
        tracebox=(1206,top,1893,bottom)
        scale=W/(name_width+687)
        h=(bottom-top)*scale
        self.check(h+35)
        self.draw_crop(filename,namebox,M,self.y,name_width*scale)
        self.draw_crop(filename,tracebox,M+name_width*scale,self.y,687*scale)
        self.y-=h+6
        self.p(caption,'caption',gap=12)

    def members(self):
        t = group_table(MEMBERS)
        _, h = t.wrap(W, 1000)
        self.check(h + 18)
        t.drawOn(self.c, M, self.y - h)
        self.y -= h + 18

    def build(self):
        q=self.cfg
        dif=q['dif']
        self.start()
        self.c.bookmarkPage('p1');self.c.addOutlineEntry('Apresentação e pré-requisitos','p1',0,False)
        self.p('Tutorial de simulação','title',gap=3)
        self.p(q['title'],'subtitle',gap=16)
        self.members()
        self.h2('Objetivo')
        self.p(f"Reproduzir a simulação comportamental do codificador <b>{q['entity']}</b> no Vivado, acompanhar a sequência de 16 bits e conferir o resultado das verificações automáticas do testbench.")
        self.p('O roteiro verifica as saídas lógicas <b>data_out</b> e <b>led</b>. A integração VGA e a medição física pelo PMOD pertencem aos tutoriais específicos dessas saídas.', 'small', gap=13)
        self.h2('Pré-requisitos e ambiente utilizado')
        self.table(['Item','Configuração'],[
            ['Ferramenta','AMD Vivado 2025.2, com Vivado Simulator (XSim)'],
            ['Sistema operacional','Windows 11, versão 25H2'],
            ['Linguagem','VHDL; fontes e testbench compatíveis com VHDL-93'],
            ['Projeto',q['project']+'.xpr, em projeto independente'],
            ['Equipamento','Computador com o projeto e os arquivos-fonte disponíveis. A simulação é executada no próprio Vivado.'],
        ],[125,W-125],gap=12)
        self.p('A simulação utiliza 10 ciclos de clock por bit, conforme os parâmetros definidos no testbench.', 'caption',gap=0)

        self.start('1. Abra o projeto e confira os arquivos')
        self.step(1,'Abra o Vivado 2025.2 e escolha <b>Open Project</b> na tela inicial.')
        self.step(2,'Na pasta de entrega do codificador, abra o arquivo <b>.xpr</b> localizado em <b>vivado_project/</b>:')
        self.code(q['folder']+'/vivado_project/'+q['project']+'.xpr')
        self.step(3,'Aguarde o carregamento. No painel <b>Sources</b>, expanda <b>Design Sources</b>, <b>Simulation Sources → sim_1</b> e <b>Constraints</b>.')
        self.image(q['sources'],q['sources_box'],'Figura 1. Estrutura do projeto no painel Sources. Fonte: acervo dos autores (2026).',width=410,gap=12)
        self.table(['Arquivo / módulo','Onde localizar e finalidade'],[
            [q['entity']+'.vhd','Design Sources: implementação do codificador.'],
            [q['tb']+'.vhd','Simulation Sources: geração do clock, estímulos e verificações.'],
            [q['tb'],'Top de simulação; contém a instância <b>dut</b> do codificador.'],
            ['constraints.xdc','Constraints: restrições de pinos e clock usadas na implementação física.'],
        ],[165,W-165],gap=9)
        if dif:
            self.p('Na captura, <b>manchester_dif</b> é o top de implementação e <b>manchester_dif_tb</b> é o top de simulação. Mantenha os arquivos do projeto juntos ao transferi-lo para outro computador.', 'small', gap=0)
        else:
            self.p('Na captura, <b>top_manchester_vga</b> é o top de implementação. Expanda sua hierarquia para localizar o codificador. Para este roteiro, o top de simulação é <b>manchester_tb</b>, que instancia diretamente <b>manchester</b>.', 'small',gap=0)

        self.start('2. Configure e abra a simulação')
        self.step(1,f"Em <b>Simulation Sources → sim_1</b>, clique com o botão direito em <b>{q['tb']}</b> e selecione <b>Set as Top</b>. Confira o nome em negrito na hierarquia.")
        self.step(2,'Salve os arquivos abertos e confira os parâmetros definidos no testbench. Para reproduzir as capturas, mantenha os valores abaixo.')
        self.table(['Parâmetro / grandeza','Valor utilizado'],[
            ['CLK_PERIOD','10 ns (clock de 100 MHz)'],
            ['SIM_CYCLES_PER_BIT','10 ciclos'],
            ['BIT_PERIOD','10 ns × 10 = 100 ns'],
            ['Duração de cada metade','50 ns'],
            ['INITIAL_RESET_CYCLES','9 bordas de subida; liberação inicial em 95 ns'],
        ],[235,W-235],gap=10)
        self.p('O valor padrão de <b>CYCLES_PER_BIT</b> no codificador é 100_000_000. O <b>generic map</b> do testbench substitui esse valor por 10 durante a simulação. Os parâmetros são definidos no testbench, sem alterações adicionais nas configurações do Vivado.', 'small',gap=12)
        self.step(3,'No <b>Flow Navigator</b>, abra <b>Run Simulation</b> e selecione <b>Run Behavioral Simulation</b>. Aguarde a compilação e a abertura do simulador.')
        self.image(q['menu'],q['menu_box'],'Figura 2. Caminho para iniciar a simulação comportamental. Fonte: acervo dos autores (2026).',width=440,gap=10)
        self.note(f"<b>Conferência:</b> a faixa superior da simulação deve identificar <b>{q['tb']}</b>, e o painel <b>Scope</b> deve apresentar esse testbench com a instância <b>dut</b>.",gap=0)

        self.start('3. Adicione os sinais à janela Wave')
        self.step(1,f"Em <b>Scope</b>, selecione <b>{q['tb']}</b>. No painel <b>Objects</b>, selecione os sinais do testbench indicados na tabela e use <b>Add to Wave Window</b> no menu do botão direito.")
        self.step(2,'Expanda o testbench, selecione <b>dut</b> e adicione os sinais internos. Os sinais também podem ser arrastados de Objects para Wave. [1]')
        # Two adjacent excerpts retain the original screenshot content.
        self.check(145)
        top=self.y
        self.draw_crop(q['initial'],q['scope_box'],M,top,232)
        self.draw_crop(q['initial'],q['objects_box'],M+W-232,top,232)
        self.y-=max((q['scope_box'][3]-q['scope_box'][1])*232/(q['scope_box'][2]-q['scope_box'][0]),
                    (q['objects_box'][3]-q['objects_box'][1])*232/(q['objects_box'][2]-q['objects_box'][0]))+5
        self.p('Figura 3. Identificação do testbench, instância dut e painel Objects. Fonte: acervo dos autores (2026).','caption',gap=10)
        self.table(['Origem','Sinais','Uso na conferência'],[
            ['Testbench','clk, rst','Clock e reset.'],
            ['Testbench','data_in','Sequência aplicada à entrada.'],
            ['Testbench','data_out, expected_level','Comparação da saída com o modelo de referência.'],
            ['Testbench','led','Posição e nível da saída lógica dos LEDs.'],
            ['Testbench','test_case, sim_done','Caso em execução e término dos testes.'],
            ['dut','bit_index, current_bit','Posição atual (15 a 0) e bit capturado.'],
            ['dut','cycle_count','Contagem de 0 a 9 dentro de cada bit.'],
            ['dut','half_bit, started','Metade do bit (0/1) e início da transmissão.'],
        ],[78,185,W-263],gap=10)
        self.step(3,'Na janela Wave, clique com o botão direito no sinal e ajuste <b>Radix</b>: use decimal para os índices e contadores; hexadecimal ou binário para <b>data_in</b> e <b>led</b>. [1]')
        self.note('Organize <b>data_out</b> próximo de <b>expected_level</b> e mantenha <b>bit_index</b> e <b>current_bit</b> visíveis. Adicione os sinais antes do reinício indicado no próximo passo para registrar o histórico desde o tempo zero.',gap=0)

        self.start('4. Confira o início da transmissão')
        self.step(1,'Com a simulação aberta e os sinais adicionados, execute na <b>Tcl Console</b>, uma linha por vez:')
        self.code('restart\nrun 600 ns')
        self.step(2,'Clique em <b>Zoom Fit</b> na janela Wave. A execução reiniciada cobre de 0 a 600 ns. Use <b>Zoom In</b> ou <b>Zoom Out</b> para ajustar a leitura. [1]')
        self.wave(q['initial'],q['initial_y'][0],q['initial_y'][1],
                  'Figura 4. Início da sequência B2A5 e primeiras transições. Fonte: acervo dos autores (2026).')
        self.p('A sequência inicial é <b>B2A5</b> em hexadecimal, equivalente a <b>1011001010100101</b> em binário. A leitura começa em <b>data_in(15)</b>. Confira os primeiros intervalos:',gap=8)
        levels = ['0','1','0','1','1','0'] if dif else ['0','1','1','0','0','1']
        spans=['100 a 150 ns','150 a 200 ns','200 a 250 ns','250 a 300 ns','300 a 350 ns','350 a 400 ns']
        bits=['15 / 1','15 / 1','14 / 0','14 / 0','13 / 1','13 / 1']
        self.table(['Intervalo','bit_index / current_bit','data_out'],list(zip(spans,bits,levels)),[165,205,W-370],gap=10)
        if dif:
            self.note('<b>Leitura esperada:</b> para dado 0, inverta o nível no início do bit; para dado 1, mantenha o nível anterior. No meio de qualquer bit, a saída inverte. Em 200 ns o dado 0 provoca a queda; em 250 ns ocorre a inversão central.',gap=8)
        else:
            self.note('<b>Leitura esperada:</b> dado 0 produz nível 1 na primeira metade e 0 na segunda; dado 1 produz 0 e depois 1. Em 200 ns o segundo bit começa em nível alto; a queda acontece no meio, em 250 ns.',gap=8)
        self.p('O reset inicial é liberado em <b>95 ns</b>. A transmissão começa em <b>100 ns</b>, quando <b>started = 1</b>; a primeira transição de saída aparece em <b>150 ns</b>. Esses dois instantes têm funções diferentes.', 'small',gap=0)

        self.start('5. Confira a repetição da sequência')
        self.step(1,'Após os 600 ns do passo anterior, avance mais 1500 ns pela Tcl Console. A simulação chegará a 2100 ns:')
        self.code('run 1500 ns')
        self.step(2,'Use <b>Zoom Fit</b>, aproxime a região com <b>Zoom In</b> e ajuste a barra horizontal para mostrar aproximadamente <b>1500 a 1900 ns</b>.')
        self.wave(q['wrap'],q['wrap_y'][0],q['wrap_y'][1],
                  'Figura 5. Retorno do índice 0 ao 15 em 1700 ns. Fonte: acervo dos autores (2026).')
        self.p('Cada quadro contém 16 bits de 100 ns, totalizando <b>1600 ns</b>. Como o primeiro quadro começa em 100 ns, o seguinte começa em <b>1700 ns</b>. Confira os valores após cada borda:',gap=8)
        spans=['1600 a 1650 ns','1650 a 1700 ns','1700 a 1750 ns','1750 a 1800 ns','1800 a 1850 ns','1850 a 1900 ns']
        idx=['0','0','15','15','14','14']
        vals=['1','0','0','1','0','1'] if dif else ['0','1','0','1','1','0']
        leds=['0001','0000','0000','8000','0000','4000'] if dif else ['0000','0001','0000','8000','4000','0000']
        self.table(['Intervalo','bit_index','data_out','led (hex)'],list(zip(spans,idx,vals,leds)),[180,95,95,W-370],gap=10)
        if dif:
            self.note('Na passagem de 0 para 15, o primeiro dado do novo quadro é <b>1</b>. Por isso, a saída mantém o nível 0 em <b>1700 ns</b> e sobe no meio do bit, em <b>1750 ns</b>. O testbench também possui um caso específico com <b>0001</b> para verificar a preservação do nível entre quadros.',gap=8)
        else:
            self.note('Em <b>1700 ns</b>, o novo bit de valor <b>1</b> começa com a saída em 0. Em <b>1750 ns</b>, a saída sobe para 1. Esse comportamento demonstra a retomada da sequência pela posição 15.',gap=8)
        self.p('O vetor <b>led</b> contém o nível codificado apenas na posição selecionada. Quando <b>data_out = 0</b>, todos os LEDs lógicos ficam em zero; use <b>bit_index</b> para identificar a posição em transmissão.', 'small',gap=0)

        self.start('6. Execute e confira todos os testes')
        self.step(1,'Na Tcl Console, execute o comando abaixo ou use <b>Run → Run All</b>. Aguarde a conclusão dos cenários. [1]')
        self.code('run -all')
        self.step(2,f"Confira a mensagem final de sucesso e <b>sim_done = TRUE</b>. Com a configuração deste tutorial, a mensagem aparece em <b>{q['success_time']} ns</b>.")
        self.image(q['log'],q['log_box'],'Figura 6. Trecho da Tcl Console com a mensagem de sucesso. Fonte: acervo dos autores (2026).',width=W,gap=10)
        self.h2('Cenários executados pelo testbench')
        cases=[
            ['1','B2A5, duas voltas','Ordem 15 a 0, codificação e repetição.'],
            ['2','0000','Comportamento para todos os bits em zero.'],
            ['3','FFFF','Comportamento para todos os bits em um.'],
            ['4','AAAA','Sequência alternada iniciada por 1.'],
            ['5','5555','Sequência alternada iniciada por 0.'],
        ]
        if dif:
            cases.append(['6','0001, três voltas','Preservação do nível entre quadros.'])
        n=7 if dif else 6
        cases += [
            [str(n),'Alteração de SW15 na primeira metade','Bit em andamento preservado; atualização na próxima volta.'],
            [str(n+1),'Alteração de SW14 durante SW15','Novo valor capturado quando chegar a posição 14.'],
            [str(n+2),'Alteração de SW15 na segunda metade','Bit em andamento preservado; atualização na próxima volta.'],
            [str(n+3),'Reset durante a transmissão','Saída e LEDs zerados; reinício pela posição 15.'],
        ]
        self.table(['Caso','Estímulo','Verificação'],cases,[43,190,W-233],gap=10)
        self.note('Critério de aprovação: mensagem <b>SUCESSO</b>, <b>sim_done = TRUE</b> e nenhuma falha de assert. As verificações comparam a saída e o vetor completo dos LEDs e também conferem se as mudanças da saída ocorrem nas bordas de subida do clock.',gap=8)
        self.p('Após a conclusão, o testbench interrompe a geração do clock e os sinais ficam constantes. O instante mostrado no rodapé pode ser posterior à mensagem; use o log e <b>sim_done</b> para confirmar o término.', 'small',gap=0)

        self.start('7. Salve os resultados e consulte as dúvidas')
        self.step(1,f"Com a janela Wave ativa, use <b>File → Simulation Waveform → Save Configuration As</b> e salve a organização dos sinais como <b>{q['entity']}.wcfg</b>, preferencialmente em <b>sim/</b>. [1]")
        self.step(2,'Guarde as capturas em <b>docs/midia/</b>, identificando o início, a repetição da sequência e a conclusão. Copie também o texto da Tcl Console, caso seja necessário registrar os detalhes de cada teste.')
        self.p('O arquivo <b>.wcfg</b> preserva a configuração de visualização. Para obter novas formas de onda após reabrir o projeto, execute novamente a simulação com o mesmo testbench e parâmetros.', 'small',gap=12)
        self.h2('Situações comuns')
        self.table(['Situação observada','Como proceder'],[
            ['O cabeçalho identifica outro testbench.',f"Feche a simulação, defina <b>{q['tb']}</b> como top em sim_1 e abra novamente Run Behavioral Simulation."],
            ['Um sinal adicionado está sem histórico.','Adicione-o à Wave, execute <b>restart</b> e repita o trecho ou use <b>run&#160;-all</b>.'],
            ['A saída parece parada.','Confira o tempo exibido. Após o término, o clock para. Volte a 0 a 600 ns ou à região de 1700 ns para ler as transições.'],
            ['sim_done é FALSE na Wave e TRUE em Objects.','A Wave mostra o valor no tempo do cursor; Objects mostra o estado atual. No início dos testes, FALSE é esperado.'],
            ['Um arquivo aparece ausente ao copiar o projeto.','Mantenha src/, sim/ e vivado_project/ juntos. Corrija a referência com Add Sources, selecionando o fonte ou testbench correspondente.'],
            ['O código foi alterado depois de abrir a simulação.','Salve o arquivo e use <b>Relaunch Simulation</b> para recompilar. Restart apenas reinicia o modelo já carregado. [1]'],
        ],[177,W-177],gap=13)
        self.h2('Fontes de consulta')
        self.p('[1] AMD. <i>Vivado Design Suite User Guide: Logic Simulation (UG900)</i>, versão 2025.2. Orientações oficiais para execução, sinais e configuração da janela Wave. Consulta em 13/11/2026.', 'caption',gap=5)
        base='https://docs.amd.com/r/2025.2-English/ug900-vivado-logic-simulation/'
        links=[('Run-Menu','Execução'),('Scope-Window','Scope e Objects'),('Using-the-Zoom-Feature-Buttons','Zoom'),('Saving-a-Wave-Configuration','Salvar configuração'),('Re-running-the-Simulation-After-Design-Changes-relaunch','Recompilar')]
        self.p(' | '.join(f'<link href="{base}{slug}" color="#117D8A"><u>{label}</u></link>' for slug,label in links),'caption',gap=8)
        self.finish_page()
        if self.page!=8: raise RuntimeError('Contagem inesperada de páginas')
        self.c.save()
        return {'path':str(self.path),'page_bottoms':self.lowest}

CONFIGS=[
 dict(dif=False,title='Manchester básico',short='Manchester básico',entity='manchester',tb='manchester_tb',
      project='manchester',folder='manchester',filename='tutorial_simulacao_manchester.pdf',
      sources='image(2).png',sources_box=(253,152,735,444),menu='image(5).png',menu_box=(6,393,580,624),
      initial='image(6).png',initial_y=(212,546),scope_box=(252,121,521,283),objects_box=(538,121,789,282),
      wrap='image(20261113-234828).png',wrap_y=(212,546),log='image(20261113-234828).png',log_box=(275,901,850,939),success_time='19641'),
 dict(dif=True,title='Manchester Diferencial',short='Manchester Diferencial',entity='manchester_dif',tb='manchester_dif_tb',
      project='manchester_diferencial',folder='manchester_diferencial',filename='tutorial_simulacao_manchester_diferencial.pdf',
      sources='image(3).png',sources_box=(266,128,773,422),menu='image(4).png',menu_box=(7,398,620,626),
      initial='image(7).png',initial_y=(221,554),scope_box=(262,129,506,273),objects_box=(520,129,789,294),
      wrap='image(8).png',wrap_y=(212,545),log='image(8).png',log_box=(285,904,860,941),success_time='24471'),
]

if __name__ == '__main__':
    results=[]
    for cfg in CONFIGS:
        result=Tutorial(cfg).build()
        reader=PdfReader(result['path'])
        texts=[p.extract_text() or '' for p in reader.pages]
        assert len(texts)==8
        for name,ra in MEMBERS:
            assert name in texts[0] and ra in texts[0], (name,ra)
        for token in ['Faculdade Engenheiro Salvador Arena','7° Semestre']:
            assert token in texts[0]
        assert cfg['success_time'] in '\n'.join(texts)
        assert len(reader.outline)==8
        result['pages']=len(texts)
        result['bytes']=Path(result['path']).stat().st_size
        results.append(result)
    (BUILD/'tutorial_pdf_validation.json').write_text(json.dumps(results,ensure_ascii=False,indent=2), encoding='utf-8')
    print(json.dumps(results,ensure_ascii=False,indent=2))
