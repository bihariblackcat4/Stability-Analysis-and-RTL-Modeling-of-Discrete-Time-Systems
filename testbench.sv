module tb;
    reg clk, rst;
    reg signed [15:0] w1, w2;
    wire signed [15:0] x1, x2;

    grn_filter dut(clk, rst, w1, w2, x1, x2);

    initial begin
        $dumpfile("dump.vcd"); $dumpvars(0, tb);
        clk = 0; rst = 1; w1 = 0; w2 = 0;
        #10 rst = 0;
        
        // Simulate 100 steps
        for (int i = 0; i < 100; i++) begin
            if (i < 50) begin
                // Simplified "wavy" noise
                w1 = 64; // Constant 0.5 for noise phase
                w2 = -32;
            end else begin
                w1 = 0; w2 = 0;
            end
            #10 clk = ~clk; #10 clk = ~clk;
        end
        $finish;
    end
endmodule
