"""Verificação estrutural dos PDFs e renderização para revisão visual."""
import argparse
import json
import re
import sys

import fitz
from pypdf import PdfReader
from caminhos_documentacao import ROOT, BUILD, DOCUMENTOS

INTEGRANTES = {
    'Victor Mendes de Andrade Ferreira': '082230015',
    'Lucas Junqueira Gonçalves': '082230029',
    'Murilo Umbelino Oliveira dos Santos': '082230013',
    'Guilherme Alves Barbosa': '082220014',
}
PROIBIDOS = ('FONTES DO ENSAIO', 'ORGANIZAÇÃO NA ENTREGA', 'Destino na entrega',
             'informado pelo grupo', 'arquivos enviados pelo grupo')


def validar(alvo):
    resultados = []
    falhas = []
    for item in DOCUMENTOS:
        path = (ROOT / item['destino'] if alvo == 'finais'
                else BUILD / 'pdf' / item['gerado'])
        erros = []
        if not path.is_file():
            falhas.append(f'Arquivo ausente: {path.relative_to(ROOT)}')
            continue
        reader = PdfReader(path)
        textos = [p.extract_text() or '' for p in reader.pages]
        texto = '\n'.join(textos)
        normalizado = re.sub(r'\s+', ' ', texto)
        if len(reader.pages) != item['paginas']:
            erros.append(f'Páginas: {len(reader.pages)}; esperado: {item["paginas"]}')
        for nome, ra in INTEGRANTES.items():
            if nome not in textos[0] or ra not in textos[0]:
                erros.append('Integrante ausente da primeira página: ' + nome)
        for termo in PROIBIDOS:
            if termo.casefold() in normalizado.casefold():
                erros.append('Trecho editorial removido reapareceu: ' + termo)
        for numero, pagina in enumerate(reader.pages, 1):
            w, h = float(pagina.mediabox.width), float(pagina.mediabox.height)
            if abs(w - 595.276) > 1 or abs(h - 841.89) > 1:
                erros.append(f'Página {numero} fora do tamanho A4')
        rendered = BUILD / 'revisao' / alvo / path.stem
        # The same PDF basename appears in both projects; use unique generation name.
        rendered = rendered.parent / item['gerado'].removesuffix('.pdf')
        rendered.mkdir(parents=True, exist_ok=True)
        doc = fitz.open(path)
        image_count = 0
        for number, page in enumerate(doc, 1):
            image_count += len(page.get_images())
            page.get_pixmap(matrix=fitz.Matrix(1.1, 1.1), alpha=False).save(
                rendered / f'pagina_{number:02d}.png')
        doc.close()
        if image_count == 0:
            erros.append('Nenhuma imagem incorporada ao documento')
        resultados.append({'arquivo':str(path.relative_to(ROOT)),
                           'paginas':len(reader.pages),
                           'referencias_a_imagens':image_count,
                           'erros':erros,
                           'renderizacoes':str(rendered.relative_to(ROOT))})
        falhas.extend(f'{item["gerado"]}: {erro}' for erro in erros)
    report = {'alvo':alvo, 'documentos':resultados, 'falhas':falhas,
              'observacao':'Verificação estrutural; revisar as páginas renderizadas visualmente.'}
    (BUILD / f'validacao_{alvo}.json').write_text(
        json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps(report,ensure_ascii=False,indent=2))
    return 1 if falhas else 0


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--alvo',choices=['finais','build'],default='finais')
    args = parser.parse_args()
    sys.exit(validar(args.alvo))
