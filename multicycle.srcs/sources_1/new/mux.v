`timescale 1ns / 1ps

module mux_2_32(
    input wire[31:0] in1,in2,
    input wire       sel,
    
    output reg[31:0] out
    );
    
    always @ (*) begin
        case (sel)
            1'b0 : out <= in1;
            1'b1 : out <= in2;
        endcase
    end
endmodule

module mux_2_5(
    input wire[4:0] in1,in2,
    input wire sel,
    
    output reg[4:0] out
    );
    
    always @ (*) begin
        case (sel)
            1'b0 : out <= in1;
            1'b1 : out <= in2;
        endcase
    end
endmodule

module mux_5_32(
    input wire[31:0] in1,in2,in3,in4,in5,
    input wire[2:0]  sel,
    
    output reg[31:0] out
    );
    
    always @ (*) begin
        case (sel)
            3'b000 : out <= in1;
            3'b001 : out <= in2;
            3'b010 : out <= in3;
            3'b011 : out <= in4;
            3'b100 : out <= in5;
            default : out <= 32'h00000000;
        endcase
    end
endmodule