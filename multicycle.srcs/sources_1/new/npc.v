`timescale 1ns / 1ps

module npc(
    input wire[31:0] pc,
    input wire[25:0] imm26,
    input wire[15:0] imm16,
    input wire[1:0]  npc_sel,
    
    output wire[31:0] npc,
    output wire[31:0] pc_4
    );
    
    assign pc_4 = pc + 4;
    assign npc = (npc_sel == 2'b00) ? pc_4 :
                 (npc_sel == 2'b01) ? {pc[31:28], imm26, 2'b00} :
                 (npc_sel == 2'b10) ? pc_4 + {{14{imm16[15]}}, imm16, 2'b00} :
                 32'h00000000;
endmodule
