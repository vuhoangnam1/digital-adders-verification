module full_adder(
input logic a, 
input logic b,
input logic C_i, //carry-in
output logic S, //tổng sum
output logic C_o //carry-out
);
assign S = (a^b)^C_i;
assign C_o = (a&b) | (C_i&(a^b));
endmodule