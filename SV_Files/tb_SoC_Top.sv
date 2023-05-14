`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module tb_SoC_Top;

  // Inputs
  reg clk;
  reg reset;
  reg risc_v_read;
  reg risc_v_write;
  reg [9:0] risc_v_addr;
  reg [31:0] risc_v_data_in;

  // Outputs
  wire [15:0] risc_v_data_out;
  wire [15:0] spike_detected;

  // Instantiate the SoC_Top module
  SoC_Top dut (
    .clk(clk),
    .reset(reset),
    .risc_v_read(risc_v_read),
    .risc_v_write(risc_v_write),
    .risc_v_addr(risc_v_addr),
    .risc_v_data_in(risc_v_data_in),
    .risc_v_data_out(risc_v_data_out),
    .spike_detected(spike_detected)
  );

  // Clock generation
  always #2.5 clk = ~clk;  // Adjusted delay to achieve 160 MHz frequency

  // Initialize inputs
  initial begin
    clk = 0;
    reset = 1;
    risc_v_read = 0;
    risc_v_write = 0;
    risc_v_addr = 0;
    risc_v_data_in = 32'h12345678;

    // Release reset after 10 clock cycles
    #40 reset = 0;  // Adjusted delay to match the new clock frequency

    // Perform read and write operations
    #6 risc_v_read = 1;
    #6 risc_v_read = 0;
    #6 risc_v_write = 1;
    #6 risc_v_write = 0;

    // Simulate data input changes
    #6 risc_v_data_in = 32'h87654321;
    #6 risc_v_data_in = 32'hABCDEFF0;

    // Finish simulation
    #40 $finish;  // Adjusted delay to match the new clock frequency
  end

  // Display outputs
  always @(posedge clk) begin
    $display("risc_v_data_out = %h", risc_v_data_out);
    $display("spike_detected = %h", spike_detected);
  end

endmodule

