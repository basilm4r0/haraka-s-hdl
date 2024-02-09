module deserializer
# (parameter INWIDTH = 64, parameter OUTWIDTH = 256)
(sEEG, enable, bclk, clk, eegOut);
    input [INWIDTH-1:0] sEEG;
    input bclk,clk;
    input enable;
    reg [OUTWIDTH-1:0] temp;
    reg [OUTWIDTH-1:0] temp_reg; //..synchronizer
    logic [$clog2(OUTWIDTH/INWIDTH)-1:0] counter;
    output reg [OUTWIDTH-1:0] eegOut;
    logic [OUTWIDTH-1:0] pad = 0;

    always @(negedge bclk) begin
        temp[OUTWIDTH-1-INWIDTH:0] <= temp[OUTWIDTH-1:INWIDTH];
        if (enable) begin
            temp[OUTWIDTH-1:OUTWIDTH-INWIDTH]   <= sEEG;
            counter <= counter + 1;
        end
        else
            case (counter)
                0: begin
                    pad[255] <= 1;
                    pad[0] <= 1;
                end
                1: begin
                    pad[191] <= 1;
                    pad[0] <= 1;
                end
                2: begin
                    pad[127] <= 1;
                    pad[0] <= 1;
                end
                3: begin
                    pad[63] <= 1;
                    pad[0] <= 1;
                end
            endcase
        pad[OUTWIDTH-1-INWIDTH:0] <= pad[OUTWIDTH-1:INWIDTH];
        temp[OUTWIDTH-1:OUTWIDTH-INWIDTH] <= pad[INWIDTH-1:0];

    end

    always@(posedge clk) begin
        temp_reg <= temp;
        eegOut   <= temp_reg;
    end
endmodule
