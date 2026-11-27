# Execute no Tcl Console do Vivado ou em modo batch.
set project_dir [file dirname [file normalize [info script]]]
set source_dir [file dirname $project_dir]
set project_name manchester_dif
set project_file [file join $project_dir ${project_name}.xpr]

if {[file isfile $project_file]} {
    open_project $project_file
    return
}

create_project $project_name $project_dir -part xc7a35tcpg236-1
set_property target_language VHDL [current_project]
set_property target_simulator XSim [current_project]

add_files -fileset sources_1 [list \
    [file join $source_dir src vga_sync.vhd] \
    [file join $source_dir src ${project_name}.vhd]]
add_files -fileset sim_1 [file join $source_dir sim ${project_name}_tb.vhd]
add_files -fileset constrs_1 [file join $source_dir constraints ${project_name}.xdc]

set_property top $project_name [get_filesets sources_1]
set_property top ${project_name}_tb [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
