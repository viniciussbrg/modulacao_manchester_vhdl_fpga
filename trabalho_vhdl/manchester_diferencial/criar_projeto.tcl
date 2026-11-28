# Execute no Vivado completo (nao no Vivado Lab).
# O diretorio e calculado a partir deste script, nao do diretorio atual.
set project_source_root [file dirname [file normalize [info script]]]
if {[llength [get_projects -quiet]] != 0} {
    error "Feche o projeto atual antes de executar criar_projeto.tcl."
}
set project_output [file join $project_source_root vivado_project]
if {[file exists [file join $project_output manchester_diferencial.xpr]]} {
    error "Projeto ja existe. Abra $project_output/manchester_diferencial.xpr; nada foi sobrescrito."
}
create_project manchester_diferencial $project_output -part xc7a35tcpg236-1
set_property target_language VHDL [current_project]
set_property simulator_language Mixed [current_project]
set design_sources [list \
    [file join $project_source_root src input_conditioner.vhd] \
    [file join $project_source_root src line_encoder.vhd] \
    [file join $project_source_root saidas vga src vga_colors.vhd] \
    [file join $project_source_root src manchester_diferencial_top.vhd]]
import_files -fileset sources_1 -norecurse $design_sources
import_files -fileset sim_1 -norecurse [glob [file join $project_source_root sim *.vhd]]
import_files -fileset constrs_1 -norecurse [file join $project_source_root constraints manchester_diferencial.xdc]
set_property file_type {VHDL 2008} [get_files *.vhd]
set_property top manchester_diferencial_top [get_filesets sources_1]
set_property generic {CYCLES_PER_BIT=100000000} [get_filesets sources_1]
set_property top manchester_diferencial_tb [get_filesets sim_1]
set_property xsim.simulate.runtime {40us} [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
puts "PRONTO: $project_output/manchester_diferencial.xpr"
puts "Proximo passo: Run Simulation -> Run Behavioral Simulation."
