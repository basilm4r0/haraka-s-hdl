module deserializer
(serial_in, enable, clear, clk, outclk, out, start_squeeze);

    parameter INWIDTH = 8,
              OUTWIDTH = 256,
              FIRSTPAD = 'h1f,
              LASTPAD = 'h80;

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
            temp[OUTWIDTH-1:OUTWIDTH-INWIDTH] <= serial_in;
        end
        else    // padding scheme specified in FIPS PUB 202 for SHAKE256
            case (pad_counter)
                0: begin
                    temp[OUTWIDTH-1:OUTWIDTH-INWIDTH] <= FIRSTPAD;
                    pad_counter <= 1;
                end
                1: begin
                    case (counter)
                        default: begin
                            temp[OUTWIDTH-1:OUTWIDTH-INWIDTH] <= 0;
                        end
                        $clog2(OUTWIDTH/INWIDTH)'(OUTWIDTH/INWIDTH): begin // reached end of shift register
                            temp[OUTWIDTH-1:OUTWIDTH-INWIDTH] <= LASTPAD;
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
