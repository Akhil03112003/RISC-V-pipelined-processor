module HazardDetectionUnit (
    input wire [4:0] id_rs1,
    input wire [4:0] id_rs2,
    input wire [4:0] ex_rd,
    input wire ex_memRead,
    output reg stall,
    output reg pc_write,
    output reg if_id_write
);

always @(*) begin
    if (ex_memRead && ((ex_rd == id_rs1) || (ex_rd == id_rs2))) begin
        stall      <= 1;
        pc_write   <= 0;
        if_id_write <= 0;
    end else begin
        stall      <= 0;
        pc_write   <= 1;
        if_id_write <= 1;
    end
end

endmodule
