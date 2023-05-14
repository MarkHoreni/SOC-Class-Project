module SoC_Top (
    input wire clk,
    input wire reset,
    input wire risc_v_read,
    input wire risc_v_write,
    input wire [9:0] risc_v_addr,
    input wire [31:0] risc_v_data_in,
    output wire [15:0] risc_v_data_out,
    output wire [15:0] spike_detected
);

    // Buffer to hold data read from RF array
    reg [15:0] buffer_data;

    // Instantiate rf_array_buffer_interface
    rf_array_buffer_interface #(
        .ADDR_WIDTH(10),
        .DATA_WIDTH(32)
    ) rf_buffer (
        .clk(clk),
        .reset(reset),
        .risc_v_read(risc_v_read),
        .risc_v_write(risc_v_write),
        .risc_v_addr(risc_v_addr),
        .risc_v_data_in(risc_v_data_in),
        .risc_v_data_out(buffer_data)
    );

    // Instantiate fifo_16bit
    fifo_16bit #(
        .FIFO_DEPTH(8)
    ) fifo (
        .clk(clk),
        .reset(reset),
        .wr_en(risc_v_read),
        .wr_data(buffer_data),
        .rd_en(risc_v_write),
        .rd_data(risc_v_data_out)
        // Not connecting status signals for simplicity
    );

    // Instantiate 16 adder_units
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin: adder_gen
            adder_unit #(
                .ADDR_WIDTH(6),
                .DATA_WIDTH(16),
                .MEM_DEPTH(64 / (16 / 8)),
                .THRESHOLD(16'd1000)
            ) adder (
                .clk(clk),
                .reset(reset),
                .risc_v_read(1'b0), // Not connecting for simplicity
                .risc_v_write(1'b1), // Always write to adder
                .risc_v_addr(risc_v_addr[5:0]), // Assuming lower 6 bits of address are used
                .risc_v_data_in(risc_v_data_out),
                .risc_v_data_out(), // Not connecting for simplicity
                .spike_detected(spike_detected[i])
            );
        end
    endgenerate

endmodule
