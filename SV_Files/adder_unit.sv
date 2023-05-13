module adder_unit #(
    parameter integer ADDR_WIDTH = 6,
    parameter integer DATA_WIDTH = 16,
    parameter integer MEM_DEPTH = 64 / (DATA_WIDTH / 8),
    parameter integer THRESHOLD = 16'd1000
) (
    input wire clk,
    input wire reset,

    // RISC-V core interface
    input wire risc_v_read,
    input wire risc_v_write,
    input wire [ADDR_WIDTH-1:0] risc_v_addr,
    input wire [DATA_WIDTH-1:0] risc_v_data_in,
    output reg [DATA_WIDTH-1:0] risc_v_data_out,
    
    // Comparator output
    output wire spike_detected
);

    // 64 B SRAM weight memory
    reg [DATA_WIDTH-1:0] weight_mem [0:MEM_DEPTH-1];

    // 16-bit SRAM membrane potential
    reg [DATA_WIDTH-1:0] membrane_potential;

    // Adder unit
    reg [DATA_WIDTH-1:0] adder_output;

    always_comb begin
        adder_output = membrane_potential + weight_mem[risc_v_addr[ADDR_WIDTH-1:0]];
    end

    // Comparator
    assign spike_detected = (adder_output >= THRESHOLD) ? 1'b1 : 1'b0;

    // Read and write operations
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            risc_v_data_out <= 0;
            membrane_potential <= 0;
        end else begin
            if (risc_v_read) begin
                risc_v_data_out <= adder_output;
            end
            if (risc_v_write) begin
                // Write to weight memory or membrane potential
                if (risc_v_addr[ADDR_WIDTH-1]) begin
                    membrane_potential <= risc_v_data_in;
                end else begin
                    weight_mem[risc_v_addr[ADDR_WIDTH-2:0]] <= risc_v_data_in;
                end
            end
        end
    end

endmodule