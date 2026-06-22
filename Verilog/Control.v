module Control (
    input [6:0] opcode,
    input [2:0] funct3,
    input BrEq, BrLT,
    output reg memRead,
    output reg [1:0] memtoReg,
    output reg [1:0] ALUOp,
    output reg memWrite,
    output reg ALUSrc,
    output reg regWrite,
    output reg [1:0] PCSel
);

    reg [9:0] ctrl_signals;

    always @(*) begin
        case(opcode)
            // 1. R-Type (add, sub, and, or...)
            7'b0110011: ctrl_signals = 10'b00_0_00_10_0_0_1; 

            // 2. I-Type ALU (addi, andi, ori...)
            7'b0010011: ctrl_signals = 10'b00_0_00_01_0_1_1; 

            // 3. Load Instructions (lw)
            7'b0000011: ctrl_signals = 10'b00_1_01_00_0_1_1;

            // 4. Store Instructions (sw)
            7'b0100011: ctrl_signals = 10'b00_0_00_00_1_1_0;
			
            7'b0110111: ctrl_signals = 10'b00_0_00_11_0_1_1;

            7'b1101111: ctrl_signals = 10'b01_0_10_00_0_0_1;

            7'b1100111: ctrl_signals = 10'b10_0_10_00_0_1_1;

            7'b1100011: begin
                case(funct3)
                    // beq
                    3'b000: begin
                        if (BrEq) ctrl_signals = 10'b01_0_00_01_0_0_0;
                        else      ctrl_signals = 10'b00_0_00_01_0_0_0;
                    end
                    // bne
                    3'b001: begin
                        if (!BrEq) ctrl_signals = 10'b01_0_00_01_0_0_0;
                        else       ctrl_signals = 10'b00_0_00_01_0_0_0;
                    end
                    // blt
                    3'b100: begin
                        if (BrLT) ctrl_signals = 10'b01_0_00_01_0_0_0;
                        else      ctrl_signals = 10'b00_0_00_01_0_0_0;
                    end
                    // bge
                    3'b101: begin
                        if (!BrLT) ctrl_signals = 10'b01_0_00_01_0_0_0;
                        else       ctrl_signals = 10'b00_0_00_01_0_0_0;
                    end
                    default: ctrl_signals = 10'b00_0_00_00_0_0_0;
                endcase
            end

            default: ctrl_signals = 10'b00_0_00_00_0_0_0; 
        
        endcase

        {PCSel, memRead, memtoReg, ALUOp, memWrite, ALUSrc, regWrite} = ctrl_signals;

    end

endmodule