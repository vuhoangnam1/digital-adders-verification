module test_skip(
	 input  logic clk,
    output logic [15:0] S,
    output logic C_o
);
    logic [15:0] a, b;
    logic C_i;
    assign a   = 16'b0101010101010101;
    assign b   = 16'b1010101010101010;
    assign C_i = 1'b1;

    csa_16bit dut (
        .clk(clk),
        .a(a),
        .b(b),
        .C_i(C_i),
        .S(S),
        .C_o(C_o)
    );
endmodule
