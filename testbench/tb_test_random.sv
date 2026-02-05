module tb_test_random;
logic clk;
logic [15:0] a;
logic [15:0] b;
logic C_i;
logic [15:0] S;
logic C_o;
logic [16:0] expected_sum; //kết quả mong đợi
logic [16:0] actual_sum; //kết quả thực tế
int n;
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
driver dvr(.clk(clk));
monitor_i mon(.clk(clk), .a(a), .b(b), .expected_sum(expected_sum), .actual_sum(actual_sum) );
checker_random chk_2(.clk(clk),.a(a),.b(b),.C_i(C_i),.expected_sum(expected_sum),.actual_sum(actual_sum));

initial begin
//kiểm tra giá trị ngẫu nhiên 100 lần
for(n=0;n<100;n++) begin
$display("///////////////////////");
$display("kiem tra gia tri ngau nhien lan %0d",n);
a=$urandom_range(0,65535); b=$urandom_range(0,65535); C_i=$urandom_range(0,1); expected_sum=a+b+C_i; 
$display(" a=%0h | b=%0h | C_i =%0d",a,b,C_i);
repeat (2)@(posedge clk); 
end

//kết thúc
$display("Hoan thanh kiem tra");
$stop;
end
endmodule
