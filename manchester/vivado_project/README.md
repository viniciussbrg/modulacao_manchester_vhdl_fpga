# Projeto Vivado — Manchester (IEEE 802.3)

O arquivo `manchester.xpr` será gerado neste diretório, com o dispositivo `xc7a35tcpg236-1` e as fontes das pastas do projeto.

No Vivado 2025.2, abra o **Tcl Console**, entre nesta pasta com `cd` e execute:

```tcl
source criar_projeto.tcl
```

Também é possível rodar `vivado -mode batch -source criar_projeto.tcl` a partir deste diretório e abrir `manchester.xpr` depois. Se o .xpr já existir, o script abre o projeto existente. As fontes são referenciadas nas pastas `src/`, `sim/` e `constraints/`; mantenha a estrutura ao mover o projeto.

Esta versão da entrega inclui o script Tcl. Ao executar o script no Vivado, o projeto será gerado a partir das fontes incluídas.

[Tutorial de simulação](../docs/tutorial_simulacao.pdf) · [Referência Tcl do Vivado](https://docs.amd.com/r/en-US/ug835-vivado-tcl-commands)
