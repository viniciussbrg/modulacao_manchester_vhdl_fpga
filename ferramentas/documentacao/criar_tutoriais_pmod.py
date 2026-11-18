from pathlib import Path
from xml.sax.saxutils import escape
import json
from PIL import Image
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.enums import TA_JUSTIFY, TA_LEFT, TA_CENTER
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

ST = STYLES
GREY = MUTED
MEMBERS = [
    ['Victor Mendes de Andrade Ferreira', '082230015'],
    ['Lucas Junqueira Gonçalves', '082230029'],
    ['Murilo Umbelino Oliveira dos Santos', '082230013'],
    ['Guilherme Alves Barbosa', '082220014'],
]
CONFIGS = [
    dict(kind='basico', name='Manchester básico', folder='manchester', project='manchester.xpr',
         top='top_manchester_vga', encoder='manchester', source='manchester.vhd',
         base='image(20261114-013716).png', alt='image(20261114-013749).png',
         vivado='image(2).png', filename='tutorial_pmod_manchester.pdf'),
    dict(kind='diferencial', name='Manchester Diferencial', folder='manchester_diferencial',
         project='manchester_diferencial.xpr', top='manchester_dif', encoder='manchester_dif',
         source='manchester_dif.vhd', base='image(20261114-013848).png',
         alt='image(20261114-014044).png', vivado='image(3).png',
         filename='tutorial_pmod_manchester_diferencial.pdf'),
]

def par(text, style='body'):
    return Paragraph(text, ST[style])

class Tutorial:
    def __init__(self, cfg):
        self.cfg = cfg
        self.path = OUT / cfg['filename']
        self.c = canvas.Canvas(str(self.path), pagesize=A4, pageCompression=1)
        self.c.setTitle('Tutorial de PMOD e osciloscópio - ' + cfg['name'])
        self.c.setAuthor('; '.join(m[0] for m in MEMBERS))
        self.c.setSubject('Faculdade Engenheiro Salvador Arena - Engenharia da Computação - 7° Semestre')
        self.c.setKeywords('Basys 3, PMOD, L2, JA2, Analog Discovery 3, WaveForms, Manchester, tutorial')
        self.c._doc.Catalog.Lang = PDFString('pt-BR')
        self.page = 0
        self.fig = 0
        self.lowest = {}

    def start(self, heading=None):
        if self.page:
            self.finish_page()
            self.c.showPage()
        self.page += 1
        self.y = PH - TOP
        self.c.setStrokeColor(LINE)
        self.c.setLineWidth(.6)
        self.c.line(LEFT, PH-40, PW-RIGHT, PH-40)
        self.c.setFillColor(GREY)
        self.c.setFont('Body', 7.1)
        self.c.drawString(LEFT, PH-29, 'FACULDADE ENGENHEIRO SALVADOR ARENA')
        self.c.drawRightString(PW-RIGHT, PH-29, self.cfg['name'].upper()+' | PMOD')
        self.c.setFillColor(INK)
        if heading:
            self.c.bookmarkPage('p' + str(self.page))
            self.c.addOutlineEntry(heading, 'p' + str(self.page), 0, False)
            self.p(heading, 'h1', gap=HEADING_GAP)

    def finish_page(self):
        self.lowest[self.page] = round(self.y, 2)
        self.c.setStrokeColor(LINE)
        self.c.setLineWidth(.6)
        self.c.line(LEFT, 43, PW-RIGHT, 43)
        self.c.setFillColor(GREY)
        self.c.setFont('Body', 7.4)
        self.c.drawString(LEFT, 29, 'Engenharia da Computação | 7° Semestre | Novembro de 2026')
        self.c.drawRightString(PW-RIGHT, 29, f'{self.page} / 11')

    def need(self, height):
        if self.y - height < BOTTOM - .1:
            raise RuntimeError(f'{self.cfg["kind"]} p{self.page}: overflow {height:.1f} from {self.y:.1f}')

    def p(self, text, style='body', gap=BODY_GAP, x=None, width=None):
        x = LEFT if x is None else x
        width = WIDTH if width is None else width
        obj = par(text, style)
        _, h = obj.wrap(width, PH)
        self.need(h + gap)
        obj.drawOn(self.c, x, self.y - h)
        self.y -= h + gap
        return h

    def gap(self, h=8):
        self.need(h)
        self.y -= h

    def steps(self, texts, start=1, width=None, x=None):
        for i, txt in enumerate(texts, start):
            self.p(f'<b>{i}.</b> {txt}', 'step', gap=STEP_GAP, width=width, x=x)

    def table(self, rows, widths=None, header=True, x=None, gap=12, spans=None, band_rows=None, pale_rows=None):
        x = LEFT if x is None else x
        widths = widths or [WIDTH * .32, WIDTH * .68]
        bands = set(band_rows or []) | ({0} if header else set())
        cells = [[par(str(v), 'headcell' if i in bands else 'cell') for v in row]
                 for i, row in enumerate(rows)]
        t = Table(cells, colWidths=widths, hAlign='LEFT')
        cmds = [('VALIGN', (0,0), (-1,-1), 'TOP'),
                ('LINEBELOW', (0,0), (-1,-1), .35, LINE),
                ('TOPPADDING', (0,0), (-1,-1), TABLE_PAD), ('BOTTOMPADDING', (0,0), (-1,-1), TABLE_PAD),
                ('LEFTPADDING', (0,0), (-1,-1), TABLE_HORIZONTAL_PAD), ('RIGHTPADDING', (0,0), (-1,-1), TABLE_HORIZONTAL_PAD)]
        if header:
            for i in range(1,len(rows)):
                if i % 2: cmds.append(('BACKGROUND',(0,i),(-1,i),PALE))
        else:
            cmds.append(('BOX',(0,0),(-1,-1),.7,LINE))
        for i in pale_rows or []: cmds.append(('BACKGROUND',(0,i),(-1,i),PALE))
        for i in bands: cmds.append(('BACKGROUND',(0,i),(-1,i),NAVY))
        for a,b in spans or []: cmds.append(('SPAN',a,b))
        t.setStyle(TableStyle(cmds))
        _, h = t.wrap(WIDTH, PH)
        self.need(h + gap)
        t.drawOn(self.c, x, self.y - h)
        self.y -= h + gap
        return h

    def img(self, filename, width=None, height=None, crop=None, x=None, border=True):
        path = localizar_midia(filename)
        iw, ih = Image.open(path).size
        crop = crop or (0,0,iw,ih)
        l,t,r,b = crop
        if width is None and height is None: width = WIDTH
        if width is None: width = height * (r-l)/(b-t)
        if height is None: height = width * (b-t)/(r-l)
        x = LEFT + (WIDTH-width)/2 if x is None else x
        self.need(height)
        y = self.y-height
        sx, sy = width/(r-l), height/(b-t)
        self.c.saveState()
        clip=self.c.beginPath();clip.rect(x,y,width,height)
        self.c.clipPath(clip,stroke=0,fill=0)
        self.c.drawImage(str(path),x-l*sx,y-(ih-b)*sy,width=iw*sx,height=ih*sy)
        self.c.restoreState()
        if border:
            self.c.setStrokeColor(LINE);self.c.setLineWidth(.4);self.c.rect(x,y,width,height)
        self.y-=height+6
        return height

    def figure(self, filename, caption, width=None, height=None, crop=None, source='acervo dos autores (2026).'):
        self.fig += 1
        self.img(filename, width=width, height=height, crop=crop)
        self.p(f'Figura {self.fig}. {caption} Fonte: {source}', 'caption', gap=12)

    def members(self):
        t = group_table(MEMBERS)
        _, h = t.wrap(WIDTH, 1000)
        self.need(h + 18)
        t.drawOn(self.c, LEFT, self.y - h)
        self.y -= h + 18

    def code(self, lines, gap=10):
        fs = ST['mono'].fontSize
        leading = ST['mono'].leading
        h = leading * len(lines) + 18
        self.need(h + gap)
        self.c.setFillColor(PALE)
        self.c.roundRect(LEFT, self.y-h, WIDTH, h, 5, stroke=0, fill=1)
        self.c.setFillColor(NAVY)
        self.c.setFont('Mono', fs)
        for i, line in enumerate(lines):
            if pdfmetrics.stringWidth(line, 'Mono', fs) > WIDTH - 22:
                raise RuntimeError('Código muito largo: ' + line)
            self.c.drawString(LEFT + 11, self.y - 18 - leading*i, line)
        self.y -= h + gap

    def theoretical_wave(self):
        self.fig+=1
        self.p(f'Figura {self.fig} - Referência teórica para os quatro primeiros bits 0101.', 'caption', gap=7)
        h=210
        self.need(h)
        y0=self.y-h
        c=self.c
        xs=LEFT+38; ww=WIDTH-48; unit=ww/4
        levels=[1,0,0,1,1,0,0,1] if self.cfg['kind']=='basico' else [1,0,0,1,0,1,1,0]
        for i,bit in enumerate([0,1,0,1]):
            c.setFillColor(INK);c.setFont('BodyBold',10)
            c.drawCentredString(xs+(i+.5)*unit,y0+192,f'SW{15-i} = {bit}')
        for j in range(9):
            xx=xs+j*unit/2
            c.setStrokeColor(LINE);c.setLineWidth(.5)
            c.setDash(2,2) if j%2==0 else c.setDash(1,4)
            c.line(xx,y0+32,xx,y0+178)
        c.setDash()
        for title, seq, hi, lo in [('Dado original (referência)',[0,0,1,1,0,0,1,1],y0+151,y0+125),
                                   ('Sinal codificado',levels,y0+77,y0+51)]:
            c.setFillColor(INK);c.setFont('Body',10)
            c.drawString(xs,hi+14,title)
            c.drawRightString(xs-9,hi-3,'1');c.drawRightString(xs-9,lo-3,'0')
            p=c.beginPath();p.moveTo(xs,hi if seq[0] else lo)
            for j, val in enumerate(seq):
                xx=xs+(j+1)*unit/2; yy=hi if val else lo
                p.lineTo(xx,yy)
                if j+1<len(seq):p.lineTo(xx,hi if seq[j+1] else lo)
            c.setStrokeColor(TEAL if title.startswith('Dado') else NAVY);c.setLineWidth(1.5);c.drawPath(p)
        c.setFont('Body',9)
        for i in range(5):c.drawCentredString(xs+i*unit,y0+16,f'{i} s')
        self.y=y0-3
        self.p('Fonte: elaboração própria (2026), a partir do código VHDL. Diagrama teórico; o tempo zero representa o início de SW15.', 'source',gap=10)

    def finish(self):
        self.finish_page()
        self.c.save()
        r=PdfReader(self.path)
        assert len(r.pages)==11,(self.path,len(r.pages))
        text='\n'.join(p.extract_text() or '' for p in r.pages)
        for name,ra in MEMBERS:
            assert name in text and ra in text
        assert 'L2' in text and 'JA2' in text and '0101010101010101' in text
        assert all(v>=BOTTOM-.1 for v in self.lowest.values()), self.lowest
        return dict(file=str(self.path),pages=len(r.pages),lowest_y=self.lowest,
                    chars=len(text),size_bytes=self.path.stat().st_size)

def build(cfg):
    d=Tutorial(cfg)
    dif=cfg['kind']=='diferencial'
    # 1. Identification and environment: title directly followed by group box.
    d.start()
    d.p('Tutorial de PMOD e osciloscópio','title',gap=3)
    d.p(cfg['name'],'subtitle',gap=16)
    d.members()
    d.p('Objetivo','h2',gap=SUBHEADING_GAP)
    d.p(f'Orientar a conexão da Basys 3 ao Analog Discovery 3 e a observação da saída do {cfg["name"]} no WaveForms. O roteiro acompanha a medição de <b>data_out no canal 1</b>, com sequências de 16 bits definidas pelos switches.',gap=13)
    d.p('Ambiente utilizado','h2',gap=SUBHEADING_GAP)
    d.table([
        ['Item','Identificação'],
        ['Sistema operacional','Windows 11, versão 25H2'],
        ['Projeto Vivado',cfg['project']+' - Vivado 2025.2'],
        ['Instrumento / aplicativo','Digilent Analog Discovery 3 / WaveForms 3.24.4'],
        ['Placa / saída','Basys 3 / data_out no pino L2, conector JA2'],
        ['Temporização na placa','100 MHz; 100.000.000 ciclos por bit; 1 s por bit'],
    ],gap=12)
    # 2. Physical setup overview.
    d.start('1. Preparar os equipamentos')
    d.steps([
        'Separe a <b>Basys 3</b>, o <b>Analog Discovery 3</b>, seus cabos USB e fios jumper para sinal e referência de terra.',
        f'Tenha no computador a pasta completa do projeto <b>{cfg["project"]}</b>, com fontes VHDL, constraints e os componentes já utilizados no Vivado.',
        'Use o cabo de programação na porta <b>USB PROG</b> da Basys 3. Conecte o Analog Discovery 3 ao computador com seu próprio cabo USB. [1]',
    ])
    d.figure('image(20261114-012618).png','Visão geral da bancada, com placa, instrumento e computador.',width=WIDTH)
    d.p('A Basys 3 produz o sinal. O Analog Discovery 3 mede a tensão e envia as amostras ao computador. O WaveForms apresenta essa medição em um gráfico.',gap=0)
    # 3. Safe, exact logical wiring.
    d.start('2. Realizar as conexões físicas')
    d.p('Antes de encaixar ou trocar fios, desligue a alimentação da montagem. Localize o conector <b>JA</b> e sua indicação de pino 1. O nome <b>L2</b> identifica um terminal da FPGA; na borda da placa ele corresponde ao <b>pino 2 de JA (JA2)</b>. [1; 2]',gap=10)
    d.figure('image(20261114-012606).png','Registro das conexões físicas utilizadas na bancada.',height=235)
    d.p('Quadro 1 - Ligações de referência para reproduzir a medição.','caption',gap=6)
    d.table([
        ['Analog Discovery 3','Basys 3 / função'],
        ['Entrada 1+','JA2 (L2): sinal codificado data_out'],
        ['Entrada 1-','GND da placa: referência da medição'],
        ['GND do instrumento','GND da placa: referência comum'],
    ],widths=[WIDTH*.43,WIDTH*.57],gap=4)
    d.p('Fonte: elaboração própria (2026), com base no manual da Basys 3 e no arquivo Basys-3-Master.xdc. [1; 2]','source',gap=10)
    d.p('Em JA, os pinos <b>5 e 11 são GND</b>; os pinos 6 e 12 são alimentação de 3,3 V. Identifique os fios por <b>1+, 1- e GND</b>, e não apenas pela cor. Use as entradas do Scope; não conecte a saída de Wavegen ao sinal da FPGA.',gap=0)
    # 4. Design and constraints.
    d.start('3. Abrir o projeto e conferir o PMOD')
    d.steps([
        f'Abra o Vivado 2025.2, selecione <b>Open Project</b> e localize <b>{cfg["project"]}</b>.',
        f'Em <b>Sources &gt; Design Sources</b>, confira o módulo superior <b>{cfg["top"]}</b>. O codificador utilizado é <b>{cfg["encoder"]}</b>.',
        'Em <b>Sources &gt; Constraints &gt; constrs_1</b>, abra o arquivo XDC e localize a associação da porta <b>data_out</b>.',
    ])
    crop=(250,145,740,435) if not dif else (260,128,772,420)
    d.figure(cfg['vivado'],'Localização dos fontes e do arquivo de constraints no Vivado (recorte).',width=WIDTH*.9,crop=crop)
    d.p('A porta <b>data_out</b> utiliza o pino <b>L2</b> da FPGA, correspondente a <b>JA2</b>. Confira as seguintes restrições no arquivo XDC: [2]',gap=8)
    d.code(['set_property PACKAGE_PIN L2 [get_ports {data_out}]',
            'set_property IOSTANDARD LVCMOS33 [get_ports {data_out}]'])
    d.p('Substitua a associação anterior de data_out, caso ainda aponte para J1. Mantenha as demais restrições necessárias ao projeto. O nome dentro de <b>get_ports</b> deve coincidir com a porta do módulo superior.',gap=0)
    # 5. Deployment.
    d.start('4. Gerar e gravar o bitstream')
    d.p('O arquivo <b>.bit</b> é o circuito que será carregado na FPGA. Sempre que o VHDL ou o XDC mudar, gere um novo bitstream antes de programar a placa. [3]',gap=10)
    d.steps([
        'Salve os arquivos. No <b>Flow Navigator</b>, execute <b>Run Synthesis</b> e aguarde a conclusão sem erros.',
        'Execute <b>Run Implementation</b> e, ao terminar, <b>Generate Bitstream</b>. Se o Vivado solicitar etapas anteriores necessárias, permita sua execução.',
        'Com a Basys 3 ligada e conectada à USB PROG, abra <b>Open Hardware Manager</b>. Selecione <b>Open Target &gt; Auto Connect</b>.',
        'Selecione a FPGA da Basys 3, clique com o botão direito e escolha <b>Program Device</b>.',
        f'No campo <b>Bitstream file</b>, selecione o arquivo gerado pelo projeto <b>{cfg["project"]}</b>. Confira o caminho completo antes de clicar em <b>Program</b>.',
        'Aguarde o término. Verifique o estado de dispositivo programado e o LED <b>DONE</b> na placa. [1; 3]',
    ])
    d.p('Localização usual do arquivo gerado:','caption',gap=6)
    d.code([cfg['folder']+'.runs/impl_1/'+cfg['top']+'.bit'])
    d.p('Use o caminho real exibido pelo seu projeto. Ao trocar de codificador, programe novamente a placa com o .bit correspondente. Apenas abrir outro projeto no Vivado não troca o circuito em execução.',gap=10)
    d.p('O reset deste projeto é o botão central <b>BTNC</b>. O botão <b>PROG</b> da placa tem outra finalidade: reinicia a configuração da FPGA. [1]',gap=10)
    d.figure('image(3).png','Controles de geração do bitstream e abertura do Hardware Manager (recorte).',width=280,crop=(0,775,254,890))
    # 6. WaveForms entry point.
    d.start('5. Abrir o osciloscópio no WaveForms')
    d.steps([
        'Abra o <b>WaveForms</b>. Se aparecer a seleção de dispositivo, escolha o <b>Analog Discovery 3</b> conectado.',
        'Confira a identificação <b>Discovery3</b> na barra inferior. Na coluna esquerda, clique em <b>Scope</b> para abrir o osciloscópio. [4]',
    ])
    d.figure('image(20261114-012554).png','Tela inicial do WaveForms e seleção do instrumento Scope.',width=WIDTH)
    d.figure('image(20261114-012554).png','Detalhe do botão Scope, no canto superior esquerdo.',width=300,crop=(0,37,340,161))
    d.p('Na janela aberta, localize os controles <b>Time</b> e <b>Channel 1</b> à direita, e os botões de aquisição na barra superior. O traço laranja representa o sinal medido no canal 1.',gap=0)
    # 7. Reproducible instrument settings.
    d.start('6. Configurar a aquisição')
    d.p('Configure a aquisição conforme o Quadro 2. Clique no valor de cada campo para alterá-lo. A configuração abaixo considera <b>1 segundo por bit</b>.',gap=10)
    d.p('Quadro 2 - Configuração da tela Scope.','caption',gap=6)
    block_top=d.y
    d.table([
        ['Controle / localização','Valor'],
        ['Mode, na barra superior','Shift'],
        ['Trigger, na barra superior','None'],
        ['Time > Base','2 s/div'],
        ['Channel 1','Habilitado'],
        ['Channel 1 > Range','1 V/div'],
        ['Channel 1 > Offset','0 V'],
        ['Channel 2','Desabilitado nas capturas apresentadas'],
        ['Amostragem exibida','32.000 amostras a 1,6 kHz'],
    ],widths=[145,170],gap=4)
    d.p('Fonte: elaboração própria (2026).','source',gap=10,width=315)
    left_bottom=d.y
    d.y=block_top
    d.fig+=1
    right_x=LEFT+330
    right_w=WIDTH-330
    d.img(cfg['base'],width=right_w,crop=(1725,153,1914,473),x=right_x)
    d.p(f'Figura {d.fig}. Ajustes de tempo e do canal 1. Fonte: acervo dos autores (2026).','caption',gap=12,x=right_x,width=right_w)
    d.y=min(left_bottom,d.y)-6
    d.p('Para fios diretos, sem ponta atenuadora, ajuste <b>Probe = 1X</b> nas propriedades do canal. O valor deve corresponder à conexão física. Se o campo estiver oculto, procure <b>Options &gt; Show Probe</b>. [4]',gap=8)
    d.p('Clique em <b>Run</b> para acompanhar o sinal. Durante a aquisição, o controle permite <b>Stop</b>, que congela a tela. Após mudar os switches, aguarde cerca de <b>20 segundos</b> para renovar a janela de 2 s/div.',gap=0)
    # 8. Reading the theoretical signal, strictly separate from measured captures.
    d.start('7. Entender as escalas e as transições')
    d.p('Cada divisão horizontal vale <b>2 segundos</b> e cada divisão vertical vale <b>1 volt</b>. A linha próxima de 0 V representa nível lógico baixo; a próxima de 3,3 V representa nível alto. Os valores lidos visualmente são aproximados.',gap=10)
    d.table([
        ['Grandeza na placa','Valor adotado'],
        ['Duração de um bit','100.000.000 / 100.000.000 Hz = 1 s'],
        ['Metade de um bit','0,5 s'],
        ['Uma sequência de 16 bits','16 s, na ordem SW15 até SW0'],
    ],gap=10)
    if dif:
        d.p('No <b>Manchester Diferencial</b>, o bit 0 inverte o nível no início do intervalo; o bit 1 conserva o nível anterior nesse instante. No meio de qualquer bit, ocorre uma inversão. O diagrama parte da saída em 0 após o reset.',gap=10)
    else:
        d.p('No <b>Manchester básico</b> adotado, o bit 0 usa nível alto na primeira metade e baixo na segunda. O bit 1 faz o contrário. Assim, no meio do bit, a transição é de descida para 0 e de subida para 1.',gap=10)
    d.theoretical_wave()
    d.p('O período de uma onda repetitiva pode abranger mais de um bit. O valor <b>1,6 kHz</b> exibido no Scope é a taxa de amostragem; a taxa de transmissão adotada na FPGA é <b>1 bit/s</b>. Os tempos em nanossegundos usados no testbench pertencem à simulação.',gap=0)
    # 9. All-zero test.
    d.start('8. Ensaio com todos os switches em zero')
    d.steps([
        'Coloque <b>SW15 até SW0 em 0</b>: sequência <b>0000000000000000</b> (hexadecimal 0x0000).',
        'Pressione e solte <b>BTNC</b>. Com a aquisição em execução, aguarde a renovação do gráfico e clique em <b>Stop</b> para salvar a imagem.',
    ])
    d.figure(cfg['base'],cfg['name']+' com todos os switches em 0.',width=WIDTH)
    d.p('Quadro 3 - Leitura aproximada da captura.','caption',gap=6)
    d.table([
        ['Característica','Observação'],
        ['Canal e níveis','C1 (laranja); aproximadamente 0 V e 3,3 V'],
        ['Tempo em cada nível','Aproximadamente 0,5 s'],
        ['Período da onda exibida','Aproximadamente 1 s'],
    ],gap=4)
    d.p('Fonte: elaboração própria (2026).','source',gap=10)
    txt = ('Para uma sequência de zeros no diferencial, há uma inversão no início e outra no meio de cada bit. Por isso, a referência teórica tem mudanças a cada 0,5 s. Uma sequência constante pode ter aparência semelhante à do Manchester básico.' if dif else
           'Para o bit 0, a referência teórica é alto por 0,5 s e baixo por 0,5 s. Como os zeros se repetem, também há mudança de nível na passagem de um bit para o próximo.')
    d.p(txt,gap=0)
    # 10. Alternating test. Do not falsely certify differential capture.
    d.start('9. Ensaio com switches alternados')
    d.steps([
        'Ajuste <b>SW15 = 0, SW14 = 1, SW13 = 0</b> e continue alternando até <b>SW0 = 1</b>. A sequência é <b>0101010101010101</b> (0x5555).',
        'Pressione e solte <b>BTNC</b>. Clique em <b>Run</b>, aguarde cerca de 20 segundos e use <b>Stop</b> para registrar a tela.',
    ])
    d.figure(cfg['alt'],cfg['name']+' - registro do ensaio com switches alternados.',width=WIDTH)
    d.p('Quadro 4 - Condições e leitura visual da captura.','caption',gap=6)
    d.table([
        ['Item','Registro'],
        ['Sequência de entrada','0101010101010101, de SW15 a SW0'],
        ['Escalas','2 s/div e 1 V/div; offset de 0 V'],
        ['Canal exibido','C1 (laranja), entre aproximadamente 0 V e 3,3 V'],
        ['Patamares visíveis','Aproximadamente 1 s em nível alto e 1 s em nível baixo'],
    ],gap=4)
    d.p('Fonte: elaboração própria (2026).','source',gap=10)
    if dif:
        d.p('A regra de codificação e a referência temporal estão na seção 7. Na leitura do diferencial, o significado do bit depende da existência de transição em seu início; o nível alto ou baixo, isoladamente, não identifica o dado.',gap=0)
    else:
        d.p('No básico, bits alternados podem unir duas metades consecutivas no mesmo nível. Assim, o patamar passa a durar 1 s e a onda completa, 2 s. A duração de cada bit continua sendo 1 s.',gap=0)
    # 11. Capture saving and practical problems.
    d.start('10. Salvar as capturas e resolver dúvidas')
    d.steps([
        'Antes de salvar, deixe visíveis o gráfico, as escalas, o canal habilitado e a identificação do aplicativo. Clique em <b>Stop</b> para congelar a aquisição.',
        'No Windows, use <b>Win + Shift + S</b> e capture a janela do Scope. Abra a imagem na Ferramenta de Captura e salve em PNG.',
        'Use nomes que identifiquem o codificador e a sequência. Ao mudar os switches novamente, retome a aquisição com <b>Run</b>.',
    ])
    d.code([cfg['folder']+'_pmod_0000.png',cfg['folder']+'_pmod_5555.png'])
    d.p('Quadro 5 - Situações comuns e ações de conferência.','caption',gap=6)
    d.table([
        ['Situação','Como proceder'],
        ['Linha parada perto de 0 V','Confira Run, alimentação, reset solto, .bit carregado e ligação entre 1+ e JA2.'],
        ['Faixa espessa ou muito ruído','Confira 1-, GND, encaixes e Probe. A opção Noise só mostra ou oculta a faixa de mínimos/máximos; não corrige a conexão. [4]'],
        ['Amplitude dez vezes maior','Confira se Probe foi ajustado para 10X apesar de a ligação usar fios diretos, sem atenuação.'],
        ['A mudança dos switches não aparece','Retome Run e aguarde a janela renovar. O código lê cada switch no início de seu intervalo; uma posição já transmitida será lida na próxima volta.'],
        ['Resultado pertence a outro projeto','Confira o caminho do .bit e programe novamente a FPGA. Abrir outro .xpr não substitui o circuito carregado.'],
    ],widths=[WIDTH*.34,WIDTH*.66],gap=4)
    d.p('Fonte: elaboração própria (2026), com base no código VHDL e na documentação do Scope. [4]','source',gap=8)
    d.p('Para observar detalhes, use <b>500 ms/div</b>. Para comparar com as figuras deste tutorial, retorne a <b>2 s/div</b>.',gap=0)
    # Technical references share the last page, following the simulation model.
    d.gap(13)
    d.c.bookmarkPage('referencias')
    d.c.addOutlineEntry('REFERÊNCIAS','referencias',0,False)
    d.p('Referências','h2',gap=SUBHEADING_GAP)
    refs=[
      ('[1] DIGILENT. <b>Basys 3 FPGA Board Reference Manual</b>. Revisão de 8 abr. 2016.',
       'https://digilent.com/reference/_media/basys3:basys3_rm.pdf'),
      ('[2] DIGILENT. <b>Basys-3-Master.xdc</b>. Repositório digilent-xdc. GitHub, [s. d.].',
       'https://github.com/Digilent/digilent-xdc/blob/master/Basys-3-Master.xdc'),
      ('[3] AMD. <b>Vivado Design Suite User Guide: Programming and Debugging (UG908)</b>. Versão 2025.2. 2025.',
       'https://docs.amd.com/r/2025.2-English/ug908-vivado-programming-debugging'),
      ('[4] DIGILENT. <b>WaveForms Reference Manual: Oscilloscope</b>. Versão 3.24.4. [S. l.], [s. d.].',
       'https://files.digilent.com/manuals/WaveForms/3.24.4/scope.html'),
    ]
    for txt,url in refs:
        d.p(txt+' Disponível em: <link href="'+escape(url)+'" color="#117D8A">'+escape(url)+'</link>. Acesso em: 15 nov. 2026.','ref',gap=8)
    return d.finish()

if __name__=='__main__':
    results=[build(cfg) for cfg in CONFIGS]
    p=BUILD/'pmod_pdf_validation.json'
    p.write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps(results,ensure_ascii=False,indent=2))
