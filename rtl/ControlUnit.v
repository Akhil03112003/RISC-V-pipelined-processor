module ControlUnit(Jump, Branch, MemToReg, MemWrite, MemRead, ALUSrc, RegWrite, ALUOp, funct7, funct3, opcode);
input [6:0] opcode;         // Opcode field from the instruction
input [2:0] funct3;         // funct3 field from the instruction
input [6:0] funct7;         // funct7 field from the instruction
output reg [3:0] ALUOp;     // ALU operation control signal
output reg RegWrite;        // Register write enable
output reg ALUSrc;          // ALU source: 0 = Register, 1 = Immediate
output reg MemRead;         // Memory read enable
output reg MemWrite;        // Memory write enable
output reg MemToReg;        // Select between ALU result and memory data for Register File
output reg Branch;          // Branch control signal
output reg Jump;            // Jump control signal

always @(*) begin
    // Default values
    RegWrite = 0;
    ALUSrc = 0;
    MemRead = 0;
    MemWrite = 0;
    MemToReg = 0;
    Branch = 0;
    Jump = 0;
    ALUOp = 4'b0000;

    case(opcode)
        7'b0110011: begin // R-type instructions (e.g., ADD, SUB, AND, OR, XOR)
            RegWrite = 1;
            ALUSrc = 0;
            MemRead = 0;
            MemWrite = 0;
            MemToReg = 0;
            Branch = 0;
            Jump = 0;
            case(funct3)
                3'b000: begin
                    if (funct7 == 7'b0000000)
                        ALUOp = 4'b0000; // ADD
                    else if (funct7 == 7'b0100000)
                        ALUOp = 4'b0001; // SUBTRACTION
                    else if (funct7 == 7'b0000001)
                        ALUOp = 4'b0010; // MULTIPLICATION
                    else if (funct7 == 7'b0000010)
                        ALUOp = 4'b0011; // DIVISION
                end
                3'b011: begin
                    if (funct7 == 7'b0000011)
                        ALUOp = 4'b1111; // MODULUS
                end
                3'b001: begin
                    if (funct7 == 7'b0000000)
                        ALUOp = 4'b1011; // LEFT SHIFT (SLL)
                end
                3'b101: begin
                    if (funct7 == 7'b0000000)
                        ALUOp = 4'b1100; // SRL (Shift Right Logical)
                    else if (funct7 == 7'b0100000)
                        ALUOp = 4'b1110; // SRA (Shift Right Arithmetic)
                end
                3'b111: begin
                    if (funct7 == 7'b0000000)
                        ALUOp = 4'b0100; // AND
                    else if (funct7 == 7'b0100000)
                        ALUOp = 4'b1000; // NAND
                end
                3'b110: begin
                    if (funct7 == 7'b0000000)
                        ALUOp = 4'b0101; // OR
                    else if (funct7 == 7'b0100000)
                        ALUOp = 4'b1001; // NOR
                end
                3'b100: begin
                    if (funct7 == 7'b0000000)
                        ALUOp = 4'b0110; // XOR
                    else if (funct7 == 7'b0100000)
                        ALUOp = 4'b1010; // XNOR
                end
                3'b010: begin
                    if (funct7 == 7'b0000001)
                        ALUOp = 4'b1101; // Circular Left Shift (CLS)
                    else if (funct7 == 7'b0000010)
                        ALUOp = 4'b1110; // Circular Right Shift (CRS)
                end
            endcase
        end
    
        7'b0010011: begin // I-type ALU instructions (e.g., ADDI, ORI, XORI)
            RegWrite = 1;
            ALUSrc = 1;
            MemRead = 0;
            MemWrite = 0;
            MemToReg = 0;
            Branch = 0;
            Jump = 0;
            case(funct3)
                3'b000: ALUOp = 4'b0000; // ADDI
                3'b110: ALUOp = 4'b0101; // ORI
                3'b100: ALUOp = 4'b0110; // XORI
                3'b101: ALUOp = (funct7 == 7'b0000000) ? 4'b1100 : 4'b1011; // SRLI/SLLI
            endcase
        end
    
        7'b0000011: begin // Load (LW)
            RegWrite = 1;
            ALUSrc = 1;
            MemRead = 1;
            MemWrite = 0;
            MemToReg = 1;
            Branch = 0;
            Jump = 0;
            ALUOp = 4'b0000; // ADD for address calculation
        end
    
        7'b0100011: begin // Store (SW)
            RegWrite = 0;
            ALUSrc = 1;
            MemRead = 0;
            MemWrite = 1;
            MemToReg = 0;
            Branch = 0;
            Jump = 0;
            ALUOp = 4'b0000; // ADD for address calculation
        end
    
        7'b1100011: begin // Branch (BEQ, BNE)
            RegWrite = 0;
            ALUSrc = 0;
            MemRead = 0;
            MemWrite = 0;
            MemToReg = 0;
            Branch = 1;
            Jump = 0;
            case(funct3)
                3'b000: ALUOp = 4'b0001; // BEQ (SUBTRACTION for comparison)
                3'b001: ALUOp = 4'b0001; // BNE (SUBTRACTION for comparison)
            endcase
        end
    
        7'b1101111: begin // Jump (JAL)
            RegWrite = 1;
            ALUSrc = 0;
            MemRead = 0;
            MemWrite = 0;
            MemToReg = 0;
            Branch = 0;
            Jump = 1;
            ALUOp = 4'b0000; 
        end
    
        default: begin
            RegWrite = 0;
            ALUSrc = 0;
            MemRead = 0;
            MemWrite = 0;
            MemToReg = 0;
            Branch = 0;
            Jump = 0;
            ALUOp = 4'b0000;
        end
    endcase

end
//always @(*) begin
//    $display("Time: %0t | Opcode: %b | ALUSrc: %b | RegWrite: %b | ALUOp: %b", 
//             $time, opcode, ALUSrc, RegWrite, ALUOp);
//end

endmodule