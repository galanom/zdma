`timescale 1ns / 1ps

module debugger(
	input clk,
	input [7:0] dma_intr,
	input [7:0] core_debug,
	input [1:0] func,
	output reg [7:0] LED
	);

parameter blink_rate=21;
reg [1:0] ev = 2'b00;
reg led_state [7:0];
reg [blink_rate:0] counter [7:0];
parameter blink_off=1'b0, blink_on=1'b1;

genvar i;

generate for (i = 0; i < 8; i = i + 1)
always @(*)
	case (func)
	2'b00:
			LED[i] = led_state[7-i];
	2'b01:
			LED[i] = core_debug[i];
	default:
			LED[i] = i % 2;
	endcase		
endgenerate
		
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
