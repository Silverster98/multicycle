`timescale 1ns / 1ps

module inst_fetch(
    input wire       rst,
    input wire       clk,
    input wire       if_en,
    input wire[15:0] imm16,
    input wire[25:0] imm26,
    input wire[1:0]  npc_sel,
    
    output wire[31:0] pc_4,
    output wire[31:0] inst
    );
    
    wire[31:0] pc;
    wire[31:0] npc;
    
    pc MIPS_PC(
        .rst(rst),
        .clk(clk),
        .pc_en(if_en),
        .npc(npc),
        .pc(pc)
    );
    
    npc MIPS_NPC(
        .pc(pc),
        .imm26(imm26),
        .imm16(imm16),
        .npc_sel(npc_sel),
        .npc(npc),
        .pc_4(pc_4)
    );
    
endmodule
