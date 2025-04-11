module ALU(Result, Operand1, Operand2, Control, ZeroFlag, CarryFlag, OverflowFlag);
    input [31:0] Operand1, Operand2;
    input [3:0] Control;
    output reg [31:0] Result;
    output reg ZeroFlag, CarryFlag, OverflowFlag;

    wire [63:0] mult_result = Operand1 * Operand2;

    always @(*) begin
        // Default flags
        ZeroFlag = 0;
        CarryFlag = 0;
        OverflowFlag = 0;

        case(Control)
            4'b0000: begin // ADD
                {CarryFlag, Result} = Operand1 + Operand2;
                OverflowFlag = (Operand1[31] == Operand2[31]) && (Result[31] != Operand1[31]);
            end

            4'b0001: begin // SUB
                Result = Operand1 - Operand2;
                CarryFlag = (Operand1 < Operand2); // Borrow for unsigned
                OverflowFlag = (Operand1[31] != Operand2[31]) && (Result[31] != Operand1[31]);
            end

            4'b0010: begin // MULT
                Result = mult_result[31:0];
                OverflowFlag = |mult_result[63:32]; // If upper 32 bits are non-zero
            end

            4'b0011: begin // DIV
                if (Operand2 != 0)
                    Result = $signed(Operand1) / $signed(Operand2);
                else
                    Result = 32'bz;

                OverflowFlag = (Operand1 == 32'h80000000 && Operand2 == 32'hFFFFFFFF);
            end


            4'b0100: Result = Operand1 & Operand2; // AND
            4'b0101: Result = Operand1 | Operand2; // OR
            4'b0110: Result = Operand1 ^ Operand2; // XOR
            4'b0111: Result = ~Operand1;           // NOT
            4'b1000: Result = ~(Operand1 & Operand2); // NAND
            4'b1001: Result = ~(Operand1 | Operand2); // NOR
            4'b1010: Result = ~(Operand1 ^ Operand2); // XNOR
            4'b1011: Result = Operand1 << 1; // LEFT SHIFT
            4'b1100: Result = Operand1 >> 1; // RIGHT SHIFT (logical)
            4'b1101: Result = (Operand1 << 1) | (Operand1 >> 31); // CLS
            4'b1110: Result = (Operand1 >> 1) | (Operand1 << 31); // CRS
            4'b1111: Result = (Operand2 != 0) ? (Operand1 % Operand2) : 32'b0; // MOD

            default: Result = 32'b0;
        endcase

        ZeroFlag = (Result == 0);
    end
endmodule
