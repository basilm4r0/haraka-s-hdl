module serializer
# (parameter INWIDTH = 256, parameter OUTWIDTH = 8)
(in, length, bclk, clk, serial_out, reset);
    input [INWIDTH-1:0] in;
    input [$clog2(INWIDTH/OUTWIDTH):0] length;
    logic [$clog2(INWIDTH/OUTWIDTH):0] counter;
    input bclk,clk;
    input reset;
    logic [INWIDTH-1:0] shift_reg;
    logic input_captured;
    output reg [OUTWIDTH-1:0] serial_out;

    always_ff @(posedge bclk, posedge reset) begin
        if (reset) begin
            shift_reg <= 0;
            input_captured <= 0;
            counter <= 0;
        end

        if (clk && !input_captured) begin
            shift_reg <= in;
            counter <= length;
            input_captured <= 1;
        end

        if (!clk)
            input_captured <= 0;

        if (counter > 0) begin
            serial_out <= shift_reg[OUTWIDTH-1:0];
            shift_reg <= {OUTWIDTH'(0), shift_reg[INWIDTH-1:OUTWIDTH]};
            counter <= counter - 1;
        end

    end
endmodule
