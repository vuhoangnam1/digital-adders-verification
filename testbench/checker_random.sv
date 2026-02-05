module checker_random(
input logic clk,
input logic [15:0] a,
input logic [15:0] b,
input logic C_i,
input logic [16:0] expected_sum, //kết quả mong đợi
input logic [16:0] actual_sum //kết quả thực tế
);

//Kiểm tra giá trị ngẫu nhiên
property test9;
@(posedge clk) 
a+b+C_i == expected_sum |=> actual_sum==expected_sum;
endproperty
assert property(test9) 
//chỉ cần xuất hiện 1 lỗi fail thì sẽ ngừng ngay lập tức
else begin $error("fail | kiem tra gia tri ngau nhien");
$stop;
end
endmodule

