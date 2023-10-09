`timescale 1ns / 1ps

module zero_pad#
	(
		parameter integer TDATA_WIDTH = 128
	)
	(
		input wire  s00_axis_aclk,
		input wire  s00_axis_aresetn,
		
		(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s00_axis TREADY" *)
		output wire  s00_axis_tready,
		(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s00_axis TDATA" *)
		input wire [TDATA_WIDTH-1 : 0] s00_axis_tdata,
		(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s00_axis TLAST" *)
		input wire  s00_axis_tlast,
		(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s00_axis TVALID" *)
		input wire  s00_axis_tvalid,

        (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m00_axis TVALID" *)
		output wire  m00_axis_tvalid,
		(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m00_axis TDATA" *)
		output wire [TDATA_WIDTH - 1 : 0] m00_axis_tdata,
		(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m00_axis TLAST" *)
		output wire  m00_axis_tlast,
		(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m00_axis TREADY" *)
		input wire  m00_axis_tready

    );
    
    assign m00_axis_tdata = (s00_axis_tvalid) ? s00_axis_tdata :
                                {TDATA_WIDTH{1'b0}};
    
    assign m00_axis_tvalid = (s00_axis_aresetn) ? 1 : 0;
    assign s00_axis_tready = m00_axis_tready;
    
endmodule
