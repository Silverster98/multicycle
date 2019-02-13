`timescale 1ns / 1ps

module mips(
    input wire clk,
    input wire rst
    );
    
    wire[31:0] npc;
    wire[31:0] pc;
    wire pc_w;
    
    wire ram_w;
    wire[31:0] ram_addr;
    wire[31:0] ram_data_in;
    wire[31:0] ram_data_out;
    
    wire ir_w;
    wire[31:0] inst;
    wire[5:0] op;
    wire[4:0] rs,rt,rd;
    wire[15:0] imm16;
    wire[25:0] imm26;
    wire[5:0] func;
    wire[4:0] sa;
    
    assign op = inst[31:26];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign sa = inst[10:6];
    assign func = inst[5:0];
    assign imm16 = inst[15:0];
    assign imm26 = inst[25:0];
    
    
    wire[31:0] dr_out;
    
    wire rf_w;
    wire[31:0] rd1,rd2;
    
    wire[31:0] A,B;
    
    wire[2:0]  alu_ctrl;
    wire[31:0] alu_res;
    wire beqout;
    wire[31:0] alu_out;
    
    
    pc mips_pc(
        .rst(rst),
        .clk(clk),
        .pc_en(pc_w),
        .npc(npc),
        .pc(pc)
    );
    
    ram mips_ram (
      .clka(clk),    // input wire clka
      .wea(ram_w),      // input wire [0 : 0] wea
      .addra(ram_addr[14:2]),  // input wire [12 : 0] addra
      .dina(ram_data_in),    // input wire [31 : 0] dina
      .douta(ram_data_out)  // output wire [31 : 0] douta
    );
    
    sequential_reg32 mips_ir(
        .clk(clk),
        .en(ir_w),
        .in(ram_data_out),
        ._reg(inst)
    );
    
    sequential_reg32 mips_dr(
        .clk(clk),
        .en(1), // always enable
        .in(ram_data_out),
        ._reg(dr_out)
    );
    
    regfile rf(
        .clk(clk),
        .rs1_in(rs),
        .rs2_in(rt),
        .rd_in(rd),
        .w_en(rf_w),
        .w_data(dr_out),
        .rs1_o(rd1),
        .rs2_o(rd2)
    );
    
    sequential_reg32 rd1r(
        .clk(clk),
        .en(1),
        .in(rd1),
        ._reg(A)
    );
    
    sequential_reg32 rd2r(
        .clk(clk),
        .en(1),
        .in(rd2),
        ._reg(B)
    );
    
    alu mips_alu(
        .A(A),
        .B(B),
        .alu_ctrl(alu_ctrl),
        .s(sa),
        .C(alu_res),
        .beqout(beqout)
    );
    
    sequential_reg32 aluresr(
        .clk(clk),
        .en(1),
        .in(alu_res),
        ._reg(alu_out)
    );
    
    assign pc = alu_res;
    
endmodule
