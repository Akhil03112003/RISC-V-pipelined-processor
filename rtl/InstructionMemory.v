module InstructionMemory (
    input [31:0] address,           // Input address from the Program Counter (PC)
    output reg [31:0] instruction   // Output instruction at the given address
);

    (* ram_style = "block" *) reg [31:0] memory [0:1023];
    integer i;

    initial begin
        // Initialize memory to zero
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 32'b0;
        end

        // Load instructions from external file
        $readmemh("C:/Verilog/RISC_V/RISC_V.srcs/sources_1/new/Program.out", memory);  // <--  machine code from Venus
    end

    // Synchronous read (combinational read actually)
    always @(*) begin
        instruction <= memory[address[31:2]]; // word-aligned access
    end
endmodule
