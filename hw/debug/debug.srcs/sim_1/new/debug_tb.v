`timescale 1ns / 1ps


module debug_tb(

    );
    
    reg [7:0] dma_intr_in = 0;
    reg clk_in = 0;
    wire [7:0] led_out;
    debug uut (
    	.dma_intr(dma_intr_in),
    	.func(1),
    	.clk(clk_in),
    	.LED(led_out)
    );
    
    always clk_in = #1 ~clk_in;

    initial begin
    	#20 dma_intr_in = 8'b0001_0000;
    	#5	dma_intr_in = 8'b0000_0000;
    	#40	dma_intr_in = 8'b0000_0100;
    	#5	dma_intr_in = 8'b0000_0000;
    	#10;
    end
endmodule
