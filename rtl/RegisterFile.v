module RegisterFile(
    output reg [31:0] read_data1,      // Data from first operand
    output reg [31:0] read_data2,      // Data from second operand
    input clk,                         // Clock signal
    input rst,                         // Reset signal
    input [4:0] read_addr1,            // Address for first operand
    input [4:0] read_addr2,            // Address for second operand
    input [4:0] write_addr,            // Address for writing result
    input [31:0] write_data,           // Data to be written
    input write_enable                 // Write enable signal
);

    reg [31:0] registers [0:31];       // 32 general-purpose registers
    integer i;

    // Initialize all registers
    initial begin
        registers[0] = 32'h00000000; // x0 is hardwired to 0
        for (i = 1; i < 32; i = i + 1)
            registers[i] = 32'hDEADBEEF; // Default value for simulation
    end

    // Synchronous reset and write
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            registers[0] <= 32'h00000000;
            for (i = 1; i < 32; i = i + 1)
                registers[i] <= i; // Set initial known values
        end
        else if (write_enable && write_addr != 5'd0) begin
            registers[write_addr] <= write_data;
        end
    end

    // Combinational read logic
    always @(*) begin
        read_data1 = (read_addr1 <= 5'd31) ? registers[read_addr1] : 32'h00000000;
        read_data2 = (read_addr2 <= 5'd31) ? registers[read_addr2] : 32'h00000000;
    end

endmodule
