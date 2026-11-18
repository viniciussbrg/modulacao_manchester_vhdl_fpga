"""Confere os bytes do pacote original sem dependências externas."""
from pathlib import Path
import hashlib
import json
import sys

ROOT = Path(__file__).resolve().parents[2]


def main():
    manifest = json.loads((ROOT / 'MANIFESTO_SHA256.json').read_text(encoding='utf-8'))
    failures = []
    for item in manifest['arquivos']:
        path = ROOT / item['caminho']
        if not path.is_file():
            failures.append('Ausente: ' + item['caminho'])
        elif hashlib.sha256(path.read_bytes()).hexdigest() != item['sha256']:
            failures.append('Conteúdo alterado: ' + item['caminho'])
    print(f'Arquivos conferidos: {len(manifest["arquivos"])}')
    if failures:
        print('\n'.join(failures))
        print('Após edições intencionais, diferenças do pacote inicial são esperadas; consulte o Git.')
        return 1
    print('Integridade do pacote inicial confirmada.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
