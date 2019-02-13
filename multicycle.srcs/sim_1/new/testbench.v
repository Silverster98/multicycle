`timescale 1ns / 1ps

module testbench();
    reg clk;
//    reg rst;
//    reg[15:0] imm16;
//    reg[25:0] imm26;
//    reg if_en;
//    reg[1:0] npc_sel;
    
//    wire[31:0] inst;
//    wire[31:0] pc_4;
    
//    inst_fetch MIPS_IF(
//        .rst(rst),
//        .clk(clk),
//        .if_en(if_en),
//        .imm16(imm16),
//        .imm26(imm26),
//        .npc_sel(npc_sel),
//        .pc_4(pc_4),  
//        .inst(inst)
//    );
    
//    initial begin
//        clk = 0;
//        rst = 1;
//        if_en = 1;
//        imm16 = 16'h0000;
//        imm26 = 26'h0000000;
//        npc_sel = 2'b00;
        
//        #15 rst = 0;
        
//        #15 if_en = 0;
//        #40 if_en = 1;
//        #20 if_en = 0;
//        #40 if_en = 1;
//        #20 if_en = 0;
//        #40 if_en = 1;
//        #20 if_en = 0;
//        #40 if_en = 1;
//        #20 if_en = 0;
//        $stop; 
//    end
    wire[31:0] out;
    reg en;
    reg[31:0] in;
    sequential_reg32 IR(
        .clk(clk),
        .en(en),
        .in(in),
        ._reg(out)
    );
    
    initial begin
        clk = 0;
        in = 32'h00001111;
        #15 en = 1;
        #20 in = 32'h11110000;
        #20 en = 0;
        in = 32'h11000011;
        #20;
        $stop;
    end
    
    always 
        #10 clk = ~clk;
endmodule
