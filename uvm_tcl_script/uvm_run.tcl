puts "Run Simulation TCL!"
# run_simulation.tcl

# Check if the correct number of arguments are passed
if { [llength $argv] != 2 } {
    puts "Usage: vivado -mode batch -source uvm_run.tcl -tclargs <project_name> <project_location>"
    exit 1
}

# Get the project name and location from the arguments
set project_name [lindex $argv 0]
set project_location [lindex $argv 1]

# Print the received arguments
puts "Project Name: $project_name"
puts "Project Location: $project_location"


# Create a new Vivado project
create_project $project_name $project_location/verif -part xc7z020clg400-1 -force

# Add Source files
add_files [glob $project_location/*.sv]

# Set UVM properties
set_property -name {xsim.compile.xvlog.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.elaborate.xelab.more_options} -value {-L uvm} -objects [get_filesets sim_1]

set_property top tb_$project_name [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]


#set_property top test [current_fileset]
#set_property top_file {$project_location/$project_name.sv} [current_fileset]

# Start Simulation
launch_simulation
