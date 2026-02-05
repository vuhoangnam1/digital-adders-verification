module tb_skip;
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
driver dvr(.clk(clk));
monitor_i mon(.clk(clk),.a(a), .b(b), .expected_sum(expected_sum), .actual_sum(actual_sum));
checker_skip chk_1(.clk(clk),.a(a),.b(b),.C_i(C_i),.expected_sum(expected_sum),.actual_sum(actual_sum));

initial begin
//kiểm tra skip ở block 1 và 3
$display("///////////////////////");
$display("kiem tra skip o block 1 va 3");
a = 16'h4AA8 ; b = 16'h4567 ; C_i = 1 ; expected_sum = 16'h9010; repeat (2)@(posedge clk);

//kiểm tra không skip ở bất kì block nào 
$display("///////////////////////");
$display("kiem tra khong skip o bat ki block nao");
a = 16'h26E1 ; b = 16'h7A07 ; C_i = 1 ; expected_sum = 16'hA0E9; repeat (2)@(posedge clk);

//kiểm tra tất cả block đều skip
$display("///////////////////////");
$display("kiem tra tat ca block deu skip");
a = 16'hAAAA ; b = 16'h5555; C_i = 0; expected_sum = 16'hFFFF; repeat (2)@(posedge clk);

// Kết thúc
$display("Hoan thanh kiem tra");
$stop;
end
endmodule
