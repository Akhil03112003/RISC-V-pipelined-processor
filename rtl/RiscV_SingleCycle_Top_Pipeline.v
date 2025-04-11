module RiscV_SingleCycle_Top_Pipeline(
    input clk,
    input reset,
    output [31:0] pc_final
);

// Program Counter
wire [31:0] pc_current;

// Instruction Fetch | Memory
wire [31:0] instruction;

// IF/ID Pipeline Register Outputs
wire [31:0] if_id_pc_out;
wire [31:0] if_id_instr_out;

// Instruction Decode
wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0] rs1, rs2, rd;
wire [31:0] imm;

// Control Signals
wire [3:0] ALUOp;
//wire [1:0] ALUOp_id;
wire RegWrite, ALUSrc, MemRead, MemWrite, MemToReg, Branch, Jump;

// Register File
wire [31:0] reg_rs1, reg_rs2, reg_rd_data;

// ID/EX Pipeline Register Outputs
wire [31:0] id_ex_pc_out;
wire [31:0] id_ex_read_data1_out, id_ex_read_data2_out;
wire [31:0] id_ex_imm_out;
wire [4:0] id_ex_rs1_out, id_ex_rs2_out, id_ex_rd_out;
wire [2:0] id_ex_funct3_out;
wire [6:0] id_ex_funct7_out;
wire [3:0] id_ex_ALUOp_out;
wire id_ex_RegWrite_out, id_ex_ALUSrc_out, id_ex_MemRead_out, id_ex_MemWrite_out, id_ex_Branch_out, id_ex_MemToReg_out;

// ALU
wire [31:0] alu_input2, alu_result;
wire alu_zero;

// EX/MEM Pipeline Register Outputs
wire [31:0] ex_mem_alu_result_out;
wire [31:0] ex_mem_write_data_out;
wire [4:0] ex_mem_rd_out;
wire ex_mem_zero_out;
wire [31:0] ex_mem_pc_branch_out;

wire ex_mem_RegWrite_out;
wire ex_mem_MemRead_out;
wire ex_mem_MemWrite_out;
wire ex_mem_MemToReg_out;
wire ex_mem_Branch_out;


// Data Memory
wire [31:0] mem_read_data;

//MEM/WB Pipeline Register Outputs
wire [31:0] mem_wb_mem_data_out;
wire [31:0] mem_wb_alu_result_out;
wire [4:0] mem_wb_rd_out;
wire mem_wb_RegWrite_out;
wire mem_wb_MemToReg_out;


// Forwarding Unit Wires
wire [1:0] forwardA, forwardB;
wire [31:0] alu_src1, alu_src2;
wire [31:0] mem_write_data;
wire [31:0] mem_wb_data;


// Hazard Detection Wires
wire stall;
wire pc_write;
wire if_id_write;


// PC Control
wire [1:0] pc_op;
assign pc_op = 2'b00;

reg [31:0] mem_wb_data_latched;
always @(posedge clk) begin
    mem_wb_data_latched <= mem_wb_data;
end


// ========== MODULE INSTANTIATIONS ==========

// Program Counter
PC PC (
    .clk(clk),
    .rst(reset),
    .pc_op(pc_op),
    .target_addr(imm),
    .jalr_base(reg_rs1),
    .pc_out(pc_current),
    .write_enable(pc_write)
);

// Instruction Memory
InstructionMemory IM (
    .address(pc_current),
    .instruction(instruction)
);

// IF/ID Pipeline Register
if_id IF_ID (
    .clk(clk),
    .reset(reset),
    .pc_in(pc_current),
    .instr_in(instruction),
    .flush(1'b0),
    .enable(if_id_write),
    .pc_out(if_id_pc_out),
    .instr_out(if_id_instr_out)
);


// Instruction Decode
instruction_decode ID (
    .instruction(if_id_instr_out),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7),
    .imm(imm)
);

// Control Unit
ControlUnit CU (
    .Jump(Jump),
    .Branch(Branch),
    .MemToReg(MemToReg),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp),
    .funct7(funct7),
    .funct3(funct3),
    .opcode(opcode)
);

// Register File
RegisterFile RF (
    .clk(clk),
    .rst(reset),
    .write_enable(mem_wb_RegWrite_out),
    .read_addr1(rs1),
    .read_addr2(rs2),
    .write_addr(mem_wb_rd_out),
    .write_data(reg_rd_data),
    .read_data1(reg_rs1),
    .read_data2(reg_rs2)
);

// HazardDetectionUnit
HazardDetectionUnit HDU (
    .id_rs1(rs1),
    .id_rs2(rs2),
    .ex_rd(id_ex_rd_out),
    .ex_memRead(id_ex_MemRead_out),
    .stall(stall),
    .pc_write(pc_write),
    .if_id_write(if_id_write)
);


// ID/EX Pipeline Register
id_ex ID_EX (
    .clk(clk),
    .reset(reset),
    // Data in
    .pc_in(if_id_pc_out),
    .read_data1_in(reg_rs1),
    .read_data2_in(reg_rs2),
    .imm_in(imm),
    .rs1_in(rs1),
    .rs2_in(rs2),
    .rd_in(rd),
    .funct3_in(funct3),
    .funct7_in(funct7),
    // Control in
    .RegWrite_in(RegWrite),
    .MemRead_in(MemRead),
    .MemWrite_in(MemWrite),
    .Branch_in(Branch),
    .ALUOp_in(ALUOp),
    .ALUSrc_in(ALUSrc),
    .MemToReg_in(MemToReg),
    // Data out
    .pc_out(id_ex_pc_out),
    .read_data1_out(id_ex_read_data1_out),
    .read_data2_out(id_ex_read_data2_out),
    .imm_out(id_ex_imm_out),
    .rs1_out(id_ex_rs1_out),
    .rs2_out(id_ex_rs2_out),
    .rd_out(id_ex_rd_out),
    .funct3_out(id_ex_funct3_out),
    .funct7_out(id_ex_funct7_out),
    // Control out
    .RegWrite_out(id_ex_RegWrite_out),
    .MemRead_out(id_ex_MemRead_out),
    .MemWrite_out(id_ex_MemWrite_out),
    .Branch_out(id_ex_Branch_out),
    .ALUOp_out(id_ex_ALUOp_out),
    .ALUSrc_out(id_ex_ALUSrc_out),
    .MemToReg_out(id_ex_MemToReg_out)
);

// ALU Input Mux
//assign alu_input2 = (id_ex_ALUSrc_out) ? id_ex_imm_out : id_ex_read_data2_out;

// Forwarding Muxes
assign alu_src1 = (forwardA == 2'b10) ? ex_mem_alu_result_out :
                  (forwardA == 2'b01) ? reg_rd_data : 
                  id_ex_read_data1_out;

assign alu_src2 = (forwardB == 2'b10) ? ex_mem_alu_result_out :
                  (forwardB == 2'b01) ? reg_rd_data : 
                  id_ex_read_data2_out;

assign alu_input2 = (id_ex_ALUSrc_out) ? id_ex_imm_out : alu_src2;

assign mem_wb_data = (mem_wb_MemToReg_out) ? mem_wb_mem_data_out : mem_wb_alu_result_out;

assign mem_write_data = (forwardB == 2'b10) ? ex_mem_alu_result_out :    // Forward from EX/MEM
                        (forwardB == 2'b01) ? reg_rd_data :              // Forward from MEM/WB
                        id_ex_read_data2_out;                            // No hazard, use normal value



////// Forwarding Muxes
//assign alu_src1 = (forwardA == 2'b10) ? ex_mem_alu_result_out :
//                  (forwardA == 2'b01) ? mem_wb_data_latched :
//                  id_ex_read_data1_out;

//assign alu_src2 = (forwardB == 2'b10) ? ex_mem_alu_result_out :
//                  (forwardB == 2'b01) ? mem_wb_data_latched :
//                  id_ex_read_data2_out;

//assign mem_write_data = (forwardB == 2'b10) ? ex_mem_alu_result_out :
//                        (forwardB == 2'b01) ? mem_wb_data_latched :
//                        id_ex_read_data2_out;



// ALU
ALU alu (
    .Operand1(alu_src1),
    .Operand2(alu_input2),
    .Control( id_ex_ALUOp_out), // Modify if ALU control module added
    .Result(alu_result),
    .ZeroFlag(alu_zero),
    .CarryFlag(),
    .OverflowFlag()
);

// EX/MEM Pipeline Register
ex_mem EX_MEM (
    .clk(clk),
    .reset(reset),
    .alu_result_in(alu_result),
    .write_data_in(mem_write_data),
    .rd_in(id_ex_rd_out),
    .zero_in(alu_zero),
    .pc_branch_in(id_ex_pc_out + id_ex_imm_out), // assuming simple PC + imm

    .RegWrite_in(id_ex_RegWrite_out),
    .MemRead_in(id_ex_MemRead_out),
    .MemWrite_in(id_ex_MemWrite_out),
    .MemToReg_in(id_ex_MemToReg_out),
    .Branch_in(id_ex_Branch_out),

    .alu_result_out(ex_mem_alu_result_out),
    .write_data_out(ex_mem_write_data_out),
    .rd_out(ex_mem_rd_out),
    .zero_out(ex_mem_zero_out),
    .pc_branch_out(ex_mem_pc_branch_out),

    .RegWrite_out(ex_mem_RegWrite_out),
    .MemRead_out(ex_mem_MemRead_out),
    .MemWrite_out(ex_mem_MemWrite_out),
    .MemToReg_out(ex_mem_MemToReg_out),
    .Branch_out(ex_mem_Branch_out)
);


// Data Memory
DataMemory DM (
    .clk(clk),
    .MemRead(ex_mem_MemRead_out),
    .MemWrite(ex_mem_MemWrite_out),
    .addr(ex_mem_alu_result_out),
    .writeData(ex_mem_write_data_out),
    .readData(mem_read_data)
);


// MEM/WB Pipeline Register
mem_wb MEM_WB (
    .clk(clk),
    .reset(reset),

    .mem_data_in(mem_read_data),
    .alu_result_in(ex_mem_alu_result_out),
    .rd_in(ex_mem_rd_out),

    .RegWrite_in(ex_mem_RegWrite_out),
    .MemToReg_in(ex_mem_MemToReg_out),

    .mem_data_out(mem_wb_mem_data_out),
    .alu_result_out(mem_wb_alu_result_out),
    .rd_out(mem_wb_rd_out),

    .RegWrite_out(mem_wb_RegWrite_out),
    .MemToReg_out(mem_wb_MemToReg_out)
);

// Forwarding Unit
ForwardingUnit FU (
    .id_ex_rs1(id_ex_rs1_out),
    .id_ex_rs2(id_ex_rs2_out),
    .ex_mem_rd(ex_mem_rd_out),
    .ex_mem_regWrite(ex_mem_RegWrite_out),
    .mem_wb_rd(mem_wb_rd_out),
    .mem_wb_regWrite(mem_wb_RegWrite_out),
    .forwardA(forwardA),
    .forwardB(forwardB)
);



// Writeback Mux
assign reg_rd_data = (mem_wb_MemToReg_out) ? mem_wb_mem_data_out : mem_wb_alu_result_out;

//always @(*) begin
//    // Only debug when SW instruction is in EX stage
//    if (id_ex_MemWrite_out == 1'b1) begin
//        $display("==== SW DEBUG ====");
//        $display("Cycle=%0t | forwardB = %b", $time, forwardB);
//        $display("mem_write_data     = %d", mem_write_data);
//        $display("id_ex_rs2_out      = x%0d", id_ex_rs2_out);
//        $display("id_ex_read_data2   = %d", id_ex_read_data2_out);
//        $display("EX_MEM alu_result  = %d", ex_mem_alu_result_out);
//        $display("MEM_WB data        = %d", mem_wb_data);
//        $display("===================");
//    end
//end



// Output
assign pc_final = pc_current;

endmodule
