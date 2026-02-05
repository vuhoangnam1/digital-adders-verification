module tb_test;
logic clk;
logic [15:0] a;
logic [15:0] b;
logic C_i;
logic [15:0] S;
logic C_o;
logic [16:0] expected_sum; //kết quả mong đợi
logic [16:0] actual_sum; //kết quả thực tế
//kết nối module carry_skip_adder_16bit
carry_skip_adder_16bit dut(
.a(a),
.b(b),
.C_i(C_i),
.S(S),
.C_o(C_o)
);
//gộp carry-out và sum lại thành actual_sum, caary-out đóng vai trò là bit thứ 17 của kết quả tổng
assign actual_sum = {C_o, S};

// Các module con
driver drv (.clk(clk));
monitor mon (.clk(clk),.expected_sum(expected_sum), .actual_sum(actual_sum));
checker_basic chk (.clk(clk),.a(a),.b(b),.C_i(C_i),.S(S),.C_o(C_o),.expected_sum(expected_sum),.actual_sum(actual_sum));

initial begin
//kiểm tra cộng không nhớ
$display("///////////////////////");
$display("kiem tra cong khong nho");
a = 4; b = 3; C_i = 0; expected_sum = 7; repeat (2)@(posedge clk);

//kiểm tra cộng có nhớ 
$display("///////////////////////");
$display("kiem tra cong co nho");
a = 8; b = 8; C_i = 1; expected_sum = 17; repeat (2)@(posedge clk);

//kiểm tra cộng qua biên giữa các block
$display("///////////////////////");
$display("kiem tra cong qua bien giau cac block");
a = 15; b = 1; C_i = 0; expected_sum = 16; repeat (2)@(posedge clk);

//kiểm tra tràn 16 bit
$display("///////////////////////");
$display("kiem tra tran 16-bit");
a = 65535 ; b = 1; C_i = 1; expected_sum = 65537; repeat (2)@(posedge clk);

//kiểm tra các bit bằng 0
$display("///////////////////////");
$display("kiem tra cac bit bang 0");
a = 0; b = 0; C_i = 0; expected_sum = 0; repeat (2)@(posedge clk);
// Kết thúc
$display("Hoan thanh kiem tra");
$stop;
end
endmodule
