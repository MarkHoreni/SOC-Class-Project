`timescale 1ns / 1ps

module tb_fifo_16bit;

    // Clock and reset signals
    reg clk;
    reg reset;

    // Instantiate the DUT
    fifo_16bit #(
        .FIFO_DEPTH(8)
    ) dut (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .empty(empty),
        .full(full)
    );

    // Define the testbench signals
    wire wr_en;
    wire [15:0] wr_data;
    wire rd_en;
    wire [15:0] rd_data;
    wire empty;
    wire full;

    // Write and read control logic
    reg wr_en_reg = 0;
    reg rd_en_reg = 0;
    reg [3:0] count = 0;

    always_ff @(posedge clk) begin
        if (reset) begin
            wr_en_reg <= 0;
            rd_en_reg <= 0;
            count <= 0;
        end else begin
            if (!full && !wr_en_reg) begin
                wr_en_reg <= 1;
            end else begin
                wr_en_reg <= 0;
            end

            if (!empty && !rd_en_reg) begin
                rd_en_reg <= 1;
            end else begin
                rd_en_reg <= 0;
            end

            if (wr_en_reg) begin
                count <= count + 1;
            end
        end
    end

    // Write data generation (from RF array)
    assign wr_data = count;

    // Read data consumption (to PE)
    always_ff @(posedge clk) begin
        if (rd_en_reg) begin
            // Consume rd_data here and perform the required operation in PE
            $display("Read Data: %0h", rd_data);
        end
    end

    // Assign write and read enable signals
    assign wr_en = wr_en_reg;
    assign rd_en = rd_en_reg;

    // Clock generation
    always #3.125 clk = ~clk; // 160 MHz clock (6.25 ns period)

    // Initial block for testbench stimulus
    initial begin
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
        #100;
        $finish;
    end

endmodule

