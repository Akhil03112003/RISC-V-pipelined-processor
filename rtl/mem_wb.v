module mem_wb (
    input wire clk,
    input wire reset,

    // Data Inputs
    input wire [31:0] mem_data_in,
    input wire [31:0] alu_result_in,
    input wire [4:0] rd_in,

    // Control Inputs
    input wire RegWrite_in,
    input wire MemToReg_in,

    // Data Outputs
    output reg [31:0] mem_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0] rd_out,

    // Control Outputs
    output reg RegWrite_out,
    output reg MemToReg_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        mem_data_out   <= 32'b0;
        alu_result_out <= 32'b0;
        rd_out         <= 5'b0;

        RegWrite_out   <= 1'b0;
        MemToReg_out   <= 1'b0;
    end else begin
        mem_data_out   <= mem_data_in;
        alu_result_out <= alu_result_in;
        rd_out         <= rd_in;

        RegWrite_out   <= RegWrite_in;
        MemToReg_out   <= MemToReg_in;
    end
end

endmodule
