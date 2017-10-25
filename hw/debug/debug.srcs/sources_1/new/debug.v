`timescale 1ns / 1ps

module debug(
	input clk,
	input [7:0] dma_intr,
	input event0,
	input event1,
	input [3:0] core0, core1, core2, core3,
	input [1:0] core_select,
	output [7:0] LED
	);

parameter blink_rate=21;
reg [1:0] ev = 2'b00;
reg led_state [7:0];
reg [blink_rate:0] counter [7:0];
parameter blink_off=1'b0, blink_on=1'b1;

always @(posedge clk)
begin
	if (event0)
		ev[0] <= 1;
	else 
		ev[0] <= ev[0];
		
	if (event1)
		ev[1] <= 1;
	else
		ev[1] <= ev[1];
end

assign 
	LED[7:6] = 
		(core_select == 0) ? {dma_intr[0], dma_intr[1]} :
		(core_select == 1) ? {dma_intr[2], dma_intr[3]} :
		(core_select == 2) ? {dma_intr[4], dma_intr[5]} :
							 {dma_intr[6], dma_intr[7]},
	LED[5] = ev[0],
	LED[4] = ev[1];

assign LED[3:0] =
	(core_select == 0) ? core0 :
	(core_select == 1) ? core1 :
	(core_select == 2) ? core2 : core3;
		
genvar i;
generate for (i = 0; i < 8; i = i + 1)
begin
	initial begin
		led_state[i] = 0;
		counter[i] = 0;
	end
	
	always @(posedge clk) 
	begin
		case(led_state[i])
		blink_off:
			if (counter[i] == 0 && dma_intr[i] == 1) begin
				counter[i] <= counter[i] + 1;
				led_state[i] <= blink_on;
			end else if (counter[i] == 0) begin
				counter[i] <= counter[i];
				led_state[i] <= blink_off;
			end else begin
				counter[i] <= counter[i] + 1;
				led_state[i] <= blink_off;				
			end
		
		blink_on:
		begin
			counter[i] <= counter[i] + 1;
			if (counter[i] == 0)
				led_state[i] <= blink_off;
			else
				led_state[i] <= blink_on;
		end	
		endcase	
	end
end
endgenerate

endmodule
