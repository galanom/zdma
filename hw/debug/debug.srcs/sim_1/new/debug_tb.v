`timescale 1ns / 1ps


module debug_tb(

    );
    
    reg [7:0] dma_intr_in = 0;
    reg [3:0] c0 = 0, c1 = 0, c2 = 0, c3 = 0;
    reg clk_in = 0;
    wire [7:0] led_out;
    reg e0 = 0, e1 = 0;
    debug uut (
    	.dma_intr(dma_intr_in),
    	.event0(e0),
    	.event1(e1),
    	.core0(c0),
    	.core1(c1),
    	.core2(c2),
    	.core3(c3),
    	.core_select(0),
    	.clk(clk_in),
    	.LED(led_out)
    );
    
    always clk_in = #1 ~clk_in;

    initial begin
    	#5	e0 = 8'b0000_0001;
    	#5	e0 = 8'b0000_0000;
    		c0 = 4'b0001; 
    	#20 dma_intr_in = 8'b0001_0000;
    		c0 = 4'b0000;
    	#5	dma_intr_in = 8'b0000_0000;
    	#40	dma_intr_in = 8'b0000_0100;
    	#5	dma_intr_in = 8'b0000_0000;
    	#10;
    end
endmodule
