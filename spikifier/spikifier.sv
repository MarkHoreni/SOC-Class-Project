`timescale 1ps/1ps

`ifndef NOISE_FILE
	`define NOISE_FILE "noise.txt"
`endif

module spikifier(v_sig, v_ref, clk, q);
	parameter real G = 0.005;
	parameter real COMP_DELAY = 2000;
	parameter real COMP_OFFSET = 450e-6;

	input real v_sig, v_ref;
	input clk;
	output reg q;

	real state;
	real input_noise, delay_noise, offset_noise;
	int q_delay;
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
			q_delay <= delay_noise + COMP_DELAY;

			q <= #q_delay 1;
			state <= #COMP_DELAY 0;
		end
	end

	always @(negedge clk) begin
		q <= 0;
		state <= 0;
	end

endmodule
