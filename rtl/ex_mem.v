module ex_mem (
    input wire clk,
    input wire reset,

    // Data Inputs
    input wire [31:0] alu_result_in,
    input wire [31:0] write_data_in,
    input wire [4:0] rd_in,
    input wire zero_in,  // For branch decisions
    input wire [31:0] pc_branch_in,  // Branch target

    // Control Inputs
    input wire RegWrite_in,
    input wire MemRead_in,
    input wire MemWrite_in,
    input wire MemToReg_in,
    input wire Branch_in,

    // Data Outputs
    output reg [31:0] alu_result_out,
    output reg [31:0] write_data_out,
    output reg [4:0] rd_out,
    output reg zero_out,
    output reg [31:0] pc_branch_out,

    // Control Outputs
    output reg RegWrite_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg MemToReg_out,
    output reg Branch_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        alu_result_out <= 32'b0;
        write_data_out <= 32'b0;
        rd_out         <= 5'b0;
        zero_out       <= 1'b0;
        pc_branch_out  <= 32'b0;

        RegWrite_out   <= 1'b0;
        MemRead_out    <= 1'b0;
        MemWrite_out   <= 1'b0;
        MemToReg_out   <= 1'b0;
        Branch_out     <= 1'b0;
    end else begin
        alu_result_out <= alu_result_in;
        write_data_out <= write_data_in;
        rd_out         <= rd_in;
        zero_out       <= zero_in;
        pc_branch_out  <= pc_branch_in;

        RegWrite_out   <= RegWrite_in;
        MemRead_out    <= MemRead_in;
        MemWrite_out   <= MemWrite_in;
        MemToReg_out   <= MemToReg_in;
        Branch_out     <= Branch_in;
    end
end

endmodule
