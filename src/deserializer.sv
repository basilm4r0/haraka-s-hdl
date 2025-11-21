// takes 8-bit serial input, a bus clock, and an internal clock 32 times
// slower than the bus clock, as well as some signals.
// Takes an indefinite number of 8-bit inputs starting on the rising edge of
// process_input and ending on its falling edge. It packs the input bytes into
// 256 bit blocks and outputs them. The final block is padded until it reaches
// the full length. Clear clears all internal registers. start_squeeze
// indicates the end of the output.
module deserializer
#(
    parameter IN_WIDTH = 8,
    parameter OUT_WIDTH = 256,
    parameter PACKETS_IN_OUTPUT = OUT_WIDTH / IN_WIDTH,
    parameter PACKET_COUNTER_WIDTH = $clog2(PACKETS_IN_OUTPUT),
    parameter PAD_BEGINNING = 'h1f,
    parameter PAD_ENDING = 'h80,
    parameter ONE_BYTE_PAD = 'h9f
)
(
    input  wire  [IN_WIDTH-1:0] serial_in,
    input  wire  process_input,
    input  wire  clear,
    input  wire  clk,
    output logic  internal_clk,
    output logic [OUT_WIDTH-1:0] out,
    output logic output_ready,
    output logic  start_squeeze
);

    logic [OUT_WIDTH-1:0] temp;
    enum logic [1:0] {UNPADDED, PADDING, PADDED} pad_state;
    logic [PACKET_COUNTER_WIDTH-1:0] counter;

    always @(posedge clk or posedge clear) begin
        if (clear) begin
            temp         <= 0;
            counter      <= 0;
            pad_state    <= UNPADDED;
            internal_clk <= 0;
            output_ready <= 0;
            out          <= 0;
        end else begin
            temp[OUT_WIDTH-1-IN_WIDTH:0] <= temp[OUT_WIDTH-1:IN_WIDTH]; // shift temp register
            temp[OUT_WIDTH-1:OUT_WIDTH-1-IN_WIDTH] <= 0; // set first byte to 0

            // Padding is done according to algorithm described in table 6 in FIPS PUB 202
            case (pad_state)
                UNPADDED: begin
                    if (process_input) begin
                        temp[OUT_WIDTH-1:OUT_WIDTH-IN_WIDTH] <= serial_in;
                    end else begin // padding
                        // if we're on the last byte in the buffer, the pad is 1 byte
                        if (counter == PACKET_COUNTER_WIDTH'(PACKETS_IN_OUTPUT - 1)) begin
                            temp[OUT_WIDTH-1:OUT_WIDTH-IN_WIDTH] <= ONE_BYTE_PAD;
                            pad_state <= PADDED;
                        end
                        else begin
                            temp[OUT_WIDTH-1:OUT_WIDTH-IN_WIDTH] <= PAD_BEGINNING;
                            pad_state <= PADDING;
                        end
                    end
                end
                PADDING: begin
                    if (counter == PACKET_COUNTER_WIDTH'(PACKETS_IN_OUTPUT - 1)) begin // if we've reached the last byte in the buffer, append the pad ending
                        temp[OUT_WIDTH-1:OUT_WIDTH-IN_WIDTH] <= PAD_ENDING;
                        pad_state <= PADDED;
                    end else begin
                        temp[OUT_WIDTH-1:OUT_WIDTH-IN_WIDTH] <= 0; // if not, append zeros (pad middle)
                    end
                end
                PADDED: begin
                    if (counter == PACKET_COUNTER_WIDTH'(PACKETS_IN_OUTPUT)) begin
                        start_squeeze <= 1;
                    end
                end
            endcase
            $display("time = %0t: counter = %h, packet = %h", $time, counter, serial_in);
            // output clock toggle every (PACKETS_IN_OUTPUT / 2) cycles
            if (counter % PACKET_COUNTER_WIDTH'(PACKETS_IN_OUTPUT / 2 - 1) == 0) begin
                internal_clk <= ~internal_clk;
            end
            // output assignment when ready
            if (counter == PACKET_COUNTER_WIDTH'(0)) begin
                out <= temp;
                output_ready <= 1;
            end
            if (output_ready) begin
                output_ready <= 0;
            end

            // increment counter
            counter <= counter + 1;
        end
    end

endmodule
