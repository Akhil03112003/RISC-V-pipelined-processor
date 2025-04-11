module ForwardingUnit (
    input wire [4:0] id_ex_rs1,
    input wire [4:0] id_ex_rs2,
    input wire [4:0] ex_mem_rd,
    input wire ex_mem_regWrite,
    input wire [4:0] mem_wb_rd,
    input wire mem_wb_regWrite,

    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

always @(*) begin
    // Default: No forwarding
    forwardA = 2'b00;
    forwardB = 2'b00;

    // EX hazard
    if (ex_mem_regWrite && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rs1))
        forwardA = 2'b10;
    if (ex_mem_regWrite && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rs2))
        forwardB = 2'b10;

    // MEM hazard
    if (mem_wb_regWrite && (mem_wb_rd != 0) &&
        !(ex_mem_regWrite && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rs1)) &&
        (mem_wb_rd == id_ex_rs1))
        forwardA = 2'b01;

    if (mem_wb_regWrite && (mem_wb_rd != 0) &&
        !(ex_mem_regWrite && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rs2)) &&
        (mem_wb_rd == id_ex_rs2))
        forwardB = 2'b01;
end

endmodule
