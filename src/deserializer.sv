module deserializer
#(
    parameter IN_WIDTH = 8,
    parameter OUT_WIDTH = 256,
    parameter PACKETS_IN_OUTPUT = OUT_WIDTH / IN_WIDTH,
    parameter PACKET_COUNTER_WIDTH = $clog2(PACKETS_IN_OUTPUT),
    parameter PAD_BEGINNING = 'h1f,
    parameter PAD_ENDING = 'h80
)
(
    input  wire [IN_WIDTH-1:0] serial_in,
    input  wire process_input,
    input  wire clear,
    input  wire clk,
    output logic outclk,
    output logic [OUT_WIDTH-1:0] out,
    output logic output_ready,
    output wire start_squeeze
);

    logic [OUT_WIDTH-1:0] temp;
    logic [PACKET_COUNTER_WIDTH-1:0] counter;
    logic [1:0] pad_counter;

    assign start_squeeze = pad_counter[1];

    always @(posedge clk or posedge clear) begin
        if (clear) begin
            temp         <= 0;
            counter      <= 31;
            pad_counter  <= 0;
            outclk       <= 0;
            output_ready <= 0;
            out          <= 0;
        end else begin
            temp[OUT_WIDTH-1-IN_WIDTH:0] <= temp[OUT_WIDTH-1:IN_WIDTH]; // shift temp register

            if (process_input) begin  //  padding
                temp[OUT_WIDTH-1:OUT_WIDTH-IN_WIDTH] <= serial_in;
            end else begin
                case (pad_counter)
                    0: begin
                        temp[OUT_WIDTH-1:OUT_WIDTH-IN_WIDTH] <= PAD_BEGINNING;
                        pad_counter <= 1;
                    end
                    1: begin
                        if (counter == PACKET_COUNTER_WIDTH'(PACKETS_IN_OUTPUT - 2)) begin
                            temp[OUT_WIDTH-1:OUT_WIDTH-IN_WIDTH] <= PAD_ENDING;
                            pad_counter <= 2;
                        end else begin
                            temp[OUT_WIDTH-1:OUT_WIDTH-IN_WIDTH] <= 0;
                        end
                    end
                endcase
            end
            $display("time = %0t: counter = %h, pkt size = %h", $time, counter, PACKET_COUNTER_WIDTH'(PACKETS_IN_OUTPUT - 1));
            // output clock toggle every (PACKETS_IN_OUTPUT / 2) cycles
            if (counter % PACKET_COUNTER_WIDTH'(PACKETS_IN_OUTPUT / 2) == 0) begin
                outclk <= ~outclk;
                if (output_ready)
                    output_ready <= 0;
            end
            // output assignment when ready
            if (counter == PACKET_COUNTER_WIDTH'(PACKETS_IN_OUTPUT - 1)) begin
                out <= temp;
                output_ready <= 1;
            end

            // increment counter
            counter <= counter + 1;
        end
    end

endmodule
