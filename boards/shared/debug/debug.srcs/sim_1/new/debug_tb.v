`timescale 1ns / 1ps


module debug_tb(

    );
    
    reg [7:0] intr_in = 0;
    reg clk_in = 0;
    wire [7:0] led_out;
    debug uut (
    	.INTR(intr_in),
    	.clk(clk_in),
    	.LED(led_out)
    );
    
    always clk_in = #1 ~clk_in;

    initial begin
    	#5	intr_in = 8'b0000_0001;
    	#5	intr_in = 8'b0000_0000;
    	#20 intr_in = 8'b0001_0000;
    	#5	intr_in = 8'b0000_0000;
    	#40	intr_in = 8'b0000_0100;
    	#5	intr_in = 8'b0000_0000;
    	#10;
    end
endmodule
