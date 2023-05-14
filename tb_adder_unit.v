`timescale 1ns/1ps

module tb_adder_unit;

    localparam integer ADDR_WIDTH = 6;
    localparam integer DATA_WIDTH = 16;
    localparam integer CLOCK_PERIOD = 200; // 5 MHz clock, period = 200 ns
    localparam integer NUM_TEST_CYCLES = 100 / (CLOCK_PERIOD / 1000); // 100 ns duration
    localparam integer THRESHOLD = 16'd1000;
    
    reg clk;
    reg reset;
    reg risc_v_read;
    reg risc_v_write;
    reg [ADDR_WIDTH-1:0] risc_v_addr;
    reg [DATA_WIDTH-1:0] risc_v_data_in;
    wire [DATA_WIDTH-1:0] risc_v_data_out;
    wire spike_detected;
    reg [ADDR_WIDTH-1:0] i;

    // Instantiate the adder_unit module
    adder_unit #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .THRESHOLD(THRESHOLD)
    ) adder_unit_inst (
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
        # CLOCK_PERIOD reset = 0;

        // Test write and read operations for weight memory and membrane potential
        for (i = 0; i < NUM_TEST_CYCLES; i = 1 + i) begin
            risc_v_write <= 1;
            risc_v_addr <= i % (1 << ADDR_WIDTH);
            risc_v_data_in <= i * 3;
            # CLOCK_PERIOD;

            risc_v_write <= 0;
            risc_v_read <= 1;
            # CLOCK_PERIOD;
            risc_v_read <= 0;

            // Check for spike
            if (spike_detected) begin
                $display("Spike detected at time: %0dns", $time);
            end
        end

        // End the simulation
        $finish;
    end

endmodule
