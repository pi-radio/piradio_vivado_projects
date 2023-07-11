 create_project piradio_standalone piradio_standalone -part xczu28dr-ffvg1517-2-e
set_property board_part xilinx.com:zcu111:part0:1.4 [current_project]
# BD Wrapper has to be verilog or else simulation crashes
set_property target_language Verilog [current_project]
set_property  ip_repo_paths  ../ofdm-ip-cores [current_project]
update_ip_catalog
source project_sa_bd.tcl
update_compile_order -fileset sources_1
make_wrapper -files [get_files piradio_standalone/piradio_standalone.srcs/sources_1/bd/node_bd/node_bd.bd] -top
add_files -norecurse piradio_standalone/piradio_standalone.gen/sources_1/bd/node_bd/hdl/node_bd_wrapper.v
start_gui
