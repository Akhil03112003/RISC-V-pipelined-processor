module if_id (
    input wire clk,
    input wire reset,
    input wire [31:0] pc_in,
    input wire [31:0] instr_in,
    input wire flush,               // for flushing on control hazard
    input wire enable,              // for stalling

    output reg [31:0] pc_out,
    output reg [31:0] instr_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc_out <= 32'b0;
        instr_out <= 32'b0;
    end else if (flush) begin
        pc_out <= 32'b0;
        instr_out <= 32'b0;
    end else if (enable) begin
        pc_out <= pc_in;
        instr_out <= instr_in;
    end
end

endmodule
