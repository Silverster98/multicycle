`timescale 1ns / 1ps

module sign_extend_16(
    input wire[15:0] imm16,
    output wire[31:0] output32
    );
    
    assign output32 = {{16{imm16[15]}}, imm16};
endmodule

module unsign_extend_16(
    input wire[15:0] imm16,
    output wire[31:0] output32
    );
    
    assign output32 = {16'b0, imm16};
endmodule

module load_uper_imm(
    input wire[15:0] imm16,
    output wire[31:0] output32
    );
    
    assign output32 = {imm16, 16'b0};
endmodule

module unsign_extend_26_left2(
    input wire[25:0] imm26,
    output wire[31:0] output32
    );
    
    assign output32 = {4'b0000, imm26, 2'b00};
endmodule