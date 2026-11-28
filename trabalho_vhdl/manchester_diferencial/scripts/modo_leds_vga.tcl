if {[llength [get_projects -quiet]] != 1} {error "Abra primeiro o projeto manchester_diferencial."}
if {[get_property TOP [get_filesets sources_1]] ne "manchester_diferencial_top"} {error "Projeto aberto nao corresponde a manchester_diferencial."}
set_property generic {CYCLES_PER_BIT=100000000} [get_filesets sources_1]
puts "CYCLES_PER_BIT=100000000. Gere um NOVO bitstream e reprograme a FPGA."
puts "As simulacoes usam parametros pequenos proprios."
