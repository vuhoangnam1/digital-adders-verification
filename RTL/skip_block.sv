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