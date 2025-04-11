module id_ex (
    input wire clk,
    input wire reset,

    // Data inputs
    input wire [31:0] pc_in,
    input wire [31:0] read_data1_in,
    input wire [31:0] read_data2_in,
    input wire [31:0] imm_in,
    input wire [4:0] rs1_in,
    input wire [4:0] rs2_in,
    input wire [4:0] rd_in,
    input wire [2:0] funct3_in,
    input wire [6:0] funct7_in,

    // Control signals in
    input wire RegWrite_in,
    input wire MemRead_in,
    input wire MemWrite_in,
    input wire Branch_in,
    input wire [3:0] ALUOp_in,  // Changed from [1:0] to [3:0]
    input wire ALUSrc_in,
    input wire MemToReg_in,

    // Outputs
    output reg [31:0] pc_out,
    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,
    output reg [31:0] imm_out,
    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out,
    output reg [2:0] funct3_out,
    output reg [6:0] funct7_out,

    // Control signals out
    output reg RegWrite_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg Branch_out,
    output reg [3:0] ALUOp_out,  // Changed from [1:0] to [3:0]
    output reg ALUSrc_out,
    output reg MemToReg_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc_out <= 32'b0;
        read_data1_out <= 32'b0;
        read_data2_out <= 32'b0;
        imm_out <= 32'b0;
        rs1_out <= 5'b0;
        rs2_out <= 5'b0;
        rd_out <= 5'b0;
        funct3_out <= 3'b0;
        funct7_out <= 7'b0;

        RegWrite_out <= 0;
        MemRead_out <= 0;
        MemWrite_out <= 0;
        Branch_out <= 0;
        ALUOp_out <= 4'b0;  // Changed from 2'b0 to 4'b0
        ALUSrc_out <= 0;
        MemToReg_out <= 0;
    end else begin
        pc_out <= pc_in;
        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;
        imm_out <= imm_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        rd_out <= rd_in;
        funct3_out <= funct3_in;
        funct7_out <= funct7_in;

        RegWrite_out <= RegWrite_in;
        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        Branch_out <= Branch_in;
        ALUOp_out <= ALUOp_in;
        ALUSrc_out <= ALUSrc_in;
        MemToReg_out <= MemToReg_in;
    end
end

endmodule
