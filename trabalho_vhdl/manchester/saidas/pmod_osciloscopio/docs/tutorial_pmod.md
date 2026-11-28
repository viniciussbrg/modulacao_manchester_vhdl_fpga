# Osciloscópio — Manchester IEEE 802.3

1. Abra o projeto e execute `scripts/modo_osciloscopio.tcl`.
2. O generic passa a `CYCLES_PER_BIT=100000`: 100 MHz / 100000 = **1 kbit/s**, 1 ms/bit e 0,5 ms por metade.
3. Gere novo bitstream e programe a placa.
4. Conecte CH1 a JA1/J1 (codificado), CH2 a JA2/L2 (dado capturado), e terras a JA5 ou JA11/GND.
5. Comece com acoplamento DC, cerca de 1 V/div e 0,5 ms/div. Ajuste o trigger do CH1 e a janela para alguns bits.
6. Configure `B2C9` nos switches: SW15..SW0 = `1011001011001001`. Pressione e solte BTNC.
7. Identifique cada intervalo pelo dado e pela escala de tempo. Bit 0: alto na primeira metade e baixo na segunda. Bit 1: baixo na primeira metade e alto na segunda.
8. Capture ambos os canais juntos. Anote código, padrão, taxa, escala de tempo/tensão e canais; marque início e meio de bit.
9. Repita com zeros, uns e alternados para distinguir as regras.
10. Para voltar a observar LEDs/VGA lentamente, execute `scripts/modo_leds_vga.tcl`, gere novo bitstream e reprograme.

O dado em JA2 é o bit capturado. Sua estabilidade durante todo o bit é intencional.
No modo rápido, LEDs e VGA também recebem o sinal de 1 kbit/s e podem parecer contínuos/misturados; use o modo lento para a demonstração visual.



## Conexão e identificação dos canais

A pinagem de projeto é JA1/J1 para pmod_encoded e JA2/L2 para pmod_data, com referência GND comum no PMOD. Ligue as entradas do instrumento a esses sinais e identifique os canais na aquisição. CH1=código e CH2=dado é a configuração proposta para reprodução. A associação efetiva dos canais e o modelo do equipamento usado nos vídeos não foram informados.

## Registro experimental

O grupo confirmou medições diretamente nas saídas PMOD conforme o enunciado. A imagem foi extraída de manchester_pmod.mp4. As escalas e os canais não estão suficientemente legíveis para obter medidas numéricas ou atribuir as curvas por cor. O modo de 1 kbit/s descrito no roteiro é uma configuração de reprodução definida pelo script, sem medição quantitativa confirmada no vídeo.

![Registro da aquisição física fornecido pelo grupo](midia/manchester_pmod_2.jpg)

## Análise das transições

A convenção IEEE 802.3 representa 0 por alto/baixo e 1 por baixo/alto. A transição central é de descida para 0 e de subida para 1. Use o início do intervalo do dado para localizar cada bit e marque a metade. Compare as curvas com a regra e exporte a tela com identificação dos canais, tempo/div e tensão/div. Mantenha a imagem original junto com qualquer anotação.
