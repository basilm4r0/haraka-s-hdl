module deserializer
# (parameter INWIDTH = 8, parameter OUTWIDTH = 256)
(serial_in, enable, clear, clk, outclk, out, start_squeeze);
    input [INWIDTH-1:0] serial_in;
    input clk;
    output logic outclk;
    input enable;
    input clear;
    logic [OUTWIDTH-1:0] temp;
    logic [$clog2(OUTWIDTH/INWIDTH)-1:0] counter;
    logic [1:0] pad_counter;
    output logic [OUTWIDTH-1:0] out;
    output wire start_squeeze = pad_counter[1];

    always @(posedge clk, posedge clear) begin
        if (clear) begin
            temp <= 0;
            counter <= 0;
            pad_counter <= 0;
        end
        temp[OUTWIDTH-1-INWIDTH:0] <= temp[OUTWIDTH-1:INWIDTH];
        if (enable) begin
            temp[OUTWIDTH-1:OUTWIDTH-INWIDTH]   <= serial_in;
        end
        else    // source of pad10*1 padding algorithm: FIPS PUB 202
            case (pad_counter)
                0: begin
                    temp[OUTWIDTH-1:OUTWIDTH-INWIDTH] <= 1;
                    pad_counter <= 1;
                end
                1: begin
                    case (counter)
                        default: begin
                            temp[OUTWIDTH-1:OUTWIDTH-INWIDTH] <= 0;
                        end
                        $clog2(OUTWIDTH/INWIDTH)'(OUTWIDTH/INWIDTH): begin
                            temp[OUTWIDTH-1:OUTWIDTH-INWIDTH] <= 1;
                            pad_counter <= 2;
                        end
                    endcase
                end
            endcase
        counter <= counter + 1;
        if (counter == $clog2(OUTWIDTH/INWIDTH)'(OUTWIDTH - 1)) begin
            outclk <= 1;
            out   <= temp;
        end
    end
endmodule
