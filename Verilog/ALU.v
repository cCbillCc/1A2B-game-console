module ALU (
    input [3:0] ALUctl,
    input signed [31:0] A,B,
    output reg signed [31:0] ALUOut,
    output reg zero
);
    // ALU has two operand, it execute different operator based on ALUctl wire
    // output zero is for determining taking branch or not (or you can change the design as you wish)

    // TODO: implement your ALU here
    // Hint: you can use operator to implement

    always @(*) begin
        case(ALUctl)
            4'b0000: begin
                ALUOut = A & B;
                zero = (ALUOut == 32'b0);
            end
            4'b0001: begin
                ALUOut = A | B;
                zero = (ALUOut == 32'b0);
            end
            4'b0010: begin
                ALUOut = A + B; 
                zero = (ALUOut == 32'b0);
            end
            4'b0011: begin 
                ALUOut = A << B[4:0];
                zero = (ALUOut == 32'b0);
            end
            4'b0110: begin
                ALUOut = A - B;
                zero = (ALUOut == 32'b0);
            end
            4'b0111: begin
            		case(A<B)
            		    1'b1:ALUOut=32'b1;
            		    1'b0:ALUOut=32'b0;
            		endcase
            		zero=(ALUOut==32'b0);
            end
            4'b1001: begin
                ALUOut = A ^ B;
                zero = (ALUOut == 32'b0);
            end
            4'b1011: begin
                ALUOut = A >>> B[4:0];
                zero = (ALUOut == 32'b0);
            end
            4'b1100: begin
                ALUOut = $unsigned(A) >> B[4:0];
                zero = (ALUOut == 32'b0);
            end
            4'b1111: begin
                ALUOut = B;
                zero = (ALUOut == 32'b0);
            end
            default: begin
                ALUOut = 32'b0;
                zero = 1'b1;
            end
        endcase
    end

endmodule