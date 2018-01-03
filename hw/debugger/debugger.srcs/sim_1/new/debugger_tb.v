`timescale 1ns / 1ps


module debugger_tb(

    );
    
    reg [15:0] dma_intr_in = 0;
    reg clk_in = 0;
    wire [7:0] led_out;
    debugger uut (
    	.dma_intr(dma_intr_in),
    	.select(1),
    	.clk(clk_in),
    	.LED(led_out)
    );
    
    always clk_in = #1 ~clk_in;

    initial begin
    	#20 dma_intr_in = 16'b1000_0000_0001_0000;
    	#5	dma_intr_in = 16'b0000_0000_0000_0000;
    	#40	dma_intr_in = 16'b0000_0000_0000_0100;
    	#5	dma_intr_in = 16'b0000_0000_0000_0000;
    	#120;
    end
endmodule
