`timescale 1ns / 1ps

module debug(
	input clk,
	input [7:0] dma_intr,
	input [3:0] core_intr,
	output [7:0] LED
	);

parameter blink_rate=22;

reg [blink_rate:0] counter [7:0] ;
reg state [7:0];
parameter blink_off=1'b0, blink_on=1'b1;
wire [7:0] data;

genvar i;
/*generate for (i = 0; i < 4; i = i + 1)
	assign	data[7-i] = dma_intr[i] || dma_intr[i+1],
			data[3-i] = core_intr[i];
endgenerate*/

assign // LEDs from left to right (LED7 to LED0)
	data[7] = dma_intr[0] | dma_intr[1],
	data[6] = dma_intr[2] | dma_intr[3],
	data[5] = dma_intr[4] | dma_intr[5],
	data[4] = dma_intr[6] | dma_intr[7],
	data[3] = core_intr[0],
	data[2] = core_intr[1],
	data[1] = core_intr[2],
	data[0] = core_intr[3];


generate for (i = 0; i < 8; i = i + 1)
begin
	initial begin
		state[i] = 0;
		counter[i] = 0;
	end
	
	always @(posedge clk) 
	begin
		case(state[i])
		blink_off:
			if (counter[i] == 0 && data[i] == 1) begin
				counter[i] <= counter[i] + 1;
				state[i] <= blink_on;
			end else if (counter[i] == 0) begin
				counter[i] <= counter[i];
				state[i] <= blink_off;
			end else begin
				counter[i] <= counter[i] + 1;
				state[i] <= blink_off;				
			end
		
		blink_on:
		begin
			counter[i] <= counter[i] + 1;
			if (counter[i] == 0)
				state[i] <= blink_off;
			else
				state[i] <= blink_on;
		end	
		endcase	
	end
	
	assign LED[i] = state[i];
		
/*	always @(state[i])
	begin
		case (state[i])
		blink_on:
			LED[i] = 1;
		blink_off:
			LED[i] = 0;
		endcase
	end*/
end
endgenerate

endmodule
