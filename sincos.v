`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2023 16:58:54
// Design Name: 
// Module Name: sincos
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sincos(
    input clk,
    input [15:0] phase,
    input phase_tvalid,
    
    output [15:0] cos,
    output [15:0] sin,
    output sincos_tvalid
    );
    
    cordic_0 cordic_0_inst (
    .aclk(clk),
    .s_axis_phase_tvalid(phase_tvalid),
    .s_axis_phase_tdata (phase),
    .m_axis_dout_tvalid(sincos_tvalid),
    .m_axis_dout_tdata ({sin,cos})
    
    );
endmodule
