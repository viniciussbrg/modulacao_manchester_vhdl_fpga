"""Relatório do grupo 4 a partir dos registros de simulação e de bancada."""
from criar_tutoriais_simulacao import CONFIGS, Tutorial
from criar_tutoriais_bancada import fotografia
from estilo_tutoriais import WIDTH


def criar():
    doc = Tutorial(dict(title='Grupo 4', short='Comunicação de Dados', filename='relatorio.pdf', paginas=5))
    doc.c.setTitle('Codificação Manchester e Manchester Diferencial — Relatório técnico')
    doc.c.setKeywords('Manchester, Manchester Diferencial, NRZ-L, Basys 3, Grupo 4')
    doc.start()
    doc.p('Codificação de linha em VHDL', 'title', gap=3)
    doc.p('Manchester e Manchester Diferencial', 'subtitle', gap=16)
    doc.members()
    doc.p('<b>Relatório técnico · Grupo 4</b><br/>Comunicação de Dados — Sistemas Reconfiguráveis<br/>Professor Vinicius Borges · 7º semestre · Novembro de 2026')
    doc.h2('Resumo')
    doc.p('Foram implementados dois codificadores para a Basys 3. A mesma palavra de 16 bits foi percorrida em ordem decrescente, o que permitiu comparar duas regras de transição. Os registros do XSim indicaram sucesso em nove cenários do Manchester básico e dez do diferencial. Na bancada, observaram-se o sinal codificado no PMOD e os estados branco e verde no monitor. As capturas do osciloscópio registraram um canal. A comparação temporal simultânea com o dado original permaneceu em aberto.')
    doc.h2('Objetivo')
    doc.p('Buscou-se relacionar o intervalo de bit às transições observadas na simulação e às saídas da placa. A comparação com NRZ-L tomou como referência a mesma sequência de entrada e a mesma taxa de bits [1].')

    doc.start('1. Fundamentos e desenvolvimento')
    doc.p('Adotou-se a convenção IEEE 802.3 para o Manchester básico. Para o diferencial, partiu-se do nível baixo após o reset. O quadro apresenta os níveis teóricos de quatro bits consecutivos. Cada par representa as duas metades de um intervalo [1].')
    doc.table(['Sequência transmitida', '1', '1', '0', '0'], [
        ['NRZ-L (1 = alto)', '11', '11', '00', '00'],
        ['Manchester básico', '01', '01', '10', '10'],
        ['Manchester Diferencial', '01', '10', '10', '10'],
    ], [203,74,74,74,WIDTH-425],gap=4)
    doc.p('Quadro 1. Exemplo calculado para a palavra 1100. Fonte: elaboração própria (2026).','caption')
    doc.p('Em NRZ-L, os bits iguais mantiveram o nível e não ofereceram uma borda para recuperar o relógio. Nos dois códigos Manchester ocorreu uma inversão central em todos os bits. Com níveis simétricos em torno de zero, as duas metades tiveram áreas opostas, equilibrando a média em cada bit. Na saída física de 0 a 3,3 V, esse equilíbrio correspondeu a uma média ideal próxima de 1,65 V.')
    doc.p('A alternância em meios intervalos exigiu maior largura de banda que NRZ-L para a mesma taxa de dados. A inversão de polaridade trocou o sentido das bordas no básico. No diferencial, preservou a presença ou ausência de transição na fronteira, desde que a referência anterior também fosse invertida.')
    doc.h2('Método e decisões de projeto')
    doc.p('Os codificadores foram descritos em projetos Vivado 2025.2 separados. Cada switch foi amostrado no início do próprio bit. Escolheram-se 100 milhões de ciclos a 100 MHz para observar cada metade por 0,5 s. No testbench, o generic foi reduzido para dez ciclos de 10 ns. Essa mudança de escala permitiu comparar a lógica no XSim e na placa sem esperar 16 s por palavra em simulação.')
    doc.p('O registrador de saída do diferencial conservou o nível anterior inclusive na volta de SW0 para SW15. Os tops de implementação encaminharam o nível codificado ao LED selecionado, ao pino L2 do PMOD e à seleção de cor do VGA.')

    doc.start('2. Resultados da simulação')
    doc.p('A janela inicial do XSim mostrou a sequência B2A5 a partir de 100 ns. Os três primeiros bits foram 1, 0 e 1. O índice indicou o switch em transmissão, current_bit mostrou o dado capturado e data_out mostrou o nível codificado.')
    for n, cfg in enumerate(CONFIGS,1):
        doc.cfg['dif'] = cfg['dif']
        doc.wave(cfg['initial'], *cfg['initial_y'],
                 f"Figura {n}. {cfg['title']}, início da sequência. Fonte: acervo dos autores (2026).")
    doc.p('Entre 200 e 250 ns, o segundo bit teve nível alto no básico e baixo no diferencial. No básico, o bit 0 começou alto. No diferencial, a entrada do bit 0 inverteu o nível alto com que o bit anterior havia terminado. Os registros históricos de término indicaram sucesso em 19.641 ns e 24.471 ns, respectivamente.')

    doc.start('3. Resultados no osciloscópio')
    doc.p('O Analog Discovery 3 adquiriu o sinal de JA2 em C1, com terra comum. No WaveForms 3.24.4, a escala horizontal foi de 2 s/div e a vertical de 1 V/div. A aquisição utilizou 1,6 kHz e 32.000 amostras.')
    for n, (nome, descricao) in enumerate([
        ('image(20261114-013716).png','Manchester básico'),
        ('image(20261114-013848).png','Manchester Diferencial'),
    ],3):
        fotografia(doc,nome,311,f'Figura {n}. {descricao} com os switches em zero. C1 registrou o sinal codificado.')
    doc.p('As capturas com zeros apresentaram níveis próximos de 0 V e 3,3 V e patamares de cerca de 0,5 s. A escala de tempo correspondeu à parametrização da placa. No diferencial, a sucessão de zeros exigiu uma inversão no início e outra no meio do bit. Sem o dado original em C2, a fase dos bits permaneceu indeterminada na leitura isolada de C1.')

    doc.start('4. Resultados na placa e conclusões')
    top = doc.y
    alturas = [
        doc.draw_crop('basys3_usb',(292,419,1652,2118),49,top,145),
        doc.draw_crop('vga_branco',(0,0,3024,4031),218,top,145),
        doc.draw_crop('vga_verde',(0,0,600,800),387,top,145),
    ]
    doc.y -= max(alturas) + 7
    doc.p('Figura 5. Da esquerda para a direita: conexão USB com LD4 e DONE acesos, monitor branco e monitor verde com a Basys 3 ligada por VGA. Fonte: acervo dos autores (2026).','caption')
    doc.p('O indicador DONE apareceu aceso na fotografia da placa. A tela passou a branco na subida do sinal codificado e a verde na descida. As cores corresponderam aos valores RGB previstos para a área ativa: FFF em nível alto e 0C0 em nível baixo. Os registros fotográficos preservaram dois estados da saída. O tempo entre mudanças e a ordem de vários bits dependiam de um registro contínuo.')
    doc.h2('Conclusões')
    doc.p('A sequência B2A5 evidenciou a diferença entre recuperar o dado pelo sentido da borda central e recuperá-lo pela transição inicial em relação ao nível anterior. Nas medições, zeros consecutivos produziram traços semelhantes nos dois codificadores. Isso limitou o valor da forma de onda isolada para identificar a convenção. A comprovação da sequência diferencial alternada permaneceu dependente de uma aquisição sincronizada com o dado original.')
    doc.p('Para concluir a comparação experimental, restaram a aquisição em dois canais e a demonstração contínua, identificada por projeto, do reset, do percurso dos LEDs e das mudanças de cor.')
    doc.h2('Referências')
    doc.p('[1] FACULDADE ENGENHEIRO SALVADOR ARENA. Trabalho prático: Codificação de Linha Manchester em VHDL (Vivado). Comunicação de Dados, 2026, p. 1–6.','caption')
    doc.p('[2] AMD. <i>Vivado Design Suite User Guide: Logic Simulation</i>, UG900, v. 2025.2. [3] AMD. <i>Vivado Design Suite User Guide: Programming and Debugging</i>, UG908, v. 2025.2.','caption')
    doc.finish_page()
    doc.c.save()


if __name__ == '__main__':
    criar()
