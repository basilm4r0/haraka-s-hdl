module serializer
# (parameter INWIDTH = 256, parameter OUTWIDTH = 64)
(sEEG, bclk, clk, eegOut);
    input [INWIDTH-1:0] sEEG;
    input bclk,clk;
    reg [INWIDTH-1:0] temp;
    reg [INWIDTH-1:0] temp_reg; //..synchronizer
    output reg [OUTWIDTH-1:0] eegOut;

    always@(posedge clk) begin
        temp <= sEEG;
    end

    always @(negedge bclk) begin
        temp_reg <= temp;
        temp_reg[INWIDTH-1-OUTWIDTH:0] <= temp_reg[INWIDTH-1:OUTWIDTH];
        eegOut <= temp_reg[OUTWIDTH-1:0];
    end
endmodule
