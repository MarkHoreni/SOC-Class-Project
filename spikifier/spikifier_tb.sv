`timescale 1ps/1ps

`ifndef SIG_FILE
	`define SIG_FILE "pos_sine.txt"
`endif

module spikifier_tb;
	real v_sig;
	real v_ref;
	reg clk;

	wire q;

	int fd;
	int status;

	initial begin
		fd = $fopen(`SIG_FILE, "r");
		clk = 0;
		v_sig = 0;
		v_ref = 0.11;
	end

	always
		#5000 clk = ~clk;

	always
		#10 status = $fscanf(fd, "%f", v_sig);

	always
		#100000 $stop;

	spikifier dut (.*);

endmodule
