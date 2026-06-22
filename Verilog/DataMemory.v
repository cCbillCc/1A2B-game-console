module DataMemory(
	input clk,
	input memWrite,
	input memRead,
	input [31:0] address,
	input [31:0] writeData,
	output reg [31:0] readData
);

	(* ram_style = "distributed" *) reg [31:0] data_memory [0:1023];
    always @(*) readData = memRead ? data_memory[address[11:2]] : 32'b0;
    
    always @(posedge clk) begin
        if (memWrite)
            data_memory[address[11:2]] <= writeData;
    end

endmodule

