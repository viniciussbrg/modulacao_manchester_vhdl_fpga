if {[llength [get_projects -quiet]] != 1} {error "Abra primeiro o projeto manchester_diferencial."}
if {[get_property TOP [get_filesets sources_1]] ne "manchester_diferencial_top"} {error "Projeto errado."}
catch {close_sim}
set_property top manchester_diferencial_tb [get_filesets sim_1]
set_property generic {} [get_filesets sim_1]
set_property xsim.simulate.runtime {0ns} [get_filesets sim_1]
update_compile_order -fileset sim_1
launch_simulation -simset sim_1 -mode behavioral
log_wave -r /*
add_wave /manchester_diferencial_tb/*
run all
puts "Confira PASS no console e ausencia de assertion failure."
