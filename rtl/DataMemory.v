module DataMemory (
    input clk,
    input MemRead,
    input MemWrite,
    input [31:0] addr,           // 32-bit byte address
    input [31:0] writeData,      // Data to write to memory
    output reg [31:0] readData   // Data read from memory
);

    reg [31:0] memory [0:1023];  // 1024 words of 32-bit memory = 4KB

    wire [31:2] word_addr = addr[31:2]; // Word-aligned address

    always @(posedge clk) begin
        if (MemWrite) begin
            memory[word_addr] <= writeData;
        end
    end
    always @(*) begin
        if (MemRead) begin
            readData = memory[word_addr];
        end else begin
            readData = 32'b0;
        end
    end
endmodule
