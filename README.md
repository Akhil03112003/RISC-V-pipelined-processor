# RISC-V Pipelined Processor (B.Tech 3rd Year Theme-Based Project)

This is a 5-stage pipelined RISC-V processor implemented in **Verilog**. It supports a wide range of ALU operations along with basic memory, branching, and jumping instructions. Developed as a part of my **3rd year theme-based project (B.Tech ECE '25)**, this work demonstrates my strong foundation and passion for **VLSI design** and **digital system architecture**.

> **Batch:** 2022–2026  
> **Branch:** B.Tech Electronics and Communication Engineering (ECE)  
> **Project Year:** 3rd Year (Theme-Based Project)

---

## 📚 Table of Contents
- [Features](#features)
- [Project Summary](#project-summary)
- [Modules Overview](#modules-overview)
- [Supported Instructions](#supported-instructions)
- [How to Run](#how-to-run)
- [Project Structure](#project-structure)
- [Author](#author)

---

##  Features

-  **5-Stage Pipelined Architecture**: IF, ID, EX, MEM, WB
-  **Hazard Detection Unit (HDU)** and **Forwarding Unit (FU)** for handling data hazards
-  **Control Unit** for instruction decoding and signal generation
-  **Custom ALU** for arithmetic, logical, and shift operations
-  **Instruction & Data memory modules** for program storage and execution

---

##  Project Summary

The processor is modular and structured, with each Verilog component performing a specific CPU pipeline function. It emulates real hardware behavior and enhances understanding of datapath flow and hazard mitigation in pipelined designs.

---

##  Modules Overview

| Module                | Description                              | Source File              |
|-----------------------|------------------------------------------|--------------------------|
| PC                    | Program Counter                          | `PC.v`                   |
| InstructionMemory     | Stores the instruction set               | `InstructionMemory.v`    |
| IF/ID Pipeline Reg    | Transfers data between IF and ID stages  | `if_id.v`                |
| Instruction Decoder   | Decodes fetched instruction              | `instruction_decode.v`   |
| Control Unit          | Generates control signals                | `ControlUnit.v`          |
| Register File         | 32 general-purpose registers             | `RegisterFile.v`         |
| Hazard Detection Unit | Detects RAW hazards                      | `HazardDetectionUnit.v`  |
| ID/EX Pipeline Reg    | Transfers data between ID and EX stages  | `id_ex.v`                |
| ALU                   | Performs computations                    | `ALU.v`                  |
| EX/MEM Pipeline Reg   | Transfers data between EX and MEM stages | `ex_mem.v`               |
| Data Memory           | Performs memory read/write               | `DataMemory.v`           |
| MEM/WB Pipeline Reg   | Transfers data between MEM and WB stages | `mem_wb.v`               |
| Forwarding Unit       | Resolves hazards via forwarding logic    | `ForwardingUnit.v`       |

---

##  Supported Instructions

### 🔹 R-Type ALU Instructions

| Instruction | Operation        |
|-------------|------------------|
| `ADD`       | Addition         |
| `SUB`       | Subtraction      |
| `MUL`       | Multiplication   |
| `DIV`       | Signed Division  |
| `MOD`       | Modulo           |
| `AND`       | Bitwise AND      |
| `OR`        | Bitwise OR       |
| `XOR`       | Bitwise XOR      |
| `NAND`      | Bitwise NAND     |
| `NOR`       | Bitwise NOR      |
| `XNOR`      | Bitwise XNOR     |
| `NOT`       | Bitwise NOT      |
| `SLL`       | Logical Shift Left |
| `SRL`       | Logical Shift Right |
| `CLS`       | Circular Left Shift |
| `CRS`       | Circular Right Shift |

### 🔹 I-Type ALU Instructions

| Instruction | Operation            |
|-------------|----------------------|
| `ADDI`      | Add Immediate        |
| `ORI`       | OR Immediate         |
| `XORI`      | XOR Immediate        |
| `SRLI`      | Shift Right Immediate |
| `SLLI`      | Shift Left Immediate  |

### 🔹 Memory Access

| Instruction | Operation     |
|-------------|---------------|
| `LW`        | Load Word     |
| `SW`        | Store Word    |

### 🔹 Branching & Jumping

| Instruction | Operation           |
|-------------|---------------------|
| `BEQ`       | Branch if Equal     |
| `BNE`       | Branch if Not Equal |
| `JAL`       | Jump and Link       |

---

##  How to Run
```bash 
 1. Clone the repository:

git clone https://github.com/Akhil03112003/RISC-V-pipeline-processor.git
cd riscv-pipeline-processor
```


2. Write RISC-V Assembly Code
Create a file named code.asm.

Write valid RISC-V instructions supported by the processor:
```
ADD x3, x1, x2
SUB x4, x3, x5
SW x4, 0(x6)
```
3. Compile Assembly to HEX
Use the custom-built compiler to convert the assembly program to machine-readable hex format:
```
python3 compiler.py
```
This generates a program.hex file.

The hex file contains binary-equivalent instructions based on RISC-V formats (R/I/L/S/B/J types).

4. Load HEX File into Instruction Memory
The InstructionMemory.v module reads the program.hex file during simulation.

Each instruction is loaded at its corresponding address in the instruction memory.

5. Simulate the Processor in Vivado/ModelSim
Load all Verilog modules and the testbench in your simulation environment.

Begin simulation and observe waveform outputs.

### 🔧 Module-Wise Architecture Overview

| Stage | Modules | Description |
|-------|---------|-------------|
| **IF**  | `PC.v`, `InstructionMemory.v` | Fetches the instruction from memory |
| **ID**  | `instruction_decode.v`, `ControlUnit.v`, `RegisterFile.v`, `HazardDetectionUnit.v` | Decodes instructions, reads registers, handles RAW hazards |
| **EX**  | `ALU.v`, `ForwardingUnit.v` | Performs ALU operations, resolves hazards using forwarding |
| **MEM** | `DataMemory.v` | Executes memory operations (`LW`, `SW`) |
| **WB**  | Write-back logic in `mem_wb.v` | Writes result back to the register file |

📌 Between each stage, pipeline registers (`if_id.v`, `id_ex.v`, `ex_mem.v`, `mem_wb.v`) pass the relevant data forward.


✅ Final Flow Summary
```
Assembly Code (code.asm)
     ↓
Compiler (compiler.py)
     ↓
Machine Code (program.hex)
     ↓
Instruction Memory (Verilog)
     ↓
5-Stage Pipeline Processor Simulation
     ↓
Waveform/Output Observation

```


##  Author

**Sunkanapelly Akhilesh**  
B.Tech ECE, Batch 2022–2026  
Passionate about **VLSI Design**, **Processor Architectures**, and **Digital Systems**.  
🔗 [LinkedIn]([https://www.linkedin.com/in/your-link](https://www.linkedin.com/in/akhilesh-sunkanapelly-11a677320/)) | 📧 akhilesh03112003@gmail.com


```




