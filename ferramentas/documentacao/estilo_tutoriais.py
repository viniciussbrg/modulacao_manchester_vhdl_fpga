"""Padrão editorial compartilhado pelos quatro tutoriais do projeto."""

from pathlib import Path
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import Paragraph, Table, TableStyle

FONT = Path(__file__).resolve().parent / 'fontes'
for name, filename in [
    ('Body', 'DejaVuSans.ttf'),
    ('BodyBold', 'DejaVuSans-Bold.ttf'),
    ('BodyItalic', 'DejaVuSans-Oblique.ttf'),
    ('BodyBoldItalic', 'DejaVuSans-BoldOblique.ttf'),
    ('Mono', 'DejaVuSansMono.ttf'),
]:
    pdfmetrics.registerFont(TTFont(name, str(FONT / filename)))
pdfmetrics.registerFontFamily(
    'Body', normal='Body', bold='BodyBold', italic='BodyItalic',
    boldItalic='BodyBoldItalic',
)

NAVY = colors.HexColor('#17364D')
TEAL = colors.HexColor('#117D8A')
INK = colors.HexColor('#243441')
MUTED = colors.HexColor('#5C6D79')
PALE = colors.HexColor('#EEF5F7')
LINE = colors.HexColor('#CCD9DE')
WHITE = colors.white

PW, PH = A4
LEFT = RIGHT = 48
TOP = 60
BOTTOM = 57
WIDTH = PW - LEFT - RIGHT
BODY_GAP = 8
STEP_GAP = 6
HEADING_GAP = 13
SUBHEADING_GAP = 7
TABLE_FONT = 9.1
TABLE_LEADING = 12.3
TABLE_PAD = 6
TABLE_HORIZONTAL_PAD = 8

STYLES = {
    'body': ParagraphStyle('body', fontName='Body', fontSize=10, leading=14.5, textColor=INK),
    'small': ParagraphStyle('small', fontName='Body', fontSize=9, leading=12.5, textColor=INK),
    'caption': ParagraphStyle('caption', fontName='Body', fontSize=8.1, leading=11.4, textColor=MUTED),
    'cell': ParagraphStyle('cell', fontName='Body', fontSize=TABLE_FONT, leading=TABLE_LEADING, textColor=INK),
    'headcell': ParagraphStyle('headcell', fontName='BodyBold', fontSize=TABLE_FONT, leading=TABLE_LEADING, textColor=WHITE),
    'title': ParagraphStyle('title', fontName='BodyBold', fontSize=24, leading=29, textColor=NAVY),
    'subtitle': ParagraphStyle('subtitle', fontName='BodyBold', fontSize=19, leading=24, textColor=TEAL),
    'h1': ParagraphStyle('h1', fontName='BodyBold', fontSize=17, leading=22, textColor=NAVY),
    'h2': ParagraphStyle('h2', fontName='BodyBold', fontSize=11.2, leading=15.5, textColor=TEAL),
    'mono': ParagraphStyle('mono', fontName='Mono', fontSize=9.1, leading=15, textColor=NAVY),
}
STYLES['step'] = ParagraphStyle('step', parent=STYLES['body'])
STYLES['source'] = ParagraphStyle('source', parent=STYLES['caption'])
STYLES['ref'] = ParagraphStyle('ref', parent=STYLES['caption'], splitLongWords=True)


def group_table(members):
    """Quadro idêntico de identificação, nome e RA em todos os tutoriais."""
    def p(text, style='small'):
        return Paragraph(text, STYLES[style])
    rows = [
        [p('<b>Faculdade:</b> Faculdade Engenheiro Salvador Arena'), ''],
        [p('<b>Turma:</b> Engenharia da Computação - 7° Semestre'), ''],
        [p('Integrantes do grupo', 'headcell'), ''],
        [p('<b>Nome</b>'), p('<b>RA</b>')],
    ] + [[p(name), p(ra)] for name, ra in members]
    table = Table(rows, colWidths=[WIDTH - 105, 105])
    table.setStyle(TableStyle([
        ('SPAN', (0, 0), (-1, 0)), ('SPAN', (0, 1), (-1, 1)),
        ('SPAN', (0, 2), (-1, 2)),
        ('BACKGROUND', (0, 0), (-1, 1), PALE),
        ('BACKGROUND', (0, 2), (-1, 2), NAVY),
        ('BACKGROUND', (0, 3), (-1, 3), PALE),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ('BOX', (0, 0), (-1, -1), .7, LINE),
        ('LINEBELOW', (0, 3), (-1, -2), .35, LINE),
        ('LEFTPADDING', (0, 0), (-1, -1), 10),
        ('RIGHTPADDING', (0, 0), (-1, -1), 10),
        ('TOPPADDING', (0, 0), (-1, -1), 7),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 7),
    ]))
    return table


LAYOUT_SPEC = {
    'page': 'A4',
    'margins_pt': {'left': LEFT, 'right': RIGHT, 'content_top': TOP, 'content_bottom': BOTTOM},
    'font': 'DejaVu Sans',
    'styles': {key: {'font_size_pt': style.fontSize, 'line_height_pt': style.leading,
                     'alignment': style.alignment} for key, style in STYLES.items()},
    'paragraph_gap_pt': BODY_GAP,
    'step_gap_pt': STEP_GAP,
    'heading_gap_pt': HEADING_GAP,
    'subheading_gap_pt': SUBHEADING_GAP,
    'table_padding_pt': {'horizontal': TABLE_HORIZONTAL_PAD, 'vertical': TABLE_PAD},
}
