import re

# R-type instructions
r_type = {
    'ADD':  ('0110011', '000', '0000000'),
    'SUB':  ('0110011', '000', '0100000'),
    'MUL':  ('0110011', '000', '0000001'),
    'DIV':  ('0110011', '000', '0000010'),
    'MOD':  ('0110011', '011', '0000011'),
    'SLL':  ('0110011', '001', '0000000'),
    'SRL':  ('0110011', '101', '0000000'),
    'SRA':  ('0110011', '101', '0100000'),
    'AND':  ('0110011', '111', '0000000'),
    'NAND': ('0110011', '111', '0100000'),
    'OR':   ('0110011', '110', '0000000'),
    'NOR':  ('0110011', '110', '0100000'),
    'XOR':  ('0110011', '100', '0000000'),
    'XNOR': ('0110011', '100', '0100000'),
    'CLS':  ('0110011', '010', '0000001'),
    'CRS':  ('0110011', '010', '0000010'),
}

# I-type instructions
i_type = {
    'ADDI': ('0010011', '000'),
    'ORI':  ('0010011', '110'),
    'XORI': ('0010011', '100'),
    'SRLI': ('0010011', '101'),
    'SLLI': ('0010011', '101'),
}

# Load (I-type style)
l_type = {
    'LW': ('0000011', '010')
}

# Store
s_type = {
    'SW': ('0100011', '010')
}

# Branch
b_type = {
    'BEQ': ('1100011', '000'),
    'BNE': ('1100011', '001'),
}

# Jump
j_type = {
    'JAL': '1101111'
}

registers = {f'x{i}': format(i, '05b') for i in range(32)}


def parse_r_type(instr, rd, rs1, rs2):
    opcode, funct3, funct7 = r_type[instr]
    return funct7 + registers[rs2] + registers[rs1] + funct3 + registers[rd] + opcode


def parse_i_type(instr, rd, rs1, imm):
    opcode, funct3 = i_type[instr]
    imm = format(int(imm) & 0xFFF, '012b')
    return imm + registers[rs1] + funct3 + registers[rd] + opcode


def parse_lw(instr, rd, offset_base):
    opcode, funct3 = l_type[instr]
    offset, rs1 = re.match(r'(\d+)\((x\d+)\)', offset_base).groups()
    imm = format(int(offset) & 0xFFF, '012b')
    return imm + registers[rs1] + funct3 + registers[rd] + opcode


def parse_sw(instr, rs2, offset_base):
    opcode, funct3 = s_type[instr]
    offset, rs1 = re.match(r'(\d+)\((x\d+)\)', offset_base).groups()
    imm = format(int(offset) & 0xFFF, '012b')
    return imm[:7] + registers[rs2] + registers[rs1] + funct3 + imm[7:] + opcode


def parse_b_type(instr, rs1, rs2, label, current_line, label_map):
    opcode, funct3 = b_type[instr]
    offset = (label_map[label] - current_line) * 4
    imm = format(offset & 0x1FFF, '013b')  # 13-bit signed immediate
    return imm[0] + imm[2:8] + registers[rs2] + registers[rs1] + funct3 + imm[8:12] + imm[1] + opcode


def parse_j_type(instr, rd, label, current_line, label_map):
    opcode = j_type[instr]
    offset = (label_map[label] - current_line) * 4
    imm = format(offset & 0xFFFFF, '020b')
    return imm[0] + imm[10:20] + imm[9] + imm[1:9] + registers[rd] + opcode


def assemble_instruction(line, current_line, label_map):
    line = line.split('#')[0].strip()
    if not line or line.endswith(':'):
        return None

    parts = re.split(r'[\s,]+', line)
    instr = parts[0].upper()

    if instr in r_type:
        rd, rs1, rs2 = parts[1], parts[2], parts[3]
        return parse_r_type(instr, rd, rs1, rs2)
    elif instr in i_type:
        rd, rs1, imm = parts[1], parts[2], parts[3]
        return parse_i_type(instr, rd, rs1, imm)
    elif instr == 'LW':
        rd, offset_base = parts[1], parts[2]
        return parse_lw(instr, rd, offset_base)
    elif instr == 'SW':
        rs2, offset_base = parts[1], parts[2]
        return parse_sw(instr, rs2, offset_base)
    elif instr in b_type:
        rs1, rs2, label = parts[1], parts[2], parts[3]
        return parse_b_type(instr, rs1, rs2, label, current_line, label_map)
    elif instr in j_type:
        rd, label = parts[1], parts[2]
        return parse_j_type(instr, rd, label, current_line, label_map)
    else:
        raise ValueError(f"Unsupported instruction: {instr}")


def compile_asm_to_hex(input_file, output_file):
    with open(input_file, 'r') as f:
        lines = [line.strip() for line in f.readlines()]

    label_map = {}
    instructions = []

    # First pass: Label mapping
    pc = 0
    for line in lines:
        if ':' in line:
            label = line.split(':')[0].strip()
            label_map[label] = pc
        elif line and not line.startswith('#'):
            pc += 1

    # Second pass: Assemble
    pc = 0
    for line in lines:
        bin_code = assemble_instruction(line, pc, label_map)
        if bin_code:
            instructions.append(format(int(bin_code, 2), '#010x'))
            pc += 1

    with open(output_file, 'w') as f:
        f.write('\n'.join(instructions))


if __name__ == "__main__":
    compile_asm_to_hex('code.asm', 'program.hex')
