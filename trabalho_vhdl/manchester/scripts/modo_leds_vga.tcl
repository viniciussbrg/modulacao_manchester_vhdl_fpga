if {[llength [get_projects -quiet]] != 1} {error "Abra primeiro o projeto manchester."}
if {[get_property TOP [get_filesets sources_1]] ne "manchester_top"} {error "Projeto aberto nao corresponde a manchester."}
set_property generic {CYCLES_PER_BIT=100000000} [get_filesets sources_1]
puts "CYCLES_PER_BIT=100000000. Gere um NOVO bitstream e reprograme a FPGA."
puts "As simulacoes usam parametros pequenos proprios."
