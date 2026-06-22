module SingleCycleCPU (
    input clk,
    input start,
    output [1023:0] r,
    
    output [31:0]   alu_out,
    output [31:0]   reg_readData2,
    output          memWrite,
    output          memRead,
    input  [31:0]   mem_readData
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// The rst signal is active low, which means the module will reset if the rst signal is zero.
// And you should follow this design.

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,
// you can modify it as you wish except I/O pin and register module

wire [31:0] pc_i;
wire [31:0] pc_o;
wire [31:0] pc_plus_4;
wire [31:0] inst;

wire [1:0] memtoReg;
wire [1:0] ALUOp;
wire ALUSrc;
wire regWrite;
wire [1:0] PCSel;

wire [31:0] reg_readData1;
wire [31:0] reg_writeData;

wire BrEq;
wire BrLT;
wire [31:0] imm;
wire [31:0] imm_shifted;
wire [31:0] adder2_out;

wire [31:0] alu_operand_b;
wire [3:0] ALUctl;
wire alu_zero;


PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(pc_i),
    .pc_o(pc_o)
);

Adder m_Adder_1(
    .a(pc_o),
    .b(32'd4),
    .sum(pc_plus_4)
);

InstructionMemory m_InstMem(
    .clk(clk),
    .readAddr(pc_o),
    .inst(inst)
);

Control m_Control(
    .opcode(inst[6:0]),
    .funct3(inst[14:12]),
    .BrEq(BrEq),
    .BrLT(BrLT),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite),
    .PCSel(PCSel)
);

// For Student:
// Do not change the Register instance name!
// Or you will fail validation.

Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(regWrite),
    .readReg1(inst[19:15]),
    .readReg2(inst[24:20]),
    .writeReg(inst[11:7]),
    .writeData(reg_writeData),
    .readData1(reg_readData1),
    .readData2(reg_readData2)
);

// ======= for validation =======
// == Dont change this section ==
assign r = {
    m_Register.regs[31], m_Register.regs[30], m_Register.regs[29], m_Register.regs[28],
    m_Register.regs[27], m_Register.regs[26], m_Register.regs[25], m_Register.regs[24],
    m_Register.regs[23], m_Register.regs[22], m_Register.regs[21], m_Register.regs[20],
    m_Register.regs[19], m_Register.regs[18], m_Register.regs[17], m_Register.regs[16],
    m_Register.regs[15], m_Register.regs[14], m_Register.regs[13], m_Register.regs[12],
    m_Register.regs[11], m_Register.regs[10], m_Register.regs[9],  m_Register.regs[8],
    m_Register.regs[7],  m_Register.regs[6],  m_Register.regs[5],  m_Register.regs[4],
    m_Register.regs[3],  m_Register.regs[2],  m_Register.regs[1],  m_Register.regs[0]
};
// ======= for vaildation =======

BranchComp m_BranchComp(
    .A(reg_readData1),
    .B(reg_readData2),
    .BrEq(BrEq),
    .BrLT(BrLT)
);

ImmGen m_ImmGen(
    .inst(inst),
    .imm(imm)
);

ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(imm_shifted)
);

Adder m_Adder_2(
    .a(pc_o),
    .b(imm),
    .sum(adder2_out)
);

Mux3to1 #(.size(32)) m_Mux_PC(
    .sel(PCSel),
    .s0(pc_plus_4),
    .s1(adder2_out),
    .s2(alu_out),
    .out(pc_i)
);

Mux4to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(alu_out),
    .s1(mem_readData), 
    .s2(pc_plus_4), 
    .s3(adder2_out),
    .out(reg_writeData)
);

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(reg_readData2), 
    .s1(imm),           
    .out(alu_operand_b)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(inst[30]),  
    .funct3(inst[14:12]),
    .ALUCtl(ALUctl)
);

ALU m_ALU(
    .ALUctl(ALUctl),
    .A(reg_readData1),
    .B(alu_operand_b),
    .ALUOut(alu_out),
    .zero(alu_zero)
);

//DataMemory m_DataMemory(
//    .rst(start),
//    .clk(clk),
//    .memWrite(memWrite),
//    .memRead(memRead),
//    .address(alu_out),
//    .writeData(reg_readData2),
//    .readData(mem_readData)
//);

endmodule
