`timescale 1ns / 1ps

module alu(
    input wire[31:0] A,             // operation number A
    input wire[31:0] B,             // operation number B
    input wire[2:0] alu_ctrl,       // alu ctrl signal
    input wire[4:0]  s,             // sa 
    
    output wire[31:0] C,            // answer
    output wire beqout              // singal of answer is zero 
    );
    
    reg[32:0] temp;                 // temp variable
    assign C = temp[31:0];
    assign beqout = (temp == 0) ? 1'b1 : 1'b0;
    
    always @ (*) begin
        case (alu_ctrl)
            3'b000 : temp <= {A[31], A} + {B[31], B}; // add operation
            3'b001 : temp <= {A[31], A} - {B[31], B}; // sub operation
            3'b010 : temp <= {A[31], A} & {B[31], B}; // and operation
            3'b011  : temp <= {A[31], A} | {B[31], B}; // or operation
            3'b100  : temp <= {B[31], B} << s;
            3'b101  : temp <= {B[31], B} >> s;
            default : temp <= {B[31], B};
        endcase
    end
endmodule
