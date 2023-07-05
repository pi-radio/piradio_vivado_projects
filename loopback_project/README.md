## Piradio loopback project

This project implements the Piradio OFDM chain in loopback mode.

### Software Prerequisites

 * Vivado 2021.1
 * [Piradio driver and supporting software](https://github.com/pi-radio/piradio_ofdm_sw.git)
 * [Ubuntu SD card image](https://pi-radio.atlassian.net/wiki/spaces/CRS/pages/36503553/Piradio+OFDM+loopback+project)

### Hardware prerequisites

* Xilinx ZCU111 RFSoC
* FMC - XM500 daughterboard
* Two SMA cables with 2 DC-Block filters

### Vivado Project Build (Optional)

To build the Piradio OFDM project for Vivado the following can be done:

* git clone git@github.com:pi-radio/piradio_vivado_projects.git
* cd piradio_vivado_projects
* git submodule update --init --recursive
* cd ofdm-ip-cores
* vivado -mode batch -source gen_cores.tcl
* cd ../loopback_project/
* vivado -mode batch -source project.tcl

The above steps clone the required repositories, and build the ip cores. In the end, the Vivado GUI launches and the block design can be reviewd, generated and built.

### Hardware Preparation

The FMC-XM500 daughterboard is used for accessing the ADCs and DACs of the RFSoC. For the loopback project, the ADC224_T0_CH0 SMA must be connected through wire and DC-blocker to the DAC229_T1_CH2 SMA,
and the ADC224_T0_CH1 SMA in a similar way to the DAC229_T1_CH3 SMA.

### Software Preparation

The piradio_ofdm_sw repository contains all necessary files for configuration of the OFDM chain. The binaries are already contained in the SD-card image. The following steps prepare the software for execution:

* cd piradio_ofdm_setup/ofdm_setup
* sudo sh setup.sh

The ``setup.sh`` bash script will in turn run ``prog.sh`` and ``piradio_setup.sh`` :

* prog.sh : This script calls the rfdc_simpl.elf which programms the LMX and LMK clocks of the ZCU111 board
  Then it runs the ``fpgautil`` utility which loads the FPGA image (design_1_wrapper.bin) and also the device tree overlay (pl.dtbo)
* ``piradio_setup.sh`` : This script loads the piradio kernel object, brings up the two interfaces of the loopback project (piradio00 and piradio01)
and configures the FPGA OFDM cores with the sync word, the template (which contains the pilots) and the map(containing the mappings of the subcarriers to pilots
and null subcarriers) binaries.

The two interfaces piradio00 and piradio01 are assigned the addresses 192.168.4.4 and 192.168.5.5 respectively. The piradio01 interface responds to 192.168.4.5 and the piradio11
interface to 192.168.5.4. The way the loopback works is that a bit flip of the transmitter's address is taking place at the receiver, so that the kernel is fooled that the packet comes from a 
different subnet.

An example execution is the following:
```
ubuntu@zynqmp:~/piradio_ofdm_sw/ofdm_setup$ ping 192.168.4.5
PING 192.168.4.5 (192.168.4.5) 56(84) bytes of data.
64 bytes from 192.168.4.5: icmp_seq=1 ttl=64 time=0.422 ms
64 bytes from 192.168.4.5: icmp_seq=2 ttl=64 time=0.386 ms

```
## Resetting the OFDM project

In case during execution a reset of the FPGA design and interfaces is needed, the following process can be followed without powercycling the board:
* sudo sh remove.sh
* sudo fpgautil -b design_1_wrapper.bit
* sudo sh piradio_setup.sh

The `` remove.sh `` brings down the interfaces, the fpgautil command reprogramms the fpga image, and then the ``piradio_setup.sh`` does the setup of the cores on the FPGA.

### SDcard Ubuntu access

  The Ubuntu distro of the SDcard runs DHCP at boot and can be sshed with credentials: 
  * username: ubuntu
  * pass: p1r@d10
  
  The root user has the same password 
