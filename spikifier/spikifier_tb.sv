`timescale 1ps/1ps

module spikifier_tb;
	real v_sig;
	real v_ref;
	reg clk;

	wire q;

	int fd;
	int status;

	initial begin
		fd = $fopen("sine.txt", "r");
		clk = 0;
		v_sig = 0;
	end

	always 
		#5000 clk = ~clk;
	
	always 
		#10 status = $fscanf(fd, "%f", v_sig);

	spikifier dut (.*);

endmodule
