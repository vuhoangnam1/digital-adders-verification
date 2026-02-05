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

module skip_block (
input logic [3:0] a,
input logic [3:0] b,
input logic C_i, //carry-in từ block trước
output logic [3:0] S,
output logic C_o, //carry-out cho block tiếp theo
output logic  skip //bỏ qua carry
);
logic [4:0] Carry;
logic [3:0] propagate; //bit truyền sinh

assign Carry[0] = C_i; //gna1 carry đầu tiên là C_i
//tạo 4 full_adder (ripple adder 4-bit) cho block
genvar i;
generate
for (i = 0;i<4;i++) begin : fa
full_adder FA(
.a(a[i]),
.b(b[i]),
.C_i(Carry[i]), //carry-in từ vị trí trước đó
.S(S[i]), //Tổng bit tại vị trí i
.C_o(Carry[i+1]) //carry-out cho vị trí kế tiếp
);
assign propagate[i] = a[i] ^ b[i]; 
end
endgenerate
// Nếu tất cả bit của propagate = 1 thì toàn bộ block có thể skip carry ripple
//P_block[i] = 4'b1111; =>&P_block[i]=1, nếu có 1 bit nào có giá trị 0 thì &P_block[i]=0
assign skip = &propagate; // skip = and tất cả bit propagate
//Nếu có thể skip thì truyền C_i trực tiếp làm C_o
//Ngược lại không thề skip thì phải dùng carry ripple truyền từng bit từ trái sang phải
assign C_o  = skip ? C_i : Carry[4];   // bỏ qua nếu propagate đủ
endmodule

module csa_16bit(
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
logic [15:0] S_comb;
logic C_o_comb;
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
assign S_comb[i*4+:4] = S_block[i];
end
endgenerate
//carry-out cuối cùng là Carry[4]
assign C_o_comb = Carry[4];
 // Đồng bộ hóa đầu ra theo clk
    always_ff @(posedge clk) begin
        S   <= S_comb;
        C_o <= C_o_comb;
    end
endmodule
