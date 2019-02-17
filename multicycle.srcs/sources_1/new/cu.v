`timescale 1ns / 1ps

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
                   exe1 = 3'b010, // sub, and, addi, or...
                   exe2 = 3'b011, // beq
                   exe3 = 3'b100, // sw, lw
                   smem = 3'b101, // mem state
                   swb1 = 3'b110, // sub, and, addi, or...
                   swb2 = 3'b111; // lw
    parameter [5:0] add = 6'b000000;
    
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
        if (rst == 0) begin
            state = sif;
        end else begin
            state = next_state;
        end
    end
    
    always @ (state or op) begin
        case (state)
            sif: next_state = sid;
            sid: begin
                case (op[5:3])
                    3'b111: next_state = sif;
                    3'b110: begin
                        if (op == 6'b110100) next_state = exe2;
                        else next_state = exe3;
                    end
                    default next_state = exe1;
                endcase
            end
            exe1: next_state = swb1;
            exe2: next_state = sif;
            exe3: next_state = smem;
            smem: begin
                if (op == 6'b110001) next_state = swb2;
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
        
        if (state == smem && op == 6'b110000) ram_w = 1;
        else ram_w = 0;
        
        if (state == sif) ir_w = 1;
        else ir_w = 0;
        
        if (op == 6'b000010 || op == 6'b010010 || op == 6'b110001) sel_reg_dst = 0;
        else sel_reg_dst = 1;
        
        if (state == swb1) sel_mem_to_reg = 1;
        else sel_mem_to_reg = 0;
        
        if (state == swb1 || state == swb2) rf_w = 1;
        else rf_w = 0;
        
        if (state == sif) sel_alu_srcA = 0;
        else sel_alu_srcA = 1;
        
        if (state == sif && op == 6'b110100) sel_alu_srcB = 2'b11;
        else if (state == sif) sel_alu_srcB = 2'b01;
        else if(op == 6'b000010 || op == 6'b010010 || op == 6'b110000 || op == 6'b110001) sel_alu_srcB = 2'b10;
        else sel_alu_srcB = 2'b00;
        
        sel_npc = 0;
        
        case (op)
            6'b000001: alu_ctrl = 3'b001;// sub
            6'b010010: alu_ctrl = 3'b011;// ori
            6'b011000: alu_ctrl = 3'b100;// sll
            6'b110100: alu_ctrl = 3'b001;// beq
            6'b010000: alu_ctrl = 3'b011;// or
            default: alu_ctrl = 3'b000;
        endcase
        
    end
endmodule
