 create_project piradio_loopback piradio_loopback -part xczu28dr-ffvg1517-2-e
set_property board_part xilinx.com:zcu111:part0:1.4 [current_project]
# BD Wrapper has to be verilog or else simulation crashes
set_property target_language Verilog [current_project]
set_property  ip_repo_paths  ../ofdm-ip-cores [current_project]
add_files piradio_loopback.srcs/sources_1/imports/new/zero_pad.v
update_ip_catalog
source project_bd.tcl
update_compile_order -fileset sources_1
make_wrapper -files [get_files piradio_loopback/piradio_loopback.srcs/sources_1/bd/design_3/design_3.bd] -top
add_files -norecurse piradio_loopback/piradio_loopback.gen/sources_1/bd/design_3/hdl/design_3_wrapper.v
start_gui
