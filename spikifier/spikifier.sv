`timescale 1ps/1ps

`ifndef NOISE_FILE
	`define NOISE_FILE "noise.txt"
`endif

module spikifier(v_sig, v_ref, clk, q);
	parameter real G = 0.0005;
	parameter real COMP_DELAY = 4e-9;
	parameter real COMP_OFFSET = 450e-6;

	input real v_sig, v_ref;
	input clk;
	output reg q;

	real state, input_noise, delay_noise, offset_noise;
	int status, fd;

	initial begin
		fd = $fopen(`NOISE_FILE, "r");
		q = 0;
	end

	always @(v_sig) begin
		while (status != 3) begin
			status = $fscanf(fd, "%f,%f,%f", input_noise, delay_noise, offset_noise);
		end

		status = 0;

		if (~clk) begin
			state <= state + ((v_sig + input_noise) * G);
		end
		else begin
			state <= 0;
		end
	end

	always @(posedge clk) begin
		if (state > (v_ref + offset_noise)) begin
			#(delay_noise + COMP_DELAY)
			q <= 1;
			state <= 0;
		end
	end

	always @(negedge clk) begin
		q <= 0;
		state <= 0;
	end
			
endmodule
