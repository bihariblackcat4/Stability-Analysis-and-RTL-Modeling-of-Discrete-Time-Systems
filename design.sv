// Fixed-point implementation of Dr. Kokil's GRN (Example 3)
module grn_filter(
    input clk,
    input rst,
    input signed [15:0] w1, w2, // External Disturbance (scaled)
    output reg signed [15:0] x1, x2 // mRNA and Protein states
);

    // Coefficients scaled by 128 (Q1.7)
    // A = [0.36, 0; 0, 0.28] -> [46, 0; 0, 36]
    // R = [0.42, 0.06; 0, 0.3] -> [54, 8; 0, 38]
    // S = [0.1, 0.02; 0.06, 0.02] -> [13, 3; 8, 3]

    wire signed [31:0] y1_raw, y2_raw;
    reg signed [15:0] f1, f2;

    // Calculate y(k) = Ax(k) + Rw(k)
    assign y1_raw = (46 * x1) + (54 * w1) + (8 * w2);
    assign y2_raw = (36 * x2) + (38 * w2);

    always @(*) begin
        // Sector [0, 1] Nonlinearity (Zeroing/Saturation)
        // 0.0 = 0, 1.0 = 128
        if (y1_raw[22:7] > 128) f1 = 128;
        else if (y1_raw[22:7] < 0) f1 = 0;
        else f1 = y1_raw[22:7];

        if (y2_raw[22:7] > 128) f2 = 128;
        else if (y2_raw[22:7] < 0) f2 = 0;
        else f2 = y2_raw[22:7];
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x1 <= 51; // Initial condition 0.4 * 128
            x2 <= -26; // Initial condition -0.2 * 128
        end else begin
            // x(k+1) = f(y) + Sw(k)
            x1 <= f1 + ((13 * w1 + 3 * w2) >>> 7);
            x2 <= f2 + ((8 * w1 + 3 * w2) >>> 7);
        end
    end
endmodule
