module test_no_skip (
    output logic [15:0] S,
    output logic C_o
);
    logic clk = 0;
    always #25 clk = ~clk;

    logic [15:0] a = 16'b1111000011110000;
    logic [15:0] b = 16'b1111000011110000;
    logic C_i = 1;

    csa_16bit dut (
        .clk(clk),
        .a(a),
        .b(b),
        .C_i(C_i),
        .S(S),
        .C_o(C_o)
    );
endmodule
