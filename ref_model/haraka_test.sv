import "DPI-C" function void dpi_haraka_s(
    input byte input_data[],
    input longint input_len, 
    output byte output_data[],
    input longint output_len
);

module haraka_test;

  byte input_data[];       // Input message
  byte output_data[64];    // Output buffer
  longint input_len;
  longint output_len = 32;

  initial begin
    string msg = "Hello";
    input_len = msg.len();

    // Resize and fill the input array
    input_data = new[input_len];
    for (int i = 0; i < input_len; i++) begin
      input_data[i] = msg[i];
    end

    // Call the DPI function
    dpi_haraka_s(input_data, input_len, output_data, output_len);

    $display("\nCalling dpi_haraka_s with input_len=%0d, output_len=%0d", input_len, output_len);

    // Display output
    $display("\nOutput from haraka_S:");
    for (int i = 0; i < output_len; i++) begin
      $write("%02x", output_data[i]);
    end
    $display("\n");
  end


endmodule
