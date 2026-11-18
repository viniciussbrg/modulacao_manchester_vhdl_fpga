"""Gera os tutoriais e as referências técnicas; só substitui os finais com --publicar."""
import argparse
from pathlib import Path
import shutil
import subprocess
import sys

from caminhos_documentacao import ROOT, BUILD, DOCUMENTOS


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--publicar', action='store_true',
                        help='copiar os PDFs validados para os destinos finais')
    args = parser.parse_args()
    here = Path(__file__).resolve().parent
    for script in ('criar_tutoriais_simulacao.py', 'criar_tutoriais_pmod.py',
                   'criar_documentacao_projetos.py'):
        subprocess.run([sys.executable, str(here / script)], cwd=ROOT, check=True)
    subprocess.run([sys.executable, str(here / 'validar.py'), '--alvo', 'build'],
                   cwd=ROOT, check=True)
    if args.publicar:
        for doc in DOCUMENTOS:
            destino = ROOT / doc['destino']
            destino.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(BUILD / 'pdf' / doc['gerado'], destino)
            print(f'Publicado: {doc["destino"]}')
    else:
        print('Geração concluída em .build/documentacao/pdf/. PDFs finais preservados.')


if __name__ == '__main__':
    main()
