`timescale 1ns / 1ps


module VGA_interface(
    input CLK,
    input [11:0] COLOUR_IN,
    output reg [9:0] ADDRH,
    output reg [8:0] ADDRV,
    output reg [11:0] COLOUR_OUT,
    output reg HS,
    output reg VS,
    output reg FRAME
    );
    

    // 640x480
    parameter VertTimeToPulseWidthEnd = 10'd2;
    parameter VertTimeToBackPorchEnd  = 10'd31;
    parameter VertTimeToDisplayTimeEnd  = 10'd511;
    parameter VertTimeToFrontPorchEnd  = 10'd521;
    
    parameter HorzTimeToPulseWidthEnd = 10'd96;
    parameter HorzTimeToBackPorchEnd  = 10'd144;
    parameter HorzTimeToDisplayTimeEnd  = 10'd784;
    parameter HorzTimeToFrontPorchEnd  = 10'd800;
    
    wire HorzCLKOUT;
    wire VertCLKOUT;
    wire CLK25OUT;
    
    wire [9:0] HorzCOUNT;
    wire [9:0] VertCOUNT;
    
    generic_counter # (.COUNTER_WIDTH(2),
                       .COUNTER_MAX(3)
                       )
                       CLK25 (
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(1'b1),
                       .TRIG_OUT(CLK25OUT)
                       );
    
    generic_counter # (.COUNTER_WIDTH(10),
                       .COUNTER_MAX(799)
                       )
                       HorzCLK (
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(CLK25OUT),
                       .COUNT(HorzCOUNT),
                       .TRIG_OUT(HorzCLKOUT)
                       );

    generic_counter # (.COUNTER_WIDTH(10),
                       .COUNTER_MAX(520)
                       )
                       VertCLK (
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(HorzCLKOUT),
                       .COUNT(VertCOUNT),
                       .TRIG_OUT(VertCLKOUT)
                       );
                       
    always begin
        FRAME <= VertCLKOUT;
    end
    always@(posedge CLK) begin
        if (HorzCOUNT <= HorzTimeToPulseWidthEnd)
            HS <= 0;
        else 
            HS <= 1;
        if (VertCOUNT <= VertTimeToPulseWidthEnd)
            VS <= 0;
        else
            VS <= 1;
    end
    always@(posedge HorzCLKOUT) begin
    if (VertCOUNT >= VertTimeToBackPorchEnd && VertCOUNT <= VertTimeToDisplayTimeEnd)
        ADDRV <= ADDRV + 1;
    else
        ADDRV <= 0;
    end
    
    always@(posedge CLK25OUT) begin
        if (HorzCOUNT >= HorzTimeToBackPorchEnd && HorzCOUNT <= HorzTimeToDisplayTimeEnd)
            ADDRH <= ADDRH + 1;
        else
            ADDRH <= 0;
    end
    always@(posedge CLK25OUT) begin
        if (VertCOUNT >= VertTimeToBackPorchEnd && VertCOUNT <= VertTimeToDisplayTimeEnd && 
            HorzCOUNT >= HorzTimeToBackPorchEnd && HorzCOUNT <= HorzTimeToDisplayTimeEnd)
            COLOUR_OUT <= COLOUR_IN;
        else
            COLOUR_OUT <= 0;
    end
    
endmodule
