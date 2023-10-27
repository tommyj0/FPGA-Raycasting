`timescale 1ns / 1ps

// 640x480


module VGA_wrapper(
    input CLK,
    input [3:0] BTN,
    
    output [11:0] COLOUR_OUT,
    output HS,
    output VS,
    output reg [15:0] led
    );
    
    // module instantiation
    reg [11:0] COLOUR;
    wire [8:0] Y;
    wire [9:0] X;
    wire FRAME;
    reg signed [15:0] angle; // in rad
    reg phase_tvalid = 1'b1;
    wire signed [15:0] sin;
    wire signed [15:0] cos;
    wire sincos_tvalid;
    reg [8:0] map [8:0];
    
    VGA_interface interface (
                   .CLK(CLK),
                   .COLOUR_IN(COLOUR),
                   .ADDRH(X),
                   .ADDRV(Y),
                   .COLOUR_OUT(COLOUR_OUT),
                   .HS(HS),
                   .VS(VS),
                   .FRAME(FRAME)
   );
   sincos sincos_int (
                   .clk(CLK),
                   .phase(angle),
                   .phase_tvalid(phase_tvalid),
                   .cos(cos),
                   .sin(sin),
                   .sincos_tvalid(sincos_tvalid)
   );
    
    integer width = 640;
    integer height = 480;
    integer colour = 12'hF00;
    integer red = 4'h0;
    integer green = 4'h0;
    integer blue = 4'h0;
    integer ixpos = 640/2;
    integer iypos = 480/2;
    integer fxpos = 640/2 << 14;
    integer fypos = 480/2 << 14;
    integer dir = 1'b0;
    localparam signed [15:0] PI_POS = 16'b0110_0100_1000_1000;
    localparam signed [15:0] PI_NEG = 16'b1001_1011_0111_1000;
    localparam PHASE_INC = 256;
    
//    integer row, col;
    integer scale = 60;
    integer dude_size = 60/12;
    integer row,col;
    integer dir = 0;
    integer point = 0;
    integer COLOUR_IN = 12'h075;
    
    function collision (input x);

    begin
        for (row = 0; row < 8; row = row+1) begin
            for (col = 0; col < 8; col = col + 1) begin
                if ((map[row] >> (7 - col)) & 1'b1) begin

                    // left wall
                    if ((ixpos < col*scale + dude_size + scale && ixpos >= col*scale + dude_size + scale - scale/3)
                    && (iypos > (row*scale - dude_size + 3) && iypos < (row*scale + scale + dude_size - 3)))
                        fxpos = (col*scale + dude_size + scale) << 14;
                    // right wall
                    else if ((ixpos > col*scale - dude_size && ixpos <= col*scale - dude_size + scale/3) 
                    && (iypos > (row*scale - dude_size + 3) && iypos < (row*scale + scale + dude_size - 3)))
                        fxpos = (col*scale - dude_size) << 14;
                    // bottom wall
                    if ((iypos < row*scale + dude_size + scale && iypos >= row*scale + dude_size + scale - scale/3) 
                    && (ixpos > (col*scale - dude_size + 3) && ixpos < (col*scale + scale + dude_size - 3)))
                        fypos = (row*scale + dude_size + scale) << 14;
                    // top wall
                    else if ((iypos > row*scale - dude_size && iypos <= row*scale - dude_size + scale/3) 
                    && (ixpos > (col*scale - dude_size + 3) && ixpos < (col*scale + scale + dude_size - 3)))
                        fypos = (row*scale - dude_size) << 14;
                end
            end
        end
    end
    endfunction
    
    // draws a rectangle given the bottom left coord as (X1,Y1) and top left coord (X2,Y2)
    function [11:0] rectangle (integer X1,Y1,X2,Y2, integer color);
    begin
        Y1 = height - Y1;
        Y2 = height - Y2;
        if (X >= X1 && X < X2 && Y > Y2 && Y <= Y1)
            rectangle = color;
        else
            rectangle = COLOUR;
    end
    endfunction
    
    // draws a line based on 2 coords
    function [11:0] line (integer X1,Y1, integer color);
        integer  grad;
        integer yoff;
        begin

        Y1 = height - Y1;
        grad = (sin*(2**5))/cos;
        yoff = Y1*(2**5) - grad*X1;
        if (Y*(2**5) >= (grad)*X + yoff - 3*(2**5) && Y*(2**5) <= (grad)*X + yoff + 3*(2**5)) begin
            if (cos >= 0 && sin >= 0 && X < X1 && Y < Y1)
                line = color;
            else if (cos <= 0 && sin >= 0 && X > X1 && Y < Y1)
                line = color;
            else if (cos <= 0 && sin <= 0 && X > X1 && Y > Y1)
                line = color;
            else if (cos >= 0 && sin <= 0 && X < X1 && Y > Y1)
                line = color;
            else
                line = COLOUR;
        end
        else
            line = COLOUR;

    end
    endfunction
    // end of functions
    
    always@(posedge FRAME) begin
        map[7] <= 8'b11111111;
        map[6] <= 8'b10110001;
        map[5] <= 8'b10110001;
        map[4] <= 8'b10011101;
        map[3] <= 8'b10011001;
        map[2] <= 8'b10110001;
        map[1] <= 8'b10000011;
        map[0] <= 8'b11111111;
    end
    
    
    always@(posedge CLK) begin
        COLOUR = COLOUR_IN; // set background
        // draw map
        for (row = 0; row < 8; row = row+1) begin
            for (col = 0; col < 8; col = col + 1) begin
                if ((map[row] >> (7 - col)) & 1'b1)
                    COLOUR = rectangle(col*scale,row*scale,col*scale + scale, row*scale + scale, 12'h077);
            end
        end
        //draw dude
        COLOUR = rectangle(ixpos - dude_size, iypos - dude_size, ixpos + dude_size, iypos + dude_size, 12'hF0F);
        COLOUR = line(ixpos,iypos,12'hF00);
    end
    // Frame based operations
    always@(posedge FRAME) begin

        if (BTN[0]) begin
            dir = 1;
            fypos = fypos + sin*2;
            fxpos = fxpos - cos*2;
        end
        if (BTN[1])
            angle = angle + PHASE_INC;
        if (BTN[2]) begin
            dir = 0;
            fypos = fypos - sin*2;
            fxpos = fxpos + cos*2;
        end
        if (BTN[3])
            angle = angle - PHASE_INC;
        ixpos = fxpos >> 14;
        iypos = fypos >> 14;
        collision(1);
        ixpos = fxpos >> 14;
        iypos = fypos >> 14;
        
        if (angle > PI_POS)
            angle = angle + PI_NEG - PI_POS;
        if (angle < PI_NEG)
            angle = angle + PI_POS - PI_NEG;
    end

endmodule
