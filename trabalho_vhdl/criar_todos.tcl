# Executar no Vivado: Tools -> Run Tcl Script -> criar_todos.tcl
set package_root [file dirname [file normalize [info script]]]
if {[llength [get_projects -quiet]] != 0} {error "Feche o projeto atual antes de criar os dois projetos."}
# Checar antes de criar qualquer projeto; nunca sobrescrever projeto existente.
foreach project_name {manchester manchester_diferencial} {
    set candidate [file join $package_root $project_name vivado_project ${project_name}.xpr]
    if {[file exists $candidate]} {error "Ja existe $candidate. Abra o .xpr ou extraia o pacote em outra pasta."}
}
foreach project_name {manchester manchester_diferencial} {
    source [file join $package_root $project_name criar_projeto.tcl]
    close_project
}
open_project [file join $package_root manchester vivado_project manchester.xpr]
puts "Dois projetos criados. Manchester esta aberto; simule antes de gerar o bitstream."
