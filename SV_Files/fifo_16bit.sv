module fifo_16bit #(
    parameter int FIFO_DEPTH = 8
) (
    input logic clk,
    input logic reset,

    // Write Interface
    input logic wr_en,
    input logic [15:0] wr_data,

    // Read Interface
    input logic rd_en,
    output logic [15:0] rd_data,

    // Status signals
    output logic empty,
    output logic full
);

    // Register file memory
    logic [15:0] rf_array [0:FIFO_DEPTH-1];
    integer i;

    // Read and write pointers
    logic [$clog2(FIFO_DEPTH)-1:0] rd_ptr = 0;
    logic [$clog2(FIFO_DEPTH)-1:0] wr_ptr = 0;

    // Status flags
    logic empty_flag = 1;
    logic full_flag = 0;

    // Write logic
    always_ff @(posedge clk) begin
        if (reset) begin
            wr_ptr <= 0;
        end else if (wr_en && !full_flag) begin
            rf_array[wr_ptr] <= wr_data;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read logic
    assign rd_data = rf_array[rd_ptr];

    always_ff @(posedge clk) begin
        if (reset) begin
            rd_ptr <= 0;
        end else if (rd_en && !empty_flag) begin
            rd_ptr <= rd_ptr + 1;
        end
    end

    // Update empty and full flags
    always_ff @(posedge clk) begin
        if (reset) begin
            empty_flag <= 1;
            full_flag <= 0;
        end else begin
            empty_flag <= (rd_ptr == wr_ptr);
            full_flag <= (rd_ptr == (wr_ptr + 1) % FIFO_DEPTH);
        end
    end

    // Assign status signals
    assign empty = empty_flag;
    assign full = full_flag;

endmodule

