`timescale 1ns / 1ps

module mips(
    input wire clk,
    input wire rst
    );
    
    wire[31:0] npc;
    wire[31:0] pc;
    wire pc_w;
    wire sel_pc_addr_mux;
    
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
    
    
    wire[31:0] data;
    
    wire sel_mem_to_reg;
    wire[31:0] reg_wdata;
    wire sel_reg_dst;
    wire[4:0] reg_dst;
    
    wire rf_w;
    wire[31:0] rd1,rd2;
    
    wire[31:0] ext16_32;
    wire[31:0] left2;
    
    wire[31:0] A,B;
    wire sel_alu_srcA;
    wire[31:0] alu_srcA;
    wire[1:0] sel_alu_srcB;
    wire[31:0] alu_srcB;
    
    wire[2:0]  alu_ctrl;
    wire[31:0] alu_res;
    wire beqout;
    wire[31:0] alu_out;
    
    wire sel_npc;
    
    // control unit
    cu mips_cu(
        .clk(clk),
        .rst(rst),
        .beqout(beqout),
        .op(op),
        .func(func),
        .pc_w(pc_w),
        .sel_pc_addr_mux(sel_pc_addr_mux),
        .ram_w(ram_w),
        .ir_w(ir_w),
        .sel_reg_dst(sel_reg_dst),
        .sel_mem_to_reg(sel_mem_to_reg),
        .rf_w(rf_w),
        .sel_alu_srcA(sel_alu_srcA),
        .sel_alu_srcB(sel_alu_srcB),
        .alu_ctrl(alu_ctrl),
        .sel_npc(sel_npc)
    );
    
    // instruction fetch
    
    pc mips_pc(
        .rst(rst),
        .clk(clk),
        .pc_en(pc_w),
        .npc(npc),
        .pc(pc)
    );
    
    mux_2_32 pc_addr_mux(
        .in1(pc),
        .in2(alu_out),
        .sel(sel_pc_addr_mux),
        .out(ram_addr)
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
        ._reg(data)
    );
    
    // decode instruction
    
    mux_2_5 reg_dst_mux(
        .in1(rt),
        .in2(rd),
        .sel(sel_reg_dst),
        .out(reg_dst)
    );
    
    mux_2_32 mem_to_reg_mux(
        .in1(data),
        .in2(alu_out),
        .sel(sel_mem_to_reg),
        .out(reg_wdata)
    );
    
    regfile rf(
        .clk(clk),
        .rs1_in(rs),
        .rs2_in(rt),
        .rd_in(reg_dst),
        .w_en(rf_w),
        .w_data(reg_wdata),
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
    
    // execute
    
    mux_2_32 alu_srcA_mux(
        .in1(pc),
        .in2(A),
        .sel(sel_alu_srcA),
        .out(alu_srcA)
    );
    
    sign_extend_16 extend_imm16(
        .imm16(imm16),
        .output32(ext16_32)
    );
    
    assign left2 = {ext16_32[29:0], 2'b00};
    
    mux_4_32 alu_srcB_mux(
        .in1(B),
        .in2(32'h00000004),
        .in3(ext16_32),
        .in4(left2),
        .sel(sel_alu_srcB),
        .out(alu_srcB)
    );
    
    alu mips_alu(
        .A(alu_srcA),
        .B(alu_srcB),
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
    
    // select npc
    
    mux_2_32 npc_mux(
        .in1(alu_res),
        .in2(alu_out),
        .sel(sel_npc),
        .out(npc)
    );
    
endmodule
