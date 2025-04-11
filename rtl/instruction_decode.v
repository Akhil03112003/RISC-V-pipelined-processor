module instruction_decode(
    input [31:0] instruction,   // 32-bit instruction
    output reg [4:0] rs1,       // Source register 1
    output reg [4:0] rs2,       // Source register 2
    output reg [4:0] rd,        // Destination register
    output reg [31:0] imm,      // Immediate value
    output reg [6:0] opcode,    // Opcode field
    output reg [2:0] funct3,    // funct3 field
    output reg [6:0] funct7     // funct7 field
);

    always @(*) begin
        // Default values for outputs
        rs1 = 5'b0;
        rs2 = 5'b0;
        rd = 5'b0;
        imm = 32'b0;
        opcode = 7'b0;
        funct3 = 3'b0;
        funct7 = 7'b0;

        // Extract instruction fields
        opcode = instruction[6:0];
        rd = instruction[11:7];
        funct3 = instruction[14:12];
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        funct7 = instruction[31:25];

        // Immediate value computation based on instruction type
        case (opcode)
            7'b0010011, // I-type (e.g., ADDI, ANDI, ORI)
            7'b0000011: // Load (e.g., LW)
                imm = {{20{instruction[31]}}, instruction[31:20]};

            7'b0100011: // Store (e.g., SW)
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            7'b1100011: // Branch (e.g., BEQ, BNE)
                imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

            7'b1101111: // Jump (e.g., JAL)
                imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};

            default: imm = 32'b0; // Default immediate value for unsupported instructions
        endcase
    end

endmodule
