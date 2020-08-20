

source $::env(NETGEN_ROOT)/travisCI/sourceConfigs.tcl
set ::env(OUT_DIR) $::env(test_dir)/lvs
if { ![file isdirectory $::env(OUT_DIR)] } {
	exec mkdir $::env(OUT_DIR)/
}

puts "Running LVS..."

set layout $::env(SPICE_NETLIST)
set schematic $::env(CURRENT_NETLIST)

set setup_file $::env(NETGEN_SETUP_FILE)
set module_name $::env(DESIGN_NAME)
set output $::env(OUT_DIR)/lvs_final.log

puts "$layout against $schematic"
    
exec netgen -batch lvs \
    "$layout $module_name" \
    "$schematic $module_name" \
    $setup_file \
    $output \
    -json |& tee /dev/tty $::env(OUT_DIR)/lvs_inter.log

exec python3 $::env(NETGEN_ROOT)/travisCI/count_lvs.py -f $::env(OUT_DIR)/lvs_final.json \
    |& tee /dev/tty $::env(OUT_DIR)/lvs_final_parsed.log