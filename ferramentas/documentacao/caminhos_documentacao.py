"""Caminhos relativos para executar os geradores em Windows, Linux ou macOS."""
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[2]
BUILD = ROOT / '.build' / 'documentacao'
BUILD.mkdir(parents=True, exist_ok=True)
HERE = Path(__file__).resolve().parent
_MEDIA = json.loads((HERE / 'evidencias.json').read_text(encoding='utf-8'))
DOCUMENTOS = json.loads((HERE / 'documentos.json').read_text(encoding='utf-8'))


def localizar_midia(nome):
    caminho = (ROOT / _MEDIA[nome]).resolve()
    if not caminho.is_relative_to(ROOT) or not caminho.is_file():
        raise FileNotFoundError(f'Evidência ausente ou fora do projeto: {nome}')
    return caminho
