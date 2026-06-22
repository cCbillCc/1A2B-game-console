module ALUCtrl (
    input [1:0] ALUOp,
    input funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtl
);

    // TODO: implement your ALU control here
    // For testbench verifying, Do not modify input and output pin
    // Hint: using ALUOp, funct7, funct3 to select exact operation

    
    // Example for addi instruction:
    // ALUOp = 2'b01, funct3 = 3'b000,
    always @(*) begin
        case(ALUOp)
            2'b10: // R-type instructions
                case({funct3, funct7})
                    {3'b000, 1'b0}: ALUCtl = 4'b0010;
                    {3'b000, 1'b1}: ALUCtl = 4'b0110;
                    {3'b110, 1'b0}: ALUCtl = 4'b0001;
                    {3'b111, 1'b0}: ALUCtl = 4'b0000;
                    {3'b001, 1'b0}: ALUCtl = 4'b0011;
                    {3'b010, 1'b0}: ALUCtl = 4'b0111;
                    {3'b100, 1'b0}: ALUCtl = 4'b1001;
                    {3'b101, 1'b0}: ALUCtl = 4'b1100;
                    {3'b101, 1'b1}: ALUCtl = 4'b1011;
                    default: ALUCtl = 4'bxxxx;
                endcase

            2'b01: // I-type instructions
                case(funct3)
                    3'b000:  ALUCtl = 4'b0010;
                    3'b001:  ALUCtl = 4'b0011;
                    3'b110:  ALUCtl = 4'b0001;
                    3'b111:  ALUCtl = 4'b0000;
                    3'b010:  ALUCtl = 4'b0111;
                    3'b100:  ALUCtl = 4'b1001;
                    3'b101:  begin
                        if (funct7 == 1'b0) 
                            ALUCtl = 4'b1100;
                        else 
                            ALUCtl = 4'b1011;
                    end
                    default: ALUCtl = 4'bxxxx;
                endcase

            // Todo: implement other ALUOp cases
            2'b00:
                ALUCtl = 4'b0010; 
                
            2'b11:
                ALUCtl = 4'b1111;

            default: ALUCtl = 4'bxxxx;
        endcase
    end


endmodule