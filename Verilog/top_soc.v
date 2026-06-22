module top_soc (
    input        clk,
    input        start,
    input  [4:0] btn_pins,
    input  [3:0] sw_pins,
    output [3:0] an_pins,
    output [7:0] seg_pins
);

    wire [31:0] cpu_addr;
    wire [31:0] cpu_wdata;
    wire [31:0] cpu_rdata;
    wire        cpu_mem_write;
    wire        cpu_mem_read;
    
    reg [5:0] clk_div;
    always @(posedge clk) begin
        if (~start) clk_div <= 0;
        else        clk_div <= clk_div + 1;
    end
    
    wire cpu_clk = clk_div[5];

    SingleCycleCPU u_core (
        .clk(cpu_clk),
        .start(start),
        .r(),
        .alu_out(cpu_addr),
        .reg_readData2(cpu_wdata),
        .memWrite(cpu_mem_write),
        .memRead(cpu_mem_read),
        .mem_readData(cpu_rdata)
    );

    wire sel_mem  = (cpu_addr < 32'h40000000);  
    wire sel_btn  = (cpu_addr == 32'h40000000); 
    wire sel_seg7 = (cpu_addr == 32'h40000004); 
    wire sel_sw   = (cpu_addr == 32'h4000000C); 

    wire [31:0] ram_rdata;
    wire [4:0]  debounced_btns;
    
    assign cpu_rdata = (sel_mem) ? ram_rdata :
                       (sel_btn) ? {27'b0, debounced_btns} :
                       (sel_sw)  ? {28'b0, sw_pins} :
                       32'b0;

    DataMemory m_DataMemory(
        .clk(cpu_clk),
        .memWrite(cpu_mem_write && sel_mem), 
        .memRead(cpu_mem_read && sel_mem),
        .address(cpu_addr),
        .writeData(cpu_wdata),
        .readData(ram_rdata)
    );

    debounce_vector #(.WIDTH(5)) u_debounce (
        .clk(clk),
        .rst(start),
        .din(btn_pins),
        .dout(debounced_btns)
    );

    seven_seg_controller u_seg7 (
        .clk(clk),
        .rst(start),
        .write_en(cpu_mem_write && sel_seg7),
        .write_data(cpu_wdata), 
        .an_pins(an_pins),
        .seg_pins(seg_pins)
    );

endmodule