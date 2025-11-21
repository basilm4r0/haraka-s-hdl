module EdgeDetector ( input in,
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

