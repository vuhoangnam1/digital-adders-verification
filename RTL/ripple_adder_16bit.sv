module full_adder(
    input  logic a, 
    input  logic b,
    input  logic C_i, // carry-in
    output logic S,   // tổng sum
    output logic C_o  // carry-out
);
    assign S    = (a ^ b) ^ C_i;
    assign C_o  = (a & b) | (C_i & (a ^ b));
endmodule


module ripple_adder_16bit(
    input  logic        clk,
    input  logic [15:0] a,
    input  logic [15:0] b,
    input  logic        C_i,     // carry-in từ block trước
    output logic [15:0] S,       // output đồng bộ
    output logic        C_o      // carry-out đồng bộ
);
    logic [16:0] Carry;
    logic [15:0] S_comb;
    logic        C_o_comb;

    assign Carry[0] = C_i;

    // tạo 16 full_adder
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin : fa
            full_adder FA (
                .a    (a[i]),
                .b    (b[i]),
                .C_i  (Carry[i]),
                .S    (S_comb[i]),     // gán vào comb
                .C_o  (Carry[i+1])
            );
        end
    endgenerate

    assign C_o_comb = Carry[16];

    // Đồng bộ hóa đầu ra theo clock
    always_ff @(posedge clk) begin
        S   <= S_comb;
        C_o <= C_o_comb;
    end
endmodule
