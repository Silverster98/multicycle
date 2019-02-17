`timescale 1ns / 1ps

module testbench();
    reg clk;
    reg rst;
    
    mips my_mips(
        .clk(clk),
        .rst(rst)
    );
    initial begin
        clk = 0;
        rst = 1;
        #17 rst = 0;
        #120;
        $stop;
    end
    
    always 
        #5 clk = ~clk;
endmodule
