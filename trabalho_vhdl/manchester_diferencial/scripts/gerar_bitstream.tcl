# Executar depois da simulacao. Nao grava a placa automaticamente.
if {[llength [get_projects -quiet]] != 1} {error "Abra primeiro o projeto manchester_diferencial."}
if {[get_property TOP [get_filesets sources_1]] ne "manchester_diferencial_top"} {error "Projeto errado."}
catch {close_sim}
# Reset dos resultados derivados; fontes e configuracao sao preservadas.
reset_run synth_1
launch_runs synth_1 -jobs 2
wait_on_run synth_1
if {![string match "*Complete*" [get_property STATUS [get_runs synth_1]]]} {
    error "Sintese nao concluiu. Consulte o log synth_1."
}
launch_runs impl_1 -to_step write_bitstream -jobs 2
wait_on_run impl_1
if {![string match "*write_bitstream Complete*" [get_property STATUS [get_runs impl_1]]]} {
    error "Implementacao/bitstream nao concluiu. Consulte o log impl_1."
}
open_run impl_1
set report_dir [file join [get_property DIRECTORY [current_project]] reports]
file mkdir $report_dir
report_timing_summary -file [file join $report_dir timing_summary.rpt]
report_utilization -file [file join $report_dir utilization.rpt]
report_drc -file [file join $report_dir drc.rpt]
report_cdc -file [file join $report_dir cdc.rpt]
check_timing -verbose -file [file join $report_dir check_timing.rpt]
puts "Bitstream gerado. Confira timing (setup/hold), DRC e CDC antes de gravar."
puts "Relatorios: $report_dir"
puts "Use Open Hardware Manager -> Open Target -> Auto Connect -> Program Device."
