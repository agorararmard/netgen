# General config
set ::env(DESIGN_NAME) $::env(DESIGN)
set ::env(SPICE_NETLIST) $::env(test_dir)/$::env(DESIGN_NAME).spice
set ::env(CURRENT_NETLIST) $::env(test_dir)/$::env(DESIGN_NAME).lvs.powered.v