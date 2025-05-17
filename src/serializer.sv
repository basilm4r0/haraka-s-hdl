module serializer
# (parameter INWIDTH = 256, parameter OUTWIDTH = 8)
(in, length, bclk, clk, serial_out, reset);
    input [INWIDTH-1:0] in;
    input [$clog2(INWIDTH/OUTWIDTH):0] length;
    logic [$clog2(INWIDTH/OUTWIDTH):0] counter;
    input bclk,clk;
    input reset;
    logic [INWIDTH-1:0] shift_reg;
    output logic [OUTWIDTH-1:0] serial_out;
    logic clk_edge;

    edge_detector detector (.in(clk), .clk(bclk), .out(clk_edge));

    always_ff @(posedge bclk, posedge reset) begin
        if (reset) begin
            shift_reg <= 0;
            counter <= 0;
        end

        if (clk_edge && !reset) begin
            shift_reg <= in;
            counter <= length;
        end

        if (counter > 0) begin
            serial_out <= shift_reg[OUTWIDTH-1:0];
            shift_reg <= {OUTWIDTH'(0), shift_reg[INWIDTH-1:OUTWIDTH]};
            counter <= counter - 1;
        end

        else begin
            serial_out <= 0;
        end
    end
endmodule

module edge_detector ( input in,
                       input clk,
                       output logic out);
    logic in_delayed;
    always_ff @(posedge clk) begin
        in_delayed <= in;
    end
    always_ff @(posedge clk) begin
        out = in & ~in_delayed;
    end
        
endmodule
