module carry_skip_adder_16bit(
input logic clk,
input  logic [15:0] a,
input  logic [15:0] b,
input  logic C_i,
output logic [15:0] S,
output logic C_o
);
//tạo 4 block, mỗi block 4-bit nên tạo mảng  a, b, S 4 phần (4x4-bit)
logic [3:0][3:0] a_block, b_block;
logic [3:0][3:0] S_block;
//cho phép skip của từng block
logic [3:0] skip_enable;
logic [4:0] Carry;
//carry ban đầu là C_i
assign Carry[0] = C_i;
genvar i;
generate
for (i = 0;i<4;i++) begin : block
//Mỗi 4-bit từ a và b để đưa vào block thứ i
assign a_block[i] = a[i*4+:4];
assign b_block[i] = b[i*4+:4];
//block cộng 4-bit có khả năng skip
skip_block block(
.a(a_block[i]),
.b(b_block[i]),
.C_i(Carry[i]),
.S(S_block[i]),
.C_o(Carry[i+1]),
.skip(skip_enable[i]) //cho biết có thể bỏ qua carry hay không
);
// Kết quả của tổng 4 block ứng với i, tạo thành tổng 16-bit
assign S[i*4+:4] = S_block[i];
end
endgenerate
//carry-out cuối cùng là Carry[4]
assign C_o = Carry[4];
endmodule
