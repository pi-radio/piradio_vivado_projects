## Piradio standalone project

This project implements the Piradio OFDM chain in standalone mode. This firmware can be run on multiple nodes.

### Software Prerequisites

 * Vivado 2021.1
 * [Piradio driver and supporting software](https://github.com/pi-radio/piradio_ofdm_sw.git)
 * [Ubuntu SD card image](https://pi-radio.atlassian.net/wiki/spaces/CRS/pages/36503553/Piradio+OFDM+loopback+project)

### Hardware prerequisites

* Xilinx ZCU111 RFSoC
* FMC - XM500 daughterboard

### Vivado Project Build (Optional)

To build the Piradio OFDM project for Vivado the following can be done:

* git clone git@github.com:pi-radio/piradio_vivado_projects.git
* cd piradio_vivado_projects
* git submodule update --init --recursive
* cd ofdm-ip-cores
* vivado -mode batch -source gen_cores.tcl
* cd ../standalone/
* vivado -mode batch -source project.tcl

The above steps clone the required repositories, and build the ip cores. In the end, the Vivado GUI launches and the block design can be reviewd, generated and built.

### Hardware Preparation

The FMC-XM500 daughterboard is used for accessing the ADCs and DACs of the RFSoC. For the standalone project, the ADC224_T0_CH0 SMA is used for the receiving antenna and the DAC229_T1_CH2 SMA 
for the transmit antenna.

### Software Preparation

The piradio_ofdm_sw repository contains all necessary files for configuration of the OFDM chain. The binaries are already contained in the SD-card image. The following steps prepare the software for execution:

* cd piradio_ofdm_setup/standalone/ofdm_setup
* sudo sh setup.sh

The ``setup.sh`` bash script will in turn run ``prog.sh`` and ``piradio_setup.sh`` :

* prog.sh : This script calls the rfdc_simpl.elf which programms the LMX and LMK clocks of the ZCU111 board
  Then it runs the ``fpgautil`` utility which loads the FPGA image (design_1_wrapper.bin) and also the device tree overlay (pl.dtbo)
* ``piradio_setup.sh`` : This script loads the piradio kernel object, brings up the piradio interface of the standalone project
and configures the FPGA OFDM cores with the sync word, the template (which contains the pilots) and the map(containing the mappings of the subcarriers to pilots
and null subcarriers) binaries.

When using the piradio_setup.sh script on miltiple nodes, make sure that the IP address set in the sh file is different, but in the same subnet, for each node.

### Resetting the OFDM project

In case during execution a reset of the FPGA design and interfaces is needed, the following process can be followed without powercycling the board:
* sudo sh remove.sh
* sudo fpgautil -b design_1_wrapper.bit
* sudo sh piradio_setup.sh
  
The `` remove.sh `` brings down the interfaces, the fpgautil command reprogramms the fpga image, and then the ``piradio_setup.sh`` does the setup of the cores on the FPGA.

### Switching between loopback and standalone projects

The user can easily switch between the loopback and standalone projects without power-cycling the board.
This is achieved by the following sequence:

* sudo sh remove.sh (Bring down the interface/interfaces)
* sudo fpgautil -R (Removes the device-tree overlay)
* cd piradio_ofdm_setup/{standalone/loopback}/ofdm_setup (cd to the project's folder)
* sudo cp design_1_wrapper.bin /lib/firmware/design_1_wrapper.bit.bin (copy the bin bitstream file in /lib/firmware)
* sudo fpgautil -b design_1_wrapper.bit -o pl.dtbo (program the FPGA and apply the dt overlay)
* sudo sh piradio_setup.sh

### SDcard Ubuntu access

A 16 GB SDcard is required for the Ubuntu distribution

  The Ubuntu distro of the SDcard runs DHCP at boot and can be sshed with credentials: 
  * username: ubuntu
  * pass: p1r@d10
  
  The root user has the same password 
