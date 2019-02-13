`timescale 1ns / 1ps

module sequential_reg32(
    input wire clk,
    input wire en,
    input wire[31:0] in,
    output reg[31:0] _reg
    );
    
    always @ (posedge clk) begin
        if (en) _reg <= in;
    end
endmodule
