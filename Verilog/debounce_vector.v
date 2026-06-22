module debounce_vector #(parameter WIDTH = 5) (
    input              clk,
    input              rst,
    input  [WIDTH-1:0] din,
    output [WIDTH-1:0] dout
);
    reg [20:0] count;
    reg [WIDTH-1:0] din_reg;
    reg [WIDTH-1:0] dout_internal;

    always @(posedge clk) begin
        if (~rst) begin
            count <= 0;
            din_reg <= 0;
            dout_internal <= 0;
        end else begin
            din_reg <= din;
            if (din != din_reg) begin
                count <= 0;
            end else if (count < 21'd2000000) begin
                count <= count + 1;
            end else begin
                dout_internal <= din_reg;
            end
        end
    end

    assign dout = dout_internal;

endmodule