module PC (
    input clk,
    input rst,
    input write_enable,             // New: Control from Hazard Detection Unit
    input [1:0] pc_op,              // 00: PC+4, 01: JAL, 10: Branch, 11: JALR
    input [31:0] target_addr,       // Immediate offset for jump/branch
    input [31:0] jalr_base,         // x[rs1] in case of JALR
    output reg [31:0] pc_out
);
    reg [31:0] branch_target;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize PC to -4 so that first PC+4 becomes 0
            pc_out <= 32'hFFFFFFFC;
        end else if(write_enable) begin //if (write_enable)
            case (pc_op)
                2'b00: begin
                    // PC + 4 (normal sequential execution)
                    pc_out <= pc_out + 4;
                end
                2'b01: begin
                    // JAL: PC + immediate
                    if (target_addr[1:0] == 2'b00)
                        pc_out <= pc_out + $signed(target_addr);
                    else
                        $display("Error: Misaligned JAL target address: %h", pc_out + $signed(target_addr));
                end
                2'b10: begin
                    // Branch: PC + signed immediate
                    branch_target = pc_out + $signed(target_addr);
                    if (branch_target[1:0] == 2'b00)
                        pc_out <= branch_target;
                    else
                        $display("Error: Misaligned branch target address: %h", branch_target);
                end
                2'b11: begin
                    // JALR: (rs1 + imm) & ~1
                    pc_out <= (jalr_base + $signed(target_addr)) & ~32'h1;
                    if (((jalr_base + $signed(target_addr)) & ~32'h1) % 4 != 0)
                        $display("Warning: JALR target address not 4-byte aligned: %h", (jalr_base + target_addr) & ~32'h1);
                end
                default: begin
                    // Hold PC
                    pc_out <= pc_out;
                end
            endcase
        end
    end
endmodule
