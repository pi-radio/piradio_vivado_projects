
################################################################
# This is a generated script based on design: node_bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source node_bd_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# zero_pad

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu28dr-ffvg1517-2-e
   set_property BOARD_PART xilinx.com:zcu111:part0:1.4 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name node_bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:axis_broadcaster:1.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:user:iq_interleaver_gain:1.0\
xilinx.com:user:signal_detect:1.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:usp_rf_data_converter:2.6\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:zynq_ultra_ps_e:3.4\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:fifo_generator:13.2\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:user:OFDM_demodulator:1.0\
xilinx.com:user:cfo_estimator:1.0\
xilinx.com:user:ssr_FFT:1.0\
xilinx.com:user:synchronizer:1.0\
xilinx.com:user:tlast_generator:1.0\
xilinx.com:user:zf_equalizer:1.0\
xilinx.com:user:OFDM_Framer:1.0\
xilinx.com:user:ssr_IFFT:1.0\
xilinx.com:user:OFDM_correlator:1.0\
xilinx.com:user:delay:1.0\
xilinx.com:user:fec_controller:1.0\
xilinx.com:ip:sd_fec:1.1\
xilinx.com:ip:axis_subset_converter:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
zero_pad\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: fec_hier_tx0
proc create_hier_cell_fec_hier_tx0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_fec_hier_tx0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_FEC

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_fec_in


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk core_clk
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: axis_broadcaster_0, and set properties
  set axis_broadcaster_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_0 ]

  # Create instance: axis_subset_converter_2, and set properties
  set axis_subset_converter_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_2 ]
  set_property -dict [ list \
   CONFIG.M_TDATA_NUM_BYTES {16} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
   CONFIG.TDATA_REMAP {\
96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,tdata[31:0]} \
   CONFIG.TKEEP_REMAP {1'b0} \
 ] $axis_subset_converter_2

  # Create instance: axis_subset_converter_3, and set properties
  set axis_subset_converter_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_3 ]
  set_property -dict [ list \
   CONFIG.M_TDATA_NUM_BYTES {4} \
   CONFIG.S_TDATA_NUM_BYTES {16} \
   CONFIG.TDATA_REMAP {tdata[31:0]} \
   CONFIG.TKEEP_REMAP {1'b0} \
 ] $axis_subset_converter_3

  # Create instance: fec_controller_0, and set properties
  set fec_controller_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:fec_controller:1.0 fec_controller_0 ]
  set_property -dict [ list \
   CONFIG.C_S00_AXIS_TDATA_WIDTH {32} \
 ] $fec_controller_0

  # Create instance: sd_fec_0, and set properties
  set sd_fec_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:sd_fec:1.1 sd_fec_0 ]
  set_property -dict [ list \
   CONFIG.Build_SDK_Project {true} \
   CONFIG.DIN_Words {4} \
   CONFIG.DOUT_Words {4} \
   CONFIG.DRV_INITIALIZATION_PARAMS {{ 0x00000014,0x00000001,0x0000000C,0x00000000 }} \
   CONFIG.DRV_STANDARD {1} \
   CONFIG.DRV_TURBO_PARAMS {undefined} \
   CONFIG.Example_Design_PS_Type {ZYNQ_UltraScale+_RFSoC} \
   CONFIG.HDL_INITIALIZATION {{20 1 FEC_CODE} {12 0 AXIS_WIDTH}} \
   CONFIG.Include_Encoder {true} \
   CONFIG.Include_PS_Example_Design {true} \
   CONFIG.LDPC_Decode {false} \
   CONFIG.LDPC_Encode {true} \
   CONFIG.LD_PERCENT_LOAD {0} \
   CONFIG.LE_PERCENT_LOAD {100} \
   CONFIG.Parameter_Interface {Initialized_retain_I/F} \
   CONFIG.Physical_Utilization {100} \
   CONFIG.Standard {5G} \
   CONFIG.TD_PERCENT_LOAD {0} \
   CONFIG.Turbo_Decode {false} \
 ] $sd_fec_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXIS] [get_bd_intf_pins axis_subset_converter_3/M_AXIS]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins s_axis_fec_in] [get_bd_intf_pins axis_broadcaster_0/S_AXIS]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_FEC] [get_bd_intf_pins sd_fec_0/S_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins s_axi] [get_bd_intf_pins fec_controller_0/s_axi]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M00_AXIS [get_bd_intf_pins axis_broadcaster_0/M00_AXIS] [get_bd_intf_pins fec_controller_0/s00_axis]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M01_AXIS [get_bd_intf_pins axis_broadcaster_0/M01_AXIS] [get_bd_intf_pins axis_subset_converter_2/S_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_2_M_AXIS [get_bd_intf_pins axis_subset_converter_2/M_AXIS] [get_bd_intf_pins sd_fec_0/S_AXIS_DIN]
  connect_bd_intf_net -intf_net fec_controller_0_m00_axis [get_bd_intf_pins fec_controller_0/m00_axis] [get_bd_intf_pins sd_fec_0/S_AXIS_CTRL]
  connect_bd_intf_net -intf_net sd_fec_0_M_AXIS_DOUT [get_bd_intf_pins axis_subset_converter_3/S_AXIS] [get_bd_intf_pins sd_fec_0/M_AXIS_DOUT]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins axis_broadcaster_0/aresetn] [get_bd_pins axis_subset_converter_2/aresetn] [get_bd_pins axis_subset_converter_3/aresetn] [get_bd_pins fec_controller_0/axis_aresetn] [get_bd_pins sd_fec_0/reset_n]
  connect_bd_net -net core_clk_1 [get_bd_pins core_clk] [get_bd_pins sd_fec_0/core_clk]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins axis_broadcaster_0/aclk] [get_bd_pins axis_subset_converter_2/aclk] [get_bd_pins axis_subset_converter_3/aclk] [get_bd_pins fec_controller_0/axis_aclk] [get_bd_pins sd_fec_0/m_axis_dout_aclk] [get_bd_pins sd_fec_0/m_axis_status_aclk] [get_bd_pins sd_fec_0/s_axi_aclk] [get_bd_pins sd_fec_0/s_axis_ctrl_aclk] [get_bd_pins sd_fec_0/s_axis_din_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: fec_hier_rx0
proc create_hier_cell_fec_hier_rx0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_fec_hier_rx0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DIN

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_fec

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_fec_ctrl


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type clk core_clk

  # Create instance: axis_broadcaster_4, and set properties
  set axis_broadcaster_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_4 ]

  # Create instance: fec_controller_0, and set properties
  set fec_controller_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:fec_controller:1.0 fec_controller_0 ]
  set_property -dict [ list \
   CONFIG.BITS_PER_SYMBOL {8} \
 ] $fec_controller_0

  # Create instance: sd_fec_1, and set properties
  set sd_fec_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:sd_fec:1.1 sd_fec_1 ]
  set_property -dict [ list \
   CONFIG.DIN_Words {16} \
   CONFIG.DOUT_Words {16} \
   CONFIG.DRV_INITIALIZATION_PARAMS {{ 0x00000014,0x00000001,0x0000000C,0x00000000 }} \
   CONFIG.DRV_STANDARD {1} \
   CONFIG.DRV_TURBO_PARAMS {undefined} \
   CONFIG.HDL_INITIALIZATION {{20 1 FEC_CODE} {12 0 AXIS_WIDTH}} \
   CONFIG.LDPC_Decode {true} \
   CONFIG.LDPC_Encode {false} \
   CONFIG.LD_PERCENT_LOAD {100} \
   CONFIG.LE_PERCENT_LOAD {0} \
   CONFIG.Parameter_Interface {Initialized_retain_I/F} \
   CONFIG.Physical_Utilization {100} \
   CONFIG.Standard {5G} \
   CONFIG.TD_PERCENT_LOAD {0} \
   CONFIG.Turbo_Decode {false} \
 ] $sd_fec_1

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXIS_DIN_1 [get_bd_intf_pins S_AXIS_DIN] [get_bd_intf_pins axis_broadcaster_4/S_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_4_M00_AXIS [get_bd_intf_pins axis_broadcaster_4/M00_AXIS] [get_bd_intf_pins fec_controller_0/s00_axis]
  connect_bd_intf_net -intf_net axis_broadcaster_4_M01_AXIS [get_bd_intf_pins axis_broadcaster_4/M01_AXIS] [get_bd_intf_pins sd_fec_1/S_AXIS_DIN]
  connect_bd_intf_net -intf_net axis_subset_converter_1_M_AXIS [get_bd_intf_pins fec_controller_0/m00_axis] [get_bd_intf_pins sd_fec_1/S_AXIS_CTRL]
  connect_bd_intf_net -intf_net s_axi_fec_1 [get_bd_intf_pins s_axi_fec] [get_bd_intf_pins sd_fec_1/S_AXI]
  connect_bd_intf_net -intf_net s_axi_fec_ctrl_1 [get_bd_intf_pins s_axi_fec_ctrl] [get_bd_intf_pins fec_controller_0/s_axi]
  connect_bd_intf_net -intf_net sd_fec_1_M_AXIS_DOUT [get_bd_intf_pins M_AXIS1] [get_bd_intf_pins sd_fec_1/M_AXIS_DOUT]

  # Create port connections
  connect_bd_net -net aresetn1_1 [get_bd_pins aresetn] [get_bd_pins axis_broadcaster_4/aresetn] [get_bd_pins fec_controller_0/axis_aresetn] [get_bd_pins sd_fec_1/reset_n]
  connect_bd_net -net core_clk_1 [get_bd_pins core_clk] [get_bd_pins sd_fec_1/core_clk]
  connect_bd_net -net m_axis_aclk_1 [get_bd_pins aclk] [get_bd_pins axis_broadcaster_4/aclk] [get_bd_pins fec_controller_0/axis_aclk] [get_bd_pins sd_fec_1/m_axis_dout_aclk] [get_bd_pins sd_fec_1/m_axis_status_aclk] [get_bd_pins sd_fec_1/s_axi_aclk] [get_bd_pins sd_fec_1/s_axis_ctrl_aclk] [get_bd_pins sd_fec_1/s_axis_din_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: correlator
proc create_hier_cell_correlator { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_correlator() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s00_axis


  # Create pins
  create_bd_pin -dir I -type clk axis_aclk
  create_bd_pin -dir I -type rst axis_aresetn

  # Create instance: OFDM_correlator_0, and set properties
  set OFDM_correlator_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:OFDM_correlator:1.0 OFDM_correlator_0 ]

  # Create instance: OFDM_correlator_1, and set properties
  set OFDM_correlator_1 [ create_bd_cell -type ip -vlnv xilinx.com:user:OFDM_correlator:1.0 OFDM_correlator_1 ]

  # Create instance: axis_broadcaster_1, and set properties
  set axis_broadcaster_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_1 ]

  # Create instance: delay_0, and set properties
  set delay_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:delay:1.0 delay_0 ]
  set_property -dict [ list \
   CONFIG.DELAY {128} \
 ] $delay_0

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TKEEP_WIDTH {16} \
   CONFIG.TSTRB_WIDTH {16} \
 ] $fifo_generator_0

  # Create instance: ssr_FFT_0, and set properties
  set ssr_FFT_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:ssr_FFT:1.0 ssr_FFT_0 ]
  set_property -dict [ list \
   CONFIG.scaled {1} \
 ] $ssr_FFT_0

  # Create instance: ssr_FFT_1, and set properties
  set ssr_FFT_1 [ create_bd_cell -type ip -vlnv xilinx.com:user:ssr_FFT:1.0 ssr_FFT_1 ]
  set_property -dict [ list \
   CONFIG.scaled {1} \
 ] $ssr_FFT_1

  # Create instance: ssr_IFFT_1, and set properties
  set ssr_IFFT_1 [ create_bd_cell -type ip -vlnv xilinx.com:user:ssr_IFFT:1.0 ssr_IFFT_1 ]
  set_property -dict [ list \
   CONFIG.C_M00_AXIS_TDATA_WIDTH {256} \
 ] $ssr_IFFT_1

  # Create instance: ssr_IFFT_2, and set properties
  set ssr_IFFT_2 [ create_bd_cell -type ip -vlnv xilinx.com:user:ssr_IFFT:1.0 ssr_IFFT_2 ]
  set_property -dict [ list \
   CONFIG.C_M00_AXIS_TDATA_WIDTH {256} \
 ] $ssr_IFFT_2

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS1] [get_bd_intf_pins axis_broadcaster_1/S_AXIS]
  connect_bd_intf_net -intf_net OFDM_correlator_0_m00_axis [get_bd_intf_pins OFDM_correlator_0/m00_axis] [get_bd_intf_pins ssr_IFFT_2/s00_axis]
  connect_bd_intf_net -intf_net OFDM_correlator_1_m00_axis [get_bd_intf_pins OFDM_correlator_1/m00_axis] [get_bd_intf_pins ssr_IFFT_1/s00_axis]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M00_AXIS [get_bd_intf_pins s00_axis] [get_bd_intf_pins ssr_FFT_0/s00_axis]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M01_AXIS [get_bd_intf_pins S_AXIS] [get_bd_intf_pins fifo_generator_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_1_M00_AXIS [get_bd_intf_pins OFDM_correlator_0/s00_axis_config] [get_bd_intf_pins axis_broadcaster_1/M00_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_1_M01_AXIS [get_bd_intf_pins OFDM_correlator_1/s00_axis_config] [get_bd_intf_pins axis_broadcaster_1/M01_AXIS]
  connect_bd_intf_net -intf_net delay_0_m00_axis [get_bd_intf_pins delay_0/m00_axis] [get_bd_intf_pins ssr_FFT_1/s00_axis]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins delay_0/s00_axis] [get_bd_intf_pins fifo_generator_0/M_AXIS]
  connect_bd_intf_net -intf_net ssr_FFT_0_m00_axis [get_bd_intf_pins OFDM_correlator_1/s00_axis] [get_bd_intf_pins ssr_FFT_0/m00_axis]
  connect_bd_intf_net -intf_net ssr_FFT_1_m00_axis [get_bd_intf_pins OFDM_correlator_0/s00_axis] [get_bd_intf_pins ssr_FFT_1/m00_axis]
  connect_bd_intf_net -intf_net ssr_IFFT_1_m00_axis [get_bd_intf_pins M_AXIS] [get_bd_intf_pins ssr_IFFT_1/m00_axis]
  connect_bd_intf_net -intf_net ssr_IFFT_2_m00_axis [get_bd_intf_pins M_AXIS1] [get_bd_intf_pins ssr_IFFT_2/m00_axis]

  # Create port connections
  connect_bd_net -net rst_ps8_0_249M_peripheral_aresetn [get_bd_pins axis_aresetn] [get_bd_pins OFDM_correlator_0/resetn] [get_bd_pins OFDM_correlator_1/resetn] [get_bd_pins axis_broadcaster_1/aresetn] [get_bd_pins delay_0/axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn] [get_bd_pins ssr_FFT_0/axis_aresetn] [get_bd_pins ssr_FFT_1/axis_aresetn] [get_bd_pins ssr_IFFT_1/s_axis_aresetn] [get_bd_pins ssr_IFFT_2/s_axis_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins axis_aclk] [get_bd_pins OFDM_correlator_0/clk] [get_bd_pins OFDM_correlator_1/clk] [get_bd_pins axis_broadcaster_1/aclk] [get_bd_pins delay_0/axis_aclk] [get_bd_pins fifo_generator_0/s_aclk] [get_bd_pins ssr_FFT_0/axis_aclk] [get_bd_pins ssr_FFT_1/axis_aclk] [get_bd_pins ssr_IFFT_1/s_axis_aclk] [get_bd_pins ssr_IFFT_2/s_axis_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: tx0
proc create_hier_cell_tx0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_tx0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m00_axis

  create_bd_intf_pin -mode Monitor -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_data

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_fec

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_fec_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_config

  create_bd_intf_pin -mode Monitor -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_data

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_fec_in

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_framer_ctrl


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk core_clk
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: OFDM_Framer_0, and set properties
  set OFDM_Framer_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:OFDM_Framer:1.0 OFDM_Framer_0 ]
  set_property -dict [ list \
   CONFIG.SAMPS_PER_FRAME {300} \
 ] $OFDM_Framer_0

  # Create instance: fec_hier_tx0
  create_hier_cell_fec_hier_tx0 $hier_obj fec_hier_tx0

  # Create instance: ssr_IFFT_0, and set properties
  set ssr_IFFT_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:ssr_IFFT:1.0 ssr_IFFT_0 ]
  set_property -dict [ list \
   CONFIG.C_M00_AXIS_TDATA_WIDTH {128} \
   CONFIG.fft_shift {1} \
   CONFIG.insert_cp {1} \
   CONFIG.scaled {1} \
 ] $ssr_IFFT_0

  # Create instance: zero_pad_0, and set properties
  set block_name zero_pad
  set block_cell_name zero_pad_0
  if { [catch {set zero_pad_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $zero_pad_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {92160000} \
 ] [get_bd_intf_pins /tx0/zero_pad_0/m00_axis]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis_config] [get_bd_intf_pins OFDM_Framer_0/s_axis_config]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins s_axi_fec_ctrl] [get_bd_intf_pins fec_hier_tx0/s_axi]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins s_axis_framer_ctrl] [get_bd_intf_pins OFDM_Framer_0/s_axis_ctrl]
  connect_bd_intf_net -intf_net OFDM_Framer_0_m_axis_data [get_bd_intf_pins OFDM_Framer_0/m_axis_data] [get_bd_intf_pins ssr_IFFT_0/s00_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets OFDM_Framer_0_m_axis_data] [get_bd_intf_pins m_axis_data] [get_bd_intf_pins OFDM_Framer_0/m_axis_data]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets OFDM_Framer_0_m_axis_data]
  connect_bd_intf_net -intf_net S_AXI_FEC_1 [get_bd_intf_pins s_axi_fec] [get_bd_intf_pins fec_hier_tx0/S_AXI_FEC]
  connect_bd_intf_net -intf_net fec_hier_M_AXIS [get_bd_intf_pins OFDM_Framer_0/s_axis_data] [get_bd_intf_pins fec_hier_tx0/M_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets fec_hier_M_AXIS] [get_bd_intf_pins s_axis_data] [get_bd_intf_pins fec_hier_tx0/M_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets fec_hier_M_AXIS]
  connect_bd_intf_net -intf_net s_axis_fec_in_1 [get_bd_intf_pins s_axis_fec_in] [get_bd_intf_pins fec_hier_tx0/s_axis_fec_in]
  connect_bd_intf_net -intf_net ssr_IFFT_0_m00_axis [get_bd_intf_pins ssr_IFFT_0/m00_axis] [get_bd_intf_pins zero_pad_0/s00_axis]
  connect_bd_intf_net -intf_net zero_pad_0_m00_axis [get_bd_intf_pins m00_axis] [get_bd_intf_pins zero_pad_0/m00_axis]

  # Create port connections
  connect_bd_net -net core_clk_1 [get_bd_pins core_clk] [get_bd_pins fec_hier_tx0/core_clk]
  connect_bd_net -net rst_ps8_0_249M_peripheral_aresetn [get_bd_pins axi_resetn] [get_bd_pins OFDM_Framer_0/axis_aresetn] [get_bd_pins fec_hier_tx0/axi_resetn] [get_bd_pins ssr_IFFT_0/s_axis_aresetn] [get_bd_pins zero_pad_0/s00_axis_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins s_axi_lite_aclk] [get_bd_pins OFDM_Framer_0/axis_aclk] [get_bd_pins fec_hier_tx0/s_axi_lite_aclk] [get_bd_pins ssr_IFFT_0/s_axis_aclk] [get_bd_pins zero_pad_0/s00_axis_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: rx0
proc create_hier_cell_rx0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_rx0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m00_axis

  create_bd_intf_pin -mode Monitor -vlnv xilinx.com:interface:axis_rtl:1.0 m00_axis1

  create_bd_intf_pin -mode Monitor -vlnv xilinx.com:interface:axis_rtl:1.0 s00_axis

  create_bd_intf_pin -mode Monitor -vlnv xilinx.com:interface:axis_rtl:1.0 s00_axis1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_fec

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_fec_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_tlast1

  create_bd_intf_pin -mode Monitor -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis2


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type clk core_clk

  # Create instance: OFDM_demodulator_0, and set properties
  set OFDM_demodulator_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:OFDM_demodulator:1.0 OFDM_demodulator_0 ]
  set_property -dict [ list \
   CONFIG.C_M00_AXIS_TDATA_WIDTH {128} \
   CONFIG.C_S00_AXIS_TDATA_WIDTH {96} \
   CONFIG.SOFT_OUTPUT {1} \
 ] $OFDM_demodulator_0

  # Create instance: axis_broadcaster_0, and set properties
  set axis_broadcaster_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_0 ]
  set_property -dict [ list \
   CONFIG.HAS_TREADY {1} \
   CONFIG.M02_TDATA_REMAP {tdata[127:0]} \
   CONFIG.M03_TDATA_REMAP {tdata[127:0]} \
   CONFIG.M_TDATA_NUM_BYTES {16} \
   CONFIG.NUM_MI {3} \
   CONFIG.S_TDATA_NUM_BYTES {16} \
 ] $axis_broadcaster_0

  # Create instance: cfo_estimator_0, and set properties
  set cfo_estimator_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:cfo_estimator:1.0 cfo_estimator_0 ]

  # Create instance: correlator
  create_hier_cell_correlator $hier_obj correlator

  # Create instance: fec_hier_rx0
  create_hier_cell_fec_hier_rx0 $hier_obj fec_hier_rx0

  # Create instance: ssr_FFT_0, and set properties
  set ssr_FFT_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:ssr_FFT:1.0 ssr_FFT_0 ]
  set_property -dict [ list \
   CONFIG.FFT_SHIFT {1} \
 ] $ssr_FFT_0

  # Create instance: synchronizer_0, and set properties
  set synchronizer_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:synchronizer:1.0 synchronizer_0 ]
  set_property -dict [ list \
   CONFIG.NUM_DATA_SYMBOLS {16} \
   CONFIG.cp_rm_enable {0} \
 ] $synchronizer_0

  # Create instance: tlast_generator_0, and set properties
  set tlast_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:tlast_generator:1.0 tlast_generator_0 ]
  set_property -dict [ list \
   CONFIG.C_M00_AXIS_TDATA_WIDTH {128} \
   CONFIG.C_S00_AXIS_TDATA_WIDTH {128} \
 ] $tlast_generator_0

  # Create instance: zf_equalizer_0, and set properties
  set zf_equalizer_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:zf_equalizer:1.0 zf_equalizer_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS1] [get_bd_intf_pins correlator/S_AXIS1]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins s_axi_tlast1] [get_bd_intf_pins tlast_generator_0/s_axi]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins s_axi1] [get_bd_intf_pins zf_equalizer_0/s_axi]
  connect_bd_intf_net -intf_net Conn11 [get_bd_intf_pins s_axi] [get_bd_intf_pins OFDM_demodulator_0/s_axi]
  connect_bd_intf_net -intf_net OFDM_demodulator_0_m00_axis [get_bd_intf_pins OFDM_demodulator_0/m00_axis] [get_bd_intf_pins fec_hier_rx0/S_AXIS_DIN]
  connect_bd_intf_net -intf_net [get_bd_intf_nets OFDM_demodulator_0_m00_axis] [get_bd_intf_pins m00_axis1] [get_bd_intf_pins fec_hier_rx0/S_AXIS_DIN]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M00_AXIS [get_bd_intf_pins axis_broadcaster_0/M00_AXIS] [get_bd_intf_pins correlator/s00_axis]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M01_AXIS [get_bd_intf_pins axis_broadcaster_0/M01_AXIS] [get_bd_intf_pins correlator/S_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M02_AXIS [get_bd_intf_pins axis_broadcaster_0/M02_AXIS] [get_bd_intf_pins synchronizer_0/s_axis]
  connect_bd_intf_net -intf_net cfo_estimator_0_m_axis [get_bd_intf_pins cfo_estimator_0/m_axis] [get_bd_intf_pins ssr_FFT_0/s00_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets cfo_estimator_0_m_axis] [get_bd_intf_pins s00_axis] [get_bd_intf_pins cfo_estimator_0/m_axis]
  connect_bd_intf_net -intf_net correlator_M_AXIS [get_bd_intf_pins correlator/M_AXIS] [get_bd_intf_pins synchronizer_0/s_axis_corr_1]
  connect_bd_intf_net -intf_net correlator_M_AXIS1 [get_bd_intf_pins correlator/M_AXIS1] [get_bd_intf_pins synchronizer_0/s_axis_corr_2]
  connect_bd_intf_net -intf_net fec_hier_1_M_AXIS1 [get_bd_intf_pins fec_hier_rx0/M_AXIS1] [get_bd_intf_pins tlast_generator_0/s00_axis]
  connect_bd_intf_net -intf_net medium_emulator_v1_0_0_m00_axis [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_broadcaster_0/S_AXIS]
  connect_bd_intf_net -intf_net s_axi2_1 [get_bd_intf_pins s_axi2] [get_bd_intf_pins synchronizer_0/s_axi]
  connect_bd_intf_net -intf_net s_axi_fec_1 [get_bd_intf_pins s_axi_fec] [get_bd_intf_pins fec_hier_rx0/s_axi_fec]
  connect_bd_intf_net -intf_net s_axi_fec_ctrl_1 [get_bd_intf_pins s_axi_fec_ctrl] [get_bd_intf_pins fec_hier_rx0/s_axi_fec_ctrl]
  connect_bd_intf_net -intf_net ssr_FFT_0_m00_axis [get_bd_intf_pins ssr_FFT_0/m00_axis] [get_bd_intf_pins zf_equalizer_0/s_axis]
  connect_bd_intf_net -intf_net synchronizer_0_m_axis [get_bd_intf_pins cfo_estimator_0/s_axis] [get_bd_intf_pins synchronizer_0/m_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets synchronizer_0_m_axis] [get_bd_intf_pins s_axis2] [get_bd_intf_pins synchronizer_0/m_axis]
  connect_bd_intf_net -intf_net tlast_generator_0_m00_axis [get_bd_intf_pins m00_axis] [get_bd_intf_pins tlast_generator_0/m00_axis]
  connect_bd_intf_net -intf_net zf_equalizer_0_m_axis [get_bd_intf_pins OFDM_demodulator_0/s00_axis] [get_bd_intf_pins zf_equalizer_0/m_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets zf_equalizer_0_m_axis] [get_bd_intf_pins s00_axis1] [get_bd_intf_pins zf_equalizer_0/m_axis]

  # Create port connections
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins OFDM_demodulator_0/axis_aresetn] [get_bd_pins axis_broadcaster_0/aresetn] [get_bd_pins cfo_estimator_0/aresetn] [get_bd_pins correlator/axis_aresetn] [get_bd_pins fec_hier_rx0/aresetn] [get_bd_pins ssr_FFT_0/axis_aresetn] [get_bd_pins synchronizer_0/resetn] [get_bd_pins tlast_generator_0/axis_aresetn] [get_bd_pins zf_equalizer_0/s_axi_aresetn]
  connect_bd_net -net core_clk_1 [get_bd_pins core_clk] [get_bd_pins fec_hier_rx0/core_clk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins aclk] [get_bd_pins OFDM_demodulator_0/axis_aclk] [get_bd_pins axis_broadcaster_0/aclk] [get_bd_pins cfo_estimator_0/clk] [get_bd_pins cfo_estimator_0/clk_fast] [get_bd_pins correlator/axis_aclk] [get_bd_pins fec_hier_rx0/aclk] [get_bd_pins ssr_FFT_0/axis_aclk] [get_bd_pins synchronizer_0/clk] [get_bd_pins tlast_generator_0/axis_aclk] [get_bd_pins zf_equalizer_0/s_axi_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: reset_hier
proc create_hier_cell_reset_hier { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_reset_hier() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir O -from 0 -to 0 -type rst ext_reset_in1
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn1
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn2
  create_bd_pin -dir I -type clk slowest_sync_clk
  create_bd_pin -dir I -type clk slowest_sync_clk1
  create_bd_pin -dir I -type clk slowest_sync_clk2
  create_bd_pin -dir I -type clk slowest_sync_clk3

  # Create instance: rst_ps8_0_249M, and set properties
  set rst_ps8_0_249M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_249M ]

  # Create instance: rst_ps8_0_249M1, and set properties
  set rst_ps8_0_249M1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_249M1 ]

  # Create instance: rst_ps8_0_249M2, and set properties
  set rst_ps8_0_249M2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_249M2 ]

  # Create instance: rst_ps8_0_249M3, and set properties
  set rst_ps8_0_249M3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_249M3 ]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins peripheral_aresetn2] [get_bd_pins rst_ps8_0_249M2/peripheral_aresetn]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins slowest_sync_clk] [get_bd_pins rst_ps8_0_249M1/slowest_sync_clk]
  connect_bd_net -net rst_ps8_0_249M1_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins rst_ps8_0_249M1/peripheral_aresetn]
  connect_bd_net -net rst_ps8_0_249M3_peripheral_aresetn [get_bd_pins peripheral_aresetn1] [get_bd_pins rst_ps8_0_249M3/peripheral_aresetn]
  connect_bd_net -net rst_ps8_0_249M_peripheral_aresetn [get_bd_pins ext_reset_in1] [get_bd_pins rst_ps8_0_249M/peripheral_aresetn] [get_bd_pins rst_ps8_0_249M2/ext_reset_in] [get_bd_pins rst_ps8_0_249M3/ext_reset_in]
  connect_bd_net -net usp_rf_data_converter_0_clk_adc0 [get_bd_pins slowest_sync_clk2] [get_bd_pins rst_ps8_0_249M3/slowest_sync_clk]
  connect_bd_net -net usp_rf_data_converter_0_clk_dac1 [get_bd_pins slowest_sync_clk3] [get_bd_pins rst_ps8_0_249M2/slowest_sync_clk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins slowest_sync_clk1] [get_bd_pins rst_ps8_0_249M/slowest_sync_clk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins ext_reset_in] [get_bd_pins rst_ps8_0_249M/ext_reset_in] [get_bd_pins rst_ps8_0_249M1/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_sync_tx
proc create_hier_cell_hier_sync_tx { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_sync_tx() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M03_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS2


  # Create pins
  create_bd_pin -dir I -type clk m_aclk
  create_bd_pin -dir I -type clk s_aclk
  create_bd_pin -dir I -type rst s_aresetn

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Clock_Type_AXI {Independent_Clock} \
   CONFIG.Empty_Threshold_Assert_Value_axis {1018} \
   CONFIG.Empty_Threshold_Assert_Value_rach {13} \
   CONFIG.Empty_Threshold_Assert_Value_rdch {1018} \
   CONFIG.Empty_Threshold_Assert_Value_wach {13} \
   CONFIG.Empty_Threshold_Assert_Value_wdch {1018} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {13} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Independent_Clocks_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
 ] $fifo_generator_0

  # Create instance: fifo_generator_1, and set properties
  set fifo_generator_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_1 ]
  set_property -dict [ list \
   CONFIG.Clock_Type_AXI {Independent_Clock} \
   CONFIG.Empty_Threshold_Assert_Value_axis {1018} \
   CONFIG.Empty_Threshold_Assert_Value_rach {13} \
   CONFIG.Empty_Threshold_Assert_Value_rdch {1018} \
   CONFIG.Empty_Threshold_Assert_Value_wach {13} \
   CONFIG.Empty_Threshold_Assert_Value_wdch {1018} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {13} \
   CONFIG.FIFO_Implementation_axis {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Independent_Clocks_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
 ] $fifo_generator_1

  # Create instance: fifo_generator_2, and set properties
  set fifo_generator_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_2 ]
  set_property -dict [ list \
   CONFIG.Clock_Type_AXI {Independent_Clock} \
   CONFIG.Empty_Threshold_Assert_Value_axis {1018} \
   CONFIG.Empty_Threshold_Assert_Value_rach {13} \
   CONFIG.Empty_Threshold_Assert_Value_rdch {1018} \
   CONFIG.Empty_Threshold_Assert_Value_wach {13} \
   CONFIG.Empty_Threshold_Assert_Value_wdch {1018} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {13} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Independent_Clocks_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
 ] $fifo_generator_2

  # Create instance: smartconnect_5, and set properties
  set smartconnect_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_5 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_5

  # Create interface connections
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins smartconnect_5/S00_AXI]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M00_AXI] [get_bd_intf_pins smartconnect_5/M00_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins M_AXIS1] [get_bd_intf_pins fifo_generator_2/M_AXIS]
  connect_bd_intf_net -intf_net dmas_tx_M_AXIS_MM2S [get_bd_intf_pins S_AXIS2] [get_bd_intf_pins fifo_generator_0/S_AXIS]
  connect_bd_intf_net -intf_net dmas_tx_M_AXIS_MM2S3 [get_bd_intf_pins S_AXIS] [get_bd_intf_pins fifo_generator_1/S_AXIS]
  connect_bd_intf_net -intf_net dmas_tx_M_AXIS_MM2S6 [get_bd_intf_pins S_AXIS1] [get_bd_intf_pins fifo_generator_2/S_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins M_AXIS2] [get_bd_intf_pins fifo_generator_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_1_M_AXIS [get_bd_intf_pins M_AXIS] [get_bd_intf_pins fifo_generator_1/M_AXIS]
  connect_bd_intf_net -intf_net smartconnect_5_M01_AXI [get_bd_intf_pins M03_AXI] [get_bd_intf_pins smartconnect_5/M01_AXI]

  # Create port connections
  connect_bd_net -net rst_ps8_0_249M_peripheral_aresetn [get_bd_pins s_aresetn] [get_bd_pins fifo_generator_0/s_aresetn] [get_bd_pins fifo_generator_1/s_aresetn] [get_bd_pins fifo_generator_2/s_aresetn] [get_bd_pins smartconnect_5/aresetn]
  connect_bd_net -net usp_rf_data_converter_0_clk_dac1 [get_bd_pins m_aclk] [get_bd_pins fifo_generator_0/m_aclk] [get_bd_pins fifo_generator_1/m_aclk] [get_bd_pins fifo_generator_2/m_aclk] [get_bd_pins smartconnect_5/aclk1]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins s_aclk] [get_bd_pins fifo_generator_0/s_aclk] [get_bd_pins fifo_generator_1/s_aclk] [get_bd_pins fifo_generator_2/s_aclk] [get_bd_pins smartconnect_5/aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_sync_rx
proc create_hier_cell_hier_sync_rx { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_sync_rx() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M02_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M03_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M04_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M05_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M06_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M07_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M07_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M08_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS1


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type clk aclk1
  create_bd_pin -dir I -type rst aresetn

  # Create instance: fifo_generator_6, and set properties
  set fifo_generator_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_6 ]
  set_property -dict [ list \
   CONFIG.Clock_Type_AXI {Independent_Clock} \
   CONFIG.Empty_Threshold_Assert_Value_axis {1018} \
   CONFIG.Empty_Threshold_Assert_Value_rach {13} \
   CONFIG.Empty_Threshold_Assert_Value_rdch {1018} \
   CONFIG.Empty_Threshold_Assert_Value_wach {13} \
   CONFIG.Empty_Threshold_Assert_Value_wdch {1018} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {13} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Independent_Clocks_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
 ] $fifo_generator_6

  # Create instance: smartconnect_4, and set properties
  set smartconnect_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_4 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {8} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_4

  # Create interface connections
  connect_bd_intf_net -intf_net dmas_tx_M_AXIS_MM2S5 [get_bd_intf_pins S_AXIS1] [get_bd_intf_pins fifo_generator_6/S_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_6_M_AXIS [get_bd_intf_pins M01_AXIS] [get_bd_intf_pins fifo_generator_6/M_AXIS]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M07_AXI [get_bd_intf_pins S00_AXI1] [get_bd_intf_pins smartconnect_4/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_4_M00_AXI [get_bd_intf_pins M02_AXI1] [get_bd_intf_pins smartconnect_4/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_4_M01_AXI [get_bd_intf_pins M03_AXI1] [get_bd_intf_pins smartconnect_4/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_4_M02_AXI [get_bd_intf_pins M04_AXI1] [get_bd_intf_pins smartconnect_4/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_4_M03_AXI [get_bd_intf_pins M05_AXI1] [get_bd_intf_pins smartconnect_4/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_4_M04_AXI [get_bd_intf_pins M06_AXI1] [get_bd_intf_pins smartconnect_4/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_4_M05_AXI [get_bd_intf_pins M07_AXI] [get_bd_intf_pins smartconnect_4/M05_AXI]
  connect_bd_intf_net -intf_net smartconnect_4_M06_AXI [get_bd_intf_pins M08_AXI] [get_bd_intf_pins smartconnect_4/M06_AXI]
  connect_bd_intf_net -intf_net smartconnect_4_M07_AXI [get_bd_intf_pins M07_AXI1] [get_bd_intf_pins smartconnect_4/M07_AXI]

  # Create port connections
  connect_bd_net -net rst_ps8_0_249M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins fifo_generator_6/s_aresetn] [get_bd_pins smartconnect_4/aresetn]
  connect_bd_net -net usp_rf_data_converter_0_clk_adc0 [get_bd_pins aclk] [get_bd_pins fifo_generator_6/m_aclk] [get_bd_pins smartconnect_4/aclk1]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins aclk1] [get_bd_pins fifo_generator_6/s_aclk] [get_bd_pins smartconnect_4/aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: dmas_tx
proc create_hier_cell_dmas_tx { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_dmas_tx() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_MM2S6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE6


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk m_axi_mm2s_aclk
  create_bd_pin -dir I -type clk m_axi_mm2s_aclk1
  create_bd_pin -dir O -type intr mm2s_introut
  create_bd_pin -dir O -type intr mm2s_introut1
  create_bd_pin -dir O -type intr mm2s_introut3
  create_bd_pin -dir O -type intr mm2s_introut6

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $axi_dma_0

  # Create instance: axi_dma_1, and set properties
  set axi_dma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_1 ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $axi_dma_1

  # Create instance: axi_dma_2, and set properties
  set axi_dma_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_2 ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $axi_dma_2

  # Create instance: axi_dma_6, and set properties
  set axi_dma_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_6 ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $axi_dma_6

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins M_AXIS_MM2S6] [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S6] [get_bd_intf_pins axi_dma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_SG [get_bd_intf_pins M_AXI_SG6] [get_bd_intf_pins axi_dma_0/M_AXI_SG]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXIS_MM2S [get_bd_intf_pins M_AXIS_MM2S] [get_bd_intf_pins axi_dma_1/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_dma_1/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_SG [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins axi_dma_1/M_AXI_SG]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXIS_MM2S [get_bd_intf_pins M_AXIS_MM2S1] [get_bd_intf_pins axi_dma_2/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins axi_dma_2/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_SG [get_bd_intf_pins M_AXI_SG1] [get_bd_intf_pins axi_dma_2/M_AXI_SG]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXIS_MM2S [get_bd_intf_pins M_AXIS_MM2S3] [get_bd_intf_pins axi_dma_6/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S3] [get_bd_intf_pins axi_dma_6/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_SG [get_bd_intf_pins M_AXI_SG3] [get_bd_intf_pins axi_dma_6/M_AXI_SG]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M01_AXI [get_bd_intf_pins S_AXI_LITE6] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M02_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_dma_1/S_AXI_LITE]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M03_AXI [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins axi_dma_2/S_AXI_LITE]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M04_AXI [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins axi_dma_6/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins mm2s_introut6] [get_bd_pins axi_dma_0/mm2s_introut]
  connect_bd_net -net axi_dma_1_mm2s_introut [get_bd_pins mm2s_introut] [get_bd_pins axi_dma_1/mm2s_introut]
  connect_bd_net -net axi_dma_2_mm2s_introut [get_bd_pins mm2s_introut1] [get_bd_pins axi_dma_2/mm2s_introut]
  connect_bd_net -net axi_dma_6_mm2s_introut [get_bd_pins mm2s_introut3] [get_bd_pins axi_dma_6/mm2s_introut]
  connect_bd_net -net rst_ps8_0_249M_peripheral_aresetn [get_bd_pins axi_resetn] [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_dma_1/axi_resetn] [get_bd_pins axi_dma_2/axi_resetn] [get_bd_pins axi_dma_6/axi_resetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_sg_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_dma_1/m_axi_mm2s_aclk] [get_bd_pins axi_dma_1/m_axi_sg_aclk] [get_bd_pins axi_dma_1/s_axi_lite_aclk] [get_bd_pins axi_dma_2/m_axi_mm2s_aclk] [get_bd_pins axi_dma_2/m_axi_sg_aclk] [get_bd_pins axi_dma_2/s_axi_lite_aclk] [get_bd_pins axi_dma_6/m_axi_mm2s_aclk] [get_bd_pins axi_dma_6/m_axi_sg_aclk] [get_bd_pins axi_dma_6/s_axi_lite_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: dma_rx
proc create_hier_cell_dma_rx { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_dma_rx() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk m_axi_s2mm_aclk
  create_bd_pin -dir O -type intr s2mm_introut
  create_bd_pin -dir I -type clk s_aclk
  create_bd_pin -dir I -type rst s_aresetn

  # Create instance: axi_dma_4, and set properties
  set axi_dma_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_4 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $axi_dma_4

  # Create instance: fifo_generator_9, and set properties
  set fifo_generator_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_9 ]
  set_property -dict [ list \
   CONFIG.Clock_Type_AXI {Independent_Clock} \
   CONFIG.Empty_Threshold_Assert_Value_axis {1018} \
   CONFIG.Empty_Threshold_Assert_Value_rach {13} \
   CONFIG.Empty_Threshold_Assert_Value_rdch {1018} \
   CONFIG.Empty_Threshold_Assert_Value_wach {13} \
   CONFIG.Empty_Threshold_Assert_Value_wdch {1018} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {13} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Independent_Clocks_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TKEEP_WIDTH {16} \
   CONFIG.TSTRB_WIDTH {16} \
 ] $fifo_generator_9

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXIS1] [get_bd_intf_pins fifo_generator_9/S_AXIS]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_dma_4/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXI_SG [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins axi_dma_4/M_AXI_SG]
  connect_bd_intf_net -intf_net fifo_generator_9_M_AXIS [get_bd_intf_pins axi_dma_4/S_AXIS_S2MM] [get_bd_intf_pins fifo_generator_9/M_AXIS]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M05_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_dma_4/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net axi_dma_4_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_dma_4/s2mm_introut]
  connect_bd_net -net rst_ps8_0_249M_peripheral_aresetn [get_bd_pins axi_resetn] [get_bd_pins axi_dma_4/axi_resetn]
  connect_bd_net -net s_aclk_1 [get_bd_pins s_aclk] [get_bd_pins fifo_generator_9/s_aclk]
  connect_bd_net -net s_aresetn_1 [get_bd_pins s_aresetn] [get_bd_pins fifo_generator_9/s_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins m_axi_s2mm_aclk] [get_bd_pins axi_dma_4/m_axi_s2mm_aclk] [get_bd_pins axi_dma_4/m_axi_sg_aclk] [get_bd_pins axi_dma_4/s_axi_lite_aclk] [get_bd_pins fifo_generator_9/m_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set CLK_IN1_D [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN1_D ]

  set adc0_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc0_clk ]

  set dac1_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dac1_clk ]

  set vin0_01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin0_01 ]

  set vout12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout12 ]


  # Create ports
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [ list \
   CONFIG.NUM_SI {8} \
 ] $axi_smc

  # Create instance: axi_smc_1, and set properties
  set axi_smc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc_1 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {2} \
 ] $axi_smc_1

  # Create instance: axi_smc_2, and set properties
  set axi_smc_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc_2 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {6} \
   CONFIG.NUM_SI {1} \
 ] $axi_smc_2

  # Create instance: axis_broadcaster_2, and set properties
  set axis_broadcaster_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_2 ]
  set_property -dict [ list \
   CONFIG.HAS_TREADY {0} \
   CONFIG.M02_TDATA_REMAP {tdata[127:0]} \
   CONFIG.NUM_MI {2} \
 ] $axis_broadcaster_2

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {33.330000000000005} \
   CONFIG.CLKOUT1_JITTER {65.738} \
   CONFIG.CLKOUT1_PHASE_ERROR {71.599} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {666.66} \
   CONFIG.CLKOUT2_JITTER {76.789} \
   CONFIG.CLKOUT2_PHASE_ERROR {71.599} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {300} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {95.138} \
   CONFIG.CLKOUT3_PHASE_ERROR {71.599} \
   CONFIG.CLKOUT3_USED {false} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {default_sysclk1_300mhz} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {5.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {3.333} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {2.250} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {5} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
 ] $clk_wiz_0

  # Create instance: dma_rx
  create_hier_cell_dma_rx [current_bd_instance .] dma_rx

  # Create instance: dmas_tx
  create_hier_cell_dmas_tx [current_bd_instance .] dmas_tx

  # Create instance: hier_sync_rx
  create_hier_cell_hier_sync_rx [current_bd_instance .] hier_sync_rx

  # Create instance: hier_sync_tx
  create_hier_cell_hier_sync_tx [current_bd_instance .] hier_sync_tx

  # Create instance: iq_interleaver_gain_0, and set properties
  set iq_interleaver_gain_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:iq_interleaver_gain:1.0 iq_interleaver_gain_0 ]

  # Create instance: ps8_0_axi_periph_1, and set properties
  set ps8_0_axi_periph_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps8_0_axi_periph_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
 ] $ps8_0_axi_periph_1

  # Create instance: reset_hier
  create_hier_cell_reset_hier [current_bd_instance .] reset_hier

  # Create instance: rx0
  create_hier_cell_rx0 [current_bd_instance .] rx0

  # Create instance: signal_detect_0, and set properties
  set signal_detect_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:signal_detect:1.0 signal_detect_0 ]
  set_property -dict [ list \
   CONFIG.C_S_AXI_ADDR_WIDTH {4} \
 ] $signal_detect_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_BRAM_CNT {0.0} \
   CONFIG.C_DATA_DEPTH {16384} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {6} \
   CONFIG.C_NUM_OF_PROBES {0} \
   CONFIG.C_PROBE0_TYPE {0} \
   CONFIG.C_PROBE1_TYPE {0} \
   CONFIG.C_PROBE2_TYPE {0} \
   CONFIG.C_PROBE3_TYPE {0} \
   CONFIG.C_PROBE4_TYPE {0} \
   CONFIG.C_PROBE5_TYPE {0} \
   CONFIG.C_PROBE6_TYPE {0} \
   CONFIG.C_PROBE7_TYPE {0} \
   CONFIG.C_PROBE8_TYPE {0} \
   CONFIG.C_SLOT_0_APC_EN {0} \
   CONFIG.C_SLOT_0_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_0_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_APC_EN {0} \
   CONFIG.C_SLOT_1_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_1_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_APC_EN {0} \
   CONFIG.C_SLOT_2_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_2_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_3_APC_EN {0} \
   CONFIG.C_SLOT_3_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_3_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_4_APC_EN {0} \
   CONFIG.C_SLOT_4_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_4_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_4_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_5_APC_EN {0} \
   CONFIG.C_SLOT_5_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_5_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_5_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_6_APC_EN {0} \
   CONFIG.C_SLOT_6_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_6_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_6_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property -dict [ list \
   CONFIG.C_BRAM_CNT {0.0} \
   CONFIG.C_DATA_DEPTH {8192} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {3} \
   CONFIG.C_SLOT_0_APC_EN {0} \
   CONFIG.C_SLOT_0_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_0_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_APC_EN {0} \
   CONFIG.C_SLOT_1_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_1_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_APC_EN {0} \
   CONFIG.C_SLOT_2_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_2_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_1

  # Create instance: tx0
  create_hier_cell_tx0 [current_bd_instance .] tx0

  # Create instance: usp_rf_data_converter_0, and set properties
  set usp_rf_data_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:usp_rf_data_converter:2.6 usp_rf_data_converter_0 ]
  set_property -dict [ list \
   CONFIG.ADC0_Fabric_Freq {92.160} \
   CONFIG.ADC0_Outclk_Freq {92.160} \
   CONFIG.ADC0_Refclk_Freq {1474.560} \
   CONFIG.ADC0_Sampling_Rate {1.47456} \
   CONFIG.ADC_Coarse_Mixer_Freq00 {2} \
   CONFIG.ADC_Coarse_Mixer_Freq01 {2} \
   CONFIG.ADC_Coarse_Mixer_Freq02 {0} \
   CONFIG.ADC_Coarse_Mixer_Freq03 {0} \
   CONFIG.ADC_Data_Type00 {1} \
   CONFIG.ADC_Data_Type01 {1} \
   CONFIG.ADC_Data_Type02 {0} \
   CONFIG.ADC_Data_Type03 {0} \
   CONFIG.ADC_Data_Width00 {4} \
   CONFIG.ADC_Data_Width01 {4} \
   CONFIG.ADC_Data_Width02 {8} \
   CONFIG.ADC_Data_Width03 {8} \
   CONFIG.ADC_Decimation_Mode00 {4} \
   CONFIG.ADC_Decimation_Mode01 {4} \
   CONFIG.ADC_Decimation_Mode02 {0} \
   CONFIG.ADC_Decimation_Mode03 {0} \
   CONFIG.ADC_Mixer_Mode00 {0} \
   CONFIG.ADC_Mixer_Mode01 {0} \
   CONFIG.ADC_Mixer_Mode02 {2} \
   CONFIG.ADC_Mixer_Mode03 {2} \
   CONFIG.ADC_Mixer_Type00 {1} \
   CONFIG.ADC_Mixer_Type01 {1} \
   CONFIG.ADC_Mixer_Type02 {3} \
   CONFIG.ADC_Mixer_Type03 {3} \
   CONFIG.ADC_OBS02 {false} \
   CONFIG.ADC_RESERVED_1_00 {false} \
   CONFIG.ADC_RESERVED_1_02 {false} \
   CONFIG.ADC_Slice02_Enable {false} \
   CONFIG.ADC_Slice03_Enable {false} \
   CONFIG.DAC1_Enable {1} \
   CONFIG.DAC1_Fabric_Freq {92.160} \
   CONFIG.DAC1_Outclk_Freq {92.160} \
   CONFIG.DAC1_Refclk_Freq {1474.560} \
   CONFIG.DAC1_Sampling_Rate {1.47456} \
   CONFIG.DAC_Coarse_Mixer_Freq12 {1} \
   CONFIG.DAC_Coarse_Mixer_Freq13 {0} \
   CONFIG.DAC_Data_Width12 {8} \
   CONFIG.DAC_Data_Width13 {16} \
   CONFIG.DAC_Interpolation_Mode12 {4} \
   CONFIG.DAC_Interpolation_Mode13 {0} \
   CONFIG.DAC_Invsinc_Ctrl13 {false} \
   CONFIG.DAC_Mixer_Mode12 {0} \
   CONFIG.DAC_Mixer_Mode13 {2} \
   CONFIG.DAC_Mixer_Type12 {1} \
   CONFIG.DAC_Mixer_Type13 {3} \
   CONFIG.DAC_RESERVED_1_12 {false} \
   CONFIG.DAC_RESERVED_1_13 {false} \
   CONFIG.DAC_Slice12_Enable {true} \
   CONFIG.DAC_Slice13_Enable {false} \
 ] $usp_rf_data_converter_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {5} \
 ] $xlconcat_0

  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.4 zynq_ultra_ps_e_0 ]
  set_property -dict [ list \
   CONFIG.CAN0_BOARD_INTERFACE {custom} \
   CONFIG.CAN1_BOARD_INTERFACE {custom} \
   CONFIG.CSU_BOARD_INTERFACE {custom} \
   CONFIG.DP_BOARD_INTERFACE {custom} \
   CONFIG.GEM0_BOARD_INTERFACE {custom} \
   CONFIG.GEM1_BOARD_INTERFACE {custom} \
   CONFIG.GEM2_BOARD_INTERFACE {custom} \
   CONFIG.GEM3_BOARD_INTERFACE {custom} \
   CONFIG.GPIO_BOARD_INTERFACE {custom} \
   CONFIG.IIC0_BOARD_INTERFACE {custom} \
   CONFIG.IIC1_BOARD_INTERFACE {custom} \
   CONFIG.NAND_BOARD_INTERFACE {custom} \
   CONFIG.PCIE_BOARD_INTERFACE {custom} \
   CONFIG.PJTAG_BOARD_INTERFACE {custom} \
   CONFIG.PMU_BOARD_INTERFACE {custom} \
   CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS33} \
   CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
   CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {1} \
   CONFIG.PSU_IMPORT_BOARD_PRESET {} \
   CONFIG.PSU_MIO_0_DIRECTION {out} \
   CONFIG.PSU_MIO_0_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_0_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_0_POLARITY {Default} \
   CONFIG.PSU_MIO_0_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_0_SLEW {fast} \
   CONFIG.PSU_MIO_10_DIRECTION {inout} \
   CONFIG.PSU_MIO_10_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_10_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_10_POLARITY {Default} \
   CONFIG.PSU_MIO_10_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_10_SLEW {fast} \
   CONFIG.PSU_MIO_11_DIRECTION {inout} \
   CONFIG.PSU_MIO_11_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_11_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_11_POLARITY {Default} \
   CONFIG.PSU_MIO_11_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_11_SLEW {fast} \
   CONFIG.PSU_MIO_12_DIRECTION {out} \
   CONFIG.PSU_MIO_12_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_12_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_12_POLARITY {Default} \
   CONFIG.PSU_MIO_12_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_12_SLEW {fast} \
   CONFIG.PSU_MIO_13_DIRECTION {inout} \
   CONFIG.PSU_MIO_13_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_13_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_13_POLARITY {Default} \
   CONFIG.PSU_MIO_13_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_13_SLEW {fast} \
   CONFIG.PSU_MIO_14_DIRECTION {inout} \
   CONFIG.PSU_MIO_14_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_14_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_14_POLARITY {Default} \
   CONFIG.PSU_MIO_14_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_14_SLEW {fast} \
   CONFIG.PSU_MIO_15_DIRECTION {inout} \
   CONFIG.PSU_MIO_15_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_15_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_15_POLARITY {Default} \
   CONFIG.PSU_MIO_15_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_15_SLEW {fast} \
   CONFIG.PSU_MIO_16_DIRECTION {inout} \
   CONFIG.PSU_MIO_16_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_16_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_16_POLARITY {Default} \
   CONFIG.PSU_MIO_16_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_16_SLEW {fast} \
   CONFIG.PSU_MIO_17_DIRECTION {inout} \
   CONFIG.PSU_MIO_17_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_17_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_17_POLARITY {Default} \
   CONFIG.PSU_MIO_17_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_17_SLEW {fast} \
   CONFIG.PSU_MIO_18_DIRECTION {in} \
   CONFIG.PSU_MIO_18_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_18_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_18_POLARITY {Default} \
   CONFIG.PSU_MIO_18_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_18_SLEW {fast} \
   CONFIG.PSU_MIO_19_DIRECTION {out} \
   CONFIG.PSU_MIO_19_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_19_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_19_POLARITY {Default} \
   CONFIG.PSU_MIO_19_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_19_SLEW {fast} \
   CONFIG.PSU_MIO_1_DIRECTION {inout} \
   CONFIG.PSU_MIO_1_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_1_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_1_POLARITY {Default} \
   CONFIG.PSU_MIO_1_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_1_SLEW {fast} \
   CONFIG.PSU_MIO_20_DIRECTION {inout} \
   CONFIG.PSU_MIO_20_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_20_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_20_POLARITY {Default} \
   CONFIG.PSU_MIO_20_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_20_SLEW {fast} \
   CONFIG.PSU_MIO_21_DIRECTION {inout} \
   CONFIG.PSU_MIO_21_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_21_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_21_POLARITY {Default} \
   CONFIG.PSU_MIO_21_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_21_SLEW {fast} \
   CONFIG.PSU_MIO_22_DIRECTION {inout} \
   CONFIG.PSU_MIO_22_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_22_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_22_POLARITY {Default} \
   CONFIG.PSU_MIO_22_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_22_SLEW {fast} \
   CONFIG.PSU_MIO_23_DIRECTION {inout} \
   CONFIG.PSU_MIO_23_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_23_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_23_POLARITY {Default} \
   CONFIG.PSU_MIO_23_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_23_SLEW {fast} \
   CONFIG.PSU_MIO_24_DIRECTION {inout} \
   CONFIG.PSU_MIO_24_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_24_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_24_POLARITY {Default} \
   CONFIG.PSU_MIO_24_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_24_SLEW {fast} \
   CONFIG.PSU_MIO_25_DIRECTION {inout} \
   CONFIG.PSU_MIO_25_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_25_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_25_POLARITY {Default} \
   CONFIG.PSU_MIO_25_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_25_SLEW {fast} \
   CONFIG.PSU_MIO_26_DIRECTION {inout} \
   CONFIG.PSU_MIO_26_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_26_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_26_POLARITY {Default} \
   CONFIG.PSU_MIO_26_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_26_SLEW {fast} \
   CONFIG.PSU_MIO_27_DIRECTION {out} \
   CONFIG.PSU_MIO_27_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_27_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_27_POLARITY {Default} \
   CONFIG.PSU_MIO_27_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_27_SLEW {fast} \
   CONFIG.PSU_MIO_28_DIRECTION {in} \
   CONFIG.PSU_MIO_28_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_28_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_28_POLARITY {Default} \
   CONFIG.PSU_MIO_28_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_28_SLEW {fast} \
   CONFIG.PSU_MIO_29_DIRECTION {out} \
   CONFIG.PSU_MIO_29_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_29_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_29_POLARITY {Default} \
   CONFIG.PSU_MIO_29_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_29_SLEW {fast} \
   CONFIG.PSU_MIO_2_DIRECTION {inout} \
   CONFIG.PSU_MIO_2_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_2_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_2_POLARITY {Default} \
   CONFIG.PSU_MIO_2_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_2_SLEW {fast} \
   CONFIG.PSU_MIO_30_DIRECTION {in} \
   CONFIG.PSU_MIO_30_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_30_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_30_POLARITY {Default} \
   CONFIG.PSU_MIO_30_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_30_SLEW {fast} \
   CONFIG.PSU_MIO_31_DIRECTION {inout} \
   CONFIG.PSU_MIO_31_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_31_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_31_POLARITY {Default} \
   CONFIG.PSU_MIO_31_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_31_SLEW {fast} \
   CONFIG.PSU_MIO_32_DIRECTION {out} \
   CONFIG.PSU_MIO_32_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_32_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_32_POLARITY {Default} \
   CONFIG.PSU_MIO_32_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_32_SLEW {fast} \
   CONFIG.PSU_MIO_33_DIRECTION {out} \
   CONFIG.PSU_MIO_33_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_33_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_33_POLARITY {Default} \
   CONFIG.PSU_MIO_33_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_33_SLEW {fast} \
   CONFIG.PSU_MIO_34_DIRECTION {out} \
   CONFIG.PSU_MIO_34_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_34_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_34_POLARITY {Default} \
   CONFIG.PSU_MIO_34_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_34_SLEW {fast} \
   CONFIG.PSU_MIO_35_DIRECTION {out} \
   CONFIG.PSU_MIO_35_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_35_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_35_POLARITY {Default} \
   CONFIG.PSU_MIO_35_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_35_SLEW {fast} \
   CONFIG.PSU_MIO_36_DIRECTION {out} \
   CONFIG.PSU_MIO_36_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_36_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_36_POLARITY {Default} \
   CONFIG.PSU_MIO_36_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_36_SLEW {fast} \
   CONFIG.PSU_MIO_37_DIRECTION {out} \
   CONFIG.PSU_MIO_37_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_37_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_37_POLARITY {Default} \
   CONFIG.PSU_MIO_37_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_37_SLEW {fast} \
   CONFIG.PSU_MIO_38_DIRECTION {inout} \
   CONFIG.PSU_MIO_38_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_38_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_38_POLARITY {Default} \
   CONFIG.PSU_MIO_38_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_38_SLEW {fast} \
   CONFIG.PSU_MIO_39_DIRECTION {inout} \
   CONFIG.PSU_MIO_39_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_39_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_39_POLARITY {Default} \
   CONFIG.PSU_MIO_39_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_39_SLEW {fast} \
   CONFIG.PSU_MIO_3_DIRECTION {inout} \
   CONFIG.PSU_MIO_3_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_3_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_3_POLARITY {Default} \
   CONFIG.PSU_MIO_3_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_3_SLEW {fast} \
   CONFIG.PSU_MIO_40_DIRECTION {inout} \
   CONFIG.PSU_MIO_40_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_40_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_40_POLARITY {Default} \
   CONFIG.PSU_MIO_40_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_40_SLEW {fast} \
   CONFIG.PSU_MIO_41_DIRECTION {inout} \
   CONFIG.PSU_MIO_41_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_41_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_41_POLARITY {Default} \
   CONFIG.PSU_MIO_41_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_41_SLEW {fast} \
   CONFIG.PSU_MIO_42_DIRECTION {inout} \
   CONFIG.PSU_MIO_42_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_42_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_42_POLARITY {Default} \
   CONFIG.PSU_MIO_42_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_42_SLEW {fast} \
   CONFIG.PSU_MIO_43_DIRECTION {inout} \
   CONFIG.PSU_MIO_43_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_43_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_43_POLARITY {Default} \
   CONFIG.PSU_MIO_43_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_43_SLEW {fast} \
   CONFIG.PSU_MIO_44_DIRECTION {inout} \
   CONFIG.PSU_MIO_44_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_44_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_44_POLARITY {Default} \
   CONFIG.PSU_MIO_44_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_44_SLEW {fast} \
   CONFIG.PSU_MIO_45_DIRECTION {in} \
   CONFIG.PSU_MIO_45_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_45_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_45_POLARITY {Default} \
   CONFIG.PSU_MIO_45_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_45_SLEW {fast} \
   CONFIG.PSU_MIO_46_DIRECTION {inout} \
   CONFIG.PSU_MIO_46_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_46_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_46_POLARITY {Default} \
   CONFIG.PSU_MIO_46_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_46_SLEW {fast} \
   CONFIG.PSU_MIO_47_DIRECTION {inout} \
   CONFIG.PSU_MIO_47_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_47_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_47_POLARITY {Default} \
   CONFIG.PSU_MIO_47_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_47_SLEW {fast} \
   CONFIG.PSU_MIO_48_DIRECTION {inout} \
   CONFIG.PSU_MIO_48_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_48_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_48_POLARITY {Default} \
   CONFIG.PSU_MIO_48_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_48_SLEW {fast} \
   CONFIG.PSU_MIO_49_DIRECTION {inout} \
   CONFIG.PSU_MIO_49_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_49_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_49_POLARITY {Default} \
   CONFIG.PSU_MIO_49_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_49_SLEW {fast} \
   CONFIG.PSU_MIO_4_DIRECTION {inout} \
   CONFIG.PSU_MIO_4_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_4_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_4_POLARITY {Default} \
   CONFIG.PSU_MIO_4_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_4_SLEW {fast} \
   CONFIG.PSU_MIO_50_DIRECTION {inout} \
   CONFIG.PSU_MIO_50_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_50_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_50_POLARITY {Default} \
   CONFIG.PSU_MIO_50_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_50_SLEW {fast} \
   CONFIG.PSU_MIO_51_DIRECTION {out} \
   CONFIG.PSU_MIO_51_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_51_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_51_POLARITY {Default} \
   CONFIG.PSU_MIO_51_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_51_SLEW {fast} \
   CONFIG.PSU_MIO_52_DIRECTION {in} \
   CONFIG.PSU_MIO_52_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_52_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_52_POLARITY {Default} \
   CONFIG.PSU_MIO_52_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_52_SLEW {fast} \
   CONFIG.PSU_MIO_53_DIRECTION {in} \
   CONFIG.PSU_MIO_53_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_53_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_53_POLARITY {Default} \
   CONFIG.PSU_MIO_53_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_53_SLEW {fast} \
   CONFIG.PSU_MIO_54_DIRECTION {inout} \
   CONFIG.PSU_MIO_54_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_54_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_54_POLARITY {Default} \
   CONFIG.PSU_MIO_54_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_54_SLEW {fast} \
   CONFIG.PSU_MIO_55_DIRECTION {in} \
   CONFIG.PSU_MIO_55_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_55_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_55_POLARITY {Default} \
   CONFIG.PSU_MIO_55_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_55_SLEW {fast} \
   CONFIG.PSU_MIO_56_DIRECTION {inout} \
   CONFIG.PSU_MIO_56_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_56_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_56_POLARITY {Default} \
   CONFIG.PSU_MIO_56_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_56_SLEW {fast} \
   CONFIG.PSU_MIO_57_DIRECTION {inout} \
   CONFIG.PSU_MIO_57_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_57_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_57_POLARITY {Default} \
   CONFIG.PSU_MIO_57_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_57_SLEW {fast} \
   CONFIG.PSU_MIO_58_DIRECTION {out} \
   CONFIG.PSU_MIO_58_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_58_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_58_POLARITY {Default} \
   CONFIG.PSU_MIO_58_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_58_SLEW {fast} \
   CONFIG.PSU_MIO_59_DIRECTION {inout} \
   CONFIG.PSU_MIO_59_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_59_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_59_POLARITY {Default} \
   CONFIG.PSU_MIO_59_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_59_SLEW {fast} \
   CONFIG.PSU_MIO_5_DIRECTION {out} \
   CONFIG.PSU_MIO_5_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_5_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_5_POLARITY {Default} \
   CONFIG.PSU_MIO_5_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_5_SLEW {fast} \
   CONFIG.PSU_MIO_60_DIRECTION {inout} \
   CONFIG.PSU_MIO_60_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_60_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_60_POLARITY {Default} \
   CONFIG.PSU_MIO_60_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_60_SLEW {fast} \
   CONFIG.PSU_MIO_61_DIRECTION {inout} \
   CONFIG.PSU_MIO_61_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_61_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_61_POLARITY {Default} \
   CONFIG.PSU_MIO_61_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_61_SLEW {fast} \
   CONFIG.PSU_MIO_62_DIRECTION {inout} \
   CONFIG.PSU_MIO_62_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_62_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_62_POLARITY {Default} \
   CONFIG.PSU_MIO_62_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_62_SLEW {fast} \
   CONFIG.PSU_MIO_63_DIRECTION {inout} \
   CONFIG.PSU_MIO_63_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_63_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_63_POLARITY {Default} \
   CONFIG.PSU_MIO_63_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_63_SLEW {fast} \
   CONFIG.PSU_MIO_64_DIRECTION {out} \
   CONFIG.PSU_MIO_64_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_64_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_64_POLARITY {Default} \
   CONFIG.PSU_MIO_64_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_64_SLEW {fast} \
   CONFIG.PSU_MIO_65_DIRECTION {out} \
   CONFIG.PSU_MIO_65_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_65_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_65_POLARITY {Default} \
   CONFIG.PSU_MIO_65_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_65_SLEW {fast} \
   CONFIG.PSU_MIO_66_DIRECTION {out} \
   CONFIG.PSU_MIO_66_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_66_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_66_POLARITY {Default} \
   CONFIG.PSU_MIO_66_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_66_SLEW {fast} \
   CONFIG.PSU_MIO_67_DIRECTION {out} \
   CONFIG.PSU_MIO_67_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_67_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_67_POLARITY {Default} \
   CONFIG.PSU_MIO_67_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_67_SLEW {fast} \
   CONFIG.PSU_MIO_68_DIRECTION {out} \
   CONFIG.PSU_MIO_68_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_68_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_68_POLARITY {Default} \
   CONFIG.PSU_MIO_68_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_68_SLEW {fast} \
   CONFIG.PSU_MIO_69_DIRECTION {out} \
   CONFIG.PSU_MIO_69_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_69_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_69_POLARITY {Default} \
   CONFIG.PSU_MIO_69_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_69_SLEW {fast} \
   CONFIG.PSU_MIO_6_DIRECTION {out} \
   CONFIG.PSU_MIO_6_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_6_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_6_POLARITY {Default} \
   CONFIG.PSU_MIO_6_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_6_SLEW {fast} \
   CONFIG.PSU_MIO_70_DIRECTION {in} \
   CONFIG.PSU_MIO_70_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_70_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_70_POLARITY {Default} \
   CONFIG.PSU_MIO_70_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_70_SLEW {fast} \
   CONFIG.PSU_MIO_71_DIRECTION {in} \
   CONFIG.PSU_MIO_71_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_71_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_71_POLARITY {Default} \
   CONFIG.PSU_MIO_71_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_71_SLEW {fast} \
   CONFIG.PSU_MIO_72_DIRECTION {in} \
   CONFIG.PSU_MIO_72_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_72_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_72_POLARITY {Default} \
   CONFIG.PSU_MIO_72_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_72_SLEW {fast} \
   CONFIG.PSU_MIO_73_DIRECTION {in} \
   CONFIG.PSU_MIO_73_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_73_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_73_POLARITY {Default} \
   CONFIG.PSU_MIO_73_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_73_SLEW {fast} \
   CONFIG.PSU_MIO_74_DIRECTION {in} \
   CONFIG.PSU_MIO_74_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_74_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_74_POLARITY {Default} \
   CONFIG.PSU_MIO_74_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_74_SLEW {fast} \
   CONFIG.PSU_MIO_75_DIRECTION {in} \
   CONFIG.PSU_MIO_75_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_75_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_75_POLARITY {Default} \
   CONFIG.PSU_MIO_75_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_75_SLEW {fast} \
   CONFIG.PSU_MIO_76_DIRECTION {out} \
   CONFIG.PSU_MIO_76_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_76_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_76_POLARITY {Default} \
   CONFIG.PSU_MIO_76_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_76_SLEW {fast} \
   CONFIG.PSU_MIO_77_DIRECTION {inout} \
   CONFIG.PSU_MIO_77_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_77_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_77_POLARITY {Default} \
   CONFIG.PSU_MIO_77_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_77_SLEW {fast} \
   CONFIG.PSU_MIO_7_DIRECTION {out} \
   CONFIG.PSU_MIO_7_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_7_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_7_POLARITY {Default} \
   CONFIG.PSU_MIO_7_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_7_SLEW {fast} \
   CONFIG.PSU_MIO_8_DIRECTION {inout} \
   CONFIG.PSU_MIO_8_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_8_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_8_POLARITY {Default} \
   CONFIG.PSU_MIO_8_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_8_SLEW {fast} \
   CONFIG.PSU_MIO_9_DIRECTION {inout} \
   CONFIG.PSU_MIO_9_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_9_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_9_POLARITY {Default} \
   CONFIG.PSU_MIO_9_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_9_SLEW {fast} \
   CONFIG.PSU_MIO_TREE_PERIPHERALS {\
Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad\
SPI Flash#Feedback Clk#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI\
Flash#Quad SPI Flash#Quad SPI Flash#GPIO0 MIO#I2C 0#I2C 0#I2C 1#I2C 1#UART\
0#UART 0#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO1\
MIO#DPAUX#DPAUX#DPAUX#DPAUX#GPIO1 MIO#PMU GPO 0#PMU GPO 1#PMU GPO 2#PMU GPO\
3#PMU GPO 4#PMU GPO 5#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#GPIO1 MIO#GPIO1 MIO#SD 1#SD\
1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB\
0#USB 0#USB 0#USB 0#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem\
3#Gem 3#Gem 3#MDIO 3#MDIO 3} \
   CONFIG.PSU_MIO_TREE_SIGNALS {\
sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out#clk_for_lpbk#n_ss_out_upper#mo_upper[0]#mo_upper[1]#mo_upper[2]#mo_upper[3]#sclk_out_upper#gpio0[13]#scl_out#sda_out#scl_out#sda_out#rxd#txd#gpio0[20]#gpio0[21]#gpio0[22]#gpio0[23]#gpio0[24]#gpio0[25]#gpio1[26]#dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in#gpio1[31]#gpo[0]#gpo[1]#gpo[2]#gpo[3]#gpo[4]#gpo[5]#gpio1[38]#sdio1_data_out[4]#sdio1_data_out[5]#sdio1_data_out[6]#sdio1_data_out[7]#gpio1[43]#gpio1[44]#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out} \
   CONFIG.PSU_PERIPHERAL_BOARD_PRESET {} \
   CONFIG.PSU_SD0_INTERNAL_BUS_WIDTH {8} \
   CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {8} \
   CONFIG.PSU_SMC_CYCLE_T0 {NA} \
   CONFIG.PSU_SMC_CYCLE_T1 {NA} \
   CONFIG.PSU_SMC_CYCLE_T2 {NA} \
   CONFIG.PSU_SMC_CYCLE_T3 {NA} \
   CONFIG.PSU_SMC_CYCLE_T4 {NA} \
   CONFIG.PSU_SMC_CYCLE_T5 {NA} \
   CONFIG.PSU_SMC_CYCLE_T6 {NA} \
   CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {1} \
   CONFIG.PSU_VALUE_SILVERSION {3} \
   CONFIG.PSU__ACPU0__POWER__ON {1} \
   CONFIG.PSU__ACPU1__POWER__ON {1} \
   CONFIG.PSU__ACPU2__POWER__ON {1} \
   CONFIG.PSU__ACPU3__POWER__ON {1} \
   CONFIG.PSU__ACTUAL__IP {1} \
   CONFIG.PSU__ACT_DDR_FREQ_MHZ {1066.656006} \
   CONFIG.PSU__AFI0_COHERENCY {0} \
   CONFIG.PSU__AFI1_COHERENCY {0} \
   CONFIG.PSU__AUX_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__CAN0_LOOP_CAN1__ENABLE {0} \
   CONFIG.PSU__CAN0__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1199.988037} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__ACPU__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI0_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI1_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI2_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI3_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI4_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI5_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__APLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__APM_CTRL__ACT_FREQMHZ {1} \
   CONFIG.PSU__CRF_APB__APM_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__APM_CTRL__FREQMHZ {1} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__ACT_FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {533.328003} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {599.994019} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {64} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__DPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {24.999750} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__FREQMHZ {25} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.785446} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {14} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__FREQMHZ {27} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {299.997009} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__FREQMHZ {300} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {599.994019} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {0} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__ACT_FREQMHZ {-1} \
   CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__DIVISOR0 {-1} \
   CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__FREQMHZ {-1} \
   CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__SRCSEL {NA} \
   CONFIG.PSU__CRF_APB__GTGREF0__ENABLE {NA} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__ACT_FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {533.328003} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.33} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__VPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {499.994995} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__ACT_FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6__ENABLE {0} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {49.999500} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {30} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__FREQMHZ {50} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__ACT_FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__ACT_FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {499.994995} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__ACT_FREQMHZ {180} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__FREQMHZ {180} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__SRCSEL {SysOsc} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__ACT_FREQMHZ {1000} \
   CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__FREQMHZ {1000} \
   CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.984985} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__FREQMHZ {1500} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__ACT_FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__ACT_FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__ACT_FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {124.998749} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__IOPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {499.994995} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__ACT_FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__ACT_FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.498123} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {199.998001} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__ACT_FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__ACT_FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {124.998749} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {45} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__RPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__ACT_FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.498123} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__ACT_FREQMHZ {214} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__ACT_FREQMHZ {214} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__ACT_FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {19.999800} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {25} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {3} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
   CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {1} \
   CONFIG.PSU__CSU_COHERENCY {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_0__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_0__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_10__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_10__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_11__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_11__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_12__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_12__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_1__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_1__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_2__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_2__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_3__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_3__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_4__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_4__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_5__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_5__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_6__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_6__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_7__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_7__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_8__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_8__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_9__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_9__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__DDRC__ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__AL {0} \
   CONFIG.PSU__DDRC__BANK_ADDR_COUNT {2} \
   CONFIG.PSU__DDRC__BG_ADDR_COUNT {1} \
   CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
   CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
   CONFIG.PSU__DDRC__CL {15} \
   CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
   CONFIG.PSU__DDRC__COL_ADDR_COUNT {10} \
   CONFIG.PSU__DDRC__COMPONENTS {UDIMM} \
   CONFIG.PSU__DDRC__CWL {14} \
   CONFIG.PSU__DDRC__DDR3L_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
   CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
   CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
   CONFIG.PSU__DDRC__DDR4_MAXPWR_SAVING_EN {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
   CONFIG.PSU__DDRC__DEEP_PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__DEVICE_CAPACITY {8192 MBits} \
   CONFIG.PSU__DDRC__DIMM_ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
   CONFIG.PSU__DDRC__DQMAP_0_3 {0} \
   CONFIG.PSU__DDRC__DQMAP_12_15 {0} \
   CONFIG.PSU__DDRC__DQMAP_16_19 {0} \
   CONFIG.PSU__DDRC__DQMAP_20_23 {0} \
   CONFIG.PSU__DDRC__DQMAP_24_27 {0} \
   CONFIG.PSU__DDRC__DQMAP_28_31 {0} \
   CONFIG.PSU__DDRC__DQMAP_32_35 {0} \
   CONFIG.PSU__DDRC__DQMAP_36_39 {0} \
   CONFIG.PSU__DDRC__DQMAP_40_43 {0} \
   CONFIG.PSU__DDRC__DQMAP_44_47 {0} \
   CONFIG.PSU__DDRC__DQMAP_48_51 {0} \
   CONFIG.PSU__DDRC__DQMAP_4_7 {0} \
   CONFIG.PSU__DDRC__DQMAP_52_55 {0} \
   CONFIG.PSU__DDRC__DQMAP_56_59 {0} \
   CONFIG.PSU__DDRC__DQMAP_60_63 {0} \
   CONFIG.PSU__DDRC__DQMAP_64_67 {0} \
   CONFIG.PSU__DDRC__DQMAP_68_71 {0} \
   CONFIG.PSU__DDRC__DQMAP_8_11 {0} \
   CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits} \
   CONFIG.PSU__DDRC__ECC {Disabled} \
   CONFIG.PSU__DDRC__ECC_SCRUB {0} \
   CONFIG.PSU__DDRC__ENABLE {1} \
   CONFIG.PSU__DDRC__ENABLE_2T_TIMING {0} \
   CONFIG.PSU__DDRC__ENABLE_DP_SWITCH {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_HAS_ECC_COMP {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_SLOWBOOT {0} \
   CONFIG.PSU__DDRC__EN_2ND_CLK {0} \
   CONFIG.PSU__DDRC__FGRM {1X} \
   CONFIG.PSU__DDRC__FREQ_MHZ {1} \
   CONFIG.PSU__DDRC__LPDDR3_DUALRANK_SDP {0} \
   CONFIG.PSU__DDRC__LPDDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LPDDR4_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LP_ASR {manual normal} \
   CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
   CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
   CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
   CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
   CONFIG.PSU__DDRC__PLL_BYPASS {0} \
   CONFIG.PSU__DDRC__PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
   CONFIG.PSU__DDRC__RD_DQS_CENTER {0} \
   CONFIG.PSU__DDRC__ROW_ADDR_COUNT {16} \
   CONFIG.PSU__DDRC__SB_TARGET {15-15-15} \
   CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
   CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
   CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
   CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
   CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
   CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
   CONFIG.PSU__DDRC__T_FAW {30.0} \
   CONFIG.PSU__DDRC__T_RAS_MIN {33} \
   CONFIG.PSU__DDRC__T_RC {47.06} \
   CONFIG.PSU__DDRC__T_RCD {15} \
   CONFIG.PSU__DDRC__T_RP {15} \
   CONFIG.PSU__DDRC__VENDOR_PART {OTHERS} \
   CONFIG.PSU__DDRC__VIDEO_BUFFER_SIZE {0} \
   CONFIG.PSU__DDRC__VREF {1} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
   CONFIG.PSU__DDR_QOS_ENABLE {0} \
   CONFIG.PSU__DDR_QOS_FIX_HP0_RDQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP0_WRQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP1_RDQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP1_WRQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP2_RDQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP2_WRQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP3_RDQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP3_WRQOS {} \
   CONFIG.PSU__DDR_QOS_HP0_RDQOS {} \
   CONFIG.PSU__DDR_QOS_HP0_WRQOS {} \
   CONFIG.PSU__DDR_QOS_HP1_RDQOS {} \
   CONFIG.PSU__DDR_QOS_HP1_WRQOS {} \
   CONFIG.PSU__DDR_QOS_HP2_RDQOS {} \
   CONFIG.PSU__DDR_QOS_HP2_WRQOS {} \
   CONFIG.PSU__DDR_QOS_HP3_RDQOS {} \
   CONFIG.PSU__DDR_QOS_HP3_WRQOS {} \
   CONFIG.PSU__DDR_QOS_RD_HPR_THRSHLD {} \
   CONFIG.PSU__DDR_QOS_RD_LPR_THRSHLD {} \
   CONFIG.PSU__DDR_QOS_WR_THRSHLD {} \
   CONFIG.PSU__DDR_SW_REFRESH_ENABLED {1} \
   CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.500} \
   CONFIG.PSU__DEVICE_TYPE {RFSOC} \
   CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__IO {GT Lane0} \
   CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DLL__ISUSED {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
   CONFIG.PSU__DP__LANE_SEL {Dual Lower} \
   CONFIG.PSU__DP__REF_CLK_FREQ {27} \
   CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk1} \
   CONFIG.PSU__ENABLE__DDR__REFRESH__SIGNALS {0} \
   CONFIG.PSU__ENET0__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {0} \
   CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__ENET0__PTP__ENABLE {0} \
   CONFIG.PSU__ENET0__TSU__ENABLE {0} \
   CONFIG.PSU__ENET1__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET1__GRP_MDIO__ENABLE {0} \
   CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__ENET1__PTP__ENABLE {0} \
   CONFIG.PSU__ENET1__TSU__ENABLE {0} \
   CONFIG.PSU__ENET2__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET2__GRP_MDIO__ENABLE {0} \
   CONFIG.PSU__ENET2__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__ENET2__PTP__ENABLE {0} \
   CONFIG.PSU__ENET2__TSU__ENABLE {0} \
   CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
   CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
   CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
   CONFIG.PSU__ENET3__PTP__ENABLE {0} \
   CONFIG.PSU__ENET3__TSU__ENABLE {0} \
   CONFIG.PSU__EN_AXI_STATUS_PORTS {0} \
   CONFIG.PSU__EN_EMIO_TRACE {0} \
   CONFIG.PSU__EP__IP {0} \
   CONFIG.PSU__EXPAND__CORESIGHT {0} \
   CONFIG.PSU__EXPAND__FPD_SLAVES {0} \
   CONFIG.PSU__EXPAND__GIC {0} \
   CONFIG.PSU__EXPAND__LOWER_LPS_SLAVES {0} \
   CONFIG.PSU__EXPAND__UPPER_LPS_SLAVES {0} \
   CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
   CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {99.999001} \
   CONFIG.PSU__FPD_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__FPGA_PL0_ENABLE {1} \
   CONFIG.PSU__FPGA_PL1_ENABLE {0} \
   CONFIG.PSU__FPGA_PL2_ENABLE {0} \
   CONFIG.PSU__FPGA_PL3_ENABLE {0} \
   CONFIG.PSU__FP__POWER__ON {1} \
   CONFIG.PSU__FTM__CTI_IN_0 {0} \
   CONFIG.PSU__FTM__CTI_IN_1 {0} \
   CONFIG.PSU__FTM__CTI_IN_2 {0} \
   CONFIG.PSU__FTM__CTI_IN_3 {0} \
   CONFIG.PSU__FTM__CTI_OUT_0 {0} \
   CONFIG.PSU__FTM__CTI_OUT_1 {0} \
   CONFIG.PSU__FTM__CTI_OUT_2 {0} \
   CONFIG.PSU__FTM__CTI_OUT_3 {0} \
   CONFIG.PSU__FTM__GPI {0} \
   CONFIG.PSU__FTM__GPO {0} \
   CONFIG.PSU__GEM0_COHERENCY {0} \
   CONFIG.PSU__GEM0_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM1_COHERENCY {0} \
   CONFIG.PSU__GEM1_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM2_COHERENCY {0} \
   CONFIG.PSU__GEM2_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM3_COHERENCY {0} \
   CONFIG.PSU__GEM3_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM__TSU__ENABLE {0} \
   CONFIG.PSU__GEN_IPI_0__MASTER {APU} \
   CONFIG.PSU__GEN_IPI_10__MASTER {NONE} \
   CONFIG.PSU__GEN_IPI_1__MASTER {RPU0} \
   CONFIG.PSU__GEN_IPI_2__MASTER {RPU1} \
   CONFIG.PSU__GEN_IPI_3__MASTER {PMU} \
   CONFIG.PSU__GEN_IPI_4__MASTER {PMU} \
   CONFIG.PSU__GEN_IPI_5__MASTER {PMU} \
   CONFIG.PSU__GEN_IPI_6__MASTER {PMU} \
   CONFIG.PSU__GEN_IPI_7__MASTER {NONE} \
   CONFIG.PSU__GEN_IPI_8__MASTER {NONE} \
   CONFIG.PSU__GEN_IPI_9__MASTER {NONE} \
   CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
   CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
   CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO2_MIO__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__GPIO_EMIO_WIDTH {1} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__GPIO_EMIO__WIDTH {[94:0]} \
   CONFIG.PSU__GPU_PP0__POWER__ON {0} \
   CONFIG.PSU__GPU_PP1__POWER__ON {0} \
   CONFIG.PSU__GT_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__GT__LINK_SPEED {HBR} \
   CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
   CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
   CONFIG.PSU__HIGH_ADDRESS__ENABLE {1} \
   CONFIG.PSU__HPM0_FPD__NUM_READ_THREADS {4} \
   CONFIG.PSU__HPM0_FPD__NUM_WRITE_THREADS {4} \
   CONFIG.PSU__HPM0_LPD__NUM_READ_THREADS {4} \
   CONFIG.PSU__HPM0_LPD__NUM_WRITE_THREADS {4} \
   CONFIG.PSU__HPM1_FPD__NUM_READ_THREADS {4} \
   CONFIG.PSU__HPM1_FPD__NUM_WRITE_THREADS {4} \
   CONFIG.PSU__I2C0_LOOP_I2C1__ENABLE {0} \
   CONFIG.PSU__I2C0__GRP_INT__ENABLE {0} \
   CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15} \
   CONFIG.PSU__I2C1__GRP_INT__ENABLE {0} \
   CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC0__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {99.999001} \
   CONFIG.PSU__IOU_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__IRQ_P2F_ADMA_CHAN__INT {0} \
   CONFIG.PSU__IRQ_P2F_AIB_AXI__INT {0} \
   CONFIG.PSU__IRQ_P2F_AMS__INT {0} \
   CONFIG.PSU__IRQ_P2F_APM_FPD__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_COMM__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_CPUMNT__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_CTI__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_EXTERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_IPI__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_L2ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_PMU__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_REGS__INT {0} \
   CONFIG.PSU__IRQ_P2F_ATB_LPD__INT {0} \
   CONFIG.PSU__IRQ_P2F_CAN0__INT {0} \
   CONFIG.PSU__IRQ_P2F_CAN1__INT {0} \
   CONFIG.PSU__IRQ_P2F_CLKMON__INT {0} \
   CONFIG.PSU__IRQ_P2F_CSUPMU_WDT__INT {0} \
   CONFIG.PSU__IRQ_P2F_CSU_DMA__INT {0} \
   CONFIG.PSU__IRQ_P2F_CSU__INT {0} \
   CONFIG.PSU__IRQ_P2F_DDR_SS__INT {0} \
   CONFIG.PSU__IRQ_P2F_DPDMA__INT {0} \
   CONFIG.PSU__IRQ_P2F_DPORT__INT {0} \
   CONFIG.PSU__IRQ_P2F_EFUSE__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT0_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT0__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT1_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT1__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT2_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT2__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT3_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT3__INT {0} \
   CONFIG.PSU__IRQ_P2F_FPD_APB__INT {0} \
   CONFIG.PSU__IRQ_P2F_FPD_ATB_ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_FP_WDT__INT {0} \
   CONFIG.PSU__IRQ_P2F_GDMA_CHAN__INT {0} \
   CONFIG.PSU__IRQ_P2F_GPIO__INT {0} \
   CONFIG.PSU__IRQ_P2F_GPU__INT {0} \
   CONFIG.PSU__IRQ_P2F_I2C0__INT {0} \
   CONFIG.PSU__IRQ_P2F_I2C1__INT {0} \
   CONFIG.PSU__IRQ_P2F_LPD_APB__INT {0} \
   CONFIG.PSU__IRQ_P2F_LPD_APM__INT {0} \
   CONFIG.PSU__IRQ_P2F_LP_WDT__INT {0} \
   CONFIG.PSU__IRQ_P2F_NAND__INT {0} \
   CONFIG.PSU__IRQ_P2F_OCM_ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_PCIE_DMA__INT {0} \
   CONFIG.PSU__IRQ_P2F_PCIE_LEGACY__INT {0} \
   CONFIG.PSU__IRQ_P2F_PCIE_MSC__INT {0} \
   CONFIG.PSU__IRQ_P2F_PCIE_MSI__INT {0} \
   CONFIG.PSU__IRQ_P2F_PL_IPI__INT {0} \
   CONFIG.PSU__IRQ_P2F_QSPI__INT {0} \
   CONFIG.PSU__IRQ_P2F_R5_CORE0_ECC_ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_R5_CORE1_ECC_ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_RPU_IPI__INT {0} \
   CONFIG.PSU__IRQ_P2F_RPU_PERMON__INT {0} \
   CONFIG.PSU__IRQ_P2F_RTC_ALARM__INT {0} \
   CONFIG.PSU__IRQ_P2F_RTC_SECONDS__INT {0} \
   CONFIG.PSU__IRQ_P2F_SATA__INT {0} \
   CONFIG.PSU__IRQ_P2F_SDIO0_WAKE__INT {0} \
   CONFIG.PSU__IRQ_P2F_SDIO0__INT {0} \
   CONFIG.PSU__IRQ_P2F_SDIO1_WAKE__INT {0} \
   CONFIG.PSU__IRQ_P2F_SDIO1__INT {0} \
   CONFIG.PSU__IRQ_P2F_SPI0__INT {0} \
   CONFIG.PSU__IRQ_P2F_SPI1__INT {0} \
   CONFIG.PSU__IRQ_P2F_TTC0__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_TTC0__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_TTC0__INT2 {0} \
   CONFIG.PSU__IRQ_P2F_TTC1__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_TTC1__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_TTC1__INT2 {0} \
   CONFIG.PSU__IRQ_P2F_TTC2__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_TTC2__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_TTC2__INT2 {0} \
   CONFIG.PSU__IRQ_P2F_TTC3__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_TTC3__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_TTC3__INT2 {0} \
   CONFIG.PSU__IRQ_P2F_UART0__INT {0} \
   CONFIG.PSU__IRQ_P2F_UART1__INT {0} \
   CONFIG.PSU__IRQ_P2F_USB3_ENDPOINT__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_USB3_ENDPOINT__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_USB3_OTG__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_USB3_OTG__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_USB3_PMU_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_XMPU_FPD__INT {0} \
   CONFIG.PSU__IRQ_P2F_XMPU_LPD__INT {0} \
   CONFIG.PSU__IRQ_P2F__INTF_FPD_SMMU__INT {0} \
   CONFIG.PSU__IRQ_P2F__INTF_PPD_CCI__INT {0} \
   CONFIG.PSU__L2_BANK0__POWER__ON {1} \
   CONFIG.PSU__LPDMA0_COHERENCY {0} \
   CONFIG.PSU__LPDMA1_COHERENCY {0} \
   CONFIG.PSU__LPDMA2_COHERENCY {0} \
   CONFIG.PSU__LPDMA3_COHERENCY {0} \
   CONFIG.PSU__LPDMA4_COHERENCY {0} \
   CONFIG.PSU__LPDMA5_COHERENCY {0} \
   CONFIG.PSU__LPDMA6_COHERENCY {0} \
   CONFIG.PSU__LPDMA7_COHERENCY {0} \
   CONFIG.PSU__LPD_SLCR__CSUPMU_WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__FREQMHZ {100.000000} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
   CONFIG.PSU__M_AXI_GP0_SUPPORTS_NARROW_BURST {1} \
   CONFIG.PSU__M_AXI_GP1_SUPPORTS_NARROW_BURST {1} \
   CONFIG.PSU__M_AXI_GP2_SUPPORTS_NARROW_BURST {1} \
   CONFIG.PSU__NAND_COHERENCY {0} \
   CONFIG.PSU__NAND_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__NAND__CHIP_ENABLE__ENABLE {0} \
   CONFIG.PSU__NAND__DATA_STROBE__ENABLE {0} \
   CONFIG.PSU__NAND__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__NAND__READY0_BUSY__ENABLE {0} \
   CONFIG.PSU__NAND__READY1_BUSY__ENABLE {0} \
   CONFIG.PSU__NAND__READY_BUSY__ENABLE {0} \
   CONFIG.PSU__NUM_FABRIC_RESETS {1} \
   CONFIG.PSU__OCM_BANK0__POWER__ON {1} \
   CONFIG.PSU__OCM_BANK1__POWER__ON {1} \
   CONFIG.PSU__OCM_BANK2__POWER__ON {1} \
   CONFIG.PSU__OCM_BANK3__POWER__ON {1} \
   CONFIG.PSU__OVERRIDE_HPX_QOS {0} \
   CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
   CONFIG.PSU__PCIE__ACS_VIOLAION {0} \
   CONFIG.PSU__PCIE__ACS_VIOLATION {0} \
   CONFIG.PSU__PCIE__AER_CAPABILITY {0} \
   CONFIG.PSU__PCIE__ATOMICOP_EGRESS_BLOCKED {0} \
   CONFIG.PSU__PCIE__BAR0_64BIT {0} \
   CONFIG.PSU__PCIE__BAR0_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR0_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR0_VAL {} \
   CONFIG.PSU__PCIE__BAR1_64BIT {0} \
   CONFIG.PSU__PCIE__BAR1_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR1_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR1_VAL {} \
   CONFIG.PSU__PCIE__BAR2_64BIT {0} \
   CONFIG.PSU__PCIE__BAR2_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR2_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR2_VAL {} \
   CONFIG.PSU__PCIE__BAR3_64BIT {0} \
   CONFIG.PSU__PCIE__BAR3_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR3_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR3_VAL {} \
   CONFIG.PSU__PCIE__BAR4_64BIT {0} \
   CONFIG.PSU__PCIE__BAR4_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR4_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR4_VAL {} \
   CONFIG.PSU__PCIE__BAR5_64BIT {0} \
   CONFIG.PSU__PCIE__BAR5_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR5_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR5_VAL {} \
   CONFIG.PSU__PCIE__CLASS_CODE_BASE {} \
   CONFIG.PSU__PCIE__CLASS_CODE_INTERFACE {} \
   CONFIG.PSU__PCIE__CLASS_CODE_SUB {} \
   CONFIG.PSU__PCIE__CLASS_CODE_VALUE {} \
   CONFIG.PSU__PCIE__COMPLETER_ABORT {0} \
   CONFIG.PSU__PCIE__COMPLTION_TIMEOUT {0} \
   CONFIG.PSU__PCIE__CORRECTABLE_INT_ERR {0} \
   CONFIG.PSU__PCIE__CRS_SW_VISIBILITY {0} \
   CONFIG.PSU__PCIE__DEVICE_ID {} \
   CONFIG.PSU__PCIE__ECRC_CHECK {0} \
   CONFIG.PSU__PCIE__ECRC_ERR {0} \
   CONFIG.PSU__PCIE__ECRC_GEN {0} \
   CONFIG.PSU__PCIE__EROM_ENABLE {0} \
   CONFIG.PSU__PCIE__EROM_VAL {} \
   CONFIG.PSU__PCIE__FLOW_CONTROL_ERR {0} \
   CONFIG.PSU__PCIE__FLOW_CONTROL_PROTOCOL_ERR {0} \
   CONFIG.PSU__PCIE__HEADER_LOG_OVERFLOW {0} \
   CONFIG.PSU__PCIE__INTX_GENERATION {0} \
   CONFIG.PSU__PCIE__LANE0__ENABLE {0} \
   CONFIG.PSU__PCIE__LANE1__ENABLE {0} \
   CONFIG.PSU__PCIE__LANE2__ENABLE {0} \
   CONFIG.PSU__PCIE__LANE3__ENABLE {0} \
   CONFIG.PSU__PCIE__MC_BLOCKED_TLP {0} \
   CONFIG.PSU__PCIE__MSIX_BAR_INDICATOR {} \
   CONFIG.PSU__PCIE__MSIX_CAPABILITY {0} \
   CONFIG.PSU__PCIE__MSIX_PBA_BAR_INDICATOR {} \
   CONFIG.PSU__PCIE__MSIX_PBA_OFFSET {0} \
   CONFIG.PSU__PCIE__MSIX_TABLE_OFFSET {0} \
   CONFIG.PSU__PCIE__MSIX_TABLE_SIZE {0} \
   CONFIG.PSU__PCIE__MSI_64BIT_ADDR_CAPABLE {0} \
   CONFIG.PSU__PCIE__MSI_CAPABILITY {0} \
   CONFIG.PSU__PCIE__MULTIHEADER {0} \
   CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__PCIE__PERIPHERAL__ENDPOINT_ENABLE {1} \
   CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_ENABLE {0} \
   CONFIG.PSU__PCIE__PERM_ROOT_ERR_UPDATE {0} \
   CONFIG.PSU__PCIE__RECEIVER_ERR {0} \
   CONFIG.PSU__PCIE__RECEIVER_OVERFLOW {0} \
   CONFIG.PSU__PCIE__RESET__POLARITY {Active Low} \
   CONFIG.PSU__PCIE__REVISION_ID {} \
   CONFIG.PSU__PCIE__SUBSYSTEM_ID {} \
   CONFIG.PSU__PCIE__SUBSYSTEM_VENDOR_ID {} \
   CONFIG.PSU__PCIE__SURPRISE_DOWN {0} \
   CONFIG.PSU__PCIE__TLP_PREFIX_BLOCKED {0} \
   CONFIG.PSU__PCIE__UNCORRECTABL_INT_ERR {0} \
   CONFIG.PSU__PCIE__VENDOR_ID {} \
   CONFIG.PSU__PJTAG__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__PL_CLK0_BUF {TRUE} \
   CONFIG.PSU__PL_CLK1_BUF {FALSE} \
   CONFIG.PSU__PL_CLK2_BUF {FALSE} \
   CONFIG.PSU__PL_CLK3_BUF {FALSE} \
   CONFIG.PSU__PL__POWER__ON {1} \
   CONFIG.PSU__PMU_COHERENCY {0} \
   CONFIG.PSU__PMU__AIBACK__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPI__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPO__ENABLE {0} \
   CONFIG.PSU__PMU__GPI0__ENABLE {0} \
   CONFIG.PSU__PMU__GPI1__ENABLE {0} \
   CONFIG.PSU__PMU__GPI2__ENABLE {0} \
   CONFIG.PSU__PMU__GPI3__ENABLE {0} \
   CONFIG.PSU__PMU__GPI4__ENABLE {0} \
   CONFIG.PSU__PMU__GPI5__ENABLE {0} \
   CONFIG.PSU__PMU__GPO0__ENABLE {1} \
   CONFIG.PSU__PMU__GPO0__IO {MIO 32} \
   CONFIG.PSU__PMU__GPO1__ENABLE {1} \
   CONFIG.PSU__PMU__GPO1__IO {MIO 33} \
   CONFIG.PSU__PMU__GPO2__ENABLE {1} \
   CONFIG.PSU__PMU__GPO2__IO {MIO 34} \
   CONFIG.PSU__PMU__GPO2__POLARITY {low} \
   CONFIG.PSU__PMU__GPO3__ENABLE {1} \
   CONFIG.PSU__PMU__GPO3__IO {MIO 35} \
   CONFIG.PSU__PMU__GPO3__POLARITY {low} \
   CONFIG.PSU__PMU__GPO4__ENABLE {1} \
   CONFIG.PSU__PMU__GPO4__IO {MIO 36} \
   CONFIG.PSU__PMU__GPO4__POLARITY {low} \
   CONFIG.PSU__PMU__GPO5__ENABLE {1} \
   CONFIG.PSU__PMU__GPO5__IO {MIO 37} \
   CONFIG.PSU__PMU__GPO5__POLARITY {low} \
   CONFIG.PSU__PMU__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__PMU__PLERROR__ENABLE {0} \
   CONFIG.PSU__PRESET_APPLIED {1} \
   CONFIG.PSU__PROTECTION__DDR_SEGMENTS {NONE} \
   CONFIG.PSU__PROTECTION__DEBUG {0} \
   CONFIG.PSU__PROTECTION__ENABLE {0} \
   CONFIG.PSU__PROTECTION__FPD_SEGMENTS {\
SA:0xFD1A0000; SIZE:1280; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware| SA:0xFD000000; SIZE:64; UNIT:KB; RegionTZ:Secure;\
WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFD010000; SIZE:64;\
UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware|\
SA:0xFD020000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware| SA:0xFD030000; SIZE:64; UNIT:KB; RegionTZ:Secure;\
WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFD040000; SIZE:64;\
UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware|\
SA:0xFD050000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware| SA:0xFD610000; SIZE:512; UNIT:KB; RegionTZ:Secure;\
WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFD5D0000; SIZE:64;\
UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU\
Firmware|SA:0xFD1A0000 ; SIZE:1280; UNIT:KB; RegionTZ:Secure ;\
WrAllowed:Read/Write; subsystemId:Secure Subsystem} \
   CONFIG.PSU__PROTECTION__LOCK_UNUSED_SEGMENTS {0} \
   CONFIG.PSU__PROTECTION__LPD_SEGMENTS {\
SA:0xFF980000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware| SA:0xFF5E0000; SIZE:2560; UNIT:KB; RegionTZ:Secure;\
WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFFCC0000; SIZE:64;\
UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware|\
SA:0xFF180000; SIZE:768; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware| SA:0xFF410000; SIZE:640; UNIT:KB; RegionTZ:Secure;\
WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFFA70000; SIZE:64;\
UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware|\
SA:0xFF9A0000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware|SA:0xFF5E0000 ; SIZE:2560; UNIT:KB; RegionTZ:Secure ;\
WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFFCC0000 ; SIZE:64;\
UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure\
Subsystem|SA:0xFF180000 ; SIZE:768; UNIT:KB; RegionTZ:Secure ;\
WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFF9A0000 ; SIZE:64;\
UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem} \
   CONFIG.PSU__PROTECTION__MASTERS {\
USB1:NonSecure;0|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;1|S_AXI_HPC0_FPD:NA;1|S_AXI_HP3_FPD:NA;0|S_AXI_HP2_FPD:NA;0|S_AXI_HP1_FPD:NA;0|S_AXI_HP0_FPD:NA;0|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;0|SATA1:NonSecure;1|SATA0:NonSecure;1|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__MASTERS_TZ {\
GEM0:NonSecure|SD1:NonSecure|GEM2:NonSecure|GEM1:NonSecure|GEM3:NonSecure|PCIe:NonSecure|DP:NonSecure|NAND:NonSecure|GPU:NonSecure|USB1:NonSecure|USB0:NonSecure|LDMA:NonSecure|FDMA:NonSecure|QSPI:NonSecure|SD0:NonSecure} \
   CONFIG.PSU__PROTECTION__OCM_SEGMENTS {NONE} \
   CONFIG.PSU__PROTECTION__PRESUBSYSTEMS {NONE} \
   CONFIG.PSU__PROTECTION__SLAVES {\
LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;1|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;0|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display\
Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;1|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1} \
   CONFIG.PSU__PROTECTION__SUBSYSTEMS {PMU Firmware:PMU|Secure Subsystem:} \
   CONFIG.PSU__PSS_ALT_REF_CLK__ENABLE {0} \
   CONFIG.PSU__PSS_ALT_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__QSPI_COHERENCY {0} \
   CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
   CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
   CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
   CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 12} \
   CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel} \
   CONFIG.PSU__REPORT__DBGLOG {0} \
   CONFIG.PSU__RPU_COHERENCY {0} \
   CONFIG.PSU__RPU__POWER__ON {1} \
   CONFIG.PSU__SATA__LANE0__ENABLE {0} \
   CONFIG.PSU__SATA__LANE1__ENABLE {1} \
   CONFIG.PSU__SATA__LANE1__IO {GT Lane3} \
   CONFIG.PSU__SATA__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SATA__REF_CLK_FREQ {125} \
   CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk3} \
   CONFIG.PSU__SAXIGP0__DATA_WIDTH {32} \
   CONFIG.PSU__SAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP2__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP3__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP4__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP5__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP6__DATA_WIDTH {128} \
   CONFIG.PSU__SD0_COHERENCY {0} \
   CONFIG.PSU__SD0_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__SD0__CLK_100_SDR_OTAP_DLY {0x3} \
   CONFIG.PSU__SD0__CLK_200_SDR_OTAP_DLY {0x3} \
   CONFIG.PSU__SD0__CLK_50_DDR_ITAP_DLY {0x3D} \
   CONFIG.PSU__SD0__CLK_50_DDR_OTAP_DLY {0x4} \
   CONFIG.PSU__SD0__CLK_50_SDR_ITAP_DLY {0x15} \
   CONFIG.PSU__SD0__CLK_50_SDR_OTAP_DLY {0x5} \
   CONFIG.PSU__SD0__GRP_CD__ENABLE {0} \
   CONFIG.PSU__SD0__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD0__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SD0__RESET__ENABLE {0} \
   CONFIG.PSU__SD1_COHERENCY {0} \
   CONFIG.PSU__SD1_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__SD1__CLK_100_SDR_OTAP_DLY {0x3} \
   CONFIG.PSU__SD1__CLK_200_SDR_OTAP_DLY {0x3} \
   CONFIG.PSU__SD1__CLK_50_DDR_ITAP_DLY {0x3D} \
   CONFIG.PSU__SD1__CLK_50_DDR_OTAP_DLY {0x4} \
   CONFIG.PSU__SD1__CLK_50_SDR_ITAP_DLY {0x15} \
   CONFIG.PSU__SD1__CLK_50_SDR_OTAP_DLY {0x5} \
   CONFIG.PSU__SD1__DATA_TRANSFER_MODE {8Bit} \
   CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
   CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
   CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD1__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 39 .. 51} \
   CONFIG.PSU__SD1__RESET__ENABLE {0} \
   CONFIG.PSU__SD1__SLOT_TYPE {SD 3.0} \
   CONFIG.PSU__SPI0_LOOP_SPI1__ENABLE {0} \
   CONFIG.PSU__SPI0__GRP_SS0__ENABLE {0} \
   CONFIG.PSU__SPI0__GRP_SS1__ENABLE {0} \
   CONFIG.PSU__SPI0__GRP_SS2__ENABLE {0} \
   CONFIG.PSU__SPI0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SPI1__GRP_SS0__ENABLE {0} \
   CONFIG.PSU__SPI1__GRP_SS1__ENABLE {0} \
   CONFIG.PSU__SPI1__GRP_SS2__ENABLE {0} \
   CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT0__PERIPHERAL__IO {NA} \
   CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
   CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT1__PERIPHERAL__IO {NA} \
   CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
   CONFIG.PSU__TCM0A__POWER__ON {1} \
   CONFIG.PSU__TCM0B__POWER__ON {1} \
   CONFIG.PSU__TCM1A__POWER__ON {1} \
   CONFIG.PSU__TCM1B__POWER__ON {1} \
   CONFIG.PSU__TESTSCAN__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__TRACE_PIPELINE_WIDTH {8} \
   CONFIG.PSU__TRACE__INTERNAL_WIDTH {32} \
   CONFIG.PSU__TRACE__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__TRISTATE__INVERTED {1} \
   CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
   CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC0__PERIPHERAL__IO {NA} \
   CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC1__PERIPHERAL__IO {NA} \
   CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC2__PERIPHERAL__IO {NA} \
   CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC3__PERIPHERAL__IO {NA} \
   CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__UART0_LOOP_UART1__ENABLE {0} \
   CONFIG.PSU__UART0__BAUD_RATE {115200} \
   CONFIG.PSU__UART0__MODEM__ENABLE {0} \
   CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
   CONFIG.PSU__UART1__BAUD_RATE {115200} \
   CONFIG.PSU__UART1__MODEM__ENABLE {0} \
   CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART1__PERIPHERAL__IO {EMIO} \
   CONFIG.PSU__USB0_COHERENCY {0} \
   CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
   CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
   CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
   CONFIG.PSU__USB0__RESET__ENABLE {0} \
   CONFIG.PSU__USB1_COHERENCY {0} \
   CONFIG.PSU__USB1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__USB1__RESET__ENABLE {0} \
   CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB2_1__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
   CONFIG.PSU__USB3_1__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__USB__RESET__MODE {Boot Pin} \
   CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP0 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP1 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP2 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP3 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP4 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP5 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP6 {0} \
   CONFIG.PSU__USE__ADMA {0} \
   CONFIG.PSU__USE__APU_LEGACY_INTERRUPT {0} \
   CONFIG.PSU__USE__AUDIO {0} \
   CONFIG.PSU__USE__CLK {0} \
   CONFIG.PSU__USE__CLK0 {0} \
   CONFIG.PSU__USE__CLK1 {0} \
   CONFIG.PSU__USE__CLK2 {0} \
   CONFIG.PSU__USE__CLK3 {0} \
   CONFIG.PSU__USE__CROSS_TRIGGER {0} \
   CONFIG.PSU__USE__DDR_INTF_REQUESTED {0} \
   CONFIG.PSU__USE__DEBUG__TEST {0} \
   CONFIG.PSU__USE__EVENT_RPU {0} \
   CONFIG.PSU__USE__FABRIC__RST {1} \
   CONFIG.PSU__USE__FTM {0} \
   CONFIG.PSU__USE__GDMA {0} \
   CONFIG.PSU__USE__IRQ {0} \
   CONFIG.PSU__USE__IRQ0 {1} \
   CONFIG.PSU__USE__IRQ1 {0} \
   CONFIG.PSU__USE__M_AXI_GP0 {1} \
   CONFIG.PSU__USE__M_AXI_GP1 {1} \
   CONFIG.PSU__USE__M_AXI_GP2 {0} \
   CONFIG.PSU__USE__PROC_EVENT_BUS {0} \
   CONFIG.PSU__USE__RPU_LEGACY_INTERRUPT {0} \
   CONFIG.PSU__USE__RST0 {0} \
   CONFIG.PSU__USE__RST1 {0} \
   CONFIG.PSU__USE__RST2 {0} \
   CONFIG.PSU__USE__RST3 {0} \
   CONFIG.PSU__USE__RTC {0} \
   CONFIG.PSU__USE__STM {0} \
   CONFIG.PSU__USE__S_AXI_ACE {0} \
   CONFIG.PSU__USE__S_AXI_ACP {0} \
   CONFIG.PSU__USE__S_AXI_GP0 {1} \
   CONFIG.PSU__USE__S_AXI_GP1 {1} \
   CONFIG.PSU__USE__S_AXI_GP2 {0} \
   CONFIG.PSU__USE__S_AXI_GP3 {0} \
   CONFIG.PSU__USE__S_AXI_GP4 {0} \
   CONFIG.PSU__USE__S_AXI_GP5 {0} \
   CONFIG.PSU__USE__S_AXI_GP6 {0} \
   CONFIG.PSU__USE__USB3_0_HUB {0} \
   CONFIG.PSU__USE__USB3_1_HUB {0} \
   CONFIG.PSU__USE__VIDEO {0} \
   CONFIG.PSU__VIDEO_REF_CLK__ENABLE {0} \
   CONFIG.PSU__VIDEO_REF_CLK__FREQMHZ {33.333} \
   CONFIG.QSPI_BOARD_INTERFACE {custom} \
   CONFIG.SATA_BOARD_INTERFACE {custom} \
   CONFIG.SD0_BOARD_INTERFACE {custom} \
   CONFIG.SD1_BOARD_INTERFACE {custom} \
   CONFIG.SPI0_BOARD_INTERFACE {custom} \
   CONFIG.SPI1_BOARD_INTERFACE {custom} \
   CONFIG.SUBPRESET1 {Custom} \
   CONFIG.SUBPRESET2 {Custom} \
   CONFIG.SWDT0_BOARD_INTERFACE {custom} \
   CONFIG.SWDT1_BOARD_INTERFACE {custom} \
   CONFIG.TRACE_BOARD_INTERFACE {custom} \
   CONFIG.TTC0_BOARD_INTERFACE {custom} \
   CONFIG.TTC1_BOARD_INTERFACE {custom} \
   CONFIG.TTC2_BOARD_INTERFACE {custom} \
   CONFIG.TTC3_BOARD_INTERFACE {custom} \
   CONFIG.UART0_BOARD_INTERFACE {custom} \
   CONFIG.UART1_BOARD_INTERFACE {custom} \
   CONFIG.USB0_BOARD_INTERFACE {custom} \
   CONFIG.USB1_BOARD_INTERFACE {custom} \
 ] $zynq_ultra_ps_e_0

  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN1_D_1 [get_bd_intf_ports CLK_IN1_D] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]
connect_bd_intf_net -intf_net Conn [get_bd_intf_pins rx0/s_axis2] [get_bd_intf_pins system_ila_0/SLOT_1_AXIS]
connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins rx0/s00_axis] [get_bd_intf_pins system_ila_0/SLOT_2_AXIS]
connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins rx0/s00_axis1] [get_bd_intf_pins system_ila_0/SLOT_3_AXIS]
connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins rx0/m00_axis1] [get_bd_intf_pins system_ila_0/SLOT_4_AXIS]
connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins system_ila_1/SLOT_1_AXIS] [get_bd_intf_pins tx0/m_axis_data]
connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins system_ila_1/SLOT_2_AXIS] [get_bd_intf_pins tx0/s_axis_data]
  connect_bd_intf_net -intf_net S00_AXI1_1 [get_bd_intf_pins hier_sync_rx/S00_AXI1] [get_bd_intf_pins ps8_0_axi_periph_1/M00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins hier_sync_tx/S00_AXI] [get_bd_intf_pins ps8_0_axi_periph_1/M01_AXI]
  connect_bd_intf_net -intf_net S_AXIS_1 [get_bd_intf_pins axis_broadcaster_2/M00_AXIS] [get_bd_intf_pins rx0/S_AXIS]
  connect_bd_intf_net -intf_net S_AXI_LITE1_1 [get_bd_intf_pins axi_smc_2/M01_AXI] [get_bd_intf_pins dmas_tx/S_AXI_LITE1]
  connect_bd_intf_net -intf_net S_AXI_LITE3_1 [get_bd_intf_pins axi_smc_2/M02_AXI] [get_bd_intf_pins dmas_tx/S_AXI_LITE3]
  connect_bd_intf_net -intf_net S_AXI_LITE4_1 [get_bd_intf_pins axi_smc_2/M03_AXI] [get_bd_intf_pins dmas_tx/S_AXI_LITE4]
  connect_bd_intf_net -intf_net S_AXI_LITE6_1 [get_bd_intf_pins axi_smc_2/M04_AXI] [get_bd_intf_pins dmas_tx/S_AXI_LITE6]
  connect_bd_intf_net -intf_net S_AXI_LITE_1 [get_bd_intf_pins axi_smc_2/M00_AXI] [get_bd_intf_pins dmas_tx/S_AXI_LITE]
  connect_bd_intf_net -intf_net S_AXI_LITE_2 [get_bd_intf_pins axi_smc_2/M05_AXI] [get_bd_intf_pins dma_rx/S_AXI_LITE]
  connect_bd_intf_net -intf_net adc0_clk_1 [get_bd_intf_ports adc0_clk] [get_bd_intf_pins usp_rf_data_converter_0/adc0_clk]
  connect_bd_intf_net -intf_net axi4_iq_interleaver_0_m00_axis [get_bd_intf_pins axis_broadcaster_2/S_AXIS] [get_bd_intf_pins iq_interleaver_gain_0/m00_axis]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi4_iq_interleaver_0_m00_axis] [get_bd_intf_pins axis_broadcaster_2/S_AXIS] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axi4_iq_interleaver_0_m00_axis]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins hier_sync_tx/M_AXIS1] [get_bd_intf_pins tx0/s_axis_fec_in]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_dma_0_M_AXIS_MM2S] [get_bd_intf_pins hier_sync_tx/M_AXIS1] [get_bd_intf_pins system_ila_1/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axi_dma_0_M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_smc/S01_AXI] [get_bd_intf_pins dmas_tx/M_AXI_MM2S6]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_SG [get_bd_intf_pins axi_smc/S00_AXI] [get_bd_intf_pins dmas_tx/M_AXI_SG6]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_MM2S [get_bd_intf_pins axi_smc/S02_AXI] [get_bd_intf_pins dmas_tx/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_SG [get_bd_intf_pins axi_smc/S03_AXI] [get_bd_intf_pins dmas_tx/M_AXI_SG]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_MM2S [get_bd_intf_pins axi_smc/S04_AXI] [get_bd_intf_pins dmas_tx/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net axi_dma_2_M_AXI_SG [get_bd_intf_pins axi_smc/S05_AXI] [get_bd_intf_pins dmas_tx/M_AXI_SG1]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_MM2S [get_bd_intf_pins axi_smc_1/S01_AXI] [get_bd_intf_pins dmas_tx/M_AXI_MM2S3]
  connect_bd_intf_net -intf_net axi_dma_6_M_AXI_SG [get_bd_intf_pins axi_smc_1/S00_AXI] [get_bd_intf_pins dmas_tx/M_AXI_SG3]
  connect_bd_intf_net -intf_net axi_smc_1_M00_AXI [get_bd_intf_pins axi_smc_1/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HPC1_FPD]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HPC0_FPD]
  connect_bd_intf_net -intf_net axis_broadcaster_1_M01_AXIS [get_bd_intf_pins hier_sync_rx/M01_AXIS] [get_bd_intf_pins rx0/S_AXIS1]
  connect_bd_intf_net -intf_net axis_broadcaster_2_M01_AXIS [get_bd_intf_pins axis_broadcaster_2/M01_AXIS] [get_bd_intf_pins signal_detect_0/s_axis]
  connect_bd_intf_net -intf_net dac1_clk_1 [get_bd_intf_ports dac1_clk] [get_bd_intf_pins usp_rf_data_converter_0/dac1_clk]
  connect_bd_intf_net -intf_net dma_rx_M_AXI_S2MM [get_bd_intf_pins axi_smc/S06_AXI] [get_bd_intf_pins dma_rx/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_rx_M_AXI_SG [get_bd_intf_pins axi_smc/S07_AXI] [get_bd_intf_pins dma_rx/M_AXI_SG]
  connect_bd_intf_net -intf_net dmas_tx_M_AXIS_MM2S [get_bd_intf_pins dmas_tx/M_AXIS_MM2S] [get_bd_intf_pins hier_sync_tx/S_AXIS2]
  connect_bd_intf_net -intf_net dmas_tx_M_AXIS_MM2S3 [get_bd_intf_pins dmas_tx/M_AXIS_MM2S3] [get_bd_intf_pins hier_sync_tx/S_AXIS]
  connect_bd_intf_net -intf_net dmas_tx_M_AXIS_MM2S5 [get_bd_intf_pins dmas_tx/M_AXIS_MM2S1] [get_bd_intf_pins hier_sync_rx/S_AXIS1]
  connect_bd_intf_net -intf_net dmas_tx_M_AXIS_MM2S6 [get_bd_intf_pins dmas_tx/M_AXIS_MM2S6] [get_bd_intf_pins hier_sync_tx/S_AXIS1]
  connect_bd_intf_net -intf_net fifo_generator_1_M_AXIS [get_bd_intf_pins hier_sync_tx/M_AXIS] [get_bd_intf_pins tx0/s_axis_framer_ctrl]
  connect_bd_intf_net -intf_net hier_sync_rx_M08_AXI [get_bd_intf_pins hier_sync_rx/M08_AXI] [get_bd_intf_pins iq_interleaver_gain_0/s_axi]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets hier_sync_rx_M08_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_1_M02_AXI [get_bd_intf_pins ps8_0_axi_periph_1/M02_AXI] [get_bd_intf_pins usp_rf_data_converter_0/s_axi]
  connect_bd_intf_net -intf_net rx0_m00_axis [get_bd_intf_pins dma_rx/S_AXIS1] [get_bd_intf_pins rx0/m00_axis]
connect_bd_intf_net -intf_net [get_bd_intf_nets rx0_m00_axis] [get_bd_intf_pins dma_rx/S_AXIS1] [get_bd_intf_pins system_ila_0/SLOT_5_AXIS]
  connect_bd_intf_net -intf_net s_axi1_1 [get_bd_intf_pins hier_sync_rx/M06_AXI1] [get_bd_intf_pins rx0/s_axi1]
  connect_bd_intf_net -intf_net s_axi2_1 [get_bd_intf_pins hier_sync_rx/M07_AXI1] [get_bd_intf_pins rx0/s_axi2]
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins hier_sync_rx/M05_AXI1] [get_bd_intf_pins rx0/s_axi]
  connect_bd_intf_net -intf_net s_axi_fec_1 [get_bd_intf_pins hier_sync_tx/M03_AXI] [get_bd_intf_pins tx0/s_axi_fec]
  connect_bd_intf_net -intf_net s_axi_fec_3 [get_bd_intf_pins hier_sync_rx/M02_AXI1] [get_bd_intf_pins rx0/s_axi_fec]
  connect_bd_intf_net -intf_net s_axi_fec_ctrl_2 [get_bd_intf_pins hier_sync_rx/M03_AXI1] [get_bd_intf_pins rx0/s_axi_fec_ctrl]
  connect_bd_intf_net -intf_net s_axi_fec_ctrl_3 [get_bd_intf_pins hier_sync_tx/M00_AXI] [get_bd_intf_pins tx0/s_axi_fec_ctrl]
  connect_bd_intf_net -intf_net s_axi_tlast1_1 [get_bd_intf_pins hier_sync_rx/M04_AXI1] [get_bd_intf_pins rx0/s_axi_tlast1]
  connect_bd_intf_net -intf_net s_axis_config_1 [get_bd_intf_pins hier_sync_tx/M_AXIS2] [get_bd_intf_pins tx0/s_axis_config]
  connect_bd_intf_net -intf_net smartconnect_0_M07_AXI [get_bd_intf_pins hier_sync_rx/M07_AXI] [get_bd_intf_pins signal_detect_0/s_axi]
  connect_bd_intf_net -intf_net tx0_m00_axis [get_bd_intf_pins tx0/m00_axis] [get_bd_intf_pins usp_rf_data_converter_0/s12_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m00_axis [get_bd_intf_pins iq_interleaver_gain_0/s00_axis] [get_bd_intf_pins usp_rf_data_converter_0/m00_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m01_axis [get_bd_intf_pins iq_interleaver_gain_0/s01_axis] [get_bd_intf_pins usp_rf_data_converter_0/m01_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_vout12 [get_bd_intf_ports vout12] [get_bd_intf_pins usp_rf_data_converter_0/vout12]
  connect_bd_intf_net -intf_net vin0_01_1 [get_bd_intf_ports vin0_01] [get_bd_intf_pins usp_rf_data_converter_0/vin0_01]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins axi_smc_2/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM1_FPD [get_bd_intf_pins ps8_0_axi_periph_1/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM1_FPD]

  # Create port connections
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins dmas_tx/mm2s_introut6] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_dma_1_mm2s_introut [get_bd_pins dmas_tx/mm2s_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_dma_2_mm2s_introut [get_bd_pins dmas_tx/mm2s_introut1] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_resetn_1 [get_bd_pins reset_hier/peripheral_aresetn2] [get_bd_pins system_ila_1/resetn] [get_bd_pins tx0/axi_resetn] [get_bd_pins usp_rf_data_converter_0/s1_axis_aresetn]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins rx0/core_clk] [get_bd_pins tx0/core_clk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins reset_hier/slowest_sync_clk]
  connect_bd_net -net dma_rx_s2mm_introut [get_bd_pins dma_rx/s2mm_introut] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net dmas_tx_mm2s_introut3 [get_bd_pins dmas_tx/mm2s_introut3] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins clk_wiz_0/reset]
  connect_bd_net -net rst_ps8_0_249M3_peripheral_aresetn [get_bd_pins axis_broadcaster_2/aresetn] [get_bd_pins dma_rx/s_aresetn] [get_bd_pins iq_interleaver_gain_0/aresetn] [get_bd_pins reset_hier/peripheral_aresetn1] [get_bd_pins rx0/aresetn] [get_bd_pins signal_detect_0/aresetn] [get_bd_pins system_ila_0/resetn] [get_bd_pins usp_rf_data_converter_0/m0_axis_aresetn]
  connect_bd_net -net rst_ps8_0_249M_peripheral_aresetn [get_bd_pins axi_smc/aresetn] [get_bd_pins axi_smc_1/aresetn] [get_bd_pins axi_smc_2/aresetn] [get_bd_pins dma_rx/axi_resetn] [get_bd_pins dmas_tx/axi_resetn] [get_bd_pins hier_sync_rx/aresetn] [get_bd_pins hier_sync_tx/s_aresetn] [get_bd_pins ps8_0_axi_periph_1/ARESETN] [get_bd_pins ps8_0_axi_periph_1/M00_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M01_ARESETN] [get_bd_pins ps8_0_axi_periph_1/M02_ARESETN] [get_bd_pins ps8_0_axi_periph_1/S00_ARESETN] [get_bd_pins reset_hier/ext_reset_in1] [get_bd_pins usp_rf_data_converter_0/s_axi_aresetn]
  connect_bd_net -net usp_rf_data_converter_0_clk_adc0 [get_bd_pins axis_broadcaster_2/aclk] [get_bd_pins dma_rx/s_aclk] [get_bd_pins dmas_tx/m_axi_mm2s_aclk1] [get_bd_pins hier_sync_rx/aclk] [get_bd_pins iq_interleaver_gain_0/clk] [get_bd_pins reset_hier/slowest_sync_clk2] [get_bd_pins rx0/aclk] [get_bd_pins signal_detect_0/clk] [get_bd_pins system_ila_0/clk] [get_bd_pins usp_rf_data_converter_0/clk_adc0] [get_bd_pins usp_rf_data_converter_0/m0_axis_aclk]
  connect_bd_net -net usp_rf_data_converter_0_clk_dac1 [get_bd_pins hier_sync_tx/m_aclk] [get_bd_pins reset_hier/slowest_sync_clk3] [get_bd_pins system_ila_1/clk] [get_bd_pins tx0/s_axi_lite_aclk] [get_bd_pins usp_rf_data_converter_0/clk_dac1] [get_bd_pins usp_rf_data_converter_0/s1_axis_aclk]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins axi_smc/aclk] [get_bd_pins axi_smc_1/aclk] [get_bd_pins axi_smc_2/aclk] [get_bd_pins dma_rx/m_axi_s2mm_aclk] [get_bd_pins dmas_tx/m_axi_mm2s_aclk] [get_bd_pins hier_sync_rx/aclk1] [get_bd_pins hier_sync_tx/s_aclk] [get_bd_pins ps8_0_axi_periph_1/ACLK] [get_bd_pins ps8_0_axi_periph_1/M00_ACLK] [get_bd_pins ps8_0_axi_periph_1/M01_ACLK] [get_bd_pins ps8_0_axi_periph_1/M02_ACLK] [get_bd_pins ps8_0_axi_periph_1/S00_ACLK] [get_bd_pins reset_hier/slowest_sync_clk1] [get_bd_pins usp_rf_data_converter_0/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm1_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/saxihpc0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihpc1_fpd_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins reset_hier/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

  # Create address segments
  assign_bd_address -offset 0xB0006000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rx0/OFDM_demodulator_0/s_axi/reg0] -force
  assign_bd_address -offset 0xA0000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs dmas_tx/axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs dmas_tx/axi_dma_1/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs dmas_tx/axi_dma_2/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0004000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs dma_rx/axi_dma_4/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0006000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs dmas_tx/axi_dma_6/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xB0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rx0/fec_hier_rx0/fec_controller_0/s_axi/reg0] -force
  assign_bd_address -offset 0xB0000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs tx0/fec_hier_tx0/fec_controller_0/s_axi/reg0] -force
  assign_bd_address -offset 0xB0010000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs iq_interleaver_gain_0/s_axi/reg0] -force
  assign_bd_address -offset 0xB0040000 -range 0x00040000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs tx0/fec_hier_tx0/sd_fec_0/S_AXI/PARAMS] -force
  assign_bd_address -offset 0xB0080000 -range 0x00040000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rx0/fec_hier_rx0/sd_fec_1/S_AXI/PARAMS] -force
  assign_bd_address -offset 0xB0002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs signal_detect_0/s_axi/reg0] -force
  assign_bd_address -offset 0xB0030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rx0/synchronizer_0/s_axi/reg0] -force
  assign_bd_address -offset 0xB0007000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rx0/tlast_generator_0/s_axi/reg0] -force
  assign_bd_address -offset 0xB0180000 -range 0x00040000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs usp_rf_data_converter_0/s_axi/Reg] -force
  assign_bd_address -offset 0xB0004000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rx0/zf_equalizer_0/s_axi/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces dma_rx/axi_dma_4/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces dma_rx/axi_dma_4/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces dma_rx/axi_dma_4/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces dma_rx/axi_dma_4/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_0/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_0/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_1/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_1/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_2/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_2/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_6/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_6/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_6/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_6/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_QSPI] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces dma_rx/axi_dma_4/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces dma_rx/axi_dma_4/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces dma_rx/axi_dma_4/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces dma_rx/axi_dma_4/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_0/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_0/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_1/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_1/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_2/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_2/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_2/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_6/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_6/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_6/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces dmas_tx/axi_dma_6/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP1/HPC1_LPS_OCM]


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


