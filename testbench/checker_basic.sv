module checker_basic(
input logic clk,
input logic [15:0] a,
input logic [15:0] b,
input logic C_i,
input logic [15:0] S,
input logic C_o,
input logic [16:0] expected_sum, //kết quả mong đợi
input logic [16:0] actual_sum //kết quả thực tế
);
//kiểm tra cộng không nhớ
property test1;
@(posedge clk) 
a==4 && b==3 && C_i==0 |=> actual_sum==expected_sum;
endproperty
assert property(test1) else $error("fail | kiem tra cong khong nho");

//kiểm tra cộng có nhớ 
property test2;
@(posedge clk)
a==8 && b==8 && C_i==1 |=> actual_sum==expected_sum;
endproperty
assert property(test2) else $error("fail | kiem tra cong co nho");


//kiểm tra cộng qua biên giữa các block
property test3;
@(posedge clk)
a==15 && b==1 && C_i==0 |=> actual_sum==expected_sum;
endproperty
assert property(test3) else $error("fail | kiem tra cong qua bien giau cac block");

//kiểm tra tràn 16 bit
property test4;
@(posedge clk) 
a==65535 && b==1 && C_i==1 |=> actual_sum==expected_sum;
endproperty
assert property(test4) else $error("fail | kiem tra tran 16-bit");

//kiểm tra các bit bằng 0
property test5;
@(posedge clk) 
a==0 && b==0 && C_i==0 |=> actual_sum==expected_sum;
endproperty
assert property(test5) else $error("fail | kiem tra cac bit bang 0");

endmodule

