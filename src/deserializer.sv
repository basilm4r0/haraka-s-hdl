module deserializer
(serial_in, process_input, clear, clk, outclk, out, output_ready, start_squeeze);

    parameter IN_WIDTH = 8,
              OUT_WIDTH = 256,
              PACKETS_IN_OUTPUT = OUT_WIDTH / IN_WIDTH,
              PACKET_COUNTER_WIDTH = $clog2(PACKETS_IN_OUTPUT),
              PAD_BEGINNING = 'h1f,
              PAD_ENDING = 'h80;

    input [IN_WIDTH-1:0] serial_in;
    input process_input;
    input clear;
    input clk;
    output logic outclk;
    output logic [OUT_WIDTH-1:0] out;
    output logic output_ready;
    output wire start_squeeze;
    logic [OUT_WIDTH-1:0] temp;
    logic [PACKET_COUNTER_WIDTH-1:0] counter;
    logic [1:0] pad_counter;

    assign start_squeeze = pad_counter[1];

    always @(posedge clk, posedge clear) begin
        if (clear) begin
            temp <= 0;
            counter <= 0;
            pad_counter <= 0;
            outclk <= 0;
            output_ready <= 0;
        end
        temp[OUT_WIDTH-1-IN_WIDTH:0] <= temp[OUT_WIDTH-1:IN_WIDTH];
        if (process_input) begin
            temp[OUT_WIDTH-1:OUT_WIDTH-IN_WIDTH] <= serial_in;
        end
        else    // padding scheme specified in FIPS PUB 202 for SHAKE256
            case (pad_counter)
                0: begin
                    temp[OUT_WIDTH-1:OUT_WIDTH-IN_WIDTH] <= PAD_BEGINNING;
                    pad_counter <= 1;
                end
                1: begin
                    case (counter)
                        default: begin
                            temp[OUT_WIDTH-1:OUT_WIDTH-IN_WIDTH] <= 0;
                        end
                        PACKET_COUNTER_WIDTH'(PACKETS_IN_OUTPUT - 1): begin // reached end of shift register
                            temp[OUT_WIDTH-1:OUT_WIDTH-IN_WIDTH] <= PAD_ENDING;
                            pad_counter <= 2;
                        end
                    endcase
                end
            endcase
        // Haraka clk 4 times frequency of deserialized output because it
        // takes 4 clock cycles for Haraka module's output to be ready
        if (counter % PACKET_COUNTER_WIDTH'(PACKETS_IN_OUTPUT/4) == 0) begin
            outclk <= !outclk;
            if (output_ready == 1)
                output_ready <= 0;
        end
        if (counter == PACKET_COUNTER_WIDTH'(PACKETS_IN_OUTPUT - 1)) begin
            out   <= temp;
            output_ready <= 1;
        end
        counter <= counter + 1;
    end
endmodule
