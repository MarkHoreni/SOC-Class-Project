//`timescale 1ns / 1ps

module rf_array_buffer_interface #(
    parameter integer ADDR_WIDTH = 10,
    parameter integer DATA_WIDTH = 32
) (
    input wire clk,
    input wire reset,

    // RISC-V core interface
    input wire risc_v_read,
    input wire risc_v_write,
    input wire [ADDR_WIDTH-1:0] risc_v_addr,
    input wire [DATA_WIDTH-1:0] risc_v_data_in,
    output reg [DATA_WIDTH-1:0] risc_v_data_out
);

    // External RF array buffer memory (Assuming a simple memory array)
    reg [DATA_WIDTH-1:0] rf_array_buffer [0:(1 << ADDR_WIDTH) - 1];

    // Address decoder
    reg [ADDR_WIDTH-1:0] selected_address;

    always @* begin
        selected_address = risc_v_addr;
    end

    // Read and write operations
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            risc_v_data_out <= 0;
        end else begin
            if (risc_v_read) begin
                risc_v_data_out <= rf_array_buffer[selected_address];
            end
            if (risc_v_write) begin
                rf_array_buffer[selected_address] <= risc_v_data_in;
            end
        end
    end

endmodule

