`timescale 1ns / 1ps

module debug(
	input clk,
	input [7:0] INTR,
	output [7:0] LED
	);

reg [22:0] counter [7:0] ;
reg state [7:0];
parameter blink_off=1'b0, blink_on=1'b1;

genvar i;
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
			if (counter[i] == 0 && INTR[i] == 1) begin
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
