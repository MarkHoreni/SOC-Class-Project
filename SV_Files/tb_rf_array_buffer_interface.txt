`timescale 1ns/1ns

module tb_rf_array_buffer_interface;

localparam integer ADDR_WIDTH = 10;
localparam integer DATA_WIDTH = 32;
localparam real CLOCK_PERIOD = 6.25; // 160 MHz clock, period = 6.25 ns
localparam integer NUM_TEST_CYCLES = 100 / (CLOCK_PERIOD / 1000); // 100 ns duration
reg [ADDR_WIDTH-1:0] i;

wire [DATA_WIDTH-1:0] risc_v_data_out;
reg [ADDR_WIDTH-1:0] risc_v_addr; // Changed from wire to reg
reg [DATA_WIDTH-1:0] risc_v_data_in; // Changed from wire to reg
reg clk;
reg reset; // Changed from wire to reg
reg risc_v_read; // Changed from wire to reg
reg risc_v_write; // Changed from wire to reg

// Instantiate the rf_array_buffer_interface module
rf_array_buffer_interface #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) rf_array_buffer_interface_inst (
    .clk(clk),
    .reset(reset),
    .risc_v_read(risc_v_read),
    .risc_v_write(risc_v_write),
    .risc_v_addr(risc_v_addr),
    .risc_v_data_in(risc_v_data_in),
    .risc_v_data_out(risc_v_data_out)
);

// Clock generation
always begin
    # (CLOCK_PERIOD / 2) clk = ~clk;
end

// Testbench stimulus
initial begin
    // Initialize signals
    clk = 0;
    reset = 1;
    risc_v_read = 0;
    risc_v_write = 0;
    risc_v_addr = 0;
    risc_v_data_in = 0;

    // Apply reset
    # (CLOCK_PERIOD / 2) reset = 0;

    // Load 64 B of data from the RF array buffer using a FIFO-like approach
    for (i = 0; i < NUM_TEST_CYCLES; i = i + 1) begin
        #1 risc_v_read = 1;
        #1 risc_v_addr = i % (1 << ADDR_WIDTH);
        #1;
    end

    // De-assert read signal
    #1 risc_v_read = 0;

    // End the simulation
    #1 $finish;
end

endmodule