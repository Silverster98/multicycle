`timescale 1ns / 1ps
`include "instruction.v"

module cu(
    input wire clk,
    input wire rst,
    input wire beqout,
    input wire[5:0] op,
    input wire[5:0] func,
    
    output reg pc_w,
    output reg sel_pc_addr_mux,
    output reg ram_w,
    output reg ir_w,
    output reg sel_reg_dst,
    output reg sel_mem_to_reg,
    output reg rf_w,
    output reg sel_alu_srcA,
    output reg[1:0] sel_alu_srcB,
    output reg[2:0] alu_ctrl,
    output reg sel_npc
    );
    
    parameter[2:0] sif = 3'b000,
                   sid = 3'b001,
                   exe1 = 3'b010, // sub, and, addiu, or...
                   exe2 = 3'b011, // beq
                   exe3 = 3'b100, // sw, lw
                   smem = 3'b101, // mem state
                   swb1 = 3'b110, // sub, and, addiu, or...
                   swb2 = 3'b111; // lw
    
    reg[2:0] state, next_state;
    initial begin
        state = sif;
        pc_w = 0;
        sel_pc_addr_mux = 0;
        ram_w = 0;
        ir_w = 0;
        sel_reg_dst = 0;
        sel_mem_to_reg = 0;
        rf_w = 0;
        sel_alu_srcA = 0;
        sel_alu_srcB = 2'b00;
        alu_ctrl = 3'b000;
        sel_npc = 0;
    end
    
    always @ (posedge clk) begin
        if (rst == 1) begin
            state = sif;
        end else begin
            state = next_state;
        end
    end
    
    always @ (state or op) begin
        case (state)
            sif: next_state = sid;
            sid: begin
                case (op)
                    `INST_J: next_state = sif;
                    `INST_BEQ: next_state = exe2;
                    `INST_LW || `INST_SW: next_state = exe3;
                    default next_state = exe1;
                endcase
            end
            exe1: next_state = swb1;
            exe2: next_state = sif;
            exe3: next_state = smem;
            smem: begin
                if (op == `INST_LW) next_state = swb2;
                else next_state = sif;
            end
            swb1: next_state = sif;
            swb2: next_state = sif;
            default: next_state = sif;
        endcase
    end
    
    always @ (state) begin
        if (state == sif) pc_w = 1;
        else pc_w = 0;
        
        if (state == smem) sel_pc_addr_mux = 1;
        else sel_pc_addr_mux = 0;
        
        if (state == smem && op == `INST_SW) ram_w = 1;
        else ram_w = 0;
        
        if (state == sif) ir_w = 1;
        else ir_w = 0;
        
        if (op == `INST_ADDIU || op == `INST_ORI || op == `INST_LW) sel_reg_dst = 0;
        else sel_reg_dst = 1;
        
        if (state == swb1) sel_mem_to_reg = 1;
        else sel_mem_to_reg = 0;
        
        if (state == swb1 || state == swb2) rf_w = 1;
        else rf_w = 0;
        
        if (state == sif) sel_alu_srcA = 0;
        else sel_alu_srcA = 1;
        
        if (state == sif && op == `INST_BEQ) sel_alu_srcB = 2'b11;
        else if (state == sif) sel_alu_srcB = 2'b01;
        else if(op == `INST_ADDIU || op == `INST_ORI || op == `INST_SW || op == `INST_LW) sel_alu_srcB = 2'b10;
        else sel_alu_srcB = 2'b00;
        
        sel_npc = 0;
        
        if (state == 3'b000) alu_ctrl = 3'b000;
        else begin
        case (op)
            `INST_ORI: alu_ctrl = 3'b011; // ori
            `INST_BEQ: alu_ctrl = 3'b001; // beq
            `INST_TYPE_R: begin
                if (func == `INST_SLL) alu_ctrl = 3'b100; // sll
                else if (func == `INST_SUB) alu_ctrl = 3'b001; // sub
                else if (func == `INST_AND) alu_ctrl = 3'b010; // and
            end
            default: alu_ctrl = 3'b000;
        endcase
        end
    end
endmodule
