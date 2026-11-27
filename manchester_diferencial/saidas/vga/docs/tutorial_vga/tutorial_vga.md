# Tutorial VGA — Manchester Diferencial

**Faculdade Engenheiro Salvador Arena**  
Disciplina: Comunicação de Dados — Sistemas Reconfiguráveis  
Professor: Vinícius S. Borges  
Semestre 2026/2 — Grupo 1

| Integrante | RA |
|---|---|
| Eduardo Souza Urbanovicz Bastiani | 082230018 |
| João Vitor Maciel Nai | 082230004 |
| Ronaldo de Oliveira Santos | 082230031 |

Passo a passo para ver o sinal Manchester Diferencial piscando na tela de um monitor VGA.

## 1. Pré-requisitos

| Item | Detalhe |
|---|---|
| Placa | Basys 3 + cabo micro-USB |
| Monitor | Qualquer monitor com entrada **VGA** (para monitor só HDMI, é preciso conversor ativo VGA → HDMI) |
| Cabo | Cabo VGA (conector DB-15) |
| Bitstream | `manchester_diferencial.bit` ([tutorial da placa](../../../../docs/tutorial_placa/tutorial_placa.md)) |

## 2. Conexão física

1. Com a placa desligada (chave POWER em OFF), ligue o cabo VGA no conector VGA da Basys 3 e no monitor.
2. Ligue o monitor e a placa e selecione **VGA** como entrada do monitor.

![Basys 3 com cabo VGA e cabo micro-USB.](placa_cabo_vga.jpg)

*Figura 1 — Basys 3 com o cabo VGA e o cabo micro-USB conectados (mesma montagem nos dois projetos).*

## 3. Gravar o bitstream

Siga as seções 5 e 6 do [tutorial da placa](../../../../docs/tutorial_placa/tutorial_placa.md). Não é preciso trocar o top nem o XDC: o top `manchester_diferencial` já instancia `vga_sync`. Logo após a gravação o monitor recebe imagem (640x480, ≈ 59,5 Hz; o monitor pode indicar 60 Hz).

## 4. Observar

1. Deixe o **BTNU solto** (1 s por bit). No modo rápido a tela troca de cor rápido demais para ser vista.
2. Aperte e solte o **BTNC** para recomeçar em SW15.
3. A tela inteira alterna entre **vermelho** e **amarelo**, acompanhando o LED ativo, e **sempre muda de cor no meio do bit**.

| Bit atual | Início do bit | Meio do bit |
|---|---|---|
| 0 | a cor **troca** em relação ao fim do bit anterior | troca |
| 1 | a cor **se mantém** | troca |

Após o reset a tela fica **vermelha** (nível baixo) e o primeiro bit parte dessa cor. Enquanto o **BTNC** está pressionado, a tela permanece vermelha e o sincronismo continua ativo.

## 5. Resultado esperado

![Tela VGA vermelha com o projeto diferencial.](tela_vermelha_nivel0.png)

*Figura 2 — Projeto diferencial: tela inteira em **vermelho** (sinal em nível 0), com o WaveForms exibindo o mesmo sinal no notebook e a Basys 3 à direita (quadro do vídeo `diferencial_video_01.mp4`). No nível 1 a tela fica **amarela**.*

O vídeo de demonstração está listado em [relatorio_final/README.md](../../../../../relatorio_final/README.md).

## 6. Problemas comuns

| Problema | Solução |
|---|---|
| "Sem sinal" | Selecione a entrada VGA no monitor e confira o cabo e o `.bit` |
| "Fora de faixa" / *Out of range* | Alguns monitores rejeitam 25 MHz (o padrão exato é 25,175 MHz); tente outro monitor |
| Faixas ou cor média no vídeo | Modo rápido ativo ou efeito da câmera; solte o BTNU e compare com o osciloscópio |
| Tela sempre da mesma cor | Confira se o BTNC não está pressionado e se o `.bit` gravado é deste projeto |
