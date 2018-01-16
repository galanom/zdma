`timescale 1ns / 1ps

module debugger (
	input clk,
	input [intr_width-1:0] intr,
	input [2:0] sel,
	output reg [7:0] LED
	);

parameter blink_rate = 18;
parameter intr_width = 16;

reg [1:0] ev = 2'b00;
reg [blink_rate:0] counter [7:0];
reg [63:0] intr_reg = 64'h0000_0000_0000_0000;
parameter blink_off=1'b0, blink_on=1'b1;

genvar i;

always @(posedge clk)
	intr_reg[intr_width-1:0] <= intr;

generate for (i = 0; i < 8; i = i + 1)
begin
	initial begin
		LED[i] = 0;
		counter[i] = 0;
	end
	
	always @(posedge clk) 
	begin
		case(LED[i])
		blink_off:
			if (counter[i] == 0 && intr_reg[i + (sel << 3)] == 1) begin
				counter[i] <= counter[i] + 1;
				LED[i] <= blink_on;
			end else if (counter[i] == 0) begin
				counter[i] <= counter[i];
				LED[i] <= blink_off;
			end else begin
				counter[i] <= counter[i] + 1;
				LED[i] <= blink_off;				
			end
		
		blink_on:
		begin
			counter[i] <= counter[i] + 1;
			if (counter[i] == 0)
				LED[i] <= blink_off;
			else
				LED[i] <= blink_on;
		end	
		endcase	
	end
end
endgenerate

endmodule
