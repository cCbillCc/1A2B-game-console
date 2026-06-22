module seven_seg_controller (
    input             clk,
    input             rst,
    input             write_en,
    input      [31:0] write_data,
    output reg [3:0]  an_pins,
    output reg [7:0]  seg_pins
);

    reg [15:0] display_reg;
    reg [3:0]  cursor_reg;
    
    always @(posedge clk) begin
        if (~rst) begin
            display_reg <= 16'hCCCC;
            cursor_reg  <= 4'b0000;
        end else if (write_en) begin
            display_reg <= write_data[15:0];
            cursor_reg  <= write_data[19:16];
        end
    end

    reg [25:0] blink_counter;
    always @(posedge clk) begin
        if (~rst) blink_counter <= 0;
        else      blink_counter <= blink_counter + 1;
    end
    
    wire [1:0] scan_sel = blink_counter[16:15];
    
    wire blink_clk = blink_counter[24]; 
    reg [3:0] current_digit;
    reg       gate_light;
    
    always @(*) begin
        gate_light = 1'b1;
        case(scan_sel)
            2'b00: begin 
                an_pins = 4'b1110;
                current_digit = display_reg[3:0];
                if (cursor_reg[0] && !blink_clk) gate_light = 1'b0;
            end
            2'b01: begin 
                an_pins = 4'b1101;
                current_digit = display_reg[7:4]; 
                if (cursor_reg[1] && !blink_clk) gate_light = 1'b0;
            end
            2'b10: begin 
                an_pins = 4'b1011;
                current_digit = display_reg[11:8]; 
                if (cursor_reg[2] && !blink_clk) gate_light = 1'b0;
            end
            2'b11: begin 
                an_pins = 4'b0111;
                current_digit = display_reg[15:12]; 
                if (cursor_reg[3] && !blink_clk) gate_light = 1'b0;
            end
        endcase
        
        if (!gate_light) an_pins = 4'b1111;
    end

    always @(*) begin
        case(current_digit)
            4'h0: seg_pins = 8'b1100_0000;
            4'h1: seg_pins = 8'b1111_1001;
            4'h2: seg_pins = 8'b1010_0100;
            4'h3: seg_pins = 8'b1011_0000;
            4'h4: seg_pins = 8'b1001_1001;
            4'h5: seg_pins = 8'b1001_0010;
            4'h6: seg_pins = 8'b1000_0010;
            4'h7: seg_pins = 8'b1111_1000;
            4'h8: seg_pins = 8'b1000_0000;
            4'h9: seg_pins = 8'b1001_0000;
            4'hA: seg_pins = 8'b1000_1000;
            4'hB: seg_pins = 8'b1000_0011;
            4'hC: seg_pins = 8'b1111_1111;
            4'hD: seg_pins = 8'b1010_1111;
            4'hE: seg_pins = 8'b1000_0110;
            4'hF: seg_pins = 8'b1000_1110;
            default: seg_pins = 8'b1111_1111;
        endcase
    end

endmodule