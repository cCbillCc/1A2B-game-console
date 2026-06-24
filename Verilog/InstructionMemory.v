module InstructionMemory (
    input        clk,
    input [31:0] readAddr,
    output [31:0] inst
);

    (* ram_style = "distributed" *) reg [31:0] insts [0:1023];

    assign inst = insts[readAddr[11:2]];
    
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            insts[i] = 32'b0;
        end
        $readmemb("MachineCode.txt", insts);
    end

endmodule