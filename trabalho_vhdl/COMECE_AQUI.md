# Como abrir e usar no Vivado

## 1. Extrair

Extraia o ZIP inteiro. Exemplo de pasta no Windows: `C:/VHDL/trabalho_vhdl/`.
Não abra arquivos diretamente dentro do ZIP. Mantenha as pastas dos dois projetos.

## 2. Criar os projetos automaticamente

1. Abra o **Vivado completo**, com suporte à família Artix-7 instalado.
2. Feche o projeto NRZL, caso esteja aberto (**File → Close Project**).
3. Use **Tools → Run Tcl Script**.
4. Selecione `criar_todos.tcl` na raiz do pacote.
5. Aguarde. O script cria os dois projetos e deixa o Manchester aberto.

Alternativa pelo Tcl Console, adaptando a pasta:

```tcl
source {C:/VHDL/trabalho_vhdl/criar_todos.tcl}
```

O script não sobrescreve projetos existentes. Para repetir do zero, extraia novamente em outra pasta.
Se um dos projetos já existir e o outro não, abra o existente ou execute apenas `criar_projeto.tcl` da pasta que falta, com todos os projetos fechados.

## 3. Simular primeiro

Clique em **Run Simulation → Run Behavioral Simulation**.
O teste do codificador deve terminar com `PASS` no console, sem erros de assertion.
Se necessário, clique **Run All**. O teste padrão leva cerca de **30,5 µs de tempo simulado**, não segundos reais de transmissão.

Para validar a integração e VGA, execute também os scripts da pasta do projeto:

- `scripts/simular_integracao.tcl`
- `scripts/simular_vga.tcl`
- `scripts/simular_core.tcl` para retornar à simulação principal.

## 4. Gerar e gravar

1. Execute **Run Synthesis → Run Implementation → Generate Bitstream**.
2. Confira os relatórios de timing e DRC. Se houver erro, resolva antes de gravar.
3. Conecte e ligue a Basys 3.
4. **Open Hardware Manager → Open Target → Auto Connect → Program Device**.
5. Escolha o `.bit` do projeto correspondente.

Também há `scripts/gerar_bitstream.tcl`, que automatiza síntese, implementação e geração de relatórios. Ele não grava a placa.

## 5. Usar a placa

| Controle/saída | Comportamento |
|---|---|
| SW15..SW0 | Sequência de 16 bits, transmitida repetidamente nessa ordem |
| BTNC | Segure para parar/zerar; solte para reiniciar em SW15 |
| LEDs | Só a posição atual recebe o sinal codificado |
| PMOD JA1 | Sinal codificado |
| PMOD JA2 | Bit original capturado |
| VGA | Azul para 0, verde para 1 |

O padrão é **1 segundo por bit**, com duas metades de 0,5 segundo.
Para osciloscópio, execute `scripts/modo_osciloscopio.tcl` e gere/grave novo bitstream: **1 kbit/s**.
Para retornar ao modo lento, execute `scripts/modo_leds_vga.tcl` e gere/grave novo bitstream.

## 6. Abrir o segundo projeto ou reabrir depois

Use **File → Close Project** e depois **File → Open Project**:

- `manchester/vivado_project/manchester.xpr`
- `manchester_diferencial/vivado_project/manchester_diferencial.xpr`

Esses arquivos só existem depois da criação pelo Tcl. Na primeira vez, execute o script.
Não execute a criação novamente se pretende apenas abrir o projeto.

## 7. Se algo falhar

| Mensagem/sintoma | O que conferir |
|---|---|
| Componente FPGA não encontrado | Instalação do suporte Artix-7 no Vivado |
| `std.env`/`finish` não reconhecido | Tipo dos `.vhd` deve ser **VHDL 2008** |
| Arquivo não encontrado | Extração completa; criar pelo Tcl; não mover somente o `.xpr` |
| Sem placa no Hardware Manager | Alimentação, cabo de dados, porta de programação e drivers |
| VGA parece parada ou misturada | Voltar ao modo lento e regravar; selecionar entrada VGA no monitor |
| LEDs não mostram nada logo ao iniciar | Espere a segunda metade; em Manchester, bit 1 começa apagado |

Ao editar fontes dentro do Vivado, são alteradas as cópias em `vivado_project/*.srcs/`; mantenha também a versão correspondente nas pastas de código do repositório.
Leia [VALIDACAO.md](VALIDACAO.md) para distinguir os testes executados das validações ainda pendentes.
